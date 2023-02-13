pageextension 50088 "Purchase_Return_Order_ext" extends "Purchase Return Order"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    layout
    {

        addafter("Purchaser Code")
        {
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }
        }
        addafter("Job Queue Status")
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
            field("Bill Of Lading Date"; "Bill Of Lading Date")
            {
                ApplicationArea = all;
            }
            field("Short Closed"; "Short Closed")
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
            field("Container Seal No."; "Container Seal No.")
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
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }
        modify(PostBatch)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118
            end;
        }
    }



}

