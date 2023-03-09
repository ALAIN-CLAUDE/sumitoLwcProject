public virtual class TriggerHandler{ 
    public virtual void beforeInsert(List<sObject> newRecords) {}
    public virtual void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {}
    public virtual void beforeDelete(Map<Id, sObject> oldRecords) {}
    public virtual void afterInsert(Map<Id, sObject> newRecords) {}
    public virtual void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {}
    public virtual void afterDelete(Map<Id, sObject> oldRecords) {}
    public virtual void afterUnDelete(Map<Id, sObject> oldRecords) {}
}