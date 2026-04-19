package ngz.markov.pipeline.fluss;
 
import ngz.markov.pipeline.fluss.implementation.CustomerFlussFixturePipeline;
import ngz.markov.pipeline.fluss.implementation.EventFlussFixturePipeline;
import ngz.markov.pipeline.fluss.implementation.SaleOrderFlussFixturePipeline;
 
public class FlussFixturePipelineFactory {
 
    public static final String ENTITY_CUSTOMER     = "customer";
    public static final String ENTITY_EVENT = "event";
    public static final String ENTITY_SALE_ORDER = "sale_order";
 
    private FlussFixturePipelineFactory() {}
 
    public static FlussFixturePipeline<?> create(String entity) {
        switch (entity.toLowerCase().trim()) {
            
            case ENTITY_SALE_ORDER:
                return new SaleOrderFlussFixturePipeline();
            case ENTITY_CUSTOMER:
                return new CustomerFlussFixturePipeline();
            case ENTITY_EVENT:
                return new EventFlussFixturePipeline();
            default:
                throw new IllegalArgumentException(
                    "Unknown entity: \"" + entity + "\". " +
                    "Valid values are: [" + ENTITY_CUSTOMER + ", " + ENTITY_EVENT + ", "+ ENTITY_SALE_ORDER +"]"
                );
        }
    }
}
 