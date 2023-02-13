pageextension 50010 Vendor_Ledger_Entries_Ext extends "Vendor Ledger Entries"
{
    // version TFS225977

    layout
    {

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
        }
        addafter(Description)
        {
            field(Comment; Comment)
            {
                ApplicationArea = all;
            }
        }
        addafter("Remaining Amount")
        {
            field("Total TDS Including SHE CESS"; "Total TDS Including SHE CESS")
            {
                ApplicationArea = all;
            }
            // field("TDS Nature of Deduction"; "TDS Nature of Deduction")
            // {
            //     ApplicationArea=all;
            // }
            // field("TDS Group"; "TDS Group")
            // {
            //     ApplicationArea=all;
            // }
        }
        addafter("Remaining Amt. (LCY)")
        {
            field("Original Currency Factor"; "Original Currency Factor")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Print Voucher")
        {
            action("GST Print Voucher")
            {
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //RL
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETFILTER("Document Type", '%1|%2', VendorLedgerEntry."Document Type"::Payment,
                      VendorLedgerEntry."Document Type"::Refund);
                    VendorLedgerEntry.SETRANGE("Document No.", "Document No.");
                    REPORT.RUNMODAL(16412, TRUE, TRUE, VendorLedgerEntry);

                    //RL
                end;
            }
        }





        addafter(IncomingDocAttachFile)
        {
            action("Update Vendor Detail")
            {
                Image = Union;

                trigger OnAction();
                begin
                    //RL
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Document No.", "Document No.");
                    VendorLedgerEntry.SETRANGE("Document Type", "Document Type");
                    IF VendorLedgerEntry.FINDFIRST THEN
                        REPORT.RUNMODAL(50046, TRUE, TRUE, VendorLedgerEntry);
                    //RL
                end;
            }
        }
        addafter("Print Voucher")
        {
            action("Print Voiucher 4")
            {
                ApplicationArea = all;
                Image = Print;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    GLEntry.SETRANGE("Document No.", "Document No.");
                    GLEntry.SETRANGE("Posting Date", "Posting Date");
                    IF GLEntry.FindFirst() THEN
                        REPORT.RUNMODAL(50122, TRUE, TRUE, GLEntry);

                end;

            }

        }
    }

    var
        VendorLedgerEntry: Record 25;

    //Unsupported feature: PropertyChange. Please convert manually.

}

