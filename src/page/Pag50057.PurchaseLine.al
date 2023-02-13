page 50057 "Purchase Line"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE(Type = FILTER("G/L Account"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
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
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                    ApplicationArea = All;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("VAT %"; "VAT %")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight"; "Gross Weight")
                {
                    ApplicationArea = All;
                }
                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = All;
                }
                field("Units per Parcel"; "Units per Parcel")
                {
                    ApplicationArea = All;
                }
                field("Unit Volume"; "Unit Volume")
                {
                    ApplicationArea = All;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    ApplicationArea = All;
                }
                field("Recalculate Invoice Disc."; "Recalculate Invoice Disc.")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amount"; "Outstanding Amount")
                {
                    ApplicationArea = All;
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Amt. Rcd. Not Invoiced"; "Amt. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    ApplicationArea = All;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Receipt No."; "Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Receipt Line No."; "Receipt Line No.")
                {
                    ApplicationArea = All;
                }
                field("Profit %"; "Profit %")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Vendor Item No."; "Vendor Item No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Drop Shipment"; "Drop Shipment")
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
                field("VAT Calculation Type"; "VAT Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; "Transport Method")
                {
                    ApplicationArea = All;
                }
                field("Attached to Line No."; "Attached to Line No.")
                {
                    ApplicationArea = All;
                }
                field("Entry Point"; "Entry Point")
                {
                    ApplicationArea = All;
                }
                field(Area_1; Area)
                {
                    ApplicationArea = All;
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = All;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    ApplicationArea = All;
                }
                field("Tax Group Code"; "Tax Group Code")
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
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amount (LCY)"; "Outstanding Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Amt. Rcd. Not Invoiced (LCY)"; "Amt. Rcd. Not Invoiced (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                    ApplicationArea = All;
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    ApplicationArea = All;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Base Amount"; "VAT Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("System-Created Entry"; "System-Created Entry")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                }
                field("VAT Difference"; "VAT Difference")
                {
                    ApplicationArea = All;
                }
                field("Inv. Disc. Amount to Invoice"; "Inv. Disc. Amount to Invoice")
                {
                    ApplicationArea = All;
                }
                field("VAT Identifier"; "VAT Identifier")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Reference"; "IC Partner Reference")
                {
                    ApplicationArea = All;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Amt. Incl. VAT"; "Prepmt. Amt. Incl. VAT")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Amount"; "Prepayment Amount")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. VAT Base Amt."; "Prepmt. VAT Base Amt.")
                {
                    ApplicationArea = All;
                }
                field("Prepayment VAT %"; "Prepayment VAT %")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. VAT Calc. Type"; "Prepmt. VAT Calc. Type")
                {
                    ApplicationArea = All;
                }
                field("Prepayment VAT Identifier"; "Prepayment VAT Identifier")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Tax Area Code"; "Prepayment Tax Area Code")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Tax Liable"; "Prepayment Tax Liable")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Tax Group Code"; "Prepayment Tax Group Code")
                {
                    ApplicationArea = All;
                }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct")
                {
                    ApplicationArea = All;
                }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Line"; "Prepayment Line")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Amount Inv. Incl. VAT"; "Prepmt. Amount Inv. Incl. VAT")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Amount Inv. (LCY)"; "Prepmt. Amount Inv. (LCY)")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. VAT Amount Inv. (LCY)"; "Prepmt. VAT Amount Inv. (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Prepayment VAT Difference"; "Prepayment VAT Difference")
                {
                    ApplicationArea = All;
                }
                field("Prepmt VAT Diff. to Deduct"; "Prepmt VAT Diff. to Deduct")
                {
                    ApplicationArea = All;
                }
                field("Prepmt VAT Diff. Deducted"; "Prepmt VAT Diff. Deducted")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amt. Ex. VAT (LCY)"; "Outstanding Amt. Ex. VAT (LCY)")
                {
                    ApplicationArea = All;
                }
                field("A. Rcd. Not Inv. Ex. VAT (LCY)"; "A. Rcd. Not Inv. Ex. VAT (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Job Line Type"; "Job Line Type")
                {
                    ApplicationArea = All;
                }
                field("Job Unit Price"; "Job Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Job Total Price"; "Job Total Price")
                {
                    ApplicationArea = All;
                }
                field("Job Line Amount"; "Job Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Job Line Discount Amount"; "Job Line Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Job Line Discount %"; "Job Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Job Unit Price (LCY)"; "Job Unit Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Job Total Price (LCY)"; "Job Total Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Job Line Amount (LCY)"; "Job Line Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Job Line Disc. Amount (LCY)"; "Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Job Currency Factor"; "Job Currency Factor")
                {
                    ApplicationArea = All;
                }
                field("Job Currency Code"; "Job Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Job Planning Line No."; "Job Planning Line No.")
                {
                    ApplicationArea = All;
                }
                field("Job Remaining Qty."; "Job Remaining Qty.")
                {
                    ApplicationArea = All;
                }
                field("Job Remaining Qty. (Base)"; "Job Remaining Qty. (Base)")
                {
                    ApplicationArea = All;
                }
                field("Deferral Code"; "Deferral Code")
                {
                    ApplicationArea = All;
                }
                field("Returns Deferral Start Date"; "Returns Deferral Start Date")
                {
                    ApplicationArea = All;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Qty. (Base)"; "Outstanding Qty. (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Invoice (Base)"; "Qty. to Invoice (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Receive (Base)"; "Qty. to Receive (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. Rcd. Not Invoiced (Base)"; "Qty. Rcd. Not Invoiced (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. Received (Base)"; "Qty. Received (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. Invoiced (Base)"; "Qty. Invoiced (Base)")
                {
                    ApplicationArea = All;
                }
                field("Reserved Qty. (Base)"; "Reserved Qty. (Base)")
                {
                    ApplicationArea = All;
                }
                field("FA Posting Date"; "FA Posting Date")
                {
                    ApplicationArea = All;
                }
                field("FA Posting Type"; "FA Posting Type")
                {
                    ApplicationArea = All;
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                    ApplicationArea = All;
                }
                field("Salvage Value"; "Salvage Value")
                {
                    ApplicationArea = All;
                }
                field("Depr. until FA Posting Date"; "Depr. until FA Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Depr. Acquisition Cost"; "Depr. Acquisition Cost")
                {
                    ApplicationArea = All;
                }
                field("Maintenance Code"; "Maintenance Code")
                {
                    ApplicationArea = All;
                }
                field("Insurance No."; "Insurance No.")
                {
                    ApplicationArea = All;
                }
                field("Budgeted FA No."; "Budgeted FA No.")
                {
                    ApplicationArea = All;
                }
                field("Duplicate in Depreciation Book"; "Duplicate in Depreciation Book")
                {
                    ApplicationArea = All;
                }
                field("Use Duplication List"; "Use Duplication List")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure (Cross Ref.)"; "Unit of Measure (Cross Ref.)")
                {
                    ApplicationArea = All;
                }
                field("Cross-Reference Type"; "Cross-Reference Type")
                {
                    ApplicationArea = All;
                }
                field("Cross-Reference Type No."; "Cross-Reference Type No.")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    ApplicationArea = All;
                }
                field(Nonstock; Nonstock)
                {
                    ApplicationArea = All;
                }
                field("Purchasing Code"; "Purchasing Code")
                {
                    ApplicationArea = All;
                }

                field("Delivery Challan Posted"; "Delivery Challan Posted")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Reject (Rework)"; "Qty. to Reject (Rework)")
                {
                    ApplicationArea = All;
                }
                field("Qty. Rejected (Rework)"; "Qty. Rejected (Rework)")
                {
                    ApplicationArea = All;
                }
                field(SendForRework; SendForRework)
                {
                    ApplicationArea = All;
                }
                field("Qty. to Reject (C.E.)"; "Qty. to Reject (C.E.)")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Reject (V.E.)"; "Qty. to Reject (V.E.)")
                {
                    ApplicationArea = All;
                }
                field("Qty. Rejected (C.E.)"; "Qty. Rejected (C.E.)")
                {
                    ApplicationArea = All;
                }
                field("Qty. Rejected (V.E.)"; "Qty. Rejected (V.E.)")
                {
                    ApplicationArea = All;
                }
                field("Deliver Comp. For"; "Deliver Comp. For")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Vendor Shipment No."; "Vendor Shipment No.")
                {
                    ApplicationArea = All;
                }
                field("Released Production Order"; "Released Production Order")
                {
                    ApplicationArea = All;
                }
                field(SubConReceive; SubConReceive)
                {
                    ApplicationArea = All;
                }
                field("Component Item No."; "Component Item No.")
                {
                    ApplicationArea = All;
                }

                field("MPS Order"; "MPS Order")
                {
                    ApplicationArea = All;
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                    ApplicationArea = All;
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    ApplicationArea = All;
                }
                field("Routing Reference No."; "Routing Reference No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        IF RecVendor.GET("Buy-from Vendor No.") THEN
            "Buy-from Vendor Name" := RecVendor.Name;
    end;

    trigger OnOpenPage();
    begin
        IF RecVendor.GET("Buy-from Vendor No.") THEN
            "Buy-from Vendor Name" := RecVendor.Name;
    end;

    var
        RecVendor: Record 23;
}

