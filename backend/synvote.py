import os

try:
    from backend.deployer import SynVoteDeployer
except ImportError:
    from deployer import SynVoteDeployer

class SynVoteBackend:
    def __init__(self):
        self.deployed_contract = SynVoteDeployer()
        self.contract = self.deployed_contract.SynVote_contact
        self.accounts = self.deployed_contract.accounts
        self.w3 = self.deployed_contract.w3
        self.w3.eth.default_account = self.accounts[0]  # Set the default account

    def get_accounts(self):
        return self.accounts

    def get_account_from_index(self, index):
        if index >= self.get_accounts_count():
            raise Exception(f'Index out of bound Error! {self.get_accounts_count() - 1} is the maximum')
        else:
            return self.accounts[index]

    def get_accounts_count(self):
        return len(self.accounts)

    def get_account_balance(self, address):
        address = self.w3.to_checksum_address(address)
        return self.w3.eth.get_balance(address)

    def get_is_deployer(self, address):
        if address == self.accounts[0] or self.w3.to_checksum_address(address) == self.accounts[0]:
            return True
        return False

    def get_deployer(self):
        return str(self.accounts[0])

    def create_voting_room(self, name):
        try:
            tx_hash = self.contract.functions.createVotingRoom(name).transact()
            return self.w3.eth.wait_for_transaction_receipt(tx_hash)
        except: 
            print(f"Transaction Failed! \n\tCurrent account is not contract deployer")

    def add_candidate(self, room_id, name):
        tx_hash = self.contract.functions.addCandidate(room_id, name).transact()
        return self.w3.eth.wait_for_transaction_receipt(tx_hash)

    def vote(self, room_id, candidate_id):
        tx_hash = self.contract.functions.vote(room_id, candidate_id).transact()
        return self.w3.eth.wait_for_transaction_receipt(tx_hash)

    def get_candidate(self, room_id, candidate_id):
        return self.contract.functions.getCandidate(room_id, candidate_id).call()
    
    def get_candidates(self, room_id):
        room_obj = self.get_voting_room(room_id)
        count = room_obj[1]
        candidates = []
        i= 0
        for i in range(count):
            candidates.append(self.get_candidate(room_id, i+1)[0])
        return candidates
    
    def get_candidates_data(self, room_id):
        room_obj = self.get_voting_room(room_id)
        count = room_obj[1]
        candidates = []
        i= 0
        for i in range(count):
            candidates.append(self.get_candidate(room_id, i+1))
        return candidates

    def get_voting_room(self, room_id):
        return self.contract.functions.getVotingRoom(room_id).call()

    def get_voting_room_count(self):
        return self.contract.functions.votingRoomCount().call()

    def get_owner(self):
        return self.contract.functions.owner().call()
    
    def add_demo_candidates(self, room_id):
        candidates = ["Alice", "Bob", "Charlie", "David", "Eve"]
        for candidate in candidates:
            self.add_candidate(room_id, candidate)

    def switch_account(self, id):
        if id >= self.get_accounts_count():
            print("Error! Out of index Account")
            return
        self.w3.eth.default_account = self.accounts[id]
    
    def get_current_account(self):
        return self.w3.eth.default_account


def main():
    backend = SynVoteBackend()
    backend.create_voting_room("textt")
    backend.add_demo_candidates(1)
    print(backend.get_candidates_data(1))

if __name__ == "__main__":
    main()



"""transact_hash = SynVote.constructor().transact()
        transact_reciept = self.w3.eth.wait_for_transaction_receipt(
            transaction_hash=transact_hash)

        self.SynVote_contact = self.w3.eth.contract(
            address=transact_reciept.contractAddress, abi=contract_abi)"""