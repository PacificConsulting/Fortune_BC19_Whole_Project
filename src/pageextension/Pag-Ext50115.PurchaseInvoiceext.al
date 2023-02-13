pageextension 50115 "Purchase_Invoice_ext1" extends "Purchase Invoices"
{
    // version NAVW19.00.00.46621

    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = all;
            }

            field("TDS Amount"; "TDS Amount")
            {
                ApplicationArea = all;
            }
            field("GST Amount"; "GST Amount")
            {
            }
        }
        addafter("Pay-to Name")
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("Created User"; "Created User")
            {
                ApplicationArea = all;
            }
        }


    }
}

