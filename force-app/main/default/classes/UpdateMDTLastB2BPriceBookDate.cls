public class UpdateMDTLastB2BPriceBookDate implements Metadata.DeployCallback {
    
    @future(callout=false)
    public static void updateCustomMetadata(String mdtVarName){
        try {
            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.fullName = 'Org_Variables__mdt.' + mdtVarName; //custom metadata name
            customMetadata.label = mdtVarName;

            // customMetadata.id = customMetadataId;
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue(); //the values you're changing/updating
            customField.field = 'Date_Time_Value__c'; //the custom field API Name that you're wanting to insert/update a value of
            customField.value = System.now();
            customMetadata.values.add(customField);//add the changes to list of changes to be deployed

            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            mdContainer.addMetadata(customMetadata);

            UpdateMDTLastB2BPriceBookDate callback = new UpdateMDTLastB2BPriceBookDate();
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        } catch (Exception exc) {
            Map<String, Org_Variables__mdt> orgVars = Org_Variables__mdt.getAll();

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{orgVars.get('Batch_Email_To_Addresses').Text_Area_Value__c});
            mail.setSubject('UpdateMDTLastB2BPriceBookDate');
            mail.setPlainTextBody('Good day\n\nPlease see error that occured below. \n\nMessage:\n' + exc.getMessage() + '\n\nStack Trace:\n' + exc.getStackTraceString() + '\n\nLine Number: \n' + exc.getLineNumber());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
    }
}