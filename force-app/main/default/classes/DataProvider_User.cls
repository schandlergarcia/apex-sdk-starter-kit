public with sharing class DataProvider_User {
  public static User getUserById(String recordId) {
    try{
      User user = [SELECT Name, Title, AboutMe, PhotoURL__c FROM User WHERE Id = :recordId];
      return user;  
    } catch(Exception ex){
      return null;
    }
  }
  public static String getBaseURL() {
    return URL.getSalesforceBaseUrl().toExternalForm() + '/';
  }
}
