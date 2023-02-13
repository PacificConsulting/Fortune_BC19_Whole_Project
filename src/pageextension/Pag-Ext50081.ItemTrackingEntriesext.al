pageextension 50081 "Item_Tracking_Entries_ext" extends "Item Tracking Entries"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {
        addafter("Expiration Date")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                ApplicationArea = all;
            }
        }
    }


}

