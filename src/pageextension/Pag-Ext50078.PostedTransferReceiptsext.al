pageextension 50078 "Posted_Transfer_Receipts_ext" extends "Posted Transfer Receipts"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("No.")
        {
            field("Transfer Order No."; "Transfer Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Receipt Date")
        {
            field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
            {
                ApplicationArea = all;
            }
            field("In-Bond BOE Date"; "In-Bond BOE Date")
            {
                ApplicationArea = all;
            }
            field("Ex-bond BOE No."; "Ex-bond BOE No.")
            {
                ApplicationArea = all;
            }
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
            field("Ex-bond BOE Date"; "Ex-bond BOE Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Transfer Goods Receipt Note")
            {
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //CCIT-SG-26042018
                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Document No.", "No.");
                    REPORT.RUNMODAL(50056, TRUE, FALSE, RecILE);
                    //CCIT-SG-26042018
                    /*
                    RecTSH.RESET;
                    RecTSH.SETRANGE(RecTSH."No.","No.");
                    REPORT.RUNMODAL(50045,TRUE,FALSE,RecTSH);
                    */

                end;
            }
        }
    }

    var
        RecTransRecptHead: Record 5746;
        RecILE: Record 32;
}

