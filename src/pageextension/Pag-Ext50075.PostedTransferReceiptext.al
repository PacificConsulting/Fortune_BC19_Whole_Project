pageextension 50075 "Posted_Transfer_Receipt_ext" extends "Posted Transfer Receipt"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    layout
    {
        addafter("Posting Date")
        {
            field("LR/RR No."; "LR/RR No.")
            {
                ApplicationArea = all;
            }
            field("LR/RR Date"; "LR/RR Date")
            {
                ApplicationArea = all;
            }
            field("Vehicle No."; "Vehicle No.")
            {
                ApplicationArea = all;
            }
            field("Mode of Transport"; "Mode of Transport")
            {
                ApplicationArea = all;
            }
            field("Seal No."; "Seal No.")
            {
                ApplicationArea = all;
            }
            field("Load Type"; "Load Type")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Vehicle Reporting Date"; "Vehicle Reporting Date")
            {
                ApplicationArea = all;
            }
            field("Vehicle Reporting Time"; "Vehicle Reporting Time")
            {
                ApplicationArea = all;
            }
            field("Vehicle Release Time"; "Vehicle Release Time")
            {
                ApplicationArea = all;
            }
        }
        addafter("Area")
        {
            field("BL Date"; "BL Date")
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
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Transfer Goods Receipt Note ")
            {
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    RecILE: Record 32;
                begin
                    //CCIT-SG-26042018
                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Document No.", "No.");
                    REPORT.RUNMODAL(50056, TRUE, FALSE, RecILE);
                    //CCIT-SG-26042018
                end;
            }
        }
    }

    var
        RecTransRecptHead: Record 5746;

    //Unsupported feature: PropertyChange. Please convert manually.

}

