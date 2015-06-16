trigger VOpportunityTrigger on Opportunity (after insert, after update) {
    new VOpportunityTriggerDispatcher().dispatch();
}