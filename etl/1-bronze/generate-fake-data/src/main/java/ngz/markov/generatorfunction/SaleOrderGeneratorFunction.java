package ngz.markov.generatorfunction ; 

import org.apache.flink.api.connector.source.SourceReaderContext;
import org.apache.flink.connector.datagen.source.GeneratorFunction;

import ngz.markov.generator.SaleOrderGenerator;
import ngz.markov.model.SaleOrder;

public class SaleOrderGeneratorFunction implements  GeneratorFunction<Long, SaleOrder>{

    private SaleOrderGenerator generator ; 

    @Override
    public void open(SourceReaderContext readerContext) throws Exception{
        this.generator = new SaleOrderGenerator() ; 
    }

    @Override
    public SaleOrder map(Long t) throws Exception {

        SaleOrder SaleOrder = generator.generate() ;

        return SaleOrder ; 
    }
}