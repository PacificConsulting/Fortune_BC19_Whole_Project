page 50008 "ILE"
{
    // version CCIT-Fortune

    Editable = true;
    PageType = List;
    Permissions = TableData 32 = rimd;
    SourceTable = "Item Ledger Entry";

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
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Remaining Quantity KG',
                                ENN = 'Remaining Quantity';
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                    ApplicationArea = All;
                }
                field(Open; Open)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Positive; Positive)
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Drop Shipment"; "Drop Shipment")
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
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Entry/Exit Point"; "Entry/Exit Point")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Area_1; Area)
                {
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; "Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Order Type"; "Order Type")
                {
                    ApplicationArea = All;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = All;
                }
                field("Order Line No."; "Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Assemble to Order"; "Assemble to Order")
                {
                    ApplicationArea = All;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Job Purchase"; "Job Purchase")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; "Variant Code")
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
                field("Derived from Blanket Order"; "Derived from Blanket Order")
                {
                    ApplicationArea = All;
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Originally Ordered No."; "Originally Ordered No.")
                {
                    ApplicationArea = All;
                }
                field("Originally Ordered Var. Code"; "Originally Ordered Var. Code")
                {
                    ApplicationArea = All;
                }
                field("Out-of-Stock Substitution"; "Out-of-Stock Substitution")
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
                // field("Product Group Code";"Product Group Code")
                // {
                //     ApplicationArea = All;
                // }
                field("Completely Invoiced"; "Completely Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Last Invoice Date"; "Last Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Applied Entry to Adjust"; "Applied Entry to Adjust")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Expected)"; "Cost Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual)"; "Cost Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Non-Invtbl.)"; "Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Expected) (ACY)"; "Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual) (ACY)"; "Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; "Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = All;
                }
                field("Purchase Amount (Expected)"; "Purchase Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Purchase Amount (Actual)"; "Purchase Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Sales Amount (Expected)"; "Sales Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Sales Amount (Actual)"; "Sales Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field(Correction; Correction)
                {
                    ApplicationArea = All;
                }
                field("Shipped Qty. Not Returned"; "Shipped Qty. Not Returned")
                {
                    ApplicationArea = All;
                }
                field("Prod. Order Comp. Line No."; "Prod. Order Comp. Line No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Warranty Date"; "Warranty Date")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; "Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Item Tracking"; "Item Tracking")
                {
                    ApplicationArea = All;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    ApplicationArea = All;
                }
                // field("DSA Entry No."; "DSA Entry No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("BED %"; "BED %")
                // {
                //     ApplicationArea = All;
                // }
                // field("BED Amount"; "BED Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Other Duties %"; "Other Duties %")
                // {
                //     ApplicationArea = All;
                // }
                // field("Other Duties Amount"; "Other Duties Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Laboratory Test"; "Laboratory Test")
                // {
                //     ApplicationArea = All;
                // }
                // field("Other Usage"; "Other Usage")
                // {
                //     ApplicationArea = All;
                // }
                // field("Nature of Disposal"; "Nature of Disposal")
                // {
                //     ApplicationArea = All;
                // }
                // field("Type of Disposal"; "Type of Disposal")
                // {
                //     ApplicationArea = All;
                // }
                // field("Reason Code"; "Reason Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Captive Consumption"; "Captive Consumption")
                // {
                //     ApplicationArea = All;
                // }
                // field("Re-Dispatch"; "Re-Dispatch")
                // {
                //     ApplicationArea = All;
                // }
                // field("Assessable Value"; "Assessable Value")
                // {
                //     ApplicationArea = All;
                // }
                field("Subcon Order No."; "Subcon Order No.")
                {
                    ApplicationArea = All;
                }
                field("MFG Date"; "MFG Date")
                {
                    ApplicationArea = All;
                }
                field("ETA - Destination Port"; "ETA - Destination Port")
                {
                    ApplicationArea = All;
                }
                field("ETA - Destination CFS"; "ETA - Destination CFS")
                {
                    ApplicationArea = All;
                }
                field("ETA - Bond"; "ETA - Bond")
                {
                    ApplicationArea = All;
                }
                field("JWL BOND GRN No."; "JWL BOND GRN No.")
                {
                    ApplicationArea = All;
                }
                field("JWL BOND GRN Date"; "JWL BOND GRN Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Description"; "Vendor Description")
                {
                    ApplicationArea = All;
                }
                field("Conversion Qty To Handle"; "Conversion Qty To Handle")
                {
                    ApplicationArea = All;
                }
                field("License No."; "License No.")
                {
                    ApplicationArea = All;
                }
                field(Weight; Weight)
                {
                    ApplicationArea = All;
                }
                field("Conversion Qty"; "Conversion Qty")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                }
                field(Reserved; Reserved)
                {
                    ApplicationArea = All;
                }
                field("BL Date"; "BL Date")
                {
                    ApplicationArea = All;
                }
                field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
                {
                    ApplicationArea = All;
                }
                field("In-Bond BOE Date"; "In-Bond BOE Date")
                {
                    ApplicationArea = All;
                }
                field("Bond Number"; "Bond Number")
                {
                    ApplicationArea = All;
                }
                field("Bond Sr.No."; "Bond Sr.No.")
                {
                    ApplicationArea = All;
                }
                field("Bond Date"; "Bond Date")
                {
                    ApplicationArea = All;
                }
                field("BL/AWB No."; "BL/AWB No.")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No."; "Ex-bond BOE No.")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date"; "Ex-bond BOE Date")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.1"; "Ex-bond BOE No.1")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 1"; "Ex-bond BOE Date 1")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.2"; "Ex-bond BOE No.2")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 2"; "Ex-bond BOE Date 2")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.3"; "Ex-bond BOE No.3")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 3"; "Ex-bond BOE Date 3")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.4"; "Ex-bond BOE No.4")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 4"; "Ex-bond BOE Date 4")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.5"; "Ex-bond BOE No.5")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 5"; "Ex-bond BOE Date 5")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.6"; "Ex-bond BOE No.6")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 6"; "Ex-bond BOE Date 6")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.7"; "Ex-bond BOE No.7")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 7"; "Ex-bond BOE Date 7")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.8"; "Ex-bond BOE No.8")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 8"; "Ex-bond BOE Date 8")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE No.9"; "Ex-bond BOE No.9")
                {
                    ApplicationArea = All;
                }
                field("Ex-bond BOE Date 9"; "Ex-bond BOE Date 9")
                {
                    ApplicationArea = All;
                }
                field("ICA No."; "ICA No.")
                {
                    ApplicationArea = All;
                }
                field("Conversion UOM"; "Conversion UOM")
                {
                    ApplicationArea = All;
                }
                field("Storage Categories"; "Storage Categories")
                {
                    ApplicationArea = All;
                }
                field("OrderDate WareActHed"; "OrderDate WareActHed")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Invoice In KG"; "Qty. to Invoice In KG")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Receive In KG"; "Qty. to Receive In KG")
                {
                    ApplicationArea = All;
                }
                field("HS Code"; "HS Code")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Base) In KG"; "Quantity (Base) In KG")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Qty. (Base) In KG"; "Outstanding Qty. (Base) In KG")
                {
                    ApplicationArea = All;
                }
                field("Lot No.GRN"; "Lot No.GRN")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date GRN"; "Expiration Date GRN")
                {
                    ApplicationArea = All;
                }
                field("Manufacturing Date GRN"; "Manufacturing Date GRN")
                {
                    ApplicationArea = All;
                }
                field("Qty. Handled In KG"; "Qty. Handled In KG")
                {
                    ApplicationArea = All;
                }
                field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
                {
                    ApplicationArea = All;
                }
                field("Damage Qty. In PCS"; "Damage Qty. In PCS")
                {
                    ApplicationArea = All;
                }
                field("Saleable Qty. In KG"; "Saleable Qty. In KG")
                {
                    ApplicationArea = All;
                }
                field("Damage Qty. In KG"; "Damage Qty. In KG")
                {
                    ApplicationArea = All;
                }
                field(FOC; FOC)
                {
                    ApplicationArea = All;
                }
                field("Gen.Prod.Post.Group"; "Gen.Prod.Post.Group")
                {
                    ApplicationArea = All;
                }
                field("Customer License No."; "Customer License No.")
                {
                    ApplicationArea = All;
                }
                field("Customer License Name"; "Customer License Name")
                {
                    ApplicationArea = All;
                }
                field("Customer License Date"; "Customer License Date")
                {
                    ApplicationArea = All;
                }
                field("Sales Category"; "Sales Category")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.1"; "Supplier Invoice No.1")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.1"; "Supplier Invoice Sr.No.1")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 1"; "Supplier Invoice Date 1")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 1"; "Gross Weight 1")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 1"; "Net Weight 1")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.2"; "Supplier Invoice No.2")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.2"; "Supplier Invoice Sr.No.2")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 2"; "Supplier Invoice Date 2")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 2"; "Gross Weight 2")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 2"; "Net Weight 2")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.3"; "Supplier Invoice No.3")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.3"; "Supplier Invoice Sr.No.3")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 3"; "Supplier Invoice Date 3")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 3"; "Gross Weight 3")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 3"; "Net Weight 3")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.4"; "Supplier Invoice No.4")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.4"; "Supplier Invoice Sr.No.4")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 4"; "Supplier Invoice Date 4")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 4"; "Gross Weight 4")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 4"; "Net Weight 4")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No."; "Supplier Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No."; "Supplier Invoice Sr.No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date"; "Supplier Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Fill Rate %"; "Fill Rate %")
                {
                    ApplicationArea = All;
                }
                field("JWL Transfer No."; "JWL Transfer No.")
                {
                    ApplicationArea = All;
                }
                field("JWL Transfer Date"; "JWL Transfer Date")
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity In KG"; "Invoiced Quantity In KG")
                {
                    ApplicationArea = All;
                }
                field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
                {
                    ApplicationArea = All;
                }
                field("Quarantine Qty In KG"; "Quarantine Qty In KG")
                {
                    ApplicationArea = All;
                }
                field("Actual Qty In PCS"; "Actual Qty In PCS")
                {
                    ApplicationArea = All;
                }
                field("Actual Qty In KG"; "Actual Qty In KG")
                {
                    ApplicationArea = All;
                }
                field("DiscountRpt Boolean"; "DiscountRpt Boolean")
                {
                    ApplicationArea = All;
                }
                field("Custom Duty Amount1"; "Custom Duty Amount1")
                {
                    ApplicationArea = All;
                }
                field("Actual Batch"; "Actual Batch")
                {
                    ApplicationArea = All;
                }
                field("Actual MFG Date"; "Actual MFG Date")
                {
                    ApplicationArea = All;
                }
                field("Actual EXP Date"; "Actual EXP Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Batch PCS"; "Actual Batch PCS")
                {
                    ApplicationArea = All;
                }
                field("Actual Batch KGS"; "Actual Batch KGS")
                {
                    ApplicationArea = All;
                }
                field("Manufacturing Date"; "Manufacturing Date")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Handle (Base) In KG"; "Qty. to Handle (Base) In KG")
                {
                    ApplicationArea = All;
                }
                field("Remainig Qty. In KG"; "Remainig Qty. In KG")
                {
                    ApplicationArea = All;
                    Caption = 'Remainig Qty. PCS';
                }
                field("PO Lot No."; "PO Lot No.")
                {
                    ApplicationArea = All;
                }
                field("PO Expiration Date"; "PO Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("PO Manufacturing Date"; "PO Manufacturing Date")
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

