pageextension 50065 "Sales_Order_Archive_ext" extends "Sales Order Archive"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621

    actions
    {
        addafter(Print)
        {
            action("Sales Order Archive")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //CCIT-SG
                    RecSH1.RESET;
                    RecSH1.SETRANGE(RecSH1."No.", "No.");
                    REPORT.RUNMODAL(50025, TRUE, FALSE, RecSH1);
                    //CCIT-SG
                end;
            }
        }
    }
    var
        RecSH1: Record 5107;
}

