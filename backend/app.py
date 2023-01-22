from fastapi import FastAPI
import psycopg2
import time

app = FastAPI()

def localTime():
    localTime = time.ctime(time.time())
    return localTime

def shippedTime():
    shippedTime = time.ctime(time.time() + 432,000 )
    return shippedTime

def create_connection():
        conn = psycopg2.connect(
                host = '78.38.35.219',
                dbname = '99463167',
                user = '99463167',
                password = '123456',
                port = 5432
            )
        cur = conn.cursor()
        return conn, cur

@app.post("/signup")
def signup(req: dict):
    conn = None
    cur = None
    id = 0
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".customers')
        for record in cur.fetchall():
            if record[0] is None:
                id = 0
            else:
                id = record[0] + 1
            if record[5] == req["customerEmail"]:
                return {"isExistEmail": "True"}
                
        # cur = conn.cursor(0)
                
        # for record2 in cur.fetchall():
        #     if record2[5] == req["customerEmail"]:
        #         return {"isExistEmail": "True"}
                
        insert_script = 'INSERT INTO "OnlineShop".customers (customerID, customerFullName, phone, city, address, customerEmail, password) VALUES (%s, %s, %s, %s, %s, %s, %s)'
        insert_value = (id, req["customerFullName"], req["phone"], req["city"], req["address"], req["customerEmail"], req["password"])
        cur.execute(insert_script, insert_value)
        conn.commit()
    except Exception as erorr:
        print(erorr)
    
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close()
    return {"isExistEmail": "False"}

@app.post('/login')
def login(req: dict):
    conn = None
    cur = None
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".customers')
        for record in cur.fetchall():
            if record[5] == req["customerEmail"] and record[6] == req["password"]:
                return {"isLogin": "True"}
        return {"isLogin": "False"}
    except Exception as erorr:
        print(erorr)
    
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close()
    

@app.post("/register-product-information")
def registerProductInformation(req: dict):
    conn = None
    cur = None
    id = 0
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".products')
        for record in cur.fetchall():
            if record[0] is None:
                id = 0
            else:
                id = record[0] + 1
                       
        insert_script = 'INSERT INTO "OnlineShop".products (productID, productName, productVendor, buyPrice, salePrice, textDescription, image) VALUES (%s, %s, %s, %s, %s, %s, %s)'
        insert_value = (id, req["productName"], req["productVendor"], req["buyPrice"], req["salePrice"], req["textDescription"], req["image"])
        cur.execute(insert_script, insert_value)
        conn.commit()
    except Exception as erorr:
        print(erorr)
    
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close()
    return {"registerProductInformation": "True"}

@app.patch("/edit-product-information")
def editProductInformation(req: dict):
    conn = None
    cur = None
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".products')
        for record in cur.fetchall():
            if record[0] == req["productID"]:
                update_script = 'UPDATE "OnlineShop".products SET productName = %s, productVendor = %s, buyPrice = %s, salePrice = %s, textDescription = %s, image = %s'
                update_value = (req["productName"], req["productVendor"], req["buyPrice"], req["salePrice"], req["textDescription"], req["image"])
                cur.execute(update_script, update_value)
                conn.commit()
                return {"wrongID": "False"}
            else:
                return {"wrongID": "True"}
    except Exception as erorr:
        print(erorr)

@app.get("/product-search")
def productSearch(req: dict):
    conn = None
    cur = None
    id = []
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".products')
        for record in cur.fetchall():
            if record[1] == req["productName"]:
                id.append(record[0])
    except Exception as erorr:
        print(erorr)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close()    
    return {"id": id}

@app.post("/registration-products-order")
def registrationProductsOrder(req: dict):
    conn = None
    cur = None
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".orders')
        for record in cur.fetchall():
            if record[0] is None:
                id = 0
            else:
                id = record[0] + 1
        insert_script = 'INSERT INTO "OnlineShop".orders (orderID, confirmationDate, requiredDate, shippedDate, status, comments, customerID) VALUES (%s, %s, %s, %s, %s, %s, %s)'
        insert_value = (id, None, localTime(), None, "ثبت سفارش", None, req["customerID"])
        cur.execute(insert_script, insert_value)
        conn.commit()
    except Exception as erorr:
        print(erorr)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close()    
    return {"isRegistrationProductsOrder": "True"}

@app.patch("/customer-order-confirmation")
def customerOrderConfirmation(req: dict):
    conn = None
    cur = None
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".orders')
        for record in cur.fetchall():
            if record[0] == req["orderID"]:
                update_script = 'UPDATE "OnlineShop".products SET confirmationDate = %s, shippedDate = %s, status = %s'
                update_value = (localTime(), shippedTime(), "تایید سفارش")
                cur.execute(update_script, update_value)
                conn.commit()
                return {"wrongID": "False"}
            else:
                return {"wrongID": "True"}
    except Exception as erorr:
        print(erorr)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close() 

@app.get("/home")
def home():
    home = []
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        home.append({"productID": record[0],
                        "productName": record[1],
                        "salePrice": record[4],
                        "image": record[6],
                        "gameReleaseDate": record[7]})
    home.sort(key=lambda home: home["gameReleaseDate"])    
    return home

# @app.get('/item/{id}')
# def read_item(id: int):
#     return id


# def search():
#     return "saerch"
# saadsdasadadssads