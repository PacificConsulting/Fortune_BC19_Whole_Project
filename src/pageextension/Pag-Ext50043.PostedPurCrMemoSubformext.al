pageextension 50043 "Posted_Pur_Cr_Memo_Subform_ext" extends "Posted Purch. Cr. Memo Subform"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {
        modify(Quantity)
        {
            CaptionML = ENU = 'Quantity In KG', ENN = 'Quantity';
        }
        addafter("Line Discount Amount")
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                Caption = 'Saleable Qty. In KG';
                ApplicationArea = all;
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                Caption = 'Damage Qty. In KG';
                ApplicationArea = all;
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                Caption = 'Saleable Qty. In PCS';
                ApplicationArea = all;
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                Caption = 'Damage Qty. In PCS';
                ApplicationArea = all;
            }
            field("BOE Qty.In PCS"; "BOE Qty.In PCS")
            {
                Caption = 'BOE Qty.In KG';
                ApplicationArea = all;
            }
            field("BOE Qty.In KG"; "BOE Qty.In KG")
            {
                Caption = 'BOE Qty.In PCS';
                ApplicationArea = all;
            }
        }
    }
}

