page 50067 "PDC Cheques"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "PDC Cheques";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cust.Code"; "Cust.Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    ApplicationArea = All;
                }
                field("Cheque Amount"; "Cheque Amount")
                {
                    ApplicationArea = All;
                }
                field(Open; Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field(Location; "Cust.Location")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales Person"; Salesperson)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

