tableextension 50004 "GL_Account_ext" extends "G/L Account"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992

    fields
    {

        //Unsupported feature: Change TableRelation on ""GST Group Code"(Field 16602)". Please convert manually.
        //modify(Gst group code)

        field(50000; "Total Payments"; Decimal)
        {
            FieldClass = Normal;
        }

        field(50001; "Ttl payments"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "Document Type" = FILTER(Payment),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "CashFlow Vendor Type" = FIELD(FILTER("CashFlow Vendor Type"))));
            Description = 'rdk';
            FieldClass = FlowField;
        }

        field(50002; "CashFlow Vendor Type"; Text[50])
        {
            Description = 'rdk 30-08-2019';
            FieldClass = FlowFilter;
        }
        field(50003; "Sales Account"; Boolean)
        {
            Description = 'RL';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

