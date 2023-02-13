tableextension 50431 "Posted_Whse_Rec_Line_ext" extends "Posted Whse. Receipt Line"
{

    fields
    {
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

