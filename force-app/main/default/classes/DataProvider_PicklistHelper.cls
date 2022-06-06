global with sharing class DataProvider_PicklistHelper {
  global static List<Slack.Option> getPicklistValues(String objectApiName, String fieldName) {
    Schema.SObjectType s = Schema.getGlobalDescribe().get(objectApiName);
    Schema.DescribeSObjectResult r = s.getDescribe();
    Map<String, Schema.SObjectField> fields = r.fields.getMap();
    Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
    List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
    // Map the picklist values to the slackOptions Schema.
    List<Slack.Option> slackOptions = new List<Slack.Option>();
    for (Schema.PicklistEntry picklistValue : picklistValues) {
      Slack.Option option = new Slack.Option(picklistValue.getLabel(), picklistValue.getValue());
      System.debug(option.getText());
      slackOptions.add(option);
    }
    return slackOptions;
  }
}
