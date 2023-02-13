tableextension 50236 "Entry_Summary_ext" extends "Entry Summary"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

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
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(70000; "Manufacturing Date"; Date)
        {
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


    var
        Today_Date: Date;
}

