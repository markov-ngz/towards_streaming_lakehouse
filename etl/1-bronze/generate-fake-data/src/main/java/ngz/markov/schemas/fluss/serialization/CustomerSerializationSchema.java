package ngz.markov.schemas.fluss.serialization;

import org.apache.fluss.flink.row.OperationType;
import org.apache.fluss.flink.row.RowWithOp;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;
import org.apache.fluss.row.BinaryString;
import org.apache.fluss.row.GenericRow;

import ngz.markov.model.Customer;

public class CustomerSerializationSchema implements FlussSerializationSchema<Customer>{

    @Override
    public void open(InitializationContext context) throws Exception {}

    @Override
    public RowWithOp serialize(Customer value) throws Exception {
        GenericRow row = new GenericRow(8);

        row.setField(0, BinaryString.fromString(value.getCustomerId()));
        row.setField(1, BinaryString.fromString(value.getEmail()));
        row.setField(2, BinaryString.fromString(value.getPhone()));
        row.setField(3, BinaryString.fromString(value.getSegment()));
        row.setField(4, BinaryString.fromString(value.getAcquisitionChannel()));
        row.setField(5, BinaryString.fromString(value.getCountry()));
        row.setField(6, value.isOptIn());
        row.setField(7, value.getLastPurchaseTs());

        return new RowWithOp(row, OperationType.UPSERT);
    }
}