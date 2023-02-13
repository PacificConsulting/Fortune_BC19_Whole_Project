pageextension 50038 "Posted_Purchase_Receipt_ext" extends "Posted Purchase Receipt"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        addafter("Responsibility Center")
        {
            field("Nature of Supply"; "Nature of Supply")
            {
                Importance = Additional;
                ApplicationArea = all;
            }
            field("License No."; "License No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Purchaser Code")
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
            field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
            {
                ApplicationArea = all;
            }
            field("In-Bond BOE Date"; "In-Bond BOE Date")
            {
                ApplicationArea = all;
            }
            field("Bond Number"; "Bond Number")
            {
                ApplicationArea = all;
            }
            field("JWL GRN No."; "JWL GRN No.")
            {
                ApplicationArea = all;
            }
            field("JWL GRN Date"; "JWL GRN Date")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

