pageextension 50047 "Posted_Purchase_Receipts_ext" extends "Posted Purchase Receipts"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {

        addafter("No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
        }
        addafter("Pay-to Vendor No.")
        {
            field("Order No."; "Order No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action(GRN)
            {
                Promoted = true;

                trigger OnAction();
                begin
                    //CCIT-SG
                    RecPRH.RESET;
                    RecPRH.SETRANGE(RecPRH."No.", "No.");
                    REPORT.RUN(50049, TRUE, FALSE, RecPRH);
                    //CCIT-SG
                end;
            }
        }
    }

    var
        RecPRH: Record 120;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];



}

