package ngz.markov.schemas.fluss.serialization;

import org.apache.fluss.flink.row.OperationType;
import org.apache.fluss.flink.row.RowWithOp;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;
import org.apache.fluss.row.BinaryString;
import org.apache.fluss.row.GenericRow;

import ngz.markov.model.Event;

public class EventSerializationSchema implements FlussSerializationSchema<Event>{

    @Override
    public void open(InitializationContext context) throws Exception {}

    @Override
    public RowWithOp serialize(Event value) throws Exception {
        GenericRow row = new GenericRow(5);

        row.setField(0, BinaryString.fromString(value.getEventId()));
        row.setField(1, BinaryString.fromString(value.getCustomerId()));
        row.setField(2, BinaryString.fromString(value.getEventType()));
        row.setField(3, BinaryString.fromString(value.getCampaignId()));
        row.setField(4, value.getEventTs());

        return new RowWithOp(row, OperationType.UPSERT);
    }
}