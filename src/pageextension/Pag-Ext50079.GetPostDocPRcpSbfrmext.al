pageextension 50079 "Get_Post_Doc_P_Rcp_Sbfrm_ext" extends "Get Post.Doc - P.RcptLn Sbfrm"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {
        modify(Quantity)
        {
            CaptionML = ENU = 'Quantity In KG', ENN = 'Quantity';
        }
        modify("Qty. Rcd. Not Invoiced")
        {
            CaptionML = ENU = 'Qty. Rcd. Not Invoiced In KG', ENN = 'Qty. Rcd. Not Invoiced';
        }
        modify(RemainingQty)
        {
            CaptionML = ENU = 'Remaining Quantity In KG', ENN = 'Remaining Quantity';
        }
        addafter("Unit Cost (LCY)")
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

    //Unsupported feature: PropertyChange. Please convert manually.

}

