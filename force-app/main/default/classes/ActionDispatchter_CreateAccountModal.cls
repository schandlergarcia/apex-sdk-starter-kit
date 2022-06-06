public class ActionDispatchter_CreateAccountModal extends Slack.ActionDispatcher {
  public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
    return Slack.ActionHandler.modal(new Handler(parameters, context));
  }

  public class Handler implements Slack.ModalHandler {
    Map<String, Object> parameters;
    Slack.RequestContext context;

    public Handler(Map<String, Object> parameters, Slack.RequestContext context) {
      this.parameters = parameters;
      this.context = context;
    }

    public Slack.ModalView call() {
      // View Definition
      Slack.ViewReference viewReference = Slack.View.new_account_modal.get();
      Slack.ModalView modalView = new Slack.ModalView.builder().viewReference(viewReference).build();
      return modalView;
    }
  }
}
