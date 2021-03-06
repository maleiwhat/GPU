import mysql.connector
from datetime import date, datetime, timedelta
from conf import mysql_host, mysql_username, mysql_password, mysql_database, th_day_interval
create_user="bitcoinbot"


def db_get_avg(myinterval):
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select avg(price) from pricevalue where create_dt >= (NOW() - INTERVAL "+str(myinterval)+" MINUTE);")
    cursor.execute(query)
    myavg = cursor.fetchone()
    cursor.close()
    cnx.close()
    return myavg[0]


def db_get_vol():
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select volume from pricevalue where id=(select max(id) from pricevalue);")
    cursor.execute(query)
    myvol = cursor.fetchone()
    cursor.close()
    cnx.close()
    return myvol[0]

def db_get_thlow(myinterval):
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select min(price) from pricevalue where create_dt >= (NOW() - INTERVAL "+str(myinterval)+" MINUTE);")
    cursor.execute(query)
    thlow = cursor.fetchone()
    cursor.close()
    cnx.close()
    return thlow[0]

def db_get_thhigh(myinterval):
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select max(price) from pricevalue where create_dt >= (NOW() - INTERVAL "+str(myinterval)+" MINUTE);")
    cursor.execute(query)
    thhigh = cursor.fetchone()
    cursor.close()
    cnx.close()
    return thhigh[0]

def db_get_last():
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select price from pricevalue where id=(select max(id) from pricevalue);")
    cursor.execute(query)
    last = cursor.fetchone()
    cursor.close()
    cnx.close()
    return last[0]


def db_get_bid():
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select buy from pricevalue where id=(select max(id) from pricevalue);")
    cursor.execute(query)
    buy = cursor.fetchone()
    cursor.close()
    cnx.close()
    return buy[0]

def db_get_ask():
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select sell from pricevalue where id=(select max(id) from pricevalue);")
    cursor.execute(query)
    sell = cursor.fetchone()
    cursor.close()
    cnx.close()
    return sell[0]

def db_get_wallet(mywallet):
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()
    query = ("select usd,btc,bucket_usd from wallet where id=(select max(id) from wallet where name='"+mywallet+"');")
    cursor.execute(query)
    wallet = cursor.fetchone()
    cursor.close()
    cnx.close()
    return wallet[0],wallet[1],wallet[2]

def db_adjust_wallet_usd(name, usd):
    my_usd,my_btc,my_bucket=db_get_wallet(name)

    if (my_usd+usd)>0:
        db_store_wallet(name, my_btc,my_usd+usd,0,my_bucket)
        return 1
    else:
        return 0

def db_adjust_wallet_btc(name, btc):
    my_usd,my_btc,my_bucket=db_get_wallet(name)

    if (my_btc+btc)>0:
        db_store_wallet(name, my_btc+btc,my_usd,0,my_bucket)
        return 1
    else:
        return 0


def db_store_total_wallet():
    short_usd,short_btc,short_bucket_usd=db_get_wallet("shortterm")
    mid_usd,mid_btc,mid_bucket_usd=db_get_wallet("midterm")
    long_usd,long_btc,long_bucket_usd=db_get_wallet("longterm")
    tiz_usd,tiz_btc,tiz_bucket_usd=db_get_wallet("tiz")

    total_usd = short_usd + mid_usd + long_usd + tiz_usd
    total_btc = short_btc + mid_btc + long_btc + tiz_btc

    db_store_wallet("total", total_btc, total_usd, 0)



def db_store_ticker(last, high, low, avg, vwap, buy, sell, vol, arestrings=1):
    #print "I am here 1"
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()

    #print "I am here 2"
    if arestrings==1:
        last  = last.replace("$","")
        high = high.replace("$","")
        low  = low.replace("$","")
        avg = avg.replace("$","")
        vwap = vwap.replace("$","")
        buy = buy.replace("$","")
        sell = sell.replace("$","")
        vol = vol.replace("BTC","")
        vol = vol.replace(",","")

    #print "I am here 3"
    mynow = datetime.now()
    myavg = db_get_avg(th_day_interval*24*60)
    thlow = db_get_thlow(th_day_interval*24*60)
    thhigh = db_get_thhigh(th_day_interval*24*60)

    add_ticker = ("INSERT INTO pricevalue "
                  "(create_dt, price, high, low, volume, avgexchange, myavg, th_low, th_high, changepct, create_user, buy, sell, vwap) "
                  "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")

    data_ticker = (mynow, last, high, low, vol, avg, myavg, thlow, thhigh, 0, create_user, buy, sell, vwap)

    cursor.execute(add_ticker, data_ticker)
    cnx.commit()

    cursor.close()
    cnx.close()
    #print "ticker inserted into database"


def db_store_trade(direction, amount, price, marketorder, description=""):
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()

    mynow = datetime.now()
    total = amount*price

    if (direction=="BUY"):
        total=-total

    add_trade = ("INSERT INTO trade "
                  "(direction, amount, price, total, marketorder, description, create_dt, create_user)"
                  "VALUES (%s, %s, %s, %s, %s, %s, %s, %s)")

    data_trade = (direction, amount, price, total, marketorder, description, mynow, create_user)

    cursor.execute(add_trade, data_trade)
    cnx.commit()

    cursor.close()
    cnx.close()
    print "trade inserted into database"


def db_store_wallet(name, btc, usd, eur, bucket=0):
    cnx = mysql.connector.connect(user=mysql_username, password=mysql_password,
                              host=mysql_host,
                              database=mysql_database)
    cursor = cnx.cursor()

    mynow = datetime.now()

    marketprice_usd = float(db_get_last());
    marketvalue_usd = marketprice_usd * float(btc)
    total_usd       = float(usd) + marketvalue_usd

    add_trade = ("INSERT INTO wallet "
                  "(name, btc, usd, eur, create_dt, create_user, marketprice_usd, marketvalue_usd, total_usd, bucket_usd)"
                  "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")

    data_trade = (name, btc, usd, eur, mynow, create_user, marketprice_usd, marketvalue_usd, total_usd, bucket)

    cursor.execute(add_trade, data_trade)
    cnx.commit()

    cursor.close()
    cnx.close()
    print "wallet", name, "inserted into database"
