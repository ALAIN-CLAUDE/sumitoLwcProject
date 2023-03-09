public class EmailUtils {
    public static void sendEmail(List<String> toAddresses, String subject, String message){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(message);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void sendBatchSaveResultErrors(Database.SaveResult[] saveResults, String subject){
        String errorString = '';
        
        if(saveResults != null){
            for (Database.SaveResult saveResult : saveResults) {
                for(Database.Error error : saveResult.getErrors()){
                    errorString += '{';
                    errorString += 'StatusCode: ' + error.getStatusCode() + ', ';
                    errorString += 'Message:' + error.getMessage() + ', ';
                    errorString += 'Fields: ' + error.getFields() + ', ';
                    errorString += '},';
                }
            }
            
            if(errorString != null && errorString != ''){
                sendEmail(new List<String>{Label.Batch_Email_To_Addresses}, subject, errorString);
            }
        }
    }
}