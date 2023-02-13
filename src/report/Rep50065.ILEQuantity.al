report 50065 "ILE Quantity"
{
    // version CCIT-Vikas

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/ILE Quantity.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            column(Location; "Item Ledger Entry"."Location Code")
            {
            }
            column(Quantity; "Item Ledger Entry".Quantity)
            {
            }
            column(RemQuantity; "Item Ledger Entry"."Remaining Quantity")
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

