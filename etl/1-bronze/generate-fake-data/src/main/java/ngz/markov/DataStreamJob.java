package ngz.markov;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.connector.source.util.ratelimit.RateLimiterStrategy;
import org.apache.flink.connector.datagen.source.DataGeneratorSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.ParameterTool;
import org.apache.fluss.flink.sink.FlussSink;

import ngz.markov.pipeline.fluss.FlussFixturePipeline;
import ngz.markov.pipeline.fluss.FlussFixturePipelineFactory;

public class DataStreamJob {

    public static void main(String[] args) throws Exception {

        // Parse job args
        ParameterTool params = ParameterTool.fromArgs(args);

        String pipelineName          = params.get("pipeline.name", "Fluss Data Generation - Default Name");
        String entity                = params.getRequired("entity");
        String flussBootstrapServers = params.getRequired("fluss.bootstrap.servers");
        String flussSinkDatabase     = params.getRequired("sink.fluss.database");
        String flussSinkTable        = params.getRequired("sink.fluss.table");

        // Resolve the pipeline components from the entity arg
        FlussFixturePipeline<?> pipeline = FlussFixturePipelineFactory.create(entity);

        // Create Streaming env
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.getConfig().setGlobalJobParameters(params);

        run(env, pipeline, flussBootstrapServers, flussSinkDatabase, flussSinkTable, pipelineName, params);

        env.execute(pipelineName);
    }

    /**
     * Generic helper that lets the compiler bind <T> once so source and sink share the same type.
     */
    private static <T> void run(
            StreamExecutionEnvironment env,
            FlussFixturePipeline<T> pipeline,
            String bootstrapServers,
            String database,
            String table,
            String pipelineName,
            ParameterTool params) {

        
        DataGeneratorSource<T> source = new DataGeneratorSource<>(
                pipeline.getGeneratorFunction(),
                Long.MAX_VALUE,
                RateLimiterStrategy.perSecond(1),
                pipeline.getTypeInformation())
        ;

        FlussSink<T> sink = FlussSink.<T>builder()
                .setBootstrapServers(bootstrapServers)
                .setDatabase(database)
                .setTable(table)
                .setSerializationSchema(pipeline.getSerializationSchema())
                .setOptions(params.toMap())
                .build();

        env.fromSource(source, WatermarkStrategy.noWatermarks(), pipeline.getSourceName())
            .sinkTo(sink) ; 
    }
}