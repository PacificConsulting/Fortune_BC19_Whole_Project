tableextension 50036 "Sales_Receivables_Setup" extends "Sales & Receivables Setup"
{
    // version NAVW19.00.00.48316,NAVIN9.00.00.48316,CCIT-Fortune,CCIT-TDS

    fields
    {

        field(50000; "Bond Nos."; Code[10])
        {
            Description = 'CCIT';
            TableRelation = "No. Series";
        }
        field(50001; Tolerance; Decimal)
        {
            Description = 'CCIT';
        }
        field(50002; "Post Bond SO-SCM"; Boolean)
        {
            Description = 'rdk 230919';
        }
        field(50003; "194Q Applicable Date"; Date)
        {
            Description = 'CCIT';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

