pageextension 50089 "Purch_Return_Order_Subf_ext" extends "Purchase Return Order Subform"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992

    layout
    {

        //Unsupported feature: Change Editable on "Control 6". Please convert manually.
        modify("GST Group Code")
        {
            Editable = true;
            Enabled = true;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
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
        addafter("Line Discount %")
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                ApplicationArea = all;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
            }
        }
    }
}

