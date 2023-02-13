pageextension 50055 "Phys_Inventory_Journal_ext" extends "Phys. Inventory Journal"
{
    // version NAVW19.00.00.45778

    layout
    {
        modify(Quantity)
        {
            Editable = false;
            //Unsupported feature: Change Editable on "Control 12". Please convert manually.

            CaptionML = ENU = 'Quantity In KG', ENN = 'Quantity';
        }
        addafter("Posting Date")
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document Date")
        {
            field("Phys. Inventory"; "Phys. Inventory")
            {
                Enabled = false;
                ApplicationArea = all;
            }
        }
        addafter("Document No.")
        {
            field("Lot No."; "Lot No.")
            {
                Editable = true;
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
        }
    }
}

