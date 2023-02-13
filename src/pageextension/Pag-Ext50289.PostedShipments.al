pageextension 50289 "Posted_Return_Shipments_ext" extends "Posted Return Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
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