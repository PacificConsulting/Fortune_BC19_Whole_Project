pageextension 50037 "Posted_SalesCr_Memo_Subfo_ext" extends "Posted Sales Cr. Memo Subform"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {

        addafter("No.")
        {
            field("Item code"; "Item code")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Item Category Code"; "Item Category Code")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
            field("Special Price"; "Special Price")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Customer Price Group"; "Customer Price Group")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                Editable = false;
                ApplicationArea = all;
            }
        }

    }

}

