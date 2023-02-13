report 50119 "Detail GST buffer"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Detail GST buffer.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Detailed GST Entry Buffer"; "Detailed GST Entry Buffer")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending)
                                WHERE("Transaction Type" = FILTER(Transfer));
            column(Doc; "Document No.")
            {
            }
            column(Line; "Line No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                TransferLine.RESET;
                TransferLine.SETRANGE("Document No.", "Document No.");
                TransferLine.SETRANGE("Line No.", "Line No.");
                IF TransferLine.FINDFIRST THEN
                    CurrReport.SKIP;
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

    var
        TransferLine: Record 5741;
}

