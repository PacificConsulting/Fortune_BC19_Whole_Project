pageextension 50082 "Item_Tracking_List_ext" extends "Item Tracking List"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {
        addafter("Expiration Date")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

