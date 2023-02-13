pageextension 50291 GetPurchRecptLine_Ext extends "Get Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'Quantity In PCS';
            }

        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}