from fastapi import FastAPI
import psycopg2
import time

app = FastAPI()

def localTime():
    localTime = time.ctime(time.time())
    return localTime


def shippedTime():
    shippedTime = time.ctime(time.time() + 432000)
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
    
    
@app.post('/login')
def login(req: dict):
        conn, cur = create_connection()
        cur.execute('SELECT * FROM "OnlineShop".customers')
        for record in cur.fetchall():
            if record[5] == req["customerEmail"] and record[6] == req["password"]:
                return {"customerID": record[0]}
        return {"customerID": 0}


@app.post("/signup")
def signup(req: dict):
    id = 1
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".customers')
    for record in cur.fetchall():
        if record[0] is None:
            id = 1
        else:
            if record[0] >= id:
                id = record[0] + 1
        if record[5] == req["customerEmail"]:
            return {"isExistEmail": True}
            
    insert_script = 'INSERT INTO "OnlineShop".customers (customerID, customerFullName, phone, city, address, customerEmail, password, expertID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)'
    insert_value = (id ,req["customerFullName"], req["phone"], req["city"], req["address"], req["customerEmail"], req["password"], 1)
    cur.execute(insert_script, insert_value)
    conn.commit()
    
    return {"isExistEmail": False}


@app.get("/product-search")
def productSearch():
    products = []
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        products.append({"productID": record[0],
                            "productName": record[1]}) 
            
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
            if record[0] >= id:
                id = record[0] + 1
                
    select_script = 'select p.orderid from "OnlineShop".products p where productid = %s'
    select_value = (str(req["productID"]))        
    cur.execute(select_script, select_value)
    if cur.fetchone()[0] == None:
        insert_script = 'INSERT INTO "OnlineShop".orders (orderID, confirmationDate, requiredDate, shippedDate, status, comments, customerID) VALUES (%s,%s,%s,%s,%s,%s,%s)'
        insert_value = (id, None, localTime(), None, 1, None, req["customerID"])
        cur.execute(insert_script, insert_value)
        conn.commit()
        cur.execute('SELECT * FROM "OnlineShop".products')
        insert_script = 'UPDATE "OnlineShop".products SET orderID = %s where productid = %s'    
        update_value = (id, req["productID"])
        cur.execute(insert_script, update_value)
        conn.commit()
        return {"isRegistrationProductsOrder": True} 
    else:
        return {"isRegistrationProductsOrder": False}
        

@app.post('/product-categories')
def productCategories(req: dict):
    conn, cur = create_connection()
    products = []
    select_script = 'select p.productid ,p.productname ,p.saleprice ,p.image ,p.gamereleasedate from "OnlineShop".products p where category = %s'
    select_value = (str(req["category"]))
    cur.execute(select_script, select_value)
    for record in cur.fetchall():
        products.append({
            "productID": record[0],
            "productName": record[1],
            "salePrice": record[2],
            "image": record[3],
            "gameReleaseDate": record[4]
        })
    return products

@app.post('/finalizing-order')
def finalizingOrder(req: dict):
    conn, cur = create_connection()
    update_script = 'UPDATE "OnlineShop".orders SET shippedDate = %s, status = %s where orderID = %s'
    update_value = (shippedTime() , 3, req["orderID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isFinalizingOrder": True}

@app.post('/cancel-order')
def cancelOrder(req: dict):
    conn, cur = create_connection()
    update_script = 'UPDATE "OnlineShop".orders SET status = %s where orderID = %s'
    update_value = (4, req["orderID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isCancelOrder": True}
    
@app.post('/login-expert')
def loginExpert(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".experts')
    for record in cur.fetchall():
        if record[4] == req["employeeNeme"] and record[5] == req["employeePass"]:
            return {"expertID": record[0]}
    return {"expertID": 0}   


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
                    
    insert_script = 'INSERT INTO "OnlineShop".products (productID, productName, productVendor, buyPrice, salePrice, textDescription, image, gameReleaseDate, category) VALUES (%s ,%s, %s, %s, %s, %s, %s, %s, %s)'
    insert_value = (id, req["productName"], req["productVendor"], req["buyPrice"], req["salePrice"], req["textDescription"], req["image"], req["gameReleaseDate"], req["category"])
    cur.execute(insert_script, insert_value)
    conn.commit()
    
    return {"registerProductInformation": True}


@app.post("/edit-product-information")
def editProductInformation(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    update_script = 'UPDATE "OnlineShop".products SET productName = %s, productVendor = %s, buyPrice = %s, salePrice = %s, textDescription = %s, image = %s, gameReleaseDate = %s, category = %s where productID = %s'
    update_value = (req["productName"], req["productVendor"], req["buyPrice"], req["salePrice"], req["textDescription"], req["image"], req["gameReleaseDate"], req["category"], req["productID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isEditProduct": True}


@app.post("/customer-order-confirmation")
def customerOrderConfirmation(req: dict):
    conn, cur = create_connection()
    update_script = 'UPDATE "OnlineShop".orders SET confirmationDate = %s, status = %s where orderID = %s'
    update_value = (localTime(), 2, req["orderID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isCustomerOrderConfirmation": True}
          
                
@app.get("/get-sort-product-release")
def getSortProductRelease():
    sort_product = []
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    for record in cur.fetchall():
        sort_product.append({"productID": record[0],
                        "productName": record[1],
                        "salePrice": record[4],
                        "image": record[6],
                        "gameReleaseDate": record[7],
                        "category": record[8]})
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
                       "gameReleaseDate": record[7],
                       "category": record[8]}
            
    return product


@app.post("/get-product-order")
def getProductOrder(req: dict):
    products =[]
    conn, cur = create_connection()
    cur.execute('''select p.productid ,p.productname ,p.productvendor ,p.buyprice ,p.saleprice , p.textdescription ,p.image ,p.gamereleasedate ,category ,o.customerid ,o.orderid, o.status
                from "OnlineShop".orders o join "OnlineShop".products p 
                on o.orderid = p.orderid ''')
    for record in cur.fetchall():
        if record[9] == req["customerID"]:
            products.append({
                        "productID": record[0],
                        "productName": record[1],
                        "productVendor": record[2],
                        "buyPrice": record[3],
                        "salePrice": record[4],
                        "textDescription": record[5],
                        "image": record[6],
                        "gameReleaseDate": record[7],
                        "category": record[8],
                        "orderID": record[10],
                        "status": record[11]})     
            
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


@app.get('/get-registered-orders')
def getRegisteredOrders():
    registered_orders = []
    conn, cur = create_connection()
    cur.execute('''select o.orderID, o.requiredDate, o.status, p.productName, p.salePrice, p.image, c.customerFullName, c.customerEmail
                   from "OnlineShop".orders o join "OnlineShop".products p on o.orderid = p.orderid join "OnlineShop".customers c on c.customerid = o.customerid
                   where o.status = 1''')
    for record in cur.fetchall(): 
        registered_orders.append({
            "orderID": record[0],
            "requiredDate": record[1],
            "status": record[2],
            "productName": record[3],
            "salePrice": record[4],
            "image": record[5],
            "customerFullName": record[6],
            "customerEmail": record[7]})
    
    return registered_orders



