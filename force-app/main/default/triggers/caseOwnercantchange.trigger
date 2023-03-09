trigger caseOwnercantchange on Case (after insert) {
   if(Trigger.isBefore && Trigger.isInsert){
        List<Group> lstPre = [SELECT Id from Group where Type = 'Queue' AND DeveloperNAME = 'Support'  LIMIT 1];
        if(!lstPre.isEmpty()){
            for (Case c : Trigger.new) {
                if(c.Status =='New' && c.Origin =='Portal' && c.RecordType.Name == 'Marketing_Query'){
                    c.ownerId = lstPre[0].Id;
                }
            }

            update lstPre;
        }
    }
}