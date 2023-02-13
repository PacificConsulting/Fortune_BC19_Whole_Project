page 50063 "Detail Cust Ledger entry"
{
    // version To be deleted

    PageType = List;
    Permissions = TableData 21 = rimd,
                  TableData 379 = rimd;
    SourceTable = "Detailed Cust. Ledg. Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Cust. Ledger Entry No."; "Cust. Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount (LCY)"; "Debit Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount (LCY)"; "Credit Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Initial Entry Due Date"; "Initial Entry Due Date")
                {
                    ApplicationArea = All;
                }
                field("Initial Entry Global Dim. 1"; "Initial Entry Global Dim. 1")
                {
                    ApplicationArea = All;
                }
                field("Initial Entry Global Dim. 2"; "Initial Entry Global Dim. 2")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Use Tax"; "Use Tax")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Initial Document Type"; "Initial Document Type")
                {
                    ApplicationArea = All;
                }
                field("Applied Cust. Ledger Entry No."; "Applied Cust. Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Unapplied; Unapplied)
                {
                    ApplicationArea = All;
                }
                field("Unapplied by Entry No."; "Unapplied by Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Remaining Pmt. Disc. Possible"; "Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = All;
                }
                field("Max. Payment Tolerance"; "Max. Payment Tolerance")
                {
                    ApplicationArea = All;
                }
                field("Tax Jurisdiction Code"; "Tax Jurisdiction Code")
                {
                    ApplicationArea = All;
                }
                field("Application No."; "Application No.")
                {
                    ApplicationArea = All;
                }
                field("Ledger Entry Amount"; "Ledger Entry Amount")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
}

