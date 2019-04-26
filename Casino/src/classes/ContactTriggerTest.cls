@isTest(seeAllData=true)
public class ContactTriggerTest {
    
    @isTest
    static void testAvoidDuplicateEmails() {
        
        // First make sure there are no contacts already in the system
        // that have the email addresses used for testing
        Set<String> testEmailAddress = new Set<String>();
        testEmailAddress.add('test1@duptest.com');
        testEmailAddress.add('test2@duptest.com');
        testEmailAddress.add('test3@duptest.com');
        testEmailAddress.add('test4@duptest.com');
        testEmailAddress.add('test5@duptest.com');
        System.assert([SELECT count() FROM Contact
                       WHERE Email IN :testEmailAddress] == 0);
        
        // Seed the database with some contacts, and make sure they can
        // be bulk inserted successfully.
        Contact contact1 = new Contact(LastName='Test1',
                                       Email='test1@duptest.com');
        Contact contact2 = new Contact(LastName='Test2',
                                       Email='test4@duptest.com');
        Contact contact3 = new Contact(LastName='Test3',
                                       Email='test5@duptest.com');
        Contact[] contacts = new Contact[] {contact1, contact2, contact3};
            insert contacts;
        
        // Now make sure that some of these contacts can be changed and
        // then bulk updated successfully. Note that contact1 is not
        // being changed, but is still being passed to the update
        // call. This should be OK.
        contact2.Email = 'test2@duptest.com';
        contact3.Email = 'test3@duptest.com';
        update contacts;
        
        // Make sure that single row contact duplication prevention works
        // on insert.
        Contact dup1 = new Contact(LastName='Test1Dup',
                                   Email='test1@duptest.com');
        try {
            insert dup1;
            System.assert(false);
        } catch (DmlException e) {
            System.assert(e.getNumDml() == 1);
            System.assert(e.getDmlIndex(0) == 0);
            System.assert(e.getDmlFields(0).size() == 1);
            System.assert(e.getDmlMessage(0).indexOf(
                'A contact with this email address already exists.') > -1);
        }
        
        // Make sure that single row contact duplication prevention works
        // on update.
        dup1 = new Contact(Id = contact1.Id, LastName='Test1Dup',
                           Email='test2@duptest.com');
        try {
            update dup1;
            System.assert(false);
        } catch (DmlException e) {
            System.assert(e.getNumDml() == 1);
            System.assert(e.getDmlIndex(0) == 0);
            System.assert(e.getDmlFields(0).size() == 1);
            System.assert(e.getDmlMessage(0).indexOf(
                'A contact with this email address already exists.') > -1);
        }
        
        // Make sure that bulk contact duplication prevention works on
        // insert. Note that the first item being inserted is fine,
        // but the second and third items are duplicates. Note also
        // that since at least one record insert fails, the entire
        // transaction will be rolled back.
        dup1 = new Contact(LastName='Test1Dup',
                           Email='test4@duptest.com');
        Contact dup2 = new Contact(LastName='Test2Dup',
                                   Email='test2@duptest.com');
        Contact dup3 = new Contact(LastName='Test3Dup',
                                   Email='test3@duptest.com');
        Contact[] dups = new Contact[] {dup1, dup2, dup3};
            try {
                insert dups;
                System.assert(false);
            } catch (DmlException e) {
                System.assert(e.getNumDml() == 2);
                System.assert(e.getDmlIndex(0) == 1);
                System.assert(e.getDmlFields(0).size() == 1);
                System.assert(e.getDmlMessage(0).indexOf(
                    'A contact with this email address already exists.') > -1);
                System.assert(e.getDmlIndex(1) == 2);
                System.assert(e.getDmlFields(1).size() == 1);
                System.assert(e.getDmlMessage(1).indexOf(
                    'A contact with this email address already exists.') > -1);
            }
        
        // Make sure that bulk contact duplication prevention works on
        // update. Note that the first item being updated is fine,
        // because the email address is new, and the second item is
        // also fine, but in this case it's because the email
        // address doesn't change. The third case is flagged as an
        // error because it is a duplicate of the email address of the
        // first contact's value in the database, even though that value
        // is changing in this same update call. It would be an
        // interesting exercise to rewrite the trigger to allow this
        // case. Note also that since at least one record update
        // fails, the entire transaction will be rolled back.
        dup1 = new Contact(Id=contact1.Id, Email='test4@duptest.com');
        dup2 = new Contact(Id=contact2.Id, Email='test2@duptest.com');
        dup3 = new Contact(Id=contact3.Id, Email='test1@duptest.com');
        dups = new Contact[] {dup1, dup2, dup3};
            try {
                update dups;
                System.assert(false);
            } catch (DmlException e) {
                System.debug(e.getNumDml());
                System.debug(e.getDmlMessage(0));
                System.assert(e.getNumDml() == 1);
                System.assert(e.getDmlIndex(0) == 2);
                System.assert(e.getDmlFields(0).size() == 1);
                System.assert(e.getDmlMessage(0).indexOf(
                    'A contact with this email address already exists.') > -1);
            }
        
        // Make sure that duplicates in the submission are caught when
        // inserting contacts. Note that this test also catches an
        // attempt to insert a contact where there is an existing
        // duplicate.
        dup1 = new Contact(LastName='Test1Dup',
                           Email='test4@duptest.com');
        dup2 = new Contact(LastName='Test2Dup',
                           Email='test4@duptest.com');
        dup3 = new Contact(LastName='Test3Dup',
                           Email='test3@duptest.com');
        dups = new Contact[] {dup1, dup2, dup3};
            try {
                insert dups;
                System.assert(false);
            } catch (DmlException e) {
                System.assert(e.getNumDml() == 2);
                System.assert(e.getDmlIndex(0) == 1);
                System.assert(e.getDmlFields(0).size() == 1);
                System.assert(e.getDmlMessage(0).indexOf(
                    'Another new contact has the same email address.') > -1);
                System.assert(e.getDmlIndex(1) == 2);
                System.assert(e.getDmlFields(1).size() == 1);
                System.assert(e.getDmlMessage(1).indexOf(
                    'A contact with this email address already exists.') > -1);
            }
        
        // Make sure that duplicates in the submission are caught when
        // updating contacts. Note that this test also catches an attempt
        // to update a contact where there is an existing duplicate.
        dup1 = new Contact(Id=contact1.Id, Email='test4@duptest.com');
        dup2 = new Contact(Id=contact2.Id, Email='test4@duptest.com');
        dup3 = new Contact(Id=contact3.Id, Email='test2@duptest.com');
        dups = new Contact[] {dup1, dup2, dup3};
            try {
                update dups;
                System.assert(false);
            } catch (DmlException e) {
                System.assert(e.getNumDml() == 2);
                System.assert(e.getDmlIndex(0) == 1);
                System.assert(e.getDmlFields(0).size() == 1);
                System.assert(e.getDmlMessage(0).indexOf(
                    'Another new contact has the same email address.') > -1);
                System.assert(e.getDmlIndex(1) == 2);
                System.assert(e.getDmlFields(1).size() == 1);
                System.assert(e.getDmlMessage(1).indexOf(
                    'A contact with this email address already exists.') > -1);
            }
    }
    
    ////////////
    //
    // Testing Create Users and Players methods
    //
    ////////////
    @isTest
    static void testCreateNewUsersAndPlayers(){
        
        
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
        insert c;
        
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='High Volume Customer Portal'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test@appirio.com';   
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.PortalRole = 'Manager';
        user.ContactId = c.Id;
        

        
        insert user;
        
        System.RunAs(user) {
            // do all of my tests
            
            //Make dummy data
            
            // First make sure there are no contacts or users already in the system
            // that have the email addresses used for testing
            Set<String> testEmailAddress = new Set<String>();
            testEmailAddress.add('test1@duptest.com');
            testEmailAddress.add('test2@duptest.com');
            testEmailAddress.add('test3@duptest.com');
            testEmailAddress.add('test4@duptest.com');
            testEmailAddress.add('test5@duptest.com');
            System.assert([SELECT count() FROM Contact
                           WHERE Email IN :testEmailAddress] == 0);
            System.assert([SELECT count() FROM User
                           WHERE Email IN :testEmailAddress] == 0);
            
            // Make sure there are no players in the system
            System.assert([SELECT count() FROM Player__C] == 0);
            
            // Seed the database with some contacts
            Contact contact1 = new Contact(LastName='Test1',
                                           Email='test1@duptest.com');
            Contact contact2 = new Contact(LastName='Test2',
                                           Email='test4@duptest.com');
            Contact contact3 = new Contact(LastName='Test3',
                                           Email='test5@duptest.com');
            Contact[] contacts = new Contact[] {contact1, contact2, contact3};
                insert contacts;
            
            // Make sure new users have been inserted with the new contacts' emails
            System.assert([SELECT count() FROM User
                           WHERE Email IN :testEmailAddress] == 3);
            
            // Make sure there are 3 new profiles inserted with the new user's aliases
            Set<String> testUserAliases = new Set<String>(); 
            for(User u : [SELECT Alias FROM User]){
                testUserAliases.add(u.Alias);
            }
            //System.assert([SELECT count() FROM Player__c
            //WHERE Name IN :testUserAliases] == 3);
        }
    }
}