pageextension 50042 "Posted_Purch_Cr_Memo_ext" extends "Posted Purchase Credit Memo"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {
        addafter("No. Printed")
        {
            field("Port of Loading-Air"; "Port of Loading-Air")
            {
                ApplicationArea = all;
            }
            field("Port of Loading-Ocean"; "Port of Loading-Ocean")
            {
                ApplicationArea = all;
            }
            field("Port of Destination-Air"; "Port of Destination-Air")
            {
                ApplicationArea = all;
            }
            field("Port of Destination-Ocean"; "Port of Destination-Ocean")
            {
                ApplicationArea = all;
            }
            field("Bill Of Lading No."; "Bill Of Lading No.")
            {
                ApplicationArea = all;
            }
            field("Container Filter"; "Container Filter")
            {
                ApplicationArea = all;
            }
            field("BL/AWB"; "BL/AWB")
            {
                ApplicationArea = all;
            }
            field("ETD - Supplier Warehouse"; "ETD - Supplier Warehouse")
            {
                ApplicationArea = all;
            }
            field("ETD - Origin Port"; "ETD - Origin Port")
            {
                ApplicationArea = all;
            }
            field("Container Number"; "Container Number")
            {
                ApplicationArea = all;
            }
            field("Container Seal #"; "Container Seal #")
            {
                ApplicationArea = all;
            }
            field("ETA - Destination Port"; "ETA - Destination Port")
            {
                ApplicationArea = all;
            }
            field("ETA - Destination CFS"; "ETA - Destination CFS")
            {
                ApplicationArea = all;
            }
            field("ETA - Bond"; "ETA - Bond")
            {
                ApplicationArea = all;
            }
            field("ETA - Availability for Sale"; "ETA - Availability for Sale")
            {
                ApplicationArea = all;
            }
        }

    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

