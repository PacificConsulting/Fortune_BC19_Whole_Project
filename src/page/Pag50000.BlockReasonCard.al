page 50000 "Block Reason Card"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Block Reason Code";

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
                field(Description; Description)
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

