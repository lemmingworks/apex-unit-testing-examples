public class UpdateAccountsBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id From Account');
    }

    public void execute(Database.BatchableContext bc, List<SObject> records) {
        for(Account acc: (List<Account>)records) {
            acc.Name = 'Account updated in batch job';
        }
        update records;
    }

    public void finish(Database.BatchableContext bc) {}
}