package ngz.markov.schemas.fluss.serialization;

import org.apache.fluss.flink.row.OperationType;
import org.apache.fluss.flink.row.RowWithOp;
import org.apache.fluss.flink.sink.serializer.FlussSerializationSchema;
import org.apache.fluss.row.BinaryString;
import org.apache.fluss.row.Decimal;
import org.apache.fluss.row.GenericRow;

import ngz.markov.model.SaleOrder;

public class SaleOrderSerializationSchema implements FlussSerializationSchema<SaleOrder>{

    @Override
    public void open(InitializationContext context) throws Exception {}

    @Override
    public RowWithOp serialize(SaleOrder value) throws Exception {
        GenericRow row = new GenericRow(4);

        row.setField(0, BinaryString.fromString(value.getOrderId()));
        row.setField(1, BinaryString.fromString(value.getCustomerId()));
        row.setField(2, Decimal.fromBigDecimal(
            value.getTotalAmount(), 
            10,
            2) 
        );
        row.setField(3, value.getOrderTs());

        return new RowWithOp(row, OperationType.UPSERT);
    }
}