import json, os

from PySide6.QtCore import QObject, Slot, Signal, QTimer, QThread
import backend.synvote as svbe
from SynAuth import SynAuth

class LoginWorker(QObject):
    loginCompleted = Signal(bool, str)  # Signal to indicate login is completed

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
        self.loginCompleted.emit(result, msg)


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
    loginChanged = Signal(bool, arguments=['status'])
    loginResponse = Signal(str, arguments=["login_response"])

    def __init__(self, backend):
        super().__init__()
        self.auth : SynAuth = None
        self.syn_backend: svbe.SynVoteBackend = backend
        self.active_account = 0
        self.is_login = False
        self.thread = None
        self.login_worker = None
        self.operation_in_process = False
        # Define timer.
        QTimer.singleShot(2000, self.update_status)

    def update_status(self):
        # Pass the current time to QML.
        d_addr = self.syn_backend.get_deployer()
        status_str = f'SynVote -> Contract Deployed by {d_addr}'
        self.statusChanged.emit(status_str)

    def update_login(self):
        # Pass the current time to QML.
        self.loginChanged.emit(self.is_login)

    def try_login(self):
        creds = self.read_creds()
        if not creds:
            return
        self.auth.login(creds["username"], creds["password"])
        result = self.auth.is_authenticated()[0]
        if result:
            self.on_login(is_login=result)
            self.update_login()
            print(f"Result: {result}")

    def process_login_request(self, username, password):
        self.auth = SynAuth()
        self.auth.login(username, password)
        result = self.auth.is_authenticated()[0]
        if result:
            self.on_login(is_login=result)
            self.update_login()
            # delete self.auth
            del self.auth
            self.auth = None
            return result
        
        
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
        
    
    def handle_login_response(self, result, message):
        if result:
            self.on_login(is_login=result)
            self.update_login()
        self.loginResponse.emit(message)
        self.operation_in_process = False
    
    def handle_register_response(self, result, message):
        self.loginResponse.emit(message)
        self.operation_in_process = False
        
