/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class QuoteEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String subject=email.subject;
        String plainTextBody=email.plainTextBody;
        list<string> parts=new list<string>();
        System.debug('Subject----'+subject);
        System.debug('body----'+plainTextBody);

        if(subject.contains('[Ref#')){
            String quoteID=subject.substring(subject.IndexOf('[Ref#')+5,subject.length()-1);
            System.debug('quoteID----'+quoteID);
            SBQQ__Quote__c quote=[Select ID,SBQQ__Status__c from SBQQ__Quote__c where name=:quoteID];
            System.debug('plainTextBody-----'+plainTextBody);
            if(plainTextBody.contains('Accepted') || plainTextBody.contains('accepted')){
                quote.SBQQ__Status__c='Accepted';
                quote.Quote_Reviewed__c=true;
                update quote;
            }
            else if(plainTextBody.contains('Rejected') || plainTextBody.contains('rejected')){
                quote.SBQQ__Status__c='Rejected';
                update quote;
            }
            //***********
            
           
        }
        return result;
    }
}