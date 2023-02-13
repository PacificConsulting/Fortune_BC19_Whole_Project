page 50043 "User Branch"
{
    PageType = List;
    SourceTable = "User Branch Table";
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
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

