@isTest
public class fromJSON {
	public String type;	//object
	//public String $schema;	//http://json-schema.org/draft-07/schema#
	public cls_properties properties;
	class cls_properties {
		public cls_id id;
		public cls_UserName UserName;
		public cls_FirstName FirstName;
		public cls_LastName LastName;
		public cls_FullName FullName;
		public cls_Email Email;
		public cls_AccessLevel AccessLevel;
		public cls_DisableMessages DisableMessages;
		public cls_Active Active;
		public cls_Skype Skype;
		public cls_PhoneWork PhoneWork;
		public cls_PhoneMobile PhoneMobile;
		public cls_LastLogin LastLogin;
		public cls_LoginKey LoginKey;
		public cls_IsCustomUsername IsCustomUsername;
		public cls_Password Password;
		public cls_SkipFirstLogin SkipFirstLogin;
		public cls_TimeZone TimeZone;
		public cls_SalesforceId SalesforceId;
		public cls_OriginalId OriginalId;
		public cls_Street1 Street1;
		public cls_Street2 Street2;
		public cls_City City;
		public cls_State State;
		public cls_PostalCode PostalCode;
		public cls_Country Country;
		public cls_CompanyName CompanyName;
		public cls_JobTitle JobTitle;
		public cls_SalesforceContactId SalesforceContactId;
		public cls_SalesforceAccountId SalesforceAccountId;
		public cls_CreatedDate CreatedDate;
		public cls_Points Points;
		public cls_Brand Brand;
		public cls_ManagerId ManagerId;
		public cls_ManagerName ManagerName;
		public cls_EnableTextNotification EnableTextNotification;
		public cls_Website Website;
		public cls_Twitter Twitter;
		public cls_ExpirationDate ExpirationDate;
	}
    public HTTPResponse respond(HTTPRequest request) {
         HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        response.setStatusCode(200);
        return response;
    }
	class cls_id {
		public String type;	//string
	}
	class cls_UserName {
		public String type;	//string
	}
	class cls_FirstName {
		public String type;	//string
	}
	class cls_LastName {
		public String type;	//string
	}
	class cls_FullName {
		public String type;	//string
	}
	class cls_Email {
		public String type;	//string
	}
	class cls_AccessLevel {
		public String type;	//string
	}
	class cls_DisableMessages {
		public String type;	//string
	}
	class cls_Active {
		public String type;	//boolean
	}
	class cls_Skype {
		public String type;	//string
	}
	class cls_PhoneWork {
		public String type;	//string
	}
	class cls_PhoneMobile {
		public String type;	//string
	}
	class cls_LastLogin {
		public String type;	//string
	}
	class cls_LoginKey {
		public String type;	//string
	}
	class cls_IsCustomUsername {
		public String type;	//boolean
	}
	class cls_Password {
		public String type;	//string
	}
	class cls_SkipFirstLogin {
		public String type;	//boolean
	}
	class cls_TimeZone {
		public String type;	//string
	}
	class cls_SalesforceId {
		public String type;	//string
	}
	class cls_OriginalId {
		public String type;	//integer
	}
	class cls_Street1 {
		public String type;	//string
	}
	class cls_Street2 {
		public String type;	//string
	}
	class cls_City {
		public String type;	//string
	}
	class cls_State {
		public String type;	//string
	}
	class cls_PostalCode {
		public String type;	//string
	}
	class cls_Country {
		public String type;	//string
	}
	class cls_CompanyName {
		public String type;	//string
	}
	class cls_JobTitle {
		public String type;	//string
	}
	class cls_SalesforceContactId {
		public String type;	//string
	}
	class cls_SalesforceAccountId {
		public String type;	//string
	}
	class cls_CreatedDate {
		public String type;	//string
	}
	class cls_Points {
		public String type;	//integer
	}
	class cls_Brand {
		public String type;	//string
	}
	class cls_ManagerId {
		public String type;	//string
	}
	class cls_ManagerName {
		public String type;	//string
	}
	class cls_EnableTextNotification {
		public String type;	//boolean
	}
	class cls_Website {
		public String type;	//string
	}
	class cls_Twitter {
		public String type;	//string
	}
	class cls_ExpirationDate {
		public String type;	//string
	}
	public static fromJSON parse(String json){
		return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
	}

