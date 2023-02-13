report 50106 "ILE Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/ILE Update.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Document Type" = FILTER("Transfer Receipt"),
                                      "Posting Date" = FILTER(> '04/01/20'));

            trigger OnAfterGetRecord();
            begin
                "Item Ledger Entry".Positive := TRUE;
                "Item Ledger Entry".MODIFY;
            end;
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

