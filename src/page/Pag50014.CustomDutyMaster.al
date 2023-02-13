page 50014 "Custom Duty Master"
{
    PageType = List;
    Permissions = TableData 50014 = rimd;
    SourceTable = "Custom Duty Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Custom Duty %"; "Custom Duty %")
                {
                    ApplicationArea = All;
                }
                field("Surcharge Applicable"; "Surcharge Applicable")
                {
                    ApplicationArea = All;
                }
                field("Surcharge %"; "Surcharge %")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Name"; "Item Name")
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

