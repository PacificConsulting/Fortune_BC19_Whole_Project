tableextension 50353 "Value_entry_ext" extends "Value Entry"
{
    // version NAVW19.00.00.48628,NAVIN9.00.00.48628

    fields
    {



        field(50000; "Valued Quantity In KG"; Decimal)
        {
            CaptionML = ENU = 'Valued Quantity',
                        ENN = 'Valued Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(50001; "ItemLedgerEntryQuantity In KG"; Decimal)
        {
            CaptionML = ENU = 'Item Ledger Entry Quantity',
                        ENN = 'Item Ledger Entry Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(50002; "Invoiced Quantity In KG"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Quantity',
                        ENN = 'Invoiced Quantity';
            DecimalPlaces = 0 : 5;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

