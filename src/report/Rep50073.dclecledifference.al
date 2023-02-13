report 50073 "dcle-cle difference"
{
    // version rdk to be deleted

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/dcle-cle difference.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(DCLE; "Detailed Cust. Ledg. Entry")
        {

            trigger OnAfterGetRecord();
            begin
                IF NOT CLE.GET(DCLE."Cust. Ledger Entry No.") THEN BEGIN
                    diff.INIT;
                    diff.DCLE := DCLE."Entry No.";
                    diff.CLE := DCLE."Cust. Ledger Entry No.";
                    diff."cust code" := DCLE."Customer No.";
                    IF cust.GET(diff."cust code") THEN
                        diff."cust name" := cust.Name;
                    diff."Doc no." := DCLE."Document No.";
                    diff."Doc date" := DCLE."Posting Date";
                    diff."Doc Amt" := DCLE.Amount;
                    diff.INSERT;
                END;
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
        CLE: Record 21;
        diff: Record 50035;
        cust: Record 18;
}

