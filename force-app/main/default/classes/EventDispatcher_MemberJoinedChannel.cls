public without sharing class EventDispatcher_MemberJoinedChannel extends Slack.EventDispatcher {
  public override Slack.ActionHandler invoke(Slack.EventParameters parameters, Slack.RequestContext context) {
    return Slack.ActionHandler.ack(new Handler(parameters, context));
  }

  public class Handler implements Slack.RunnableHandler {
    Slack.EventParameters parameters;
    Slack.RequestContext context;

    public Handler(Slack.EventParameters parameters, Slack.RequestContext context) {
      this.parameters = parameters;
      this.context = context;
    }

    public void run() {
      Slack.App app = Slack.App.MySlackApp.get();
      Slack.BotClient botClient = app.getBotClientForTeam(context.getTeamId());

      Slack.Event event = parameters.getEvent();
      Slack.MemberJoinedChannelEvent memberJoinedChannelEvent = (Slack.MemberJoinedChannelEvent) event;

      String channelId = memberJoinedChannelEvent.getChannel();
      String userId = memberJoinedChannelEvent.getUser();
      String salesforceUserId = app.getConnectedSalesforceUserId(
        memberJoinedChannelEvent.getTeam(),
        memberJoinedChannelEvent.getUser()
      );

      Slack.ViewReference viewReference = Slack.View.new_channel_member.get();
      viewReference.setParameter('userId', userId);
      viewReference.setParameter('salesforceUserLinked', String.isNotBlank(salesforceUserId));
      if(String.isBlank(salesforceUserId)){
        viewReference.setParameter('salesforceUserId', 'notlinked');
      } else {
        viewReference.setParameter('salesforceUserId', salesforceUserId);
      }

      Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
        .channel(channelId)
        .viewReference(viewReference)
        .build();
      Slack.ChatPostMessageResponse response = botClient.ChatPostMessage(req);
      if (response.getError() != null) {
        System.debug(response.getResponseMetadata().getMessages());
      }
    }
  }
}
