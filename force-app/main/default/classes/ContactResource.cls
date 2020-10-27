@RestResource(urlMapping='/ContactAPI1/*')
global with sharing class ContactResource {
    Boolean isLogin;
    //Creating a response wrapper
    global class ResponseWrapper {
        String success;
        String message;
    }
    //Get Method
    @HTTPGet
    global static List<Contact> getContactIdNameAndLeadSource() {
        RestRequest contactRequest = RestContext.request;
        //Getting the URL parameters from the request
        Map<String,String> contactRequestParams = contactRequest.params;
        //Getting the limit and the leadsource from the request URL params
        Integer contactLimit = Integer.valueOf(contactRequestParams.get('limit'));
        String leadSource = contactRequestParams.get('leadsource');

        List<Contact> contactList = [SELECT Id, Name, LeadSource
                                     FROM Contact
                                     WHERE LeadSource =: leadSource LIMIT : contactLimit];

        return contactList;
    }

    //Post Method
    @HTTPPost 
    global static Contact createNewContact() {
        //Initiallizing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        //Getting the request body from the request | Convert blob format to String
        String requestBody = contactRequest.requestBody.toString();
        //Deserializing the JSON response body and assigning it to an instance of Contact Object
        Contact newContact = (Contact) JSON.deserialize(requestBody, Contact.class);
        //Inserting Contact
        insert newContact;
        //Returning the contact in the response
        return newContact; 
    }

    //Delete Method
    @HTTPDelete
    global static List<ResponseWrapper> deleteContact() {
        //Initializing the response wrapper List
        List<ResponseWrapper> responseList = new List<ResponseWrapper>();
        //Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        //Getting the request URI
        String contactRequestURI = contactRequest.requestURI;
        //Getting the contact Id's from the request URI
        List<String> contactIds = (contactRequestURI.substring(contactRequestURI.lastIndexOf('/') + 1)).split(',');
        // Initializing contact Id's to delete 
        List<Contact> deleteContactsList = new List<Contact>();
        
        for(String con: contactIds) {
            Contact contactRecord = new Contact();
            contactRecord.Id = con;
            deleteContactsList.add(contactRecord);
        }

        //Deleting contacts with partial success enabled
        List<Database.DeleteResult> deleteResultsList = Database.delete(deleteContactsList, false);

        for(Database.DeleteResult deleteResult: deleteResultsList) {
            //Initializing the response wrapper
            ResponseWrapper resultWrapper = new ResponseWrapper();
            if(deleteResult.isSuccess()) {
                resultWrapper.success = '1';
                resultWrapper.message = 'Successfully deleted contact with Id : ' + deleteResult.getId();
            } else {
                resultWrapper.success = '0';
                for(Database.Error error: deleteResult.getErrors()) {
                    resultWrapper.message = 'The follow error has occurred for contact with Id :' + deleteResult.getId();
                    resultWrapper.message += error.getStatusCode() + ': ' + error.getMessage() + '.';
                    resultWrapper.message += 'Contact fields that affected this error: ' + error.getFields();
                }
            }
            responseList.add(resultWrapper);
        }

        return responseList;
    }

}