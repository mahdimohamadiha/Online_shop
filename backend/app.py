from fastapi import FastAPI
import psycopg2
import time

app = FastAPI()

def localTime():
    localTime = time.ctime(time.time())
    return localTime

def shippedTime():
    shippedTime = time.ctime(time.time() + 432,000)
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
    id = 1
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".customers')
    for record in cur.fetchall():
        if record[0] is None:
            id = 1
        else:
            id = record[0] + 1
        if record[5] == req["customerEmail"]:
            return {"isExistEmail": True}
            
    insert_script = 'INSERT INTO "OnlineShop".customers (customerID, customerFullName, phone, city, address, customerEmail, password, expertID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)'
    insert_value = (id ,req["customerFullName"], req["phone"], req["city"], req["address"], req["customerEmail"], req["password"], 1)
    cur.execute(insert_script, insert_value)
    conn.commit()
    return {"isExistEmail": False}

@app.post('/login')
def login(req: dict):
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".customers')
        for record in cur.fetchall():
            if record[5] == req["customerEmail"] and record[6] == req["password"]:
                return {"customerID": record[0]}
        return {"customerID": 0}
    

@app.post("/register-product-information")
def registerProductInformation(req: dict):
    id = 1
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        if record[0] is None:
            id = 1
        else:
            if record[0] >= id:
                id = record[0] + 1
                    
    insert_script = 'INSERT INTO "OnlineShop".products (productID, productName, productVendor, buyPrice, salePrice, textDescription, image, gameReleaseDate) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)'
    insert_value = (id, req["productName"], req["productVendor"], req["buyPrice"], req["salePrice"], req["textDescription"], req["image"], req["gameReleaseDate"])
    cur.execute(insert_script, insert_value)
    conn.commit()
    return {"registerProductInformation": True}

@app.patch("/edit-product-information")
def editProductInformation(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        if record[0] == req["productID"]:
            update_script = 'UPDATE "OnlineShop".products SET productName = %s, productVendor = %s, buyPrice = %s, salePrice = %s, textDescription = %s, image = %s, gameReleaseDate = %s'
            update_value = (req["productName"], req["productVendor"], req["buyPrice"], req["salePrice"], req["textDescription"], req["image"], req["gameReleaseDate"])
            cur.execute(update_script, update_value)
            conn.commit()
            return {"wrongID": False}
        else:
            return {"wrongID": True}

@app.get("/product-search")
def productSearch():
    conn = None
    cur = None
    products = []
    try:
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".products')
        for record in cur.fetchall():
            products.append({"productID": record[0],
                             "productName": record[1]})
            
    except Exception as erorr:
        print(erorr)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:    
            conn.close()    
    return products

@app.post("/registration-products-order")
def registrationProductsOrder(req: dict):
    id = 1
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".orders')
    for record in cur.fetchall():
        if record[0] is None:
            id = 1
        else:
            id = record[0] + 1
            
    insert_script = 'INSERT INTO "OnlineShop".orders (orderID, confirmationDate, requiredDate, shippedDate, status, comments, customerID) VALUES (%s,%s,%s,%s,%s,%s,%s)'
    insert_value = (id, None, localTime(), None, 1, None, req["customerID"])
    cur.execute(insert_script, insert_value)
    conn.commit()
    cur.execute('SELECT * FROM "OnlineShop".products')
    insert_script = 'UPDATE "OnlineShop".products SET orderID = %s where productid = %s '    
    update_value = (id, req["productID"])
    cur.execute(insert_script, update_value)
    conn.commit()
    return {"isRegistrationProductsOrder": True}

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
                update_value = (localTime(), shippedTime(), 1)
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

@app.get("/sort-product-release")
def sortProductRelease():
    sort_product = []
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        sort_product.append({"productID": record[0],
                        "productName": record[1],
                        "salePrice": record[4],
                        "image": record[6],
                        "gameReleaseDate": record[7]})
    sort_product.sort(key=lambda sort_product: sort_product["gameReleaseDate"])    
    return sort_product

@app.post("/get-product")
def getProduct(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        if record[0] == req["productID"]:
            product = {"productName": record[1],
                       "productVendor": record[2],
                       "buyPrice": record[3],
                       "salePrice": record[4],
                       "textDescription": record[5],
                       "image": record[6],
                       "gameReleaseDate": record[7]}
    return product

@app.post("/get-product-order")
def getProductOrder(req: dict):
    products =[]
    conn, cur = create_connection()
    cur.execute('''select p.productid ,p.productname ,p.productvendor ,p.buyprice ,p.saleprice , p.textdescription ,p.image ,p.gamereleasedate, o.customerid ,o.orderid 
                from "OnlineShop".orders o join "OnlineShop".products p 
                on o.orderid = p.orderid ''')
    for record in cur.fetchall():
        if record[8] == req["customerID"]:
            products.append({
                        "productID": record[0],
                        "productName": record[1],
                        "productVendor": record[2],
                        "buyPrice": record[3],
                        "salePrice": record[4],
                        "textDescription": record[5],
                        "image": record[6],
                        "gameReleaseDate": record[7],
                        "orderID": record[9]})     
    return products

@app.post("/delete-order")
def deleteOrder(req: dict):
    conn, cur = create_connection()
    update_script = 'update "OnlineShop".products set orderID = null where orderID = %s'
    update_value = (str(req["orderID"]))
    cur.execute(update_script, update_value)
    delete_script =  'delete from "OnlineShop".orders where orderID = %s'
    delete_value = (str(req["orderID"]))
    cur.execute(delete_script, delete_value)
    conn.commit()
    return {"isDelete": True}

@app.post('/login-expert')
def loginExpert(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".experts')
    for record in cur.fetchall():
        if record[4] == req["employeeNeme"] and record[5] == req["employeePass"]:
            return {"expertID": record[0]}
    return {"expertID": 0}
    
@app.post('/get-customer')
def getCustomer(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".customers')
    for record in cur.fetchall():
        if record[0] == req["customerID"]:
            customer = {"customerFullName": record[1],
                       "phone": record[2],
                       "city": record[3],
                       "address": record[4],
                       "customerEmail": record[5],
                       "password": record[6],
                       "expertID": record[7]}
    return customer

@app.post('/get-expert')
def getExpert(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".experts')
    for record in cur.fetchall():
        if record[0] == req["expertID"]:
            expert = {"expertFullName": record[1],
                       "expertEmail": record[2],
                       "jobTitle": record[3],
                       "employeeNeme": record[4],
                       "employeePass": record[5]}
    return expert

