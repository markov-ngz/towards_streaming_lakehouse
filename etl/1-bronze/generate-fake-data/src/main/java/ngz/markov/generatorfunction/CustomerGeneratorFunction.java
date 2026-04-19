package ngz.markov.generatorfunction ; 

import org.apache.flink.api.connector.source.SourceReaderContext;
import org.apache.flink.connector.datagen.source.GeneratorFunction;

import ngz.markov.generator.CustomerGenerator;
import ngz.markov.model.Customer;

public class CustomerGeneratorFunction implements  GeneratorFunction<Long, Customer>{

    private CustomerGenerator generator ; 

    @Override
    public void open(SourceReaderContext readerContext) throws Exception{
        this.generator = new CustomerGenerator() ; 
    }

    @Override
    public Customer map(Long t) throws Exception {

        Customer Customer = generator.generate() ;

        return Customer ; 
    }
}