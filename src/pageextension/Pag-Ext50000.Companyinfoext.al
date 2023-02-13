pageextension 50000 "Company_info_ext" extends "Company Information"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        //Unsupported feature: PropertyDeletion on ""Phone No.2"(Control 50)". Please convert manually.

        modify("Phone No.2")
        {
            Visible = false;
        }
        addafter("Company Status")
        {
            field("CIN No."; "CIN No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Picture)
        {
            field("UPI QR Code"; "UPI QR Code")
            {
                ApplicationArea = all;
            }
            field("MSME No."; "MSME No.")
            {
                ApplicationArea = all;
            }
            field("Auto IRN Generation"; "Auto IRN Generation")
            {
                ApplicationArea = all;
            }

        }
        addafter("E-Mail")
        {
            field("Purchase E mail"; "Purchase E mail")
            {
                ApplicationArea = all;
            }
        }

    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

