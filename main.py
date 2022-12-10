from api import sign_up
class User:
    def __init__(self, username, password):
        self.username = username
        self.password = password
    
    def get_username(self):
        return self.username
    
    def get_password(self):
        return self.password
        
user = User(sign_up(), sign_up())   

def get_user():
    return user
     