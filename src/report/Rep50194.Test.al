report 50194 testreport
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            column(No_; "Sales Header"."No.")
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }


    var
        myInt: Integer;
}