tableextension 50412 "Warehouse_Journal" extends "Warehouse Journal Line"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    fields
    {

        field(50028; "Conversion Qty To Handle"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
        }
        field(50030; Weight1; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category".Code;
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50500; "Actual Batch"; Code[20])
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50501; "Actual MFG Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50502; "Actual EXP Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50503; "Actual Batch PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(70000; "Manufacturing Date"; Date)
        {
            Description = 'CS';
        }
        field(70001; "New Manufacturing Date"; Date)
        {
            Description = 'CS';
        }
        field(70002; "Qty. to Handle (Base) In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(70003; "Remainig Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(70004; "PO Lot No."; Code[20])
        {
            Description = 'CITS-SD-26-12-17';
        }
        field(70005; "PO Expiration Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';
        }
        field(70006; "PO Manufacturing Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

