package ngz.markov.generator ; 

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import net.datafaker.Faker;
import ngz.markov.model.AcquisitionChannel;
import ngz.markov.model.Customer;
import ngz.markov.model.Segment;

public class CustomerGenerator implements Generator{
 
    // ISO-3166 country codes supported by this generator.
    private static final String[] COUNTRIES = { "FR", "ES", "BE", "CH", "IT" };
 
    // One locale-aware {@link Faker} per country for realistic phone / name data
    private static final Map<String, Faker> FAKER_BY_COUNTRY = Map.of(
        "FR", new Faker(Locale.forLanguageTag("fr-FR")),
        "ES", new Faker(Locale.forLanguageTag("es-ES")),
        "BE", new Faker(Locale.forLanguageTag("fr-BE")),
        "CH", new Faker(Locale.forLanguageTag("de-CH")),
        "IT", new Faker(Locale.forLanguageTag("it-IT"))
    );
 
    /** Default faker used for country-agnostic fields. */
    private final Faker faker;
 
    public CustomerGenerator() {
        this.faker = new Faker();
    }
 
    @Override
    public Customer generate() {
        String  country  = faker.options().option(COUNTRIES);
        Faker   local    = FAKER_BY_COUNTRY.get(country);
        Segment segment  = faker.options().option(Segment.class);
        AcquisitionChannel acquisitionChannel = faker.options().option(AcquisitionChannel.class); 
 
        return Customer.builder()
            .customerId     (generateCustomerId())
            .email          (local.internet().emailAddress())
            .phone          (local.phoneNumber().phoneNumber())
            .segment        (segment.getLabel())
            .lastPurchaseTs (randomRecentEpochSeconds(segment))
            .country        (country)
            .optIn          (faker.bool().bool())
            .acquisitionChannel(acquisitionChannel.getLabel())
            .build();
    }

    public List<Customer> generateBatch(int count) {
        List<Customer> batch = new ArrayList<>(count);
        for (int i = 0; i < count; i++) {
            batch.add(generate());
        }
        return batch;
    }

    public String generateCustomerId() {
        return String.valueOf(faker.number().numberBetween(1, 20)) ;
    }

    private long randomRecentEpochSeconds(Segment segment) {
        int minDaysAgo;
        int maxDaysAgo;
 
        switch (segment) {
            case CHURNED:   minDaysAgo = 180; maxDaysAgo = 365; break;
            case AT_RISK:   minDaysAgo =  60; maxDaysAgo = 180; break;
            case NEW:       minDaysAgo =   0; maxDaysAgo =  30; break;
            default:        minDaysAgo =   1; maxDaysAgo =  90; break;
        }
 
        Instant now  = Instant.now();
        Instant from = now.minus(maxDaysAgo, ChronoUnit.DAYS);
        Instant to   = now.minus(minDaysAgo, ChronoUnit.DAYS);
 
        long rangeSeconds = to.getEpochSecond() - from.getEpochSecond();
        return from.getEpochSecond() + (long) (Math.random() * rangeSeconds);
    }
 
}