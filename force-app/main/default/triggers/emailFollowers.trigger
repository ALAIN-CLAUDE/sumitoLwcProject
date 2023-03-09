trigger emailFollowers on FeedItem (after insert) {
    
    /*for (FeedItem f: trigger.new) {
        
        if (f.ParentID != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<EntitySubscription> followers = [select id, subscriberid, subscriber.name, subscriber.email from EntitySubscription where parentid = :f.ParentID];
            
            String[] toAddresses = new List<String>();
            
            
            for (EntitySubscription follower : followers) {
                toAddresses.add(follower.subscriber.email);
            }
            
            mail.setToAddresses(toAddresses);
            //mail.setTemplateID(templateId.Id);
            
            mail.setSubject('New Chatter Post ');
            
            mail.setPlainTextBody(f.body);
            
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }*/
}