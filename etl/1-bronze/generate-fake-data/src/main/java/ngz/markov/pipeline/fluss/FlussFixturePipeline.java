package ngz.markov.pipeline.fluss;

import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.connector.datagen.source.GeneratorFunction;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;
public interface FlussFixturePipeline<T> {

    GeneratorFunction<Long, T> getGeneratorFunction();

    TypeInformation<T> getTypeInformation();

    FlussSerializationSchema<T> getSerializationSchema();

    String getSourceName();
}