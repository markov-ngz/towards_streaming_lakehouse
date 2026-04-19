package ngz.markov.generatorfunction ; 

import org.apache.flink.api.connector.source.SourceReaderContext;
import org.apache.flink.connector.datagen.source.GeneratorFunction;

import ngz.markov.generator.EventGenerator;
import ngz.markov.model.Event;

public class EventGeneratorFunction implements  GeneratorFunction<Long, Event>{

    private EventGenerator generator ; 

    @Override
    public void open(SourceReaderContext readerContext) throws Exception{
        this.generator = new EventGenerator() ; 
    }

    @Override
    public Event map(Long t) throws Exception {

        Event intentEvent = generator.generate() ;

        return intentEvent ; 
    }
}