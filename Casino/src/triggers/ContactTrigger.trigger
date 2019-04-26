trigger ContactTrigger on Contact (before insert, after insert, before update) {
    
    
    /* Doesn't work!
    //Check for duplicate Emails, do not allow creation if there is one
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        ContactTriggerHelper.avoidDuplicateEmails(trigger.new, trigger.oldMap, trigger.isInsert);
    }
    
    //Creates a new user and player on creation of a contact
    if(trigger.isAfter && trigger.isInsert){
        
        Set<Id> contactIds = new Set<Id>();
        for(Contact c : Trigger.new){
            contactIds.add(c.id);
        }
        
        if(contactIds.size() > 0){
            ContactTriggerHelper.createNewUsersAndPlayers(contactIds);
        }
    }*/
}