package ngz.markov.pipeline.fluss.implementation;

import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.connector.datagen.source.GeneratorFunction;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;

import ngz.markov.generatorfunction.EventGeneratorFunction;
import ngz.markov.model.Event;
import ngz.markov.pipeline.fluss.FlussFixturePipeline;
import ngz.markov.schemas.fluss.serialization.EventSerializationSchema;

public class EventFlussFixturePipeline implements FlussFixturePipeline<Event> {

    @Override
    public GeneratorFunction<Long, Event> getGeneratorFunction() {
        return new EventGeneratorFunction();
    }

    @Override
    public TypeInformation<Event> getTypeInformation() {
        return TypeInformation.of(Event.class);
    }

    @Override
    public FlussSerializationSchema<Event> getSerializationSchema() {
        return new EventSerializationSchema();
    }

    @Override
    public String getSourceName() {
        return "intent-event";
    }
}