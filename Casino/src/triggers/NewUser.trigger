trigger NewUser on User (after insert) {
    if(trigger.isAfter&&trigger.isInsert){
        List<Player__c> output = new List<Player__c>();
        for(User u: trigger.new){
            if(u.Profile.UserLicense.Name == 'Customer Community Plus'){
                //create a player, assign owner to user id, playername is user nickname
                //additionally user nickname is guarenteed to be unique so this prevents
                //players with duplicate names via this trigger.
                Player__c temp = new Player__c(name=u.Alias);
                System.debug(u.Alias);
                temp.OwnerId=u.Id;
                System.debug(u.Id);
                System.debug(temp);
                output.add(temp);
            }
        }
        insert output;
    }
}