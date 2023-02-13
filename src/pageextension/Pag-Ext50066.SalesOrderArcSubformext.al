pageextension 50066 "Sales_Order_Arc_Subform_ext" extends "Sales Order Archive Subform"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    layout
    {

        addafter("Location Code")
        {
            field("Customer price Group"; "Price Group Code")
            {
                CaptionML = ENU = 'Customer price Group',
                            ENN = 'Price Group Code';
                ApplicationArea = all;
            }

        }
        addafter("Quantity Invoiced")
        {
            field("License No."; "License No.")
            {
                ApplicationArea = all;
            }
            field(Weight; Weight)
            {
                ApplicationArea = all;
            }
            field("Conversion Qty"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'Quantity In PCS';
            }
            field("Quarantine Qty"; "Quarantine Qty")
            {
                ApplicationArea = all;
            }
            field("Saleable Qty"; "Saleable Qty")
            {
                ApplicationArea = all;
            }
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
            }
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
            }
            field("Qty. to Invoice In KG"; "Qty. to Invoice In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. to Invoice In PCS';
            }
            field("Qty. to Ship In KG"; "Qty. to Ship In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. to Ship In PCS';
            }
            field("GST Group Code"; "GST Group Code")
            {
                ApplicationArea = all;
            }
            field("GST Group Type"; "GST Group Type")
            {
                ApplicationArea = all;
            }

            field("HSN/SAC Code"; "HSN/SAC Code")
            {
                ApplicationArea = all;
            }
            field("GST Jurisdiction Type"; "GST Jurisdiction Type")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

