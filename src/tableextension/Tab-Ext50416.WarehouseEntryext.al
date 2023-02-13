tableextension 50416 "Warehouse_Entry_ext" extends "Warehouse Entry"
{
    // version NAVW19.00.00.48316,CCIT-Fortune

    fields
    {
        field(50028; "Conversion Qty To Handle"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
        }
        field(50030; Weight1; Decimal)
        {
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            Description = 'CCIT';
        }
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
        field(70000; "Manufacturing Date"; Date)
        {
            CaptionML = ENU = 'Expiration Date',
                        ENN = 'Expiration Date';
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

