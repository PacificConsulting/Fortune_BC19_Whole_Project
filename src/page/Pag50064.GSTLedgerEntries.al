page 50064 "GST Ledger Entries"
{
    // version To be deleted

    PageType = List;
    Permissions = TableData "GST Ledger Entry" = rimd;
    SourceTable = "GST Ledger Entry";

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
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("GST Base Amount"; "GST Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
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
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Purchase Group Type"; "Purchase Group Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("GST Component Code"; "GST Component Code")
                {
                    ApplicationArea = All;
                }
                field("GST on Advance Payment"; "GST on Advance Payment")
                {
                    ApplicationArea = All;
                }
                field("Reverse Charge"; "Reverse Charge")
                {
                    ApplicationArea = All;
                }
                field("GST Amount"; "GST Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Factor"; "Currency Factor")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = All;
                }
                field("Reversed Entry No."; "Reversed Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Reversed by Entry No."; "Reversed by Entry No.")
                {
                    ApplicationArea = All;
                }
                field(UnApplied; UnApplied)
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Type"; "Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Input Service Distribution"; "Input Service Distribution")
                {
                    ApplicationArea = All;
                }
                field(Availment; Availment)
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No. 2"; "Bal. Account No. 2")
                {
                    ApplicationArea = All;
                }
                field("Account No. 2"; "Account No. 2")
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

