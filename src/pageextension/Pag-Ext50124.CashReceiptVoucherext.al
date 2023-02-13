pageextension 50124 "Cash_Receipt_Voucher_ext" extends "Cash Receipt Voucher"
{
    // version NAVIN9.00.00.48067

    layout
    {


    }
    actions
    {
        addafter(Preview)
        {
            action("Pre Voucher Printing")
            {
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //CCIT-JAGA
                    RecGenJunLine.RESET;
                    RecGenJunLine.SETRANGE(RecGenJunLine."Document No.", "Document No.");
                    REPORT.RUNMODAL(50027, TRUE, FALSE, RecGenJunLine);
                    //CCIT-JAGA
                end;
            }
        }
    }

    var
        RecGenJunLine: Record 81;

    //Unsupported feature: PropertyChange. Please convert manually.

}

