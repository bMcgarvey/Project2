var currentGame = sforce.connection.query("SELECT Id FROM Game__c WHERE Name = '" + gameName + "' LIMIT 1")['records']['Id'];
var currentPlayer = sforce.connection.query("SELECT Id FROM Player__c WHERE OwnerId = '{!$User.Id}' LIMIT 1");
console.log(currentPlayer);
function insertResult(gameName, betAmount, winAmount, sessionId){
    var result = new sforce.SObject('Result__c');
    result.Player__c = currentPlayer;
    result.Buy_In__c = betAmount;
    result.Payout__c = winAmount;
    console.log(result);
    var returnVal = sforce.connection.create([result]);
	if(returnVal[0].getBoolean('success')) {
		console.log('New Account is created with id' + returnVal[0].id);
	}else{
		console.log('failed to create new Account' + returnVal[0]);
	}
}