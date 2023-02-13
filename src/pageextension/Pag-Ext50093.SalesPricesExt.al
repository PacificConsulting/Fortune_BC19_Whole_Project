pageextension 50093 "Sales_Prices_Ext" extends "Sales Prices"
{
    // version NAVW19.00.00.48628,NAVIN9.00.00.48628,CCIT-Fortune

    layout
    {
        modify("Unit Price")
        {

            //Unsupported feature: Change SourceExpr on "Control 6". Please convert manually.

            CaptionML = ENU = 'Unit Price Per KG', ENN = 'Unit Price';
        }
        addafter("Variant Code")
        {
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
            }
            field("Quantity in KG"; "Quantity in KG")
            {
                ApplicationArea = all;
            }
            field("Quantity in PCS"; "Quantity in PCS")
            {
                ApplicationArea = all;
            }
        }
        addafter("Price Inclusive of Tax")
        {
            field(Block; Block)
            {
                ApplicationArea = all;
            }
        }
        addafter("Allow Line Disc.")
        {
            field("Location Code"; "Location Code")
            {
                ApplicationArea = all;
            }
            field("Customer Code"; "Customer Code")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
            }
            field("List Price"; "List Price")
            {
                ApplicationArea = all;
            }
            field("Conversion Price Per PCS"; "Conversion Price Per PCS")
            {
                Caption = 'Unit Price(PCS/CASE)';
                ApplicationArea = all;
            }
            field("Ref. Expiry Date"; "Ref. Expiry Date")
            {
                ApplicationArea = all;
            }
        }
    }

}

