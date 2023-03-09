public class InvokeChangePassword
{
  @InvocableMethod(callout=true label='Get User Id')    
  public static List<String> getUserIDs (List<ID> ids) {
      
    List<String> userIds = new List<String>();
    List<User> users= [SELECT id, name FROM User WHERE Id in :ids limit 1];
    for (User user : users) {
      System.resetPassword(user.id,true);
      userIds.add(user.name);
    }
    return userIds ;
  } 
}