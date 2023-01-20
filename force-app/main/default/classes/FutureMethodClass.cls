public class FutureMethodClass {
    
    @future
    public static void FutureMethodThatCreatesAnAccount() {
        Account acc = new Account(Name='Account created in future method');
        insert acc;
    }
}