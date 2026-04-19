package ngz.markov.generator ;

import java.math.BigDecimal;
import java.math.RoundingMode;

import net.datafaker.Faker;
import ngz.markov.model.SaleOrder;


public class SaleOrderGenerator implements Generator<SaleOrder> {

    @Override
    public SaleOrder generate() {
        String customerId = this.customerGenerator.generateCustomerId();

        return SaleOrder.builder()
                .orderId(faker.idNumber().valid())
                .customerId(customerId)
                .totalAmount(generateTotalAmount())
                .orderTs(System.currentTimeMillis())
                .build();
    }

    private final Faker faker;
    private final CustomerGenerator customerGenerator;
 
    public SaleOrderGenerator() {
        this.faker = new Faker();
        this.customerGenerator = new CustomerGenerator() ; 
    }


    private BigDecimal generateTotalAmount() {
        return BigDecimal.valueOf(
                10 + (1000 - 10) * faker.random().nextDouble()
        ).setScale(2, RoundingMode.HALF_UP);
    }

}
