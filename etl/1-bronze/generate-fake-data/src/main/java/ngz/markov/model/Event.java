package ngz.markov.model; 


import lombok.Builder;
import lombok.Data;


@Data
@Builder
public class Event {
    private String eventId;
    private String customerId;
    private String eventType;
    private String campaignId;
    private long eventTs;
}