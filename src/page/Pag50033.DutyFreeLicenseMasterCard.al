page 50033 "Duty Free License Master Card"
{
    // version CCIT-Fortune

    PageType = Card;
    SourceTable = "Duty Free License Master";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("License No."; "License No.")
                {
                    ApplicationArea = All;
                }
                field("License Name"; "License Name")
                {
                    ApplicationArea = All;
                }
                field("License Date"; "License Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Total License Quantity"; "Total License Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Total License Quantity In KG';
                }
                field("Utilized License Quantity"; "Utilized License Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Utilized License Quantity In KG';
                    Editable = false;
                }
                field("Remainig License Quantity"; "Remainig License Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Remainig License Quantity In KG';
                    Editable = false;
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

