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
    print(backend.get_is_deployer(backend.get_current_account()))
    backend.switch_account(1)
    print(backend.get_is_deployer(backend.get_current_account()))
    backend.switch_account(2)
    print(backend.get_is_deployer(backend.get_current_account()))
    backend.create_voting_room("test")
    backend.switch_account(0)
    print(backend.get_is_deployer(backend.get_current_account()))

if __name__ == "__main__":
    main()
