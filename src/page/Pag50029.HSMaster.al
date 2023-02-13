page 50029 "HS Master"
{
    // version CCIT-Fortune

    PageType = Card;
    SourceTable = "HS Code Master";

    layout
    {
        area(content)
        {
            group(General)
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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Item Code"; "Item Code")
                {
                    ApplicationArea = All;
                    Visible = true;

                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = All;
                    Visible = true;
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

