global class OrgConstants {
    
    global static final List<Schema.PicklistEntry> TRANSACTION_PICKLIST = Transaction__c.Transaction_Type__c.getDescribe().getPicklistValues();

}