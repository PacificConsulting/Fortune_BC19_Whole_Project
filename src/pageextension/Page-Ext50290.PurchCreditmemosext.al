pageextension 50290 Purchase_Cr_Memos_ext extends "Purchase Credit Memos"
{
    layout
    {
        addafter("Location Code")
        {
            field("Created User"; "Created User")
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