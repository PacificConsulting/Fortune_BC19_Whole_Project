pageextension 50067 "Sales_List_Arche_ext" extends "Sales List Archive"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Outstanding Quantity KG"; "Outstanding Quantity KG")
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field(Amount; Amount)
            {
                ApplicationArea = all;
            }
            field("Short Closed"; "Short Closed")
            {
                ApplicationArea = all;
            }
            field("ShortClose Reason Code"; "ShortClose Reason Code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(Card)
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

