public class ScheduledApexClass implements Schedulable {
    
    public void execute(SchedulableContext context) {
        System.debug('Work that will run on schedule');
        Account acc = new Account(Name='Account created in scheduled job');
        insert acc;
    }
}