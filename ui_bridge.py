import json, os, random,sys

from PySide6.QtCore import QObject, Slot, Signal, QTimer, QThread
from PySide6.QtWidgets import QApplication, QMainWindow
import backend.synvote as svbe
from SynAuth import SynAuth
from listmodel import ItemModel
from SynChart import VotingChart

class LoginWorker(QObject):
    loginCompleted = Signal(bool, str, str)  # Signal to indicate login is completed

    def __init__(self, username, password):
        super().__init__()
        self.username = username
        self.password = password

    def run(self):
        auth = SynAuth()
        auth.login(self.username, self.password)
        result = auth.is_authenticated()[0]
        if result:
            msg = "Login Successful"
        else:
            msg = "Invalid Credentials"
        self.loginCompleted.emit(result, msg, self.username)


class RegisterWorker(QObject):
    registerCompleted = Signal(bool, str)  # Signal to indicate login is completed

    def __init__(self, username, password, license_key):
        super().__init__()
        self.username = username
        self.password = password
        self.license_key = license_key

    def run(self):
        auth = SynAuth()
        auth.register(self.username, self.password, self.license_key)
        isreg = auth.is_registered()
        result = isreg[0]

        if result:
            msg = "Registered successfully!"
        else:
            msg = f"Failed! {isreg[1]}"
        self.registerCompleted.emit(result, msg)

class SynBridge(QObject):
    statusChanged = Signal(str, arguments=['msg'])
    loginChanged = Signal(bool, bool, arguments=['status', 'is_deployer'])
    loginResponse = Signal(str, arguments=["login_response"])
    modelUpdate = Signal(int, str, int, arguments=['index', 'room_name', 'candidates'])
    acknowledgement = Signal()
    candidatesUpdate = Signal(str, list)

    def __init__(self, backend):
        super().__init__()
        self.vote_res: VotingChart = None
        self.window: QMainWindow = None

        self.auth : SynAuth = None
        self.syn_backend: svbe.SynVoteBackend = backend
        self.active_account = 0
        self.is_login = False
        self.thread = None
        self.login_worker = None
        self.operation_in_process = False
        self._rooms_info = []
        self.emitted_index = 0
        self.acknowledgement.connect(self.on_acknowledgement)
        # Define timer.
        QTimer.singleShot(300, self.update_status)

    def update_status(self):
        # Pass the current time to QML.
        d_addr = self.syn_backend.get_deployer()
        status_str = f'SynVote -> Contract Deployed by {d_addr}'
        self.statusChanged.emit(status_str)

    def update_login(self, username):
        # Pass the current time to QML.
        deployer = False
        if self.is_login:
            deployer = self.syn_backend.get_is_deployer(self.syn_backend.get_current_account())
        self.loginChanged.emit(self.is_login, deployer)

    def try_login(self):
        creds = self.read_creds()
        if not creds:
            return
        self.auth.login(creds["username"], creds["password"])
        result = self.auth.is_authenticated()[0]
        if result:
            self.on_login(is_login=result)
            self.update_login(creds["username"])
            print(f"Result: {result}")

    def process_login_request(self, username, password):
        self.auth = SynAuth()
        self.auth.login(username, password)
        result = self.auth.is_authenticated()[0]
        if result:
            self.on_login(is_login=result)
            self.update_login(username)
            # delete self.auth
            del self.auth
            self.auth = None
            return result

    def init_test_rooms(self, add_demo_candidates = False):
        self.syn_backend.create_voting_room("BCS-A CR")
        self.syn_backend.create_voting_room("School Board")
        self.syn_backend.create_voting_room("Union Leadership")
        self.syn_backend.create_voting_room("Board of Directors")

        self.syn_backend.add_candidate(1, "Muhammad Zaid")
        self.syn_backend.add_candidate(1, "Umair Dost")
        self.syn_backend.add_candidate(1, "Ahmed Khan")
        self.syn_backend.add_candidate(1, "Khayal Muhammad")
        self.syn_backend.add_candidate(1, "Ahmad Irfan Khan")

        if add_demo_candidates:
            count = self.syn_backend.get_voting_room_count()
            while count > 1:
                self.syn_backend.add_demo_candidates(count)
                count-=1
    
    def gen_item_model(self):
        self._rooms_info = []
        
        self.init_test_rooms(add_demo_candidates=True)
        rooms_count = self.syn_backend.get_voting_room_count()
        n = 1
        while n <= rooms_count:
            temp = []
            temp.append(n)
            temp.append(self.syn_backend.get_voting_room(n)[0])
            temp.append(self.syn_backend.get_voting_room(n)[1])
            self._rooms_info.append(temp)
            n += 1

        self.emitted_index = 0
        idx = self._rooms_info[self.emitted_index][0]
        name = self._rooms_info[self.emitted_index][1]
        cand = self._rooms_info[self.emitted_index][2]
        self.modelUpdate.emit(idx, name, cand)
        return self._rooms_info
    
    @Slot()
    def acknowledge(self):
        # Emit the acknowledgement signal
        self.acknowledgement.emit()

    @Slot()
    def get_list_data(self):
        # Emit the acknowledgement signal
        self.gen_item_model()

    @Slot()
    def on_acknowledgement(self):
        self.emitted_index += 1
        if self.emitted_index >= self.syn_backend.get_voting_room_count():
            self.emitted_index = 0
            return
        idx = self._rooms_info[self.emitted_index][0]
        name = self._rooms_info[self.emitted_index][1]
        cand = self._rooms_info[self.emitted_index][2]
        self.modelUpdate.emit(idx, name, cand)
        
    def read_creds(self):
        file_path = os.path.join("C:\\", "ProgramData", "SynVote", "creds.json")
        try:
            # Read the JSON file
            with open(file_path, "r") as file:
                credentials = json.load(file)
                return credentials
        except FileNotFoundError:
            print("Credentials file not found.")
            return None

    def on_login(self, is_login):
        self.is_login = is_login

    @Slot(str, str)
    def on_login_request(self, username, password):
        if not username or not password:
            self.loginResponse.emit("Username or Password is empty")
            return
        
        if self.operation_in_process:
            print("processing an event already")
            return
        
        self.operation_in_process = True
        self.thread = QThread()
        self.login_worker = LoginWorker(username, password)
        self.login_worker.moveToThread(self.thread)

        self.thread.started.connect(self.login_worker.run)
        self.login_worker.loginCompleted.connect(self.handle_login_response)
        self.login_worker.loginCompleted.connect(self.thread.quit)
        self.login_worker.loginCompleted.connect(self.login_worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)

        self.thread.start()
    
    @Slot(str, str, str)
    def on_register_request(self, username, password, license_key):
        if not username or not password or not license_key:
            self.loginResponse.emit("Username, Password or License Key is empty")
            return
        
        if self.operation_in_process:
            print("processing an event already")
            return
        
        license_key = f"KEYAUTH-{license_key}"

        self.operation_in_process = True
        self.thread = QThread()
        self.login_worker = RegisterWorker(username, password, license_key)
        self.login_worker.moveToThread(self.thread)

        self.thread.started.connect(self.login_worker.run)
        self.login_worker.registerCompleted.connect(self.handle_register_response)
        self.login_worker.registerCompleted.connect(self.thread.quit)
        self.login_worker.registerCompleted.connect(self.login_worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)

        self.thread.start()
        
    def bind_acc_to_profile(self, username, acc_id):
        file_path = os.path.join("C:\\", "ProgramData", "SynVote", "bindings.json")
        with open(file_path, 'a') as file:
            content = {
                "username": username,
                "acc_id": acc_id
            }
            jstr = json.dumps(content, indent=4)
            file.write(jstr + '\n')

    def read_bindings(self):
        file_path = os.path.join("C:\\", "ProgramData", "SynVote", "bindings.json")
        bindings = []
        try:
            with open(file_path, 'r') as file:
                for line in file:
                    binding = json.loads(line)
                    bindings.append(binding)
            return bindings
        except:
            print("Failed!")
            return bindings
        
    def check_binding_exists(self, username):
        bindings = self.read_bindings()
        for binding in bindings:
            if binding["username"] == username:
                return True
        return False
    
    def is_acc_free(self, acc_id):
        bindings = self.read_bindings()
        for binding in bindings:
            if binding["acc_id"] == acc_id:
                return False
        return True
    
    def get_binding(self, username):
        bindings = self.read_bindings()
        for binding in bindings:
            if binding["username"] == username:
                return binding["acc_id"]
        return 0
    
    def get_total_binds(self):
        bindings = self.read_bindings()
        return len(bindings)
    
    @Slot(int)
    def get_candidates(self, roomID):
        print(f"Candidates requested for Room #{roomID}")
        candidates = self.syn_backend.get_candidates(roomID)
        name = self.syn_backend.get_voting_room(roomID)[0]
        self.candidatesUpdate.emit(name, candidates)
    
    def init_eth_account(self, user):
        acc_id = 0
        if self.check_binding_exists(user):
            acc_id = self.get_binding(user)
            self.syn_backend.switch_account(acc_id)
        else:
            acc_id = random.randint(1, self.syn_backend.get_accounts_count() - 1)
            while not self.is_acc_free(acc_id) and self.get_total_binds() < 10:
                acc_id = random.randint(1, self.syn_backend.get_accounts_count() - 1)

            self.syn_backend.switch_account(acc_id)
            self.bind_acc_to_profile(user, acc_id)
        print (f"Logged In as : Syn#{acc_id}")
    
    def handle_login_response(self, result, message, user):
        if result:
            self.on_login(is_login=result)
            if user != 'arieb':
                self.init_eth_account(user)
            else:
                # DEPLOYER ACCOUNT IS ARIEB
                self.syn_backend.switch_account(0)
            
            self.update_login(user)
            
                
        self.loginResponse.emit(message)
        self.operation_in_process = False
    
    def handle_register_response(self, result, message):
        self.loginResponse.emit(message)
        self.operation_in_process = False

    @Slot()
    def get_rooms_info(self):
        return self._rooms_info
    
    @Slot(int, int, str)
    def cast_vote(self, room_id, candidate_id, candidate_name):
        try:
            self.syn_backend.vote(room_id, candidate_id)
            self.loginResponse.emit(f"Vote Casted to {candidate_name}!")
        except:
            self.loginResponse.emit(f"Voting again is not allowed..")

    @Slot(int)
    def show_room_result2(self, room_id):
        try:
            print(f"Fetching room result for Room #{room_id}")
            room_result = self.syn_backend.get_candidates_data(room_id)
            print(f"Room result: {room_result}")

            if not room_result:
                raise ValueError("Room result is empty")

            self.vote_res = VotingChart(room_result, room_id)
            self.vote_res.show()
        except Exception as e:
            print(f"Error in show_room_result: {e}")
            self.loginResponse.emit(f"Failed to show room result for Room #{room_id}")


    @Slot(int)
    def show_room_result(self, room_id):
        room_result = self.syn_backend.get_candidates_data(room_id)
        self.window = QMainWindow()
        self.window.setWindowTitle("Voting Result")
        self.vote_res = VotingChart(room_result, room_id)
        self.window.setCentralWidget(self.vote_res)
        self.window.resize(650, 600)
        self.window.show()



def main():
    print("backend.get_candidate(1, 5)[0]")

if __name__ == "__main__":
    main()