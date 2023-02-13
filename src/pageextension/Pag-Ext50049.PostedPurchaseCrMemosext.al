pageextension 50049 "Posted_Purchase_Cr_Memos_ext" extends "Posted Purchase Credit Memos"
{
    // version NAVW19.00.00.45778
    layout
    {
        addafter("No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addafter("&Navigate")
        {
            action("Debit Note-GL")
            {
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //CCIT-SG
                    RecPCH.RESET;
                    RecPCH.SETRANGE(RecPCH."No.", "No.");
                    REPORT.RUN(50053, TRUE, FALSE, RecPCH);
                    //CCIT-SG
                end;
            }
            action("Debit Note-Product")
            {
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    RecPCH.RESET;
                    RecPCH.SETRANGE(RecPCH."No.", "No.");
                    REPORT.RUN(50052, TRUE, FALSE, RecPCH);
                end;
            }
        }
    }

    var
        RecPCH: Record 124;
}

