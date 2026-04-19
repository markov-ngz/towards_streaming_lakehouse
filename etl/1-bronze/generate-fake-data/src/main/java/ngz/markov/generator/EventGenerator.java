package ngz.markov.generator;

import java.time.Instant;

import net.datafaker.Faker;
import ngz.markov.model.Event;

public class EventGenerator implements Generator<Event>{

   private static final String[] EVENT_TYPES = {
        "product_view",
        "add_to_cart",
        "remove_from_cart",
        "wishlist_add",
        "checkout_start",
        "checkout_complete",
        "product_search",
        "category_browse",
        "coupon_applied",
        "review_submitted"
    };
 
    private final Faker faker;
    private final CustomerGenerator customerGenerator;
 
    public EventGenerator() {
        this.faker = new Faker();
        this.customerGenerator = new CustomerGenerator() ; 
    }

    @Override
    public Event generate() {
        String eventId    = faker.internet().uuid();
        String customerId = this.customerGenerator.generateCustomerId(); // customer only between 1 and 100
        String eventType  = faker.options().option(EVENT_TYPES);
        String campaignId  = faker.options().option("1","2"); // choose between "1" or "2"
        long   eventTs    = nowEpochSec();

        Event intentEvent = Event.builder()
            .eventId(eventId)
            .customerId(customerId)
            .eventType(eventType)
            .campaignId(campaignId)
            .eventTs(eventTs)
            .build()
        ;
 
        return intentEvent;
    }

    @Override
    public void open() {
        Generator.super.open();
    }
    
    private long nowEpochSec() {
        Instant now  = Instant.now();
        long nowUnixTsMili = now.toEpochMilli() ;
        long nowUnixTsSec = Math.floorDiv(nowUnixTsMili, 1000L) ;
        return nowUnixTsSec ;
    }
 
}