pageextension 50087 "Sales_Return_Order_Sub_ext" extends "Sales Return Order Subform"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    layout
    {
        modify("GST Group Code")
        {
            Editable = true;
            Enabled = true;
        }
        modify(Description)
        {
            Editable = false;
        }
        modify("Description 2")
        {
            Editable = false;
        }

        modify("Tax Group Code")
        {
            Editable = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        modify("Unit Price Incl. of Tax")
        {
            Editable = false;
        }

        addafter(Description)
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
            }
            field("Customer Price Group"; "Customer Price Group")
            {
                ApplicationArea = all;
            }

        }
        addafter(Quantity)
        {
            field("Quarantine Qty In KG"; "Quarantine Qty In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Variance Qty. In KG"; "Variance Qty. In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Salable Qty. In KG"; "Salable Qty. In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Variance Qty. In PCS"; "Variance Qty. In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Salable Qty. In PCS"; "Salable Qty. In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Conversion Qty"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'Quantity In PCS';
            }
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Rate In PCS"; "Rate In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Qty. to Ship"; "Qty. to Ship")
            {
                ApplicationArea = all;
                Caption = 'Qty. to Ship In KG';
            }
            field("Quantity Shipped"; "Quantity Shipped")
            {
                ApplicationArea = all;
                Caption = 'Quantity Shipped In KG';
                Editable = false;
            }
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                ApplicationArea = all;
                Caption = 'Outstanding Quantity In KG';
                Editable = false;
            }
            field("Qty. to Invoice In KG"; "Qty. to Invoice In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. to Invoice In PCS';
                Editable = false;
            }
            field("Qty. to Ship In KG"; "Qty. to Ship In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. to Ship In PCS';
            }
            field("Quantity Shipped In KG"; "Quantity Shipped In KG")
            {
                ApplicationArea = all;
                Caption = 'Quantity Shipped In PCS';
            }
            field("Quantity Invoiced In KG"; "Quantity Invoiced In KG")
            {
                ApplicationArea = all;
                Caption = 'Quantity Invoiced In PCS';
                Editable = false;
            }
            field("Outstanding Quantity In KG"; "Outstanding Quantity In KG")
            {
                Caption = 'Outstanding Quantity In PCS';
                Editable = false;
                ApplicationArea = all;

            }
        }
    }
}
