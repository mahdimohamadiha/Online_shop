import mysql.connector
from main import User

mydb = mysql.connector.connect(
    host="127.0.0.1",
    user="Ali",
    passwd="AMA994631",
    database="Test"
) 
mycursor = mydb.cursor()

sql = "INSERT INTO user (name, password) VALUES (%s, %s)"
val = (User.get_username, User.get_password) 
mycursor.execute(sql, val)

mydb.commit()

mydb.close()