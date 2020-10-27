//Setting up the request URL
@RestResource(urlMapping='/ContactAPI/*')
global with sharing class ContactResource1 {

    //creating a response wrapper
    global class ResponseWrapper {
        String success;
        String message;
    }

    //GET Method
    @HttpGet
    global static List<Contact> getContactIdNameAndLeadSource() {
        //Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        //Getting the request URI
        String contactRequestURI = contactRequest.requestURI;
        //Getting the limit from the request URI
        Integer contactLimit = Integer.valueOf(contactRequestURI.substring(contactRequestURI.lastIndexOf('/') + 1));
        //Querying contacts
        List<Contact> contactList = [SELECT Id, Name 
                                     FROM Contact
                                     LIMIT : contactLimit];
        //Returning the contacts in response
        return contactList;
    }

    //Post Method
    @HTTPPost
    global static Contact createNewContact(String firstName, String lastName, String birthDate, String leadSource) {
        //Initializing New Contact
        Contact newContact = new Contact();
        newContact.FirstName = firstName;
        newContact.LastName = lastName;
        newContact.Birthdate = Date.parse(birthDate);
        newContact.LeadSource = leadSource;
        //Inserting the contact
        insert newContact;
        //Returning the contact in the respose
        return newContact;
    }

    //Delete Method 
    @HTTPDelete
    global static Map<String, String> deleteContact() {
        //Initializing the response map
        Map<String, String> responseMap = new Map<String, String>();
        //Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        //Getting the request URI
        String contactRequestURI = contactRequest.requestURI;
        //Getting the contact ID from the request URI
        Id contactId = Id.valueOf(contactRequestURI.substring(contactRequestURI.lastIndexOf('/') + 1));
        //Initializing contact to delete 
        Contact delContact = new Contact(Id = contactId);

        //Deleting contact
        try {
            delete delContact;
            responseMap.put('Success', '1');
            responseMap.put('Message', 'Record Deleted Successfully.');
        } catch (DmlException e) {
            responseMap.put('Succss', '0');
            responseMap.put('Message', e.getMessage());
        }

        //Returning the response map in the response
        return responseMap;
    }

    //Put Method
    @HTTPPut
    global static Contact upsertContact(String firstName, String lastName, String birthDate, String leadSource) {
        //Initializing the request parameter with the incoming request 
        RestRequest contactRequest = RestContext.request;
        //Getting the request URI
        String contactRequestURI = contactRequest.requestURI;
        //Getting the ID from the request URI 
        String contactId = contactRequestURI.substring(contactRequestURI.lastIndexOf('/') + 1);
        //Initializing the contact to upsert
        Contact newContact = new Contact();
        //Assigning contact Id to the new contact if contact ID from URI is not empty
        if(!String.isEmpty(contactId)) {
            newContact.Id = contactId;
        }
        newContact.FirstName = firstName;
        newContact.LastName = lastName;
        newContact.Birthdate = Date.parse(birthDate);
        newContact.LeadSource = leadSource;
        //Upserting the contact
        upsert newContact;

        //Returning the contact in the response
        return newContact;

    }
}