@isTest
public class ActionDispatcher_CreateAccount_Test {

  private static Slack.App slackApp;
  private static Slack.TestHarness testHarness;
  private static Slack.TestHarness.State slackState;
  private static Slack.TestHarness.User user;
  private static Slack.TestHarness.UserSession userSession;
  private static Slack.TestHarness.Team team;
  private static Slack.TestHarness.Channel publicChannel;

  static {
    // setup test harness and user session
    slackApp = Slack.App.MySlackApp.get();
    testHarness = new Slack.TestHarness();
    slackState = testHarness.getNewSlackState();
    team = slackState.createTeam('team');
    publicChannel = slackState.createPublicChannel(team, 'public-channel');
    user = slackState.createUser('testUser@test.com', 'test', team);
    userSession = slackState.createUserSession(user, publicChannel);
  }

  @isTest
  static void createNewAccountWithModal() {

    // open the create account shortcut
    userSession.executeGlobalShortcut('new-account', slackApp);
    Slack.TestHarness.Modal modal = userSession.getTopModal();
    System.assertEquals('New Account', modal.getTitle());


    // Populate Input Fields
    Slack.TestHarness.Input input = modal.getInputByLabel('Name');
    Slack.TestHarness.TextInput textInput = (Slack.TestHarness.TextInput) input.getComponent(Slack.TestHarness.TextInput.class);
    textInput.setValue('Account Name');

    input = modal.getInputByLabel('Description');
    textInput = (Slack.TestHarness.TextInput) input.getComponent(Slack.TestHarness.TextInput.class);
    textInput.setValue('Description');

    input = modal.getInputByLabel('Website');
    textInput = (Slack.TestHarness.TextInput) input.getComponent(Slack.TestHarness.TextInput.class);
    textInput.setValue('www.salesforce.com');

    // Get Picklist Values for the Select 
    List<Slack.Option> picklistValues = DataProvider_PicklistHelper.getPicklistValues('Account', 'Type');
    input = modal.getInputByLabel('Account Type');
    Slack.TestHarness.SelectInput selectInput = (Slack.TestHarness.SelectInput) input.getComponent(Slack.TestHarness.SelectInput.class);
    selectInput.setValue(picklistValues[0].getValue());

    modal.submit();

    Account account = [SELECT Name, Description, Website, Type FROM Account WHERE Name = 'Account Name' LIMIT 1];
    System.assertEquals('Account Name', account.Name);
    System.assertEquals('Description', account.Description);
    System.assertEquals('www.salesforce.com', account.Website);
    System.assertEquals(picklistValues[0].getValue(), account.Type);


    // Get Next Modal
    modal = userSession.getTopModal();
    System.assertEquals('Account Created', modal.getTitle());
  }

  @isTest
  static void createNewAccountWithModalWithError() {

    // open the create account shortcut
    userSession.executeGlobalShortcut('new-account', slackApp);
    Slack.TestHarness.Modal modal = userSession.getTopModal();
    System.assertEquals('New Account', modal.getTitle());


    // Populate Input Fields and set an account name that causes an insert failure
    Slack.TestHarness.Input input = modal.getInputByLabel('Name');
    Slack.TestHarness.TextInput textInput = (Slack.TestHarness.TextInput) input.getComponent(Slack.TestHarness.TextInput.class);
    textInput.setValue('This Account Name is far too long for the input field This Account Name is far too long for the input field This Account Name is far too long for the input field This Account Name is far too long for the input field This Account Name is far too long for the input field');

    input = modal.getInputByLabel('Description');
    textInput = (Slack.TestHarness.TextInput) input.getComponent(Slack.TestHarness.TextInput.class);
    textInput.setValue('Description');

    input = modal.getInputByLabel('Website');
    textInput = (Slack.TestHarness.TextInput) input.getComponent(Slack.TestHarness.TextInput.class);
    textInput.setValue('www.salesforce.com');

    // Get Picklist Values for the Select 
    List<Slack.Option> picklistValues = DataProvider_PicklistHelper.getPicklistValues('Account', 'Type');
    input = modal.getInputByLabel('Account Type');
    Slack.TestHarness.SelectInput selectInput = (Slack.TestHarness.SelectInput) input.getComponent(Slack.TestHarness.SelectInput.class);
    selectInput.setValue(picklistValues[0].getValue());

    modal.submit();

    // Get Next Modal
    modal = userSession.getTopModal();
    System.assertEquals('Error Record Creation', modal.getTitle());
  }

}
