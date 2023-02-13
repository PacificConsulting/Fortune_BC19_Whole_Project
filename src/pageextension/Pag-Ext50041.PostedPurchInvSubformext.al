pageextension 50041 "Posted_Purch_Inv_Subform_ext" extends "Posted Purch. Invoice Subform"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {
        modify(Quantity)
        {
            CaptionML = ENU = 'Quantity IN KG', ENN = 'Quantity';
        }
        addafter(Description)
        {
            // field("Description 2"; "Description 2")
            // {
            //     ApplicationArea = all;
            // }
            field("Bill Of Entry No."; "Bill Of Entry No.")
            {
                ApplicationArea = all;
            }
            field("GST Reverse Charge"; "GST Reverse Charge")
            {
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
        addafter("Return Reason Code")
        {
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