	static testMethod void testParse() {
		String json=		'{   '+
		' "type": "object",'+
		'     "$schema": "http://json-schema.org/draft-07/schema#",'+
		'     "properties": {'+
		'          "id": {'+
		'               "type": "string"'+
		'          },'+
		'          "UserName": {'+
		'               "type": "string"'+
		'          },'+
		'          "FirstName": {'+
		'               "type": "string"'+
		'          },'+
		'          "LastName": {'+
		'               "type": "string"'+
		'          },'+
		'          "FullName": {'+
		'               "type": "string"'+
		'          },'+
		'          "Email": {'+
		'               "type": "string"'+
		'          },'+
		'          "AccessLevel": {'+
		'               "type": "string"'+
		'          },'+
		'          "DisableMessages": {'+
		'               "type": "string"'+
		'          },'+
		'          "Active": {'+
		'               "type": "boolean"'+
		'          },'+
		'          "Skype": {'+
		'               "type": "string"'+
		'          },'+
		'          "PhoneWork": {'+
		'               "type": "string"'+
		'          },'+
		'          "PhoneMobile": {'+
		'               "type": "string"'+
		'          },'+
		'          "LastLogin": {'+
		'               "type": "string"'+
		'          },'+
		'          "LoginKey": {'+
		'               "type": "string"'+
		'          },'+
		'          "IsCustomUsername": {'+
		'               "type": "boolean"'+
		'          },'+
		'          "Password": {'+
		'               "type": "string"'+
		'          },'+
		'          "SkipFirstLogin": {'+
		'               "type": "boolean"'+
		'          },'+
		'          "TimeZone": {'+
		'               "type": "string"'+
		'          },'+
		'          "SalesforceId": {'+
		'               "type": "string"'+
		'          },'+
		'          "OriginalId": {'+
		'               "type": "integer"'+
		'          },'+
		'          "Street1": {'+
		'               "type": "string"'+
		'          },'+
		'          "Street2": {'+
		'               "type": "string"'+
		'          },'+
		'          "City": {'+
		'               "type": "string"'+
		'          },'+
		'          "State": {'+
		'               "type": "string"'+
		'          },'+
		'          "PostalCode": {'+
		'               "type": "string"'+
		'          },'+
		'          "Country": {'+
		'               "type": "string"'+
		'          },'+
		'          "CompanyName": {'+
		'               "type": "string"'+
		'          },'+
		'          "JobTitle": {'+
		'               "type": "string"'+
		'          },'+
		'          "SalesforceContactId": {'+
		'               "type": "string"'+
		'          },'+
		'          "SalesforceAccountId": {'+
		'               "type": "string"'+
		'          },'+
		'          "CreatedDate": {'+
		'               "type": "string"'+
		'          },'+
		'          "Points": {'+
		'               "type": "integer"'+
		'          },'+
		'          "Brand": {'+
		'               "type": "string"'+
		'          },'+
		'          "ManagerId": {'+
		'               "type": "string"'+
		'          },'+
		'          "ManagerName": {'+
		'               "type": "string"'+
		'          },'+
		'          "EnableTextNotification": {'+
		'               "type": "boolean"'+
		'          },'+
		'          "Website": {'+
		'               "type": "string"'+
		'          },'+
		'          "Twitter": {'+
		'               "type": "string"'+
		'          },'+
		'          "ExpirationDate": {'+
		'               "type": "string"'+
		'          }'+
		'     }'+
		'}';
        
		fromJSON obj = parse(json);
        
		//System.assert(obj != null);
	}
}