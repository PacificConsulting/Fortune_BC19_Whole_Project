pageextension 50053 "Bank_Acc_Reco_Lines_ext" extends "Bank Acc. Reconciliation Lines"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Document No.")
        {
            field(CRDR; CRDR)
            {
                ApplicationArea = all;
            }
        }
        addafter("Check No.")
        {
            field(TxnPostedDate; TxnPostedDate)
            {
                ApplicationArea = all;
            }
        }
    }
}

