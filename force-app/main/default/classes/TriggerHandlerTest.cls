/**
 * @description       : Test class for TriggerHandler apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class TriggerHandlerTest {
	@isTest
    public static void testBeforeInsert(){
        new TriggerHandler().beforeInsert(new List<Account>());
    }

	@isTest
    public static void beforeUpdate() {
        new TriggerHandler().beforeUpdate(new Map<Id, sObject>(), new Map<Id, sObject>());
    }

	@isTest
    public static void beforeDelete() {
        new TriggerHandler().beforeDelete(new Map<Id, sObject>());
    }

	@isTest
    public static void afterInsert() {
        new TriggerHandler().afterInsert(new Map<Id, sObject>());
    }

	@isTest
    public static void afterUpdate() {
        new TriggerHandler().afterUpdate(new Map<Id, sObject>(), new Map<Id, sObject>());
    }

	@isTest
    public static void afterDelete() {
        new TriggerHandler().afterDelete(new Map<Id, sObject>());
    }

	@isTest
    public static void afterUnDelete() {
        new TriggerHandler().afterUnDelete(new Map<Id, sObject>());
    }
}