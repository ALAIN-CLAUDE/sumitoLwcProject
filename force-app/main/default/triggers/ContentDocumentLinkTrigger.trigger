trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
	TriggerDispatcher.run(new TriggerHandlerContentDocumentLink()); 
}