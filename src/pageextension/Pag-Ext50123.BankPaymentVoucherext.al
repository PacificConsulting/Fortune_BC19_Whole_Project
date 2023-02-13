pageextension 50123 "Bank_Payment_Voucher_ext" extends "Bank Payment Voucher"
{
    // version NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        addafter(Amount)
        {
            field("RTGS/NEFT"; "RTGS/NEFT")
            {
                ApplicationArea = all;
            }
        }
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



}

