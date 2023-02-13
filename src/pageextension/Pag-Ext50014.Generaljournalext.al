pageextension 50014 "General_journal_ext" extends "General Journal"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {
        addafter("Posting Date")
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = all;
            }
            field("Due Date"; "Due Date")
            {
                ApplicationArea = all;
            }
        }

        addafter("Account Type")
        {


            field("Currency Factor"; "Currency Factor")
            {
                ApplicationArea = all;
            }


        }
    }
    actions
    {

        modify("Apply Entries")
        {
            Visible = false;
        }
        addafter(DeferralSchedule)
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

