pageextension 50002 "Customer_price_group_ext" extends "Customer Price Groups"
{
    // version NAVW17.10
    layout
    {

        addafter("Allow Line Disc.")
        {
            // field("Location Code"; "Location Code")
            // {
            //     ApplicationArea = all;
            // }
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
            }
        }
    }
}

