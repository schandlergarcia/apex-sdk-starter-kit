Slack.App app = Slack.App.MySlackApp.get();
Slack.BotClient botClient = app.getBotClientForTeam('T037YL440ET');
Slack.ViewReference viewReference = Slack.View.action_formatted_message.get();
viewReference.setParameter('heading', 'Hello');
viewReference.setParameter('body', 'From Apex');
Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder().channel('C03KC6FK3BP').viewReference(viewReference).build();
Slack.ChatPostMessageResponse response = botClient.ChatPostMessage(req);
