@isTest
public class ActionDispatcher_OrgInfo_Test {
  private static Slack.App slackApp;
  private static Slack.TestHarness testHarness;
  private static Slack.TestHarness.State slackState;
  private static Slack.TestHarness.UserSession userSession;

  static {
    // setup test harness and user session
    slackApp = Slack.App.MySlackApp.get();
    testHarness = new Slack.TestHarness();
    slackState = testHarness.getNewSlackState();
    userSession = slackState.createUserSession();
  }

  @isTest
  static void getGetOrgInfoCommand() {
    userSession.executeSlashCommand('/get-org-info', slackApp);
    Slack.TestHarness.Modal modal = userSession.getTopModal();
    System.assertEquals('Salesforce Org Info', modal.getTitle());
    Slack.TestHarness.Section section = (Slack.TestHarness.Section)modal.getComponent(1, Slack.TestHarness.Section.class);
    Organization org = [SELECT Name, OrganizationType, PrimaryContact FROM Organization LIMIT 1];
    System.assert(section.getText().contains(org.Name));
}
}
