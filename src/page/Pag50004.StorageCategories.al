page 50004 "Storage Categories"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Storage Categories";

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

