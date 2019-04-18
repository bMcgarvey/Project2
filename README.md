# project1saleforce
this is an edit to the readme

https://trello.com/b/nXIJdENl/project-2-tbd

Player; 

Name Name,

balance__c: formula field

DepositTotal__c: rollup summary

GameIncome__c: rollup summary

Games_Played__c: rollup summary

WithdrawalTotal__c: rollup summary


Game; Name,

Games_Played__c rollup summary

Profit_Loss__c rollup summary

Transaction; Has record types(withdrawal/deposit)

name name auto number,

player player__c master detail, 

withdrawal/deposit Transaction_Type__c picklist(withdrawal/deposit),

amount amount__c currency

Result; 

name name autonumber

game game__c master detail,

player player__c master detail, 

buy in buy_in__c, currency

payout payout__c, currency

gain/loss gain_loss__c, formula

