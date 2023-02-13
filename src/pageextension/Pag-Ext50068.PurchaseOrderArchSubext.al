pageextension 50068 "Purchase_Order_Arch_Sub_ext" extends "Purchase Order Archive Subform"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {
        modify(Quantity)
        {
            CaptionML = ENU = 'Quantity In KG', ENN = 'Quantity';
        }
        modify("Qty. to Receive")
        {
            CaptionML = ENU = 'Qty. to Receive In KG', ENN = 'Qty. to Receive';
        }
        modify("Quantity Received")
        {
            CaptionML = ENU = 'Quantity Received In KG', ENN = 'Quantity Received';
        }
        modify("Qty. to Invoice")
        {
            CaptionML = ENU = 'Qty. to Invoice In KG', ENN = 'Qty. to Invoice';
        }
        modify("Quantity Invoiced")
        {
            CaptionML = ENU = 'Quantity Invoiced In KG', ENN = 'Quantity Invoiced';
        }
        addafter("Requested Receipt Date")
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
                Caption = 'Qty. to Invoice In PCS';
                ApplicationArea = all;
            }
            field("Qty. to Receive In KG"; "Qty. to Receive In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. to Receive In PCS';
            }
            field("HS Code"; "HS Code")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

