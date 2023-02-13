pageextension 50013 "Item_ledger_Entries_ext" extends "Item Ledger Entries"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    layout
    {

        modify("Expiration Date")
        {
            Visible = true;
        }
        addafter("Item No.")
        {
            field("Item Description"; "Item Description")
            {
                ApplicationArea = all;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                ApplicationArea = all;
                Visible = false;

            }
            field("Warranty Date"; "Warranty Date")
            {
                Caption = 'Manufacturing Date';
                ApplicationArea = all;
            }

        }
        addafter("Lot No.")
        {
            field("PO Lot No."; "PO Lot No.")
            {
                ApplicationArea = all;
            }
            field("PO Expiration Date"; "PO Expiration Date")
            {
                ApplicationArea = all;
            }
            field("PO Manufacturing Date"; "PO Manufacturing Date")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Custom Duty Amount1"; "Custom Duty Amount1")
            {
                ApplicationArea = all;
            }
            field("Source No."; "Source No.")
            {
                ApplicationArea = all;
            }
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                ApplicationArea = all;
                Caption = 'Saleable Qty. In KG';
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                Caption = 'Variance Qty. In KG';
                ApplicationArea = all;
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                Caption = 'Saleable Qty. In PCS';
                ApplicationArea = all;
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                Caption = 'Variance Qty. In PCS';
                ApplicationArea = all;
            }
            field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
            {
                ApplicationArea = all;
            }
            field("Quarantine Qty In KG"; "Quarantine Qty In KG")
            {
                ApplicationArea = all;
            }
            field("Actual Qty In PCS"; "Actual Qty In PCS")
            {
                ApplicationArea = all;
            }
            field("Actual Qty In KG"; "Actual Qty In KG")
            {
                ApplicationArea = all;
            }
            field("JWL BOND GRN No."; "JWL BOND GRN No.")
            {
                ApplicationArea = all;
            }
            field("JWL BOND GRN Date"; "JWL BOND GRN Date")
            {
                ApplicationArea = all;
            }
            field("JWL Transfer No."; "JWL Transfer No.")
            {
                ApplicationArea = all;
            }
            field("JWL Transfer Date"; "JWL Transfer Date")
            {
                ApplicationArea = all;
            }
            field("Gen.Prod.Post.Group"; "Gen.Prod.Post.Group")
            {
                ApplicationArea = all;
            }
            field("Permit No."; "License No.")
            {
                ApplicationArea = all;
                Caption = 'Permit No.';
            }
            field("HS Code"; "HS Code")
            {
                ApplicationArea = all;
            }
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Reserved Quantity")
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
            field("Remainig Qty. In KG"; "Remainig Qty. In KG")
            {
                Caption = 'Remainig Qty. In PCS';
                ApplicationArea = all;
            }

            field("Conversion UOM"; "Conversion UOM")
            {
                Caption = 'Conversion UOM';
            }
        }
        addafter("Completely Invoiced")
        {
            field("Customer License No."; "Customer License No.")
            {
                ApplicationArea = all;
            }
            field("Customer License Name"; "Customer License Name")
            {
                ApplicationArea = all;
            }
            field("Customer License Date"; "Customer License Date")
            {
                ApplicationArea = all;
            }
            field("Sales Category"; "Sales Category")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice No.1"; "Supplier Invoice No.1")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Sr.No.1"; "Supplier Invoice Sr.No.1")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Date 1"; "Supplier Invoice Date 1")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice No.2"; "Supplier Invoice No.2")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Sr.No.2"; "Supplier Invoice Sr.No.2")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Date 2"; "Supplier Invoice Date 2")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice No.3"; "Supplier Invoice No.3")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Sr.No.3"; "Supplier Invoice Sr.No.3")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Date 3"; "Supplier Invoice Date 3")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice No.4"; "Supplier Invoice No.4")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Sr.No.4"; "Supplier Invoice Sr.No.4")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Date 4"; "Supplier Invoice Date 4")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice No."; "Supplier Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Sr.No."; "Supplier Invoice Sr.No.")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Date"; "Supplier Invoice Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Order Line No.")
        {
            field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
            {
                ApplicationArea = all;
            }
            field("In-Bond BOE Date"; "In-Bond BOE Date")
            {
                ApplicationArea = all;
            }
            field("Bond Number"; "Bond Number")
            {
                ApplicationArea = all;
            }
            field("Bond Sr.No."; "Bond Sr.No.")
            {
                ApplicationArea = all;
            }
            field("Bond Date"; "Bond Date")
            {
                ApplicationArea = all;
            }
            field("BL/AWB No."; "BL/AWB No.")
            {
                ApplicationArea = all;
            }



            field("Actual Batch"; "Actual Batch")
            {
                ApplicationArea = all;
            }
            field("Actual MFG Date"; "Actual MFG Date")
            {
                ApplicationArea = all;
            }
            field("Actual EXP Date"; "Actual EXP Date")
            {
                ApplicationArea = all;
            }
            field("Actual Batch PCS"; "Actual Batch PCS")
            {
                ApplicationArea = all;
            }
            field("Actual Batch KGS"; "Actual Batch KGS")
            {
                ApplicationArea = all;
            }
        }

    }


    // trigger OnAfterGetRecord()
    // var
    // RecILE:Record 32;
    // begin
    //     RecILE.Reset();
    //     RecILE.SetRange();
    // end;
}

