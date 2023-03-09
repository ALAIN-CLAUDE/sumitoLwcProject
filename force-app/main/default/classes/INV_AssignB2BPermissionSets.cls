/**
 * @description       : (User_After_Save) Class used for assigning b2b permissions to B2B user, cannot be done on flow because it will trigger MIXED_DML_OPERATION exception when run on b2b
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-07   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_AssignB2BPermissionSets {
	
    @InvocableMethod(label='Assign B2B Permissions')
    public static void assignB2BPermissionSets(List<String> userIds){
        if(userIds != null && userIds.size() > 0){
            List<User> users = [SELECT Id, Profile.UserLicense.Name FROM User WHERE Id IN: userIds];
            Set<Id> b2bLoginUsers = new Set<Id>();
            Set<Id> b2bNormalUsers = new Set<Id>();

            for(User user : users){
                if(user.Profile.UserLicense.Name.Equals('Customer Community Plus Login')){
                    b2bLoginUsers.add(user.Id);
                } else if(user.Profile.UserLicense.Name.Equals('Customer Community Plus')){
                    b2bNormalUsers.add(user.Id);
                } 
            }

            if(b2bLoginUsers != null && b2bLoginUsers.size() > 0){
                assignB2BLoginPermssions(b2bLoginUsers);
            }

            if(b2bNormalUsers != null && b2bNormalUsers.size() > 0){
                assignB2BPermssions(b2bNormalUsers);
            }
        }
    }

    @future(callout=false)
    public static void assignB2BPermssions(Set<Id> userIds){
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name IN ('B2B_Buyer','B2B_Buyer_Manager','B2B_Featured_Products_Component','LB2B_Toolbox_Permissions','Merchandiser')];
        List<PermissionSetAssignment> permSetAssigns = new List<PermissionSetAssignment>();
        PermissionSetAssignment permSetAssign;

        for(PermissionSet permSet : permissionSets){

            for(String userId : userIds){
                permSetAssign = new PermissionSetAssignment();
                permSetAssign.AssigneeId = userId;
                permSetAssign.PermissionSetId = permSet.Id;
                permSetAssigns.add(permSetAssign);
            }
        }

        if(permSetAssigns != null && permSetAssigns.size() > 0){
            insert permSetAssigns;
        }
    }

    @future(callout=false)
    public static void assignB2BLoginPermssions(Set<Id> userIds){
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name IN ('B2B_Buyer_Login','B2B_Featured_Products_Component','LB2B_Toolbox_Permissions','Merchandiser')];
        List<PermissionSetAssignment> permSetAssigns = new List<PermissionSetAssignment>();
        PermissionSetAssignment permSetAssign;

        for(PermissionSet permSet : permissionSets){

            for(String userId : userIds){
                permSetAssign = new PermissionSetAssignment();
                permSetAssign.AssigneeId = userId;
                permSetAssign.PermissionSetId = permSet.Id;
                permSetAssigns.add(permSetAssign);
            }
        }

        if(permSetAssigns != null && permSetAssigns.size() > 0){
            insert permSetAssigns;
        }
    }
}