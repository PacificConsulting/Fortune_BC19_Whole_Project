page 50001 "Brand Name Card"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Brand Name";

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

