pageextension 50008 "Vendort_card_ext" extends "Vendor Card"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        addafter("Purchaser Code")
        {
            field("Custome Duty Exm."; "Custome Duty Exm.")
            {
                ApplicationArea = all;
            }
            field("Applicability of 206AB"; "Applicability of 206AB")
            {
                ApplicationArea = all;
            }
        }
        addafter("Cash Flow Payment Terms Code")
        {
            field("CashFlow Vendor Type"; "CashFlow Vendor Type")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Transport Method"; "Transport Method")
            {
                ApplicationArea = all;
            }
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
            field("Lead Time Air ETD"; "Lead Time Air ETD")
            {
                ApplicationArea = all;
            }
            field("Lead Time Ship ETD"; "Lead Time Ship ETD")
            {
                ApplicationArea = all;
            }
            field("Avail.for Sale  Air ETA"; "Avail.for Sale  Air ETA")
            {
                ApplicationArea = all;
            }
            field("Avail.for Sale Ship ETA"; "Avail.for Sale Ship ETA")
            {
                ApplicationArea = all;
            }
            field("Stock Last for Days"; "Stock Last for Days")
            {
                ApplicationArea = all;
            }

        }
        addafter("Custome Duty Exm.")
        {
            field("GST Custom House"; "GST Custom House")
            {
                ApplicationArea = all;
            }
        }
        addafter("Balance Due (LCY)")
        {
            field(SSI; SSI)
            {
                ApplicationArea = all;
            }
            field("SSI Validity Date"; "SSI Validity Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                //----CCIT
                TESTFIELD("P.A.N. No.");
                TESTFIELD("GST Registration No.");
                //----

            end;
        }


        //Unsupported feature: CodeModification on "ApplyTemplate(Action 131).OnAction". Please convert manually.


        //Unsupported feature: PropertyDeletion on "ApplyTemplate(Action 131)". Please convert manually.

        addafter(VendorReportSelections)
        {
            action("License Details")
            {
                RunObject = Page "License List";
                RunPageLink = "Vendor No." = FIELD("No.");
                RunPageView = ORDER(Ascending);
            }

            action("Bank Payment Voucher")
            {
                Caption = 'Bank Payment Voucher';
                Image = "Bank Payment Vocuher";
                RunObject = Page "Bank Payment Voucher";
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

