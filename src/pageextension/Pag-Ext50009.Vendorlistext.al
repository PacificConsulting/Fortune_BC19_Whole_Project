pageextension 50009 "Vendor_list_ext" extends "Vendor List"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Post Code")
        {
            field(Balance; Balance)
            {
                ApplicationArea = all;
            }
        }
        addafter("Country/Region Code")
        {
            field("P.A.N. No."; "P.A.N. No.")
            {
                ApplicationArea = all;
            }
            field("GST Registration No."; "GST Registration No.")
            {
                ApplicationArea = all;
            }
            field("GST Vendor Type"; "GST Vendor Type")
            {
                ApplicationArea = all;
            }
            field("Applicability of 206AB"; "Applicability of 206AB")
            {
                ApplicationArea = all;
            }

        }
        addafter(Contact)
        {
            field("Custome Duty Exm."; "Custome Duty Exm.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        addafter("CancelApprovalRequest")
        {
            action("<Bank Payment Journal>")
            {
                Caption = 'Bank Payment Journal';
                Image = "Bank payment Vocuher";
                RunObject = Page "Bank Payment Voucher";
            }
            action("License Details")
            {
                RunObject = Page "License List";
                RunPageLink = "Vendor No." = FIELD("No.");
                RunPageView = ORDER(Ascending);
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

