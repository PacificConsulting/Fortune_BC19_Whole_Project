tableextension 50234 "Reservation_Entry_ext" extends "Reservation Entry"
{
    // version NAVW19.00.00.48628,NAVIN9.00.00.48628,CCIT-Fortune

    fields
    {



        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
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
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
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
            Description = 'CCIT';
        }
        field(70003; "Remainig Qty. In KG"; Decimal)
        {
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
    keys
    {
        key(KeyExt1; "Item No.", "Lot No.")
        {
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

