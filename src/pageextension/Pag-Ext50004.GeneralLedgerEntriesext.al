pageextension 50004 "General_Ledger_Entries_ext" extends "General Ledger Entries"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {


        addafter("Posting Date")
        {
            field("Document Date"; "Document Date")
            {
                ApplicationArea = all;
            }

        }
        modify("Source Type")
        {
            Visible = true;
        }
        modify("Source No.")
        {
            Visible = true;
        }
        modify("User ID")
        {
            Visible = true;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }

        addafter("Document No.")
        {
            field("Bill of Entry Date"; "Bill of Entry Date")
            {
                ApplicationArea = all;
            }
            field("Bill of Entry No"; "Bill of Entry No")
            {
                ApplicationArea = all;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = all;
            }

        }


        addafter(Description)
        {
            field(Comment; Comment)
            {
                Caption = 'Narration';
                ApplicationArea = all;
            }
        }
        addafter("Source Code")
        {
            field("System-Created Entry"; "System-Created Entry")
            {
                ApplicationArea = all;
            }
        }
        addafter("Entry No.")
        {
            // field("Source Type"; "Source Type")
            // {
            //     ApplicationArea = all;
            // }
            // field("Source No."; "Source No.")
            // {
            //     ApplicationArea = all;
            // }
            field("CashFlow Vendor Type"; "CashFlow Vendor Type")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        //action(Action1500002)
        modify("Print Voucher")
        {
            trigger OnBeforeAction()
            begin
                GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                GLEntry.SETRANGE("Document No.", "Document No.");
                GLEntry.SETRANGE("Posting Date", "Posting Date");
                IF GLEntry.FINDFIRST THEN
                    //REPORT.RUNMODAL(REPORT::"Posted Voucher", TRUE, TRUE, GLEntry);
                    REPORT.RUNMODAL(50122, TRUE, TRUE, GLEntry);

            end;
        }
    }

    var
        RecGLEntry: Record 17;
        RecVendor: Record 23;
        VendorName: Text[50];
        textDocs: Text[200];
        GLEntry: Record 17;


}

