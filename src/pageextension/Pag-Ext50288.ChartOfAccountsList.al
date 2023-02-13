pageextension 50288 ChartOfAccountsList extends "Chart of Accounts"
{
    layout
    {
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Balance at Date")
        {
            Visible = true;
        }






    }



    // Add changes to page layout here


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
