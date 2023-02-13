pageextension 50084 "Posted_Item_Trac_Lines_ext" extends "Posted Item Tracking Lines"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {
        modify("Warranty Date")
        {
            Caption = 'Manufacturing Date';
            Visible = true;
            ApplicationArea = all;
        }
        addafter("Expiration Date")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                ApplicationArea = all;
                Visible = false;
            }

        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

