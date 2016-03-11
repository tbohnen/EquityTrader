<<<<<<< HEAD
# EquityTrader
=======

###What is Equity Trader###
Equity Trader was born out of a need that I had, that need being to be able to view and analyse stocks without spending half of my investment budget on fancy, overcharged platforms.

In short, Equity Trader is for the everyday man that just wants to look at prices and do back-testing as well as search through stocks with a specified criteria.

###DISCLAIMER###
My intention is not to violate any copyright or anything. I've done my best to keep this is platform agnostic but please do let me know if there is anything that should not be here!

###Installing###
I am working on creating a docker container as soon as possible.

###Why not Google Finance etc?###

Honestly, I think Google Finance is a great platform and I think if that's enough for you, stick with it. My problem was that although they do have the ability to filter stock, I want so much more than that. My ultimate goal is to be able to setup a pre-defined "recipe" that will allow you to use technical indicators as well as fundamentals to eliminate stocks that does not fit your investment strategy.

###Supported data imports###

1. Currently Google Finance allows you to download end of day data in CSV format for any company going back to the start of the company. For most private investors that has a longer time horizon, this should be enough although it will support intraday price updates as well. There is a project in the solution called GoogleFinanceHistoricalPriceRetriever which you can use to load the data into the solution. I live in South Africa and I use a company called InvestorData (contact me for details) that offers a legal, personal use copy of the JSE data at a very reasonable price.

2. InvestorData, a South African 

3. Build your own
This is quite easy to do as it basically means writing a mongo loader that will transform from your format to my format. It currently relies on share instrument code, Share Industry, Share Sector, Share Long name and open, high, low and close. Look at the Google Finance importer for an example.

###Why not host it?###

Unfortunately most stock exchanges requires distribution agreements and that costs a lot of money. I originally wanted to ask a small fee for a subscription to make it possible, however this became too expensive an option for myself as well as the end users. One day I believe that the data will be free to distribute and I for one will welcome that day with open arms!

Until that day has come though, I've settled for packaging the solution in as compact a way as possible so that everyone can then host it themselves, be it on a local machine or hosted somehwere. This then allows you to download and source the data for private use, not incurring any costs. 

###State of the project###
PRE-ALPHA!!!!!!

I started writing this application for myself and it quickly came to the point where I realised it could benefit a lot of other people. That being said, it's still in beta and very buggy. I worked on it early mornings and late evenings so don't judge and I believe in hacking, finding what works and then stabalising. When I hack something new together, I always try and do it in a way that will allow me to refactor in an easy manner. Wherever possible, I used tests although a lot of them hasn't been upgraded when I changed versions.

Although I use this project myself, it's not bug free and there are still a lot of concepts in the hacking phase that I need to stabalise.

###Tech Stack###

One of the things that I believe in is the right tool for the right job and as such, you will see quite a lot of tools. I also like to try a lot of languages and believe in polyglot solutions. 

##Programming Languages used##

1. Ruby - Used to generate the reports and serve the API in Sinatra that both the mobile client as well as the website consumes
2. C# - This is a very small microservice that loads the data from Google Finance.
3. F# (deprecated) - Was used to calculate movement as well as Technical indicators although it became too ardious on osx and ubuntu so decided to go for Elixir instead.
4. Elixir - This is used to calcuate movements,technical indicators as well asl import the investordata files.
5. Javascript

##Database##
Mongo

##Mobile##
1. The mobile app is written in the Ionic framework

##Web##
1. Website is served with the express framework in NodeJs, using Angular 1. I believe in having a very thin web layer and doing most of the display in html and javascript and letting the business logic reside in the API. That way the code for the website as well as the mobile application is easily changeable.
>>>>>>> parent of b1439f2... Added initial docker file as well as housekeeping
