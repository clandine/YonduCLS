@RestResource(urlMapping='/ContactAPI1/*')
global with sharing class ContactResource {
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
}