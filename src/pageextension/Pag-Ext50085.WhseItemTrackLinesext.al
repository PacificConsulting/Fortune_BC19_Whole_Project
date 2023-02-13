pageextension 50085 "Whse_Item_Track_Lines_ext" extends "Whse. Item Tracking Lines"
{
    // version NAVW19.00.00.46621,CCIT-Fortune

    layout
    {
        modify("Warranty Date")
        {
            Visible = true;
            Caption = 'Manufacturing Date';
            ApplicationArea = all;
        }
        addafter("Expiration Date")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                ApplicationArea = all;
                Visible = false;

            }
            field("New Manufacturing Date"; "New Manufacturing Date")
            {
                ApplicationArea = all;
            }
        }
    }

}

