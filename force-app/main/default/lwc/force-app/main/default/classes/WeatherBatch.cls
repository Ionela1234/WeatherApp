public class WeatherBatch implements Database.Batchable<sObject>{
    public (Database.QueryLocator | Iterable<sObject>) start(Database.BatchableContext bc) {
        String query = 'SELECT Id, ShippingCity, ShippiungCountry Name FROM Account';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<account> accounts) {
        List<Account> accsToUpdate = new List<Account>();
        for(Account a : accounts) {
            a.ShippingCity = this.ShippingCity;
            a.ShippiungCountry = this.ShippiungCountry;
            accsToUpdate.add(a);
        }
        update accsToUpdate;
    } 
    public void finish(Database.BatchableContext bc){
        
    }
}
