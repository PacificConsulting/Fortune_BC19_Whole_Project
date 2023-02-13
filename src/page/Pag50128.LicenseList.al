page 50128 "License List"
{
    // version CCIT-Fortune

    CardPageID = "License Master";
    Editable = false;
    PageType = List;
    SourceTable = "License Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Permit No."; "Permit No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Permit Validity In Days"; "Permit Validity")
                {
                    ApplicationArea = All;
                    Caption = 'Permit Validity In Days';
                }
                field("Permit Start Date"; "Permit Start Date")
                {
                    ApplicationArea = All;
                }
                field("Permit Expiry Date"; "Permit Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Product Category"; "Product Category")
                {
                    ApplicationArea = All;
                }
                field("Country Code"; "Country Code")
                {
                    ApplicationArea = All;
                }
                field("Country Name"; "Country Name")
                {
                    ApplicationArea = All;
                }
                field("HS Code"; "HS Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Permit Period"; "Permit Period")
                {
                    ApplicationArea = All;
                }
                field("Next Permit Application Date"; "Next Permit Application Date")
                {
                    ApplicationArea = All;
                }
                field("Application Sent On. Date"; "Application Sent On. Date")
                {
                    ApplicationArea = All;
                }
                field("New Permit Application No."; "New Permit Application No.")
                {
                    ApplicationArea = All;
                }
                field("New Permit Application Date"; "New Permit Application Date")
                {
                    ApplicationArea = All;
                }
                field("New Permit Appl Qty In KG"; "New Permit Appl Qty In KG")
                {
                    ApplicationArea = All;
                }
                field("License Quantity"; "License Quantity")
                {
                    ApplicationArea = All;
                }
                field("Utilized License Quantity"; "Utilized License Quantity")
                {
                    ApplicationArea = All;
                }
                field("Balance Quantity"; "Balance Quantity")
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

