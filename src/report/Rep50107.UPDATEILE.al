report 50107 "UPDATE ILE"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/UPDATE ILE.rdl';
    Permissions = TableData 32 = rimd;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Posting Date" = FILTER(<= '10/31/20'));

            trigger OnAfterGetRecord();
            begin
                IF Location.GET("Item Ledger Entry"."Location Code") THEN BEGIN
                    IF Location."Use As In-Transit" = TRUE THEN BEGIN

                        //  MESSAGE('%1,Qty-%1,Rem-%2',"Item Ledger Entry"."Entry No.","Item Ledger Entry".Quantity,"Item Ledger Entry"."Remaining Quantity");
                        "Item Ledger Entry".VALIDATE(Quantity, 0);
                        "Item Ledger Entry".VALIDATE("Remaining Quantity", 0);
                        "Item Ledger Entry".MODIFY;
                    END;
                END;
            end;

            trigger OnPreDataItem();
            begin
                Cnt := 0
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

    trigger OnPostReport();
    begin
        MESSAGE('Updated Succesfully...');
    end;

    var
        Location: Record 14;
        Cnt: Integer;
}

