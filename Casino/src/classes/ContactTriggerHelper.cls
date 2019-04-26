public class ContactTriggerHelper {
    
    // Code found and changed from: https://developer.secure.force.com/cookbook/recipe/preventing-duplicate-records-from-saving
    public static void avoidDuplicateEmails(List<Contact> newContacts, Map<Id, Contact> oldContactsMap, Boolean beingInserted){
        
        Map<String, Contact> contactMap = new Map<String, Contact>();
        for (Contact Contact : newContacts) {
            
            // Make sure we don't treat an email address that 
            // isn't changing during an update as a duplicate. 
            
            if ((Contact.Email != null) &&
                (beingInserted ||
                 (Contact.Email !=
                  oldContactsMap.get(Contact.Id).Email))) {
                      
                      // Make sure another new Contact isn't also a duplicate 
                      
                      if (contactMap.containsKey(Contact.Email)) {
                          Contact.Email.addError('Another new contact has the '
                                                 + 'same email address.');
                      } else {
                          contactMap.put(Contact.Email, Contact);
                      }
                  }
        }
        
        // Using a single database query, find all the Contacts in 
        // the database that have the same email address as any 
        // of the Contacts being inserted or updated. 
        
        for (Contact contact : [SELECT Email FROM Contact
                                WHERE Email IN :contactMap.KeySet()]) {
                                    Contact newContact = contactMap.get(Contact.Email);
                                    newContact.Email.addError('A contact with this email address already exists.');
                                }
    }
    
    // Contact is a non-setup object you can not insert a setup object's (User) records after inserting the setup object records
    // Must insert non-setup object asynchronously.
    @future
    public static void createNewUsersAndPlayers(Set<Id> newContacts){
        List<User> users = new List<User>();
       
        List<String> userEmails = new List<String>();
        for(Contact c : [Select Id, LastName, Email FROM Contact WHERE Id IN :newContacts]){
            
            
            //WHERE IT ALL GOES WRONG, PortalRole = and UserRoleId are messed up
            User u = new User(Alias = c.LastName, Email = c.Email, 
                              EmailEncodingKey = 'UTF-8', LastName = c.LastName, LanguageLocaleKey = 'en_US', 
                              LocaleSidKey = 'en_US', ProfileId = '00e2E000001DD9mQAG', // Gambling User Plus, DUMB HARDCODE
                              TimeZoneSidKey = 'America/New_York', UserName = c.Email, 
                              ContactId = c.Id, isActive = true, UserRoleId = '00E2E000002ZO9UUAW'); // Random customer role ID
                              //PortalRole = 'Manager'); 
            
            userEmails.add(c.Email); //used for later to create players
            users.add(u);
            
        }
        insert users;
        
        // Grab the users that were just inserted

        // Must run createNewPlayers method asynchronously
        //createNewPlayers(userEmails);      
    }
    
    // User is a setup object you can not insert a non-setup object's (Player__c) records after inserting the setup object records
    // Must insert non-setup object asynchronously.
    @future
    public static void createNewPlayers(List<String> userEmails){
        List<Player__c> players = new List<Player__c>();
        List<User> justCreatedUsers = [SELECT Id FROM User WHERE Username IN :userEmails];
        
        // Create new players based off of new useres
        for(User u : justcreatedUsers){
            Player__c p = new Player__c(Name = u.Alias);
            System.debug(u.Alias);
            p.OwnerId = p.Id;
            System.debug(u.Id);
            System.debug(p);
            players.add(p);
        }
        
        insert players;
    }
}