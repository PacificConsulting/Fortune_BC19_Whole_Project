page 50018 "Port Of Destination-Air"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = 50018;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code;Code)
                {
                    ApplicationArea = All;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
                field("Port Of Loading-Air";"Port Of Loading-Air")
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

