page 50030 "HS Master List"
{
    // version CCIT-Fortune

    CardPageID = "HS Master";
    Editable = false;
    PageType = List;
    SourceTable = "HS Code Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Permit No."; "License Code")
                {
                    ApplicationArea = All;
                }
                field("HS Code"; "HS Code")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name"; "Supplier Name")
                {
                    ApplicationArea = All;
                }
                field("Item Code"; "Item Code")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Total Quantity"; "Total Quantity")
                {
                    ApplicationArea = All;
                }
                field("Used Quantity"; "Used Quantity")
                {
                    ApplicationArea = All;
                }
                field("Avilable Quantity"; "Avilable Quantity")
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

