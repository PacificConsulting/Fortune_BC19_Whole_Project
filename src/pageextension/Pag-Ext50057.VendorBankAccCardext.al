pageextension 50057 "Vendor_Bank_Acc_Card_ext" extends "Vendor Bank Account Card"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Bank Account No.")
        {
            field("IFSC Code"; "IFSC Code")
            {
                ApplicationArea = all;
            }
        }
    }
}

