report 50118 "Update Ile2"
{
    // version Vikas

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Update Ile2.rdl';
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
                diffr := 0;
                ILE.RESET();
                ILE.SETFILTER("Location Code", "Item Ledger Entry"."Location Code");
                ILE.SETFILTER("Item No.", "Item Ledger Entry"."Item No.");
                ILE.SETFILTER("Lot No.", "Item Ledger Entry"."Lot No.");
                ILE.SETFILTER("Posting Date", '<=%1', 20201031D); //103120D
                IF ILE.FIND('-') THEN
                    REPEAT
                        diffr := diffr + (ILE.Quantity - ILE."Remaining Quantity");
                    // MESSAGE('ff');
                    UNTIL ILE.NEXT = 0;

                IF diffr <> 0 THEN BEGIN
                    ILE2.RESET();
                    ILE2.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                    ILE2.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                    ILE2.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                    ILE2.SETFILTER("Posting Date", '<=%1', 20201031D); //103120D
                    IF ILE2.FIND('-') THEN
                        REPEAT
                            ILE2.Quantity := 0;
                            ILE2."Remaining Quantity" := 0;
                            ILE2.MODIFY;
                        //  MESSAGE('a');
                        UNTIL ILE2.NEXT = 0;
                END;
                //MESSAGE('a');
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
        MESSAGE('Data updated successfully');
    end;

    var
        ILE: Record 32;
        diffr: Decimal;
        ILE2: Record 32;
}

