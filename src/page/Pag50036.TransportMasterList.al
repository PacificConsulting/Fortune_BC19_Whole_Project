page 50036 "Transport Master List"
{
    // version CCIT-Fortune

    CardPageID = "Transport Master Card";
    Editable = false;
    PageType = List;
    SourceTable = "Transport Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field(Address2; Address2)
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field(County; County)
                {
                    ApplicationArea = All;
                }
                field("State Code"; "State Code")
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

