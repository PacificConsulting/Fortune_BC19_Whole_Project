pageextension 50233 Accounting_Period_ext extends "Accounting Periods"
{
    layout
    {
        modify(Closed)
        {
            Editable = true;
        }
        modify("Date Locked")
        {
            Editable = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}