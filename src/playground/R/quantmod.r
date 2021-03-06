# from http://www.quantmod.com/examples/intro/
library(quantmod)
getSymbols("YHOO",src="google") # from google finance
getSymbols("GOOG",src="yahoo") # from yahoo finance 
barChart(GOOG)

getSymbols("XPT/USD",src="oanda") 
chartSeries(XPTUSD,name="Platinum (.oz) in $USD")
# platinum, weekly with candles
chartSeries(to.weekly(XPTUSD),up.col='white',dn.col='blue')

# thechnical analysis
require(TTR)
getSymbols("AAPL")
chartSeries(AAPL)
addMACD()
addBBands()


getSymbols("KO",src="yahoo") # Coca Cola
barChart(KO)
getSymbols("TWTR",src="yahoo")
TWTR

# quantstrat package
# install.packages("quantstrat", repos="http://R-Forge.R-project.org")
 library(quantstrat)
 ??quantstrat

 
# in stats package
library(stats)
?fft
?spectrum
spectrum(b_avg_price$usd)
b_avg_price$usd-mean(b_avg_price$usd)
spectrum(b_avg_price$usd-mean(b_avg_price$usd))
fft(b_avg_price$usd)
plot(fft(b_avg_price$usd), type="l") #eh?
