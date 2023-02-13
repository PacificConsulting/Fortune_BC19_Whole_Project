pageextension 50031 "General_ledget_setup_ext" extends "General Ledger Setup"
{
    // version TFS225977

    layout
    {

        addafter("GST Credit Adj. Jnl Nos.")
        {
            field("Custom Duty Payable A/c"; "Custom Duty Payable A/c")
            {
                ApplicationArea = all;
            }
            field("Custom Duty Expense A/c"; "Custom Duty Expense A/c")
            {
                ApplicationArea = all;
            }
            field(Vendor; Vendor)
            {
                ApplicationArea = all;
            }
        }
        // addafter("GST Settlement Nos.")
        // {
        //     group("E-Invoicing")
        //     {

        //         Caption = 'E-Invoicing';
        //         field("GST IRN Generation URL"; "GST IRN Generation URL")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("GST Authorization URL"; "GST Authorization URL")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("GST Public Key Directory Path"; "GST Public Key Directory Path")
        //         {
        //             ApplicationArea = all;
        //             Caption = 'GST QR Path';
        //         }
        //         field("EWAY Bill URL"; "EWAY Bill URL")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("Cancel Eway Bill URL"; "Cancel Eway Bill URL")
        //         {
        //             ApplicationArea = all;
        //         }
        //     }
        // }
    }
    actions
    {

    }



}

