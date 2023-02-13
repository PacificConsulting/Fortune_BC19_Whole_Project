pageextension 50040 "Posted_Purchase_Invoice_ext" extends "Posted Purchase Invoice"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067


    layout
    {


        addafter("Responsibility Center")
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
            }
            field("ETA - Bond"; "ETA - Bond")
            {
            }
            field("ETA - Availability for Sale"; "ETA - Availability for Sale")
            {
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action("Purchase Invoice")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Print;
                trigger OnAction()
                begin
                    PIH.Reset();
                    PIH.SetRange("No.", "No.");
                    IF PIH.FindFirst() then
                        Report.RunModal(18011, true, false, PIH);
                end;
            }
        }
    }

    var
        PIH: Record 122;
    //int : Codeunit 90;
    //Unsupported feature: PropertyChange. Please convert manually.

}

