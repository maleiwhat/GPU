from __future__ import division
from func import *
from dbadapter import *
from sys import exit
import random
#parameters
checkwalletconsistency=0 # causes interface to timeout

class DbBot(object):
    def __init__(self, wallet, frequency, timewindow, freshprices, stoploss):
        self.logstr = 'dbbot('+wallet+'):'
        print now(), self.logstr, wallet, frequency, timewindow
        self.wallet = wallet
        self.frequency = frequency
        self.timewindow = timewindow
        self.freshprices = freshprices
        self.stoploss = stoploss

    def run_once(self):
        print now(), self.logstr, 'retrieving my wallet...'
        my_usd,my_btc,my_bucket_usd=db_get_wallet(self.wallet)
        print now(), 'USD: ', my_usd, '$ BTC: ',my_btc, 'Bucket: ', my_bucket_usd, '$'
        # now verifying that wallet is not outofsync with mtgox
        if (checkwalletconsistency==1):
            wallets = get_wallets()
            mtgox_usd = int(wallets['USD']['Balance']['value_int'])
            mtgox_btc = int(wallets['BTC']['Balance']['value_int'])
            if (my_usd>mtgox_usd) or (my_btc>mtgox_btc):
                print now(), 'Internal error, exiting bot: strategy wallet has more than mtgox wallet!' 'USD: ', my_usd, 'BTC: ',my_btc, 'mtgox_USD', mtgox_usd, 'mtgox_BTC', mtgox_btc
                os._exit()
            print now(), self.logstr, 'Wallet '+self.wallet+' is consistent with mtgox one.'
            print now(), self.logstr, 'Sleeping 180 seconds before attempting anything.'
            time.sleep(180+random.randrange(0,5));
        else:
            print now(),self.logstr, "wallet consistency check disabled."

        if (self.freshprices==1):
            bid = float(current_bid_price()/rusd)
            ask = float(current_ask_price()/rusd)
        else:
            bid = db_get_bid();
            ask = db_get_ask();

        curprice = float((bid + ask) / 2)

        print now(),self.logstr, "Current prices retrieved."
        # now retrieving all parameters to start trading decision
        thlow     = db_get_thlow(self.timewindow);
        thhigh    = db_get_thhigh(self.timewindow);
        avg       = db_get_avg(self.timewindow)
        vol       = db_get_vol()
        usdtobuy  = min(my_usd, my_bucket_usd)
        btctosell = min(my_btc, float(my_bucket_usd/curprice))

        #print now(),self.logstr, "Current parameters retrieved."
        if (self.freshprices==1):
            db_store_ticker(curprice, thhigh, thlow, avg, 0, bid, ask, vol, 0)

        #print now(),self.logstr, "Storing data into local database."

        print now(), '*** Parameters to start trading decision ***'
        print 'frequency: ', self.frequency, ' min. timewindow: ', self.timewindow, ' min.'
        print 'mid: ', curprice, '$ thhigh: ', thhigh, '$ thlow: ', thlow, '$'
        print 'spread: ', (ask-bid), '$ bid: ', bid, '$ ask: ', ask, '$'
        print 'USDtobuy: ', usdtobuy, '$ BTCtosell: ', btctosell, ' BTC'
        print 'Stop loss:', self.stoploss, 'USD'
        print now(), '********************************************'

        if (curprice<self.stoploss):
            print now(), 'Price is ', price, 'and is lower than stoploss! ', stoploss
            print now(), 'Selling immediately ', my_btc, 'BTC'
            ressell = sell(my_btc*rbtc)
            print 'Sell result: ', ressell
            db_store_wallet(self.wallet, 0, my_usd+float(my_btc*curprice), 0, my_bucket_usd)
            db_store_trade('SELL', my_btc, curprice, 1, self.wallet)
            db_store_total_wallet()
            os._exit()

        if (thlow>thhigh):
            print now(), 'Internal error, exiting bot: (thlow>thhigh) thlow: ', thlow, ' thhigh: ', thhigh
            os._exit()

        if (ask<=thlow):
            print now(), 'I would like to buy...'
            if (usdtobuy>0.01):
                print now(), '*** Decided to BUY at ', ask, '$'
                btctobuy = float(usdtobuy/ask)
                print now(), ' Buying ', btctobuy, ' bitcoins...'
                resbuy = buy(btctobuy*rbtc)
                print 'Buy result: ', resbuy
                new_btc = my_btc + btctobuy
                new_usd = my_usd - float(btctobuy*ask)
                print now(), self.logstr, 'New wallet is approximately'
                print now(), 'USD: ', new_usd, 'BTC: ', new_btc
                db_store_wallet(self.wallet, new_btc, new_usd, 0, my_bucket_usd)
                db_store_trade('BUY', btctobuy, ask, 1, self.wallet)
                db_store_total_wallet()

        else:
            if (bid>=thhigh):
                print now(), 'I would like to sell...'
                if (btctosell>0.01):
                    print now(), '*** Decided to SELL at ', bid, '$'
                    print now(), ' Selling ', btctosell, ' bitcoins...'
                    ressell = sell(btctosell*rbtc)
                    print 'Sell result: ', ressell
                    new_btc = my_btc - btctosell
                    new_usd = my_usd + float(btctosell*bid)
                    print now(), self.logstr, 'New wallet is approximately'
                    print now(), 'USD: ', new_usd, 'BTC: ', new_btc
                    db_store_wallet(self.wallet, new_btc, new_usd, 0, my_bucket_usd)
                    db_store_trade('SELL', btctosell, bid, 1, self.wallet)
                    db_store_total_wallet()
            else:
                print now(), self.logstr, 'Decided to wait...'

    def run(self):
        while 1:
            try:
                self.run_once()
            except IOError as e:
                print "I/O error({0}): {1}".format(e.errno, e.strerror)
            except ValueError:
                print "Could not convert data to an integer."
            except:
                print "Unexpected error!" #, sys.exc_info()[0]
                print "Error({0}): {1}".format(e.errno, e.strerror)
                #raise

            mysleep = (self.frequency*60) + random.randrange(0,120);
            print now(), self.logstr, 'Sleeping for '+str(mysleep)+' seconds...'
            time.sleep(mysleep)

