from backend.deployer import SynVoteDeployer


class SynVoteBackend:
    def __init__(self):
        self.deloyed_contract = SynVoteDeployer()
        self.contract = self.deloyed_contract.SynVote_contact
        self.accounts = self.deloyed_contract.accounts
        self.w3 = self.deloyed_contract.w3

    def get_accounts(self):
        return self.accounts

    def get_account_from_index(self, index):
        if index >= self.get_accounts_count():
            raise Exception(
                f'Index out of bound Error! {self.get_accounts_count() - 1} is the maximum')
        else:
            return self.accounts[index]

    def get_accounts_count(self):
        # print(f'{len(self.accounts)} Available Accounts')
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


# Deployer Class


def main():
    backend = SynVoteBackend()
    print(backend.get_is_deployer(backend.accounts[0]))


if __name__ == "__main__":
    main()
