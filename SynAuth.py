from keyauth import api as keyauth_api
import hashlib
import sys
import json
import os
from time import sleep
from datetime import datetime

class SynAuth:
    def __init__(self):
        self.keyauthapp = keyauth_api(
            name = "", # Application Name
            ownerid = "", # Owner ID
            secret = "", # Application Secret
            version = "1.0", # Application Version
            hash_to_check = self.get_checksum()
        )
        self.login_response = None
        self.register_response = None
    
    def get_checksum(self):
        md5_hash = hashlib.md5()
        file = open(''.join(sys.argv), "rb")
        md5_hash.update(file.read())
        digest = md5_hash.hexdigest()
        return digest
    
    def login(self, username, password):
        self.login_response = self.keyauthapp.login(username, password)
        return self.login_response
    
    def register(self, username, password, license_key):
        self.register_response = self.keyauthapp.register(username, password, license_key)
        return self.register_response

    def get_user_data(self):
        data = []
        data.append(self.keyauthapp.user_data.username)
        data.append(self.keyauthapp.user_data.ip)
        return data
    
    def print_user_data(self):
        data = self.get_user_data()
        username = data[0]
        ip = data[1]
        print(f"Data:\nUsername: {username}\nIP Address: {ip}")

    def is_authenticated(self):
        ret = []
        # Response Error :-:-: 0x001A
        if not self.login_response:
            ret.append(False)
            ret.append("Login failed with code 0x001A")
            return ret
        
        # Creds Errpr :-:-: 0x002B
        if not self.login_response["success"]:
            ret.append(False)
            ret.append(f"{self.login_response["message"]} Error Code 0x002B")
            return ret
        
        ret.append(True)
        ret.append(self.login_response["message"])
        return ret

    def is_registered(self):
        ret = []
        # Response Error :-:-: 0x001A
        if not self.register_response:
            ret.append(False)
            ret.append("Login failed with code 0x001A")
            return ret
        
        # Creds Errpr :-:-: 0x002B
        if not self.register_response["success"]:
            ret.append(False)
            ret.append(f"{self.register_response["message"]}")
            return ret
        
        ret.append(True)
        ret.append(self.register_response["message"])
        return ret
    
    def get_username(self):
        if self.is_authenticated()[0]:
            return self.get_user_data()[0]
