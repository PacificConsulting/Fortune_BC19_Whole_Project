page 50021 "Vertical Sub Category"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Vertical Sub Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vertical Category Code"; "Vertical Category Code")
                {
                    ApplicationArea = All;
                }
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

