public class ActionDispatcher_CreateAccount extends Slack.ActionDispatcher {
  public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
    // The slack action handler should immediately be returned.
    return Slack.ActionHandler.updateModal(new Handler(parameters, context));
  }

  public class Handler implements Slack.ModalHandler {
    Map<String, Object> parameters;
    Slack.RequestContext context;

    public Handler(Map<String, Object> parameters, Slack.RequestContext context) {
      this.parameters = parameters;
      this.context = context;
    }

    public Slack.ModalView call() {
      // Process the form data and return the modal view that corresponds to the requested object.
      return createNewAccount(); // Slack.ModalView
    }

    private Slack.ModalView createNewAccount() {
      try {
        // Instantiate a new Account
        Account newAccount = new Account();

        // Map the form data to the Account fields
        Map<String, Object> formData = context.getFormData();
        newAccount.Name = (String) formData.get('account_name_value');
        newAccount.Description = (String) formData.get('account_description_value');
        newAccount.Website = (String) formData.get('account_website_value');
        newAccount.Type = (String) formData.get('account_type_values');

        insert newAccount;

        // Define the response parameters
        String title = 'Account Created';
        String body = 'An account for ' + newAccount.Name + ' has been created! :white_check_mark:';
        return MessageModal.getMessageModalView(title, new List<String>{ body });
      } catch (Exception e) {
        return getMessageModal(e.getMessage());
      }
    }

    private Slack.ModalView getMessageModal(String errorMessage) {
      String title = 'Error Record Creation';
      String body = 'There was a problem creating your record.' + '\n' + errorMessage;
      return MessageModal.getMessageModalView(title, new List<String>{ body });
    }
  }
}
