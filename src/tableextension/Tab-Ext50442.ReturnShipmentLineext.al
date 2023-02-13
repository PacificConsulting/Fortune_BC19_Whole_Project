tableextension 50442 "Return_Shipment_Line_ext" extends "Return Shipment Line"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    fields
    {
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50051; "Partial Payment Terms"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Partial Payment Terms".Code;
        }
        field(50052; "Vendor Invoiced Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50088; "Reason For Free Sample"; Option)
        {
            OptionCaption = '" ,New Product,Liquidation,Friend & Family,Market Penetration,Competitor,Government Department"';
            OptionMembers = " ","New Product",Liquidation,"Friend & Family","Market Penetration",Competitor,"Government Department";
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

