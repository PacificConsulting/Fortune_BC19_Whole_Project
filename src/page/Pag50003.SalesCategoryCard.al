page 50003 "Sales Category Card"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Sales Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = all;
                }
                field(Name; Name)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

