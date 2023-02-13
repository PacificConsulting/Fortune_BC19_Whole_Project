page 50020 "Vertical Category"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Vertical Category";

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
            }
        }
    }

    actions
    {
    }
}

