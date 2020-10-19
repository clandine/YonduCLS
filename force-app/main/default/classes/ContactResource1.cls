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
}