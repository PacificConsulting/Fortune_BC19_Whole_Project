report 50003 "Bnk Acc LEd Ent Status update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Bnk Acc LEd Ent Status update.rdl';
    Permissions = TableData 271 = rm;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(BALE; "Bank Account Ledger Entry")
        {
            DataItemTableView = WHERE("Bank Account No." = FILTER('HDFC6435'));

            trigger OnAfterGetRecord();
            begin
                IF BALE."Statement Status" = BALE."Statement Status"::"Bank Acc. Entry Applied" THEN
                    IF BALE.Open THEN BEGIN
                        BALE.Open := FALSE;
                        BALE."Statement Status" := BALE."Statement Status"::Closed;
                        BALE.MODIFY;
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
}

