package ngz.markov.model ; 

import java.math.BigDecimal;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SaleOrder {
    private String orderId;
    private String customerId;
    private BigDecimal totalAmount;
    private long orderTs;
}