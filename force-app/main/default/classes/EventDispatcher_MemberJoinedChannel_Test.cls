@isTest
public with sharing class EventDispatcher_MemberJoinedChannel_Test {
  private static Slack.App slackApp;
  private static Slack.TestHarness testHarness;
  private static Slack.TestHarness.State slackState;
  private static Slack.TestHarness.Team team;
  private static Slack.TestHarness.UserSession userSession;
  private static Slack.TestHarness.User user;
  private static Slack.TestHarness.Channel publicChannel;
  private static Slack.TestHarness.Channel privateChannel;

  // Slack Test Setup
  static {
    slackApp = Slack.App.MySlackApp.get();
    testHarness = new Slack.TestHarness();
    slackState = testHarness.getNewSlackState();
    team = slackState.createTeam('team');
    publicChannel = slackState.createPublicChannel(team, 'public-channel');
    user = slackState.createUser('testUser@test.com', 'test', team);
    userSession = slackState.createUserSession(user, publicChannel);
  }

  // We are not able to link a Slack and Salesforce user in tests yet
  @isTest
  static void testMemberJoinedChannelEventWithoutConnectedUser() {

    // Define the MemberJoineChannelEvent
    Slack.MemberJoinedChannelEvent event = new Slack.MemberJoinedChannelEvent();
    event.setChannel(publicChannel.getId());
    event.setUser(user.getId());
    event.setTeam(team.getId());

    // Fire the MemberJoinedChannelEvent
    userSession.executeEvent(event, slackApp);

    // Get all of the messages from the new channel
    List<Slack.TestHarness.Message> messages = userSession.getMessages();

    // Check to see if a message was sent to the channel
    System.assertEquals(1, messages.size());
  }
}
