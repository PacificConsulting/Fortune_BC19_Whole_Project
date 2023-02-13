pageextension 50035 "Posted_Sales_Inv_Sub_ext" extends "Posted Sales Invoice Subform"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    layout
    {


        modify("Line Discount Amount")
        {
            Editable = false;

        }
        modify("Allow Invoice Disc.")
        {
            Editable = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = false;
        }

        addafter("No.")
        {

            field("Posting Date"; "Posting Date")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
            field(Exempted; Exempted)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Variant Code")
        {
            field("Customer Price Group"; "Customer Price Group")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                Editable = false;
                ApplicationArea = all;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Rate In PCS"; "Rate In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Amount In PCS"; "Amount In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Line Discount %")
        {
            field("GST Group Code"; "GST Group Code")
            {
                Editable = false;
            }
            field("GST Group Type"; "GST Group Type")
            {
                Editable = false;
            }

            field("HSN/SAC Code"; "HSN/SAC Code")
            {
                Editable = false;
            }
            field("GST Jurisdiction Type"; "GST Jurisdiction Type")
            {
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                Editable = false;
            }
        }
    }



}

