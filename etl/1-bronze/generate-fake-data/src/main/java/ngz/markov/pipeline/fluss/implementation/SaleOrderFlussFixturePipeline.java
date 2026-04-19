package ngz.markov.pipeline.fluss.implementation;

import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.connector.datagen.source.GeneratorFunction;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;

import ngz.markov.generatorfunction.SaleOrderGeneratorFunction;
import ngz.markov.model.SaleOrder;
import ngz.markov.pipeline.fluss.FlussFixturePipeline;
import ngz.markov.schemas.fluss.serialization.SaleOrderSerializationSchema;

public class SaleOrderFlussFixturePipeline implements FlussFixturePipeline<SaleOrder> {

    @Override
    public GeneratorFunction<Long, SaleOrder> getGeneratorFunction() {
        return new SaleOrderGeneratorFunction();
    }

    @Override
    public TypeInformation<SaleOrder> getTypeInformation() {
        return TypeInformation.of(SaleOrder.class);
    }

    @Override
    public FlussSerializationSchema<SaleOrder> getSerializationSchema() {
        return new SaleOrderSerializationSchema();
    }

    @Override
    public String getSourceName() {
        return "intent-event";
    }
}