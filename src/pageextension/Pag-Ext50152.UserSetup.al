pageextension 50152 User_Setup_ext extends "User Setup"
{
    layout
    {
        addafter(Email)
        {
            field("Customer Permission"; "Customer Permission")
            {
                ApplicationArea = all;
            }
            field("Item Card Permission"; "Item Card Permission")
            {
                ApplicationArea = all;

            }
            field("Sales Price Permission"; "Sales Price Permission")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}