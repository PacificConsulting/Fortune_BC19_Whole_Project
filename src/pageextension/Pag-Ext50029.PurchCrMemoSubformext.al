pageextension 50029 "Purch_Cr_Memo_Subform_ext" extends "Purch. Cr. Memo Subform"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992

    layout
    {
        modify("GST Group Code")
        {
            Editable = true;
            Enabled = true;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("Qty. to Invoice"; "Qty. to Invoice")
            {
                ApplicationArea = all;
            }
            field("Qty. to Receive"; "Qty. to Receive")
            {
                ApplicationArea = all;
            }
            // field("HSN/SAC Code"; "HSN/SAC Code")
            // {
            //     ApplicationArea = all;
            //     Editable = true;
            //     TableRelation = "HSN/SAC".Code where("GST Group Code" = field("GST Group Code"));
            // }
        }

        addafter("Job Line Disc. Amount (LCY)")
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'Quantity In PCS';
            }
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                ApplicationArea = all;
                Caption = 'Saleable Qty. In KG';
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                ApplicationArea = all;
                Caption = 'Damage Qty. In KG';
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                ApplicationArea = all;
                Caption = 'Saleable Qty. In PCS';
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                ApplicationArea = all;
                Caption = 'Damage Qty. In PCS';
            }
            field("BOE Qty.In PCS"; "BOE Qty.In PCS")
            {
                ApplicationArea = all;
                Caption = 'BOE Qty.In KG';
            }
            field("BOE Qty.In KG"; "BOE Qty.In KG")
            {
                ApplicationArea = all;
                Caption = 'BOE Qty.In PCS';
            }
        }
    }

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

