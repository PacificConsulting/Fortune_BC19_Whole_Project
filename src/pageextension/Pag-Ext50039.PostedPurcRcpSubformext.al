pageextension 50039 "Posted_Purc_Rcp_Subform_ext" extends "Posted Purchase Rcpt. Subform"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        addafter("Bin Code")
        {
            field("Bill Of Entry No."; "Bill Of Entry No.")
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
            field("Storage Categories"; "Storage Categories")
            {
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
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                Caption = 'Saleable Qty. In KG';
                ApplicationArea = all;
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                Caption = 'Variance Qty. In PCS';
                ApplicationArea = all;
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                Caption = 'Saleable Qty. In PCS';
                ApplicationArea = all;
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                Caption = 'Variance Qty. In KG';
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("&Undo Receipt")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-SG
                PostInvPutAwayLine.RESET;
                PostInvPutAwayLine.SETRANGE(PostInvPutAwayLine."Source No.", "Order No.");
                PostInvPutAwayLine.SETRANGE(PostInvPutAwayLine."Source Line No.", "Order Line No.");
                IF PostInvPutAwayLine.FINDSET THEN
                    REPEAT
                        PostInvPutAwayLine.DELETE;
                    UNTIL PostInvPutAwayLine.NEXT = 0;

                WarehouseActLine.RESET;
                WarehouseActLine.SETRANGE(WarehouseActLine."Source No.", "Order No.");
                WarehouseActLine.SETRANGE(WarehouseActLine."Source Line No.", "Order Line No.");
                IF WarehouseActLine.FINDSET THEN
                    REPEAT
                        WarehouseActLine.DELETE;
                    UNTIL WarehouseActLine.NEXT = 0;
                //CCIT-SG

            end;
        }


    }

    var
        PostInvPutAwayLine: Record 7341;
        WarehouseActLine: Record 5767;



}

