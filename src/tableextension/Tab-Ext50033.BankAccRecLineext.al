tableextension 50033 "Bank_Acc_Rec_Line_ext" extends "Bank Acc. Reconciliation Line"
{
    // version NAVW19.00.00.48466

    fields
    {



        field(50000; "No."; Integer)
        {
        }
        field(50001; CRDR; Text[30])
        {
        }
        field(50002; Amt; Decimal)
        {
        }
        field(50003; TxnPostedDate; Date)
        {
        }
        field(50004; "Bank Acc.Led Entry No."; Integer)
        {
            Description = 'RDK 26-07-2019';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

