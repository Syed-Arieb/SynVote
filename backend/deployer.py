from web3 import Web3
from web3 import EthereumTesterProvider
from eth_tester import EthereumTester, PyEVMBackend
import json


class SynVoteDeployer:
    def __init__(self):
        # Read the ABI from the JSON file
        contract_abi = self.read_json_abi()

        # Read the binary from the text file
        contract_bin = self.read_bin()

        # Initialize EthereumTester with PyEVMBackend
        self.w3 = self.init_web3()

        self.accounts = self.w3.eth.accounts

        self.w3.eth.default_account = self.accounts[0]
        SynVote = self.w3.eth.contract(abi=contract_abi, bytecode=contract_bin)

        transact_hash = SynVote.constructor().transact()
        transact_reciept = self.w3.eth.wait_for_transaction_receipt(
            transaction_hash=transact_hash)

        self.SynVote_contact = self.w3.eth.contract(
            address=transact_reciept.contractAddress, abi=contract_abi)

    def read_json_abi(self):
        with open('backend/smart_contract/contract_abi.json', 'r') as abi_file:
            contract_abi = json.load(abi_file)
        return contract_abi

    def read_bin(self):
        with open('backend/smart_contract/contract_bin.txt', 'r') as bin_file:
            contract_bin = bin_file.read()
        return contract_bin

    def get_eth_tester(self):
        return EthereumTester(backend=PyEVMBackend())

    def init_web3(self):
        eth_tester = self.get_eth_tester()
        tester_provider = EthereumTesterProvider(eth_tester)
        return Web3(tester_provider)
