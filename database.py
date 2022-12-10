import mysql.connector
from main import get_user

mydb = mysql.connector.connect(
    host="127.0.0.1",
    user="Ali",
    passwd="AMA994631",
    database="Test"
) 
mycursor = mydb.cursor()

sql = "INSERT INTO user (name, password) VALUES (%s, %s)"
val = (get_user().get_username(), get_user().get_password()) 
mycursor.execute(sql, val)

mydb.commit()

mydb.close()