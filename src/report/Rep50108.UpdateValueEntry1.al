report 50108 "Update Value Entry1"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry Type" = FILTER(Sale));

            trigger OnAfterGetRecord();
            begin
                RecValueEntry.RESET;
                RecValueEntry.SETRANGE(RecValueEntry."Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                IF RecValueEntry.FINDFIRST THEN BEGIN
                    CurrReport.SKIP;
                END ELSE BEGIN
                    RecValueEntry1.RESET;
                    IF RecValueEntry1.FINDLAST THEN
                        TempEntryNo := RecValueEntry1."Entry No."
                    ELSE
                        TempEntryNo := 1;

                    RecValueEntry2.INIT;
                    RecValueEntry2."Entry No." := TempEntryNo + 1;
                    RecValueEntry2."Item Ledger Entry Type" := RecValueEntry2."Item Ledger Entry Type"::Sale;
                    RecValueEntry2."Item Ledger Entry No." := "Item Ledger Entry"."Entry No.";
                    RecValueEntry2.INSERT;
                END;
                //ERROR('%1',TempEntryNo);


            end;

            trigger OnPostDataItem();
            begin
                MESSAGE('Records updated...');
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
        RecValueEntry: Record 5802;
        RecValueEntry1: Record 5802;
        TempEntryNo: Integer;
        RecValueEntry2: Record 5802;
}

