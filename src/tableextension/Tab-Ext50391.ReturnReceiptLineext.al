tableextension 50391 "Return_Receipt_Line_ext" extends "Return Receipt Line"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    fields
    {
        // modify("Invoice Type")
        // {
        //     OptionCaptionML = ENU='Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST',ENN='Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';

        //     //Unsupported feature: Change OptionString on ""Invoice Type"(Field 16609)". Please convert manually.

        // }
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
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category".Code;
        }
        field(50112; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
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
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

