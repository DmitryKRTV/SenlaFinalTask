public with sharing class ExchangeRateProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        ExchangeRateController.changeRates();
    }
}