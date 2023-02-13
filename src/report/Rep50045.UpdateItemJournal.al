report 50045 "Update Item Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Item Journal.rdl';
    Permissions = TableData 32 = rimd;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Manufacturing Date" = FILTER(''),
                                      "Expiration Date" = FILTER(''));

            trigger OnAfterGetRecord();
            begin
                //"Reservation Entry".
                // ILE.RESET();
                // ILE.SETRANGE("Order No.","Reservation Entry"."Source ID");
                // ILE.SETRANGE("Item No.","Reservation Entry"."Item No.");
                // IF ILE.FIND('-') THEN BEGIN
                //  "Reservation Entry"."Lot No." := 'ERP-ERROR';//

                "Item Ledger Entry"."Manufacturing Date" := 20190925D; //092519D
                "Item Ledger Entry"."Expiration Date" := 20200331D;  //033120D
                "Item Ledger Entry".MODIFY;
                //END;
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
        MESSAGE('Updated Successfully');
    end;

    var
        ILE: Record 32;
}

