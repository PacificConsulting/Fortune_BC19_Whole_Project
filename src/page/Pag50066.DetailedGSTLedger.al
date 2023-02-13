page 50066 "Detailed GST Ledger"
{
    // version To be deleted

    PageType = List;
    Permissions = TableData "Detailed GST Ledger Entry" = rimd;
    SourceTable = "Detailed GST Ledger Entry";

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
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
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
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; "Product Type")
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
                field("HSN/SAC Code"; "HSN/SAC Code")
                {
                    ApplicationArea = All;
                }
                field("GST Component Code"; "GST Component Code")
                {
                    ApplicationArea = All;
                }
                field("GST Group Code"; "GST Group Code")
                {
                    ApplicationArea = All;
                }
                field("GST Jurisdiction Type"; "GST Jurisdiction Type")
                {
                    ApplicationArea = All;
                }
                field("GST Base Amount"; "GST Base Amount")
                {
                    ApplicationArea = All;
                }
                field("GST %"; "GST %")
                {
                    ApplicationArea = All;
                }
                field("GST Amount"; "GST Amount")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Amount Loaded on Item"; "Amount Loaded on Item")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("GST Without Payment of Duty"; "GST Without Payment of Duty")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("Reversed by Entry No."; "Reversed by Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = All;
                }
                // field("User ID"; "User ID")
                // {
                //     ApplicationArea = All;
                // }
                // field(Positive; Positive)
                // {
                //     ApplicationArea = All;
                // }
                field("Document Line No."; "Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item Charge Entry"; "Item Charge Entry")
                {
                    ApplicationArea = All;
                }
                field("Reverse Charge"; "Reverse Charge")
                {
                    ApplicationArea = All;
                }
                field("GST on Advance Payment"; "GST on Advance Payment")
                {
                    ApplicationArea = All;
                }
                // field("Nature of Supply"; "Nature of Supply")
                // {
                //     ApplicationArea = All;
                // }
                field("Payment Document No."; "Payment Document No.")
                {
                    ApplicationArea = All;
                }
                // field("GST Exempted Goods"; "GST Exempted Goods")
                // {
                //     ApplicationArea = All;
                // }
                // field("Location State Code"; "Location State Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Buyer/Seller State Code"; "Buyer/Seller State Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Shipping Address State Code"; "Shipping Address State Code")
                // {
                //     ApplicationArea = All;
                // }
                field("Location  Reg. No."; "Location  Reg. No.")
                {
                    ApplicationArea = All;
                }
                field("Buyer/Seller Reg. No."; "Buyer/Seller Reg. No.")
                {
                    ApplicationArea = All;
                }
                field("GST Group Type"; "GST Group Type")
                {
                    ApplicationArea = All;
                }
                field("GST Credit"; "GST Credit")
                {
                    ApplicationArea = All;
                }
                field("Reversal Entry"; "Reversal Entry")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
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
                field("Application Doc. Type"; "Application Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Application Doc. No"; "Application Doc. No")
                {
                    ApplicationArea = All;
                }
                // field("Original Doc. Type"; "Original Doc. Type")
                // {
                //     ApplicationArea = All;
                // }
                // field("Original Doc. No."; "Original Doc. No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Applied From Entry No."; "Applied From Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Reversed Entry No."; "Reversed Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Remaining Closed"; "Remaining Closed")
                {
                    ApplicationArea = All;
                }
                field("GST Rounding Precision"; "GST Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("GST Rounding Type"; "GST Rounding Type")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("GST Customer Type"; "GST Customer Type")
                {
                    ApplicationArea = All;
                }
                field("GST Vendor Type"; "GST Vendor Type")
                {
                    ApplicationArea = All;
                }
                // field("CLE/VLE Entry No."; "CLE/VLE Entry No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Bill Of Export No."; "Bill Of Export No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Bill of Entry No."; "Bill of Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Bill of Entry Date"; "Bill of Entry Date")
                {
                    ApplicationArea = All;
                }
                // field("Bill Of Export Date"; "Bill Of Export Date")
                // {
                //     ApplicationArea = All;
                // }
                // field("e-Comm. Merchant Id"; "e-Comm. Merchant Id")
                // {
                //     ApplicationArea = All;
                // }
                // field("e-Comm. Operator GST Reg. No."; "e-Comm. Operator GST Reg. No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Invoice Type"; "Invoice Type")
                // {
                //     ApplicationArea = All;
                // }
                field("Original Invoice No."; "Original Invoice No.")
                {
                    ApplicationArea = All;
                }
                // field("Original Invoice Date"; "Original Invoice Date")
                // {
                //     ApplicationArea = All;
                // }
                field("Reconciliation Month"; "Reconciliation Month")
                {
                    ApplicationArea = All;
                }
                field("Reconciliation Year"; "Reconciliation Year")
                {
                    ApplicationArea = All;
                }
                field(Reconciled; Reconciled)
                {
                    ApplicationArea = All;
                }
                field("Credit Availed"; "Credit Availed")
                {
                    ApplicationArea = All;
                }
                field(Paid; Paid)
                {
                    ApplicationArea = All;
                }
                // field("Amount to Customer/Vendor"; "Amount to Customer/Vendor")
                // {
                //     ApplicationArea = All;
                // }
                field("Credit Adjustment Type"; "Credit Adjustment Type")
                {
                    ApplicationArea = All;
                }
                // field("Adv. Pmt. Adjustment"; "Adv. Pmt. Adjustment")
                // {
                //     ApplicationArea = All;
                // }
                // field("Original Adv. Pmt Doc. No."; "Original Adv. Pmt Doc. No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Original Adv. Pmt Doc. Date"; "Original Adv. Pmt Doc. Date")
                // {
                //     ApplicationArea = All;
                // }
                // field("Payment Document Date"; "Payment Document Date")
                // {
                //     ApplicationArea = All;
                // }
                // field(Cess; Cess)
                // {
                //     ApplicationArea = All;
                // }
                field(UnApplied; UnApplied)
                {
                    ApplicationArea = All;
                }
                // field("Item Ledger Entry No."; "Item Ledger Entry No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Credit Reversal"; "Credit Reversal")
                // {
                //     ApplicationArea = All;
                // }
                field("GST Place of Supply"; "GST Place of Supply")
                {
                    ApplicationArea = All;
                }
                // field("Item Charge Assgn. Line No."; "Item Charge Assgn. Line No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Payment Type"; "Payment Type")
                {
                    ApplicationArea = All;
                }
                field(Distributed; Distributed)
                {
                    ApplicationArea = All;
                }
                field("Distributed Reversed"; "Distributed Reversed")
                {
                    ApplicationArea = All;
                }
                field("Input Service Distribution"; "Input Service Distribution")
                {
                    ApplicationArea = All;
                }
                field(Opening; Opening)
                {
                    ApplicationArea = All;
                }
                // field("Remaining Amount Closed"; "Remaining Amount Closed")
                // {
                //     ApplicationArea = All;
                // }
                field("Remaining Base Amount"; "Remaining Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining GST Amount"; "Remaining GST Amount")
                {
                    ApplicationArea = All;
                }
                // field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                // {
                //     ApplicationArea = All;
                // }
                // field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                // {
                //     ApplicationArea = All;
                // }
                // field("Reason Code"; "Reason Code")
                // {
                //     ApplicationArea = All;
                // }
                field("Dist. Document No."; "Dist. Document No.")
                {
                    ApplicationArea = All;
                }
                field("Associated Enterprises"; "Associated Enterprises")
                {
                    ApplicationArea = All;
                }
                // field("Delivery Challan Amount"; "Delivery Challan Amount")
                // {
                //     ApplicationArea = All;
                // }
                field("Liable to Pay"; "Liable to Pay")
                {
                    ApplicationArea = All;
                }
                // field("Subcon Document No."; "Subcon Document No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Last Credit Adjusted Date"; "Last Credit Adjusted Date")
                // {
                //     ApplicationArea = All;
                // }
                field("Dist. Input GST Credit"; "Dist. Input GST Credit")
                {
                    ApplicationArea = All;
                }
                // field("Component Calc. Type"; "Component Calc. Type")
                // {
                //     ApplicationArea = All;
                // }
                // field("Cess Amount Per Unit Factor"; "Cess Amount Per Unit Factor")
                // {
                //     ApplicationArea = All;
                // }
                // field("Cess UOM"; "Cess UOM")
                // {
                //     ApplicationArea = All;
                // }
                // field("Cess Factor Quantity"; "Cess Factor Quantity")
                // {
                //     ApplicationArea = All;
                // }
                field("Dist. Reverse Document No."; "Dist. Reverse Document No.")
                {
                    ApplicationArea = All;
                }
                // field(UOM; UOM)
                // {
                //     ApplicationArea = All;
                // }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Customer/Vendor Name"; "Customer/Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Same State GST Line"; "Same State GST Line")
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

