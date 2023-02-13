pageextension 50103 "CEO_President_role_ext" extends "CEO and President Role Center"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    actions
    {
        addafter(Customers)
        {
            action("Item Ledger Entry")
            {
                RunObject = Page 50008;
                ApplicationArea = all;
            }
        }
    }
}

