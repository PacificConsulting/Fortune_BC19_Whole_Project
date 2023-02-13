pageextension 50149 MyExtension extends "TCS Nature Of Collections"
{
    layout
    {
        addafter(Description)
        {
            field(eTCS; eTCS)
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