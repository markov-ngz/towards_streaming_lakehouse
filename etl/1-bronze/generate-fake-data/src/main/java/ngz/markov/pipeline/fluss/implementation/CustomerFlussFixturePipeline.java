package ngz.markov.pipeline.fluss.implementation;

import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.connector.datagen.source.GeneratorFunction;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;

import ngz.markov.generatorfunction.CustomerGeneratorFunction;
import ngz.markov.model.Customer;
import ngz.markov.pipeline.fluss.FlussFixturePipeline;
import ngz.markov.schemas.fluss.serialization.CustomerSerializationSchema;

public class CustomerFlussFixturePipeline implements FlussFixturePipeline<Customer> {

    @Override
    public GeneratorFunction<Long, Customer> getGeneratorFunction() {
        return new CustomerGeneratorFunction();
    }

    @Override
    public TypeInformation<Customer> getTypeInformation() {
        return TypeInformation.of(Customer.class);
    }

    @Override
    public FlussSerializationSchema<Customer> getSerializationSchema() {
        return new CustomerSerializationSchema();
    }

    @Override
    public String getSourceName() {
        return "customer";
    }
}