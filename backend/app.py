from fastapi import FastAPI
import psycopg2
import time
import uvicorn

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
            if record[7] == req["customerEmail"] and record[8] == req["password"]:
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
        if record[7] == req["customerEmail"]:
            return {"isExistEmail": True}
            
    insert_script = 'INSERT INTO "OnlineShop".customers (customerID, customerFullName, phone, city, address, score, specialMode, customerEmail, password, expertID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
    insert_value = (id ,req["customerFullName"], req["phone"], req["city"], req["address"], 0, False, req["customerEmail"], req["password"], 1)
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

@app.post("/add-product-basket")
def addProductBasket(req: dict):
    conn, cur = create_connection()
    insert_script = 'insert into "OnlineShop".productBasket (customerID, productID) values (%s, %s)'
    insert_value = (req["customerID"] ,req["productID"])
    cur.execute(insert_script, insert_value)
    conn.commit()
    return {"isaddProductBasket": True}
    
    
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
                
    insert_script = 'INSERT INTO "OnlineShop".orders (orderID, confirmationDate, requiredDate, shippedDate, customerID, statusID) VALUES (%s,%s,%s,%s,%s,%s)'
    insert_value = (id, None, localTime(), None, req["customerID"], 1)
    cur.execute(insert_script, insert_value)
    conn.commit()
    select_script = 'select * from "OnlineShop".productbasket p where p.customerID = %s'
    select_value = (str(req["customerID"]))
    cur.execute(select_script, select_value)  
    for record in cur.fetchall():
        insert_script = 'insert into "OnlineShop".orderdetails (productID, orderID) values (%s, %s)'
        insert_value = (record[1], id)
        cur.execute(insert_script, insert_value)
        conn.commit() 
    insert_script = 'delete from "OnlineShop".productbasket where customerid = %s'
    insert_value = (str(req["customerID"]))
    cur.execute(insert_script, insert_value)
    conn.commit() 
    return {"isRegistrationProductsOrder": True}

@app.post('/product-categories')
def productCategories(req: dict):
    conn, cur = create_connection()
    products = []
    select_script = 'select * from "OnlineShop".products p join "OnlineShop".category c on p.categoryid = c.categoryid where p.categoryid = %s'
    select_value = (str(req["categoryid"]))
    cur.execute(select_script, select_value)
    for record in cur.fetchall():
        products.append({
            "productID": record[0],
            "productName": record[1],
            "salePrice": record[4],
            "discountedPrice": record[5],
            "image": record[7],
            "gameReleaseDate": record[8],
            "categoryName": record[12]})
    return products

@app.post('/finalizing-order')
def finalizingOrder(req: dict):
    conn, cur = create_connection()
    update_script = 'UPDATE "OnlineShop".orders SET shippedDate = %s, statusID = %s where orderID = %s'
    update_value = (shippedTime() , 3, req["orderID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isFinalizingOrder": True}



@app.post('/cancel-order')
def cancelOrder(req: dict):
    conn, cur = create_connection()
    update_script = 'UPDATE "OnlineShop".orders SET statusID = %s where orderID = %s'
    update_value = (4, req["orderID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isCancelOrder": True}



@app.post('/registration-satisfaction')
def registrationSatisfaction(req: dict):
    conn, cur = create_connection()
    update_script = 'update "OnlineShop".orderdetails set satisfaction = true where productid = %s and orderid = %s'
    update_value = (req["productID"], req["orderid"])
    cur.execute(update_script, update_value)
    insert_script = 'insert into "OnlineShop".satisfaction values (%s, %s, %s, %s)'
    insert_value = (req["productID"], req["customerID"], req["satisfactionRate"], localTime())
    cur.execute(insert_script, insert_value)
    conn.commit()
    
    return {"isRegistrationSatisfaction": True}

@app.post('/add-product-notices')
def addProductNotices(req: dict):
    conn, cur = create_connection()
    insert_script = 'insert into "OnlineShop".notices (productID, customerID) values (%s, %s)'
    insert_value = (req["productID"], req["customerID"])
    cur.execute(insert_script, insert_value)
    conn.commit()
    
@app.post('/delete-product-notices')
def deleteProductNotices(req: dict):
    conn, cur = create_connection()
    delete_script = 'delete from "OnlineShop".notices where productid = %s and customerid = %s'
    delete_value = (req["productID"], req["customerID"])
    cur.execute(delete_script, delete_value)
    conn.commit()
    
    
@app.post('/product-notices')  
def productNotices(req: dict): 
    conn, cur = create_connection() 
    
    
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
                    
    insert_script = 'INSERT INTO "OnlineShop".products (productID, productName, productPublisher, buyPrice, salePrice, discountedPrice, textDescription, image, gameReleaseDate, stock, categoryID) VALUES (%s ,%s, %s, %s, %s, %s, %s, %s, %s,%s, %s)'
    insert_value = (id, req["productName"], req["productPublisher"], req["buyPrice"], req["salePrice"], req["discountedPrice"], req["textDescription"], req["image"], req["gameReleaseDate"], req["stock"], req["categoryID"])
    cur.execute(insert_script, insert_value)
    conn.commit()
    
    return {"registerProductInformation": True}


@app.post("/edit-product-information")
def editProductInformation(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products')
    update_script = 'UPDATE "OnlineShop".products SET productName = %s, productPublisher = %s, buyPrice = %s, salePrice = %s, discountedPrice = %s, textDescription = %s, image = %s, gameReleaseDate = %s, stock = %s, categoryID = %s where productID = %s'
    update_value = (req["productName"], req["productPublisher"], req["buyPrice"], req["salePrice"], req["discountedPrice"], req["textDescription"], req["image"], req["gameReleaseDate"], req["stock"], req["categoryID"], req["productID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isEditProduct": True}


@app.post("/customer-order-confirmation")
def customerOrderConfirmation(req: dict):
    conn, cur = create_connection()
    update_script = 'UPDATE "OnlineShop".orders SET confirmationDate = %s, statusID = %s where orderID = %s'
    update_value = (localTime(), 2, req["orderID"])
    cur.execute(update_script, update_value)
    conn.commit()
    
    return {"isCustomerOrderConfirmation": True}

@app.get("/get-order-expert")
def getOrderExpert():
    orders = []
    conn, cur = create_connection()
    cur.execute('''select o.orderID, o.confirmationDate, o.requiredDate, o.statusID, s.statusname, c.customerid, c.customerfullname , c.customeremail 
                from "OnlineShop".orders o join "OnlineShop".status s on o.statusid = s.statusid join "OnlineShop".customers c on o.customerid = c.customerid 
                where o.statusid = 1 or o.statusid = 4''')
    for record in cur.fetchall():
        orders.append({
                    "orderID": record[0],
                    "confirmationDate": record[1],
                    "requiredDate": record[2],
                    "statusID": record[3],
                    "statusName": record[4],
                    "customerid": record[5],
                    "customerfullname": record[6],
                    "customeremail": record[7],})                 
    return orders
          
                
@app.get("/get-sort-product-release")
def getSortProductRelease():
    sort_product = []
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products p join "OnlineShop".category c on p.categoryID = c.categoryID')
    for record in cur.fetchall():
        sort_product.append({"productID": record[0],
                        "productName": record[1],
                        "salePrice": record[4],
                        "discountedPrice": record[5],
                        "image": record[7],
                        "gameReleaseDate": record[8],
                        "category": record[10],
                        "categoryName": record[12]})
    sort_product.sort(key=lambda sort_product: sort_product["gameReleaseDate"], reverse=True)    
    return sort_product


@app.post("/get-product")
def getProduct(req: dict):
    conn, cur = create_connection()
    cur.execute('SELECT * FROM "OnlineShop".products p join "OnlineShop".category c on p.categoryID = c.categoryID')
    for record in cur.fetchall():
        if record[0] == req["productID"]:
            product = {"productName": record[1],
                       "productPublisher": record[2],
                       "buyPrice": record[3],
                       "salePrice": record[4],
                       "discountedPrice": record[5],
                       "textDescription": record[6],
                       "image": record[7],
                       "gameReleaseDate": record[8],
                       "stock": record[9],
                       "categoryID": record[10],
                       "categoryName": record[12]}
            
    return product


@app.post("/get-prodect-basket")
def getProdectBasket(req: dict):
    products =[]
    conn, cur = create_connection()
    select_script = 'select * from "OnlineShop".productbasket p join "OnlineShop".products p2 on p.productid = p2.productid where p.customerid = %s'
    select_value = (str(req["customerID"]))
    cur.execute(select_script, select_value)  
    for record in cur.fetchall():
        products.append({
                    "productID": record[1],
                    "productName": record[3],
                    "salePrice": record[6],
                    "discountedPrice": record[7],
                    "image": record[9]})     
            
    return products

@app.post("/delete-peoduct-basket")
def deleteProductBasket(req: dict):
    conn, cur = create_connection()
    delete_script = 'delete from "OnlineShop".productbasket where customerid = %s and productid = %s'
    delete_value = (req["customerid"], req["productid"])
    cur.execute(delete_script, delete_value)
    conn.commit()
    return {"isdeleteProductBasket": True}
    
    
@app.post("/get-product-order")
def getProductOrder(req: dict):
    products = []
    conn, cur = create_connection()
    select_script = '''select p.productid ,p.productname ,p.saleprice ,p.discountedprice 
                from "OnlineShop".orders o join "OnlineShop".orderdetails o2  on o.orderid = o2.orderid join "OnlineShop".products p on p.productid = o2.productid 
                where o.orderid = %s'''
    select_value = (str(req["orderid"]))
    cur.execute(select_script, select_value)
    for record in cur.fetchall():
        products.append({
                    "productID": record[0],
                    "productName": record[1],
                    "salePrice": record[2],
                    "discountedprice": record[3]})     
            
    return products

@app.post("/get-order")
def getOrder(req: dict):
    orders = []
    conn, cur = create_connection()
    select_script = 'select * from "OnlineShop".orders o join "OnlineShop".status s on o.statusid = s.statusid where customerid = %s'
    select_value = (str(req["customerID"]))
    cur.execute(select_script, select_value)
    for record in cur.fetchall():
        orders.append({
                    "orderID": record[0],
                    "confirmationDate": record[1],
                    "requiredDate": record[2],
                    "shippedDate": record[3],
                    "statusID": record[5],
                    "statusName": record[7]})                 
    return orders


@app.post("/delete-order")
def deleteOrder(req: dict):
    conn, cur = create_connection()
    delete_script =  'delete from "OnlineShop".orderdetails o2 where o2.orderid = %s'
    delete_value = (str(req["orderID"]))
    cur.execute(delete_script, delete_value)
    delete_script =  'delete from "OnlineShop".orders o where o.orderid = %s'
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
                       "score": record[5],
                       "specialMode": record[6],
                       "customerEmail": record[7],
                       "password": record[8],
                       "expertID": record[9]}
            
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

@app.post('/get-stock-notice')
def getStockNotice(req: dict):
    conn, cur = create_connection()
    select_script = 'select * from "OnlineShop".stocknotices s where s.productid = %s and s.customerid = %s'
    select_value = (req["productID"], req["customerID"])
    cur.execute(select_script, select_value)
    for record in cur.fetchall():
        if record[2] == False:
            return {"isReadyStockNotice": True}
        else:
            return {"isReadyStockNotice": False}
    return {"isReadyStockNotice": True}

@app.post('/add-stock-notices')
def addStockNotices(req: dict):
    conn, cur = create_connection()
    select_script = 'select * from "OnlineShop".stocknotices s where s.productid = %s and s.customerid = %s'
    select_value = (req["productID"], req["customerID"])
    cur.execute(select_script, select_value)
    if cur.fetchone() == None:
        insert_script = 'insert into "OnlineShop".stocknotices values (%s , %s, %s)'
        insert_value = (req["productID"], req["customerID"], True)
        cur.execute(insert_script, insert_value)
        conn.commit() 
        return {"isAddStockNotices": True}
    else:
        update_script = 'update "OnlineShop".stocknotices set stocknotice = true where productid = %s and customerid = %s'
        update_value = (req["productID"], req["customerID"])
        cur.execute(update_script, update_value)
        conn.commit() 
        return {"isAddStockNotices": True}

@app.post('/delete-stock-notices')
def deleteStockNotices(req: dict):
    conn, cur = create_connection()
    update_script = 'update "OnlineShop".stocknotices set stocknotice = false where productid = %s and customerid = %s'
    update_value = (req["productID"], req["customerID"])
    cur.execute(update_script, update_value)
    conn.commit() 
    return {"isDeleteStockNotices": True}


@app.post('/stock-notices')
def stockNotices(req: dict):
    products = []
    conn, cur = create_connection()
    select_script = ''' select p.productid ,p.productname ,p.stock 
                        from "OnlineShop".stocknotices s join "OnlineShop".products p on s.productid = p.productid 
                        where s.customerid = %s and s.stocknotice = true and p.stock != 0 '''
    select_value = (str(req["customerID"]))
    cur.execute(select_script, select_value)
    for record in cur.fetchall():
        products.append({"productid": record[0],
                         "productname": record[1],
                         "stock": record[2]})
    return products


if __name__ == '__main__':
    uvicorn.run("app:app", reload=True)
