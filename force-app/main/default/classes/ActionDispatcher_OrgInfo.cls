public class ActionDispatcher_OrgInfo extends Slack.ActionDispatcher {

    public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
        // The Slack action handler is returned immediately 
        return Slack.ActionHandler.pushModal(new Handler(parameters, context));
    }

    public class Handler implements Slack.ModalHandler {

        Map<String, Object> parameters;
        Slack.RequestContext context;

        public Handler (Map<String, Object> parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }

        public Slack.ModalView call () {
            Slack.ViewReference viewReference = Slack.View.org_info_modal.get();
            // Set paramaters using Salesforce data and methods
            viewReference.setParameter('organizationId', UserInfo.getOrganizationId());
            Slack.ModalView modalView = new Slack.ModalView.builder()
                .viewReference(viewReference)
                .build();
            return modalView;
        }

    }
}
