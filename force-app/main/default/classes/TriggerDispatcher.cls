/**
 * @description       : Trigger Dispatcher class to control execution of triggers
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
public class TriggerDispatcher {
    /*
     * Code commented out below has been commented out because it is not needed at this time 27/09/2021,
     * uncomment code as needed
     */
	public static Set<Id> processedBeforeRecords = new Set<Id>();
    public static Set<Id> processedAfterRecords = new Set<Id>();
    private static Set<String> skippedTriggers = new Set<String>();

    /**
    * Main method used to control how triggers are executed and handled.
    **/
    public static void run(TriggerHandler handler) {
		if(!skippedTriggers.contains( getHandlerName(handler) )) {
            /*if(Trigger.isBefore) {
				if(Trigger.isInsert) {
                    handler.beforeInsert(Trigger.new); 
                } 

                if(Trigger.isUpdate) {
                    if(!processedBeforeRecords.containsAll(Trigger.newMap.keySet())) {
                        handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
                    }

                    processedBeforeRecords.addAll(Trigger.newMap.keySet());
                }

                if(Trigger.isDelete) {
                    handler.beforeDelete(Trigger.oldMap); 
                }
            }*/

            if(Trigger.isAfter) {
                if(Trigger.isInsert) {
                    handler.afterInsert(Trigger.newMap); 
                }

                /*if(Trigger.isUpdate) {
                    if(!processedAfterRecords.containsAll(Trigger.newMap.keySet())) {
                        handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
                    }

                    processedAfterRecords.addAll(Trigger.newMap.keySet());
                }

                if(Trigger.isDelete) {
                    handler.afterDelete(Trigger.oldMap); 
                }

                if(Trigger.isUnDelete) {
                    handler.afterUnDelete(Trigger.oldMap); 
                }*/
            }
        }
    }

    /**
    * Add a handler name to the list of handlers to skip when executing triggers.
    
    public static void skip(String handlerName) {
		skippedTriggers.add(handlerName);
    }**/

    /**
    * Adds multiple handler names to the list of handlers to skip when executing triggers.
    
    public static void skip(List<String> handlerNames) {
        for(String handlerName : handlerNames) {
            skip(handlerName);
        }
    }**/

    /**
    * Removes a handler name from the list of skipped triggers.
    
    public static void resume(String handlerName) {
		skippedTriggers.remove(handlerName);
    }**/

    /**
    * Removes multiple handler names from the list of skipped triggers.
    
    public static void resume(List<String> handlerNames) {
		for(String handlerName : handlerNames) {
            resume(handlerName);
        }
    }**/

    /**
    * Gets the string name of an instance of an unknown class type.
    **/
    private static String getHandlerName(TriggerHandler handler) {
       return String.valueOf(handler).split(':')[0];
    }
}