page 50041 "Branch Master List"
{
    // version CCIT-Fortune

    CardPageID = "Branch Master";
    Editable = false;
    PageType = List;
    SourceTable = "Branch Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

