report 50059 "Collection Effectiveness Index"
{
    // version CCIT-Fortune

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.", "Shortcut Dimension 1 Code";

            trigger OnAfterGetRecord();
            begin
                Sr_No += 1;
                HideLine := TRUE;

                RecCust.RESET;
                IF RecCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                    CustName := RecCust.Name;
                    Contact := RecCust.Contact;
                    ContactNo := RecCust."Phone No.";
                    EMail_ID := RecCust."E-Mail";
                    CustGroup := RecCust."Customer Disc. Group";
                    CustPostGroup := RecCust."Customer Posting Group";
                    GenBusPostGroup := RecCust."Gen. Bus. Posting Group";
                    VerticalSubCategory := RecCust."Vertical Sub Category";
                    CustBusFormatOutletname := RecCust."Business Format / Outlet Name";
                    CreditPeriod := RecCust."Payment Terms Code";
                    CreditLimit := RecCust."Credit Limit (LCY)";
                    SalesPersonCode := RecCust."Salesperson Code";
                    //CollectionPersonCode := RecCust."Responsible Collection Person";
                END;
                //MESSAGE('%1',CustName);
                SalesPersonName := '';
                IF RecSalesPerson.GET(SalesPersonCode) THEN
                    SalesPersonName := RecSalesPerson.Name;

                PaymentReciptDate := 0D;
                RecCustLedgerEntry.RESET;
                RecCustLedgerEntry.SETRANGE(RecCustLedgerEntry."Document No.", "Sales Invoice Header"."No.");
                IF RecCustLedgerEntry.FINDFIRST THEN BEGIN
                    RecCustLedgerEntry1.RESET;
                    RecCustLedgerEntry1.SETRANGE(RecCustLedgerEntry1."Closed by Entry No.", RecCustLedgerEntry."Entry No.");
                    IF RecCustLedgerEntry1.FINDLAST THEN
                        PaymentReciptDate := RecCustLedgerEntry1."Closed at Date";
                END;

                OutstandingBal := 0;
                RecCust.RESET;
                RecCust.SETRANGE(RecCust."No.", "Sales Invoice Header"."Sell-to Customer No.");
                IF RecCust.FINDFIRST THEN BEGIN
                    //RecCust.CALCFIELDS("Balance (LCY)"); //PCPL/MIG/NSW Filed not Exist in BC18
                    OutstandingBal := RecCust."Balance (LCY)";
                END;

                Doctype := '';
                RecCustLedgerEntry.RESET;
                RecCustLedgerEntry.SETRANGE(RecCustLedgerEntry."Document No.", "Sales Invoice Header"."No.");
                IF RecCustLedgerEntry.FINDFIRST THEN
                    Doctype := FORMAT(RecCustLedgerEntry."Document Type");


                DaysPostDueDate := TODAY - "Sales Invoice Header"."Due Date";

                RecCustLedgerEntry.RESET;
                RecCustLedgerEntry.SETRANGE(RecCustLedgerEntry."Document No.", "Sales Invoice Header"."No.");
                IF RecCustLedgerEntry.FINDFIRST THEN BEGIN
                    RecCustLedgerEntry.CALCFIELDS("Remaining Amount");
                    IF RecCustLedgerEntry."Remaining Amount" = 0 THEN
                        CurrReport.SKIP;
                END;


                MakeExcelDataBody;
            end;

            trigger OnPostDataItem();
            begin
                MakeExcelTotal;
            end;

            trigger OnPreDataItem();
            begin
                DaysPostDueDate := 0;
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
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        Sr_No := 0;
        MakeExcelDataHeader;
    end;

    var
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        RecCust: Record 18;
        CustName: Text[50];
        Contact: Text[50];
        ContactNo: Text[30];
        EMail_ID: Text[80];
        CustPostGroup: Code[10];
        GenBusPostGroup: Code[10];
        VerticalSubCategory: Code[50];
        CustBusFormatOutletname: Text[100];
        CreditPeriod: Code[10];
        CreditLimit: Decimal;
        SalesPersonCode: Code[10];
        CollectionPersonCode: Code[10];
        CustGroup: Code[20];
        RecCustLedgerEntry: Record 21;
        PaymentReciptDate: Date;
        RecCustLedgerEntry1: Record 21;
        OutstandingBal: Decimal;
        HideLine: Boolean;
        Doctype: Code[20];
        RecSalesPerson: Record 13;
        SalesPersonName: Text[200];
        DaysPostDueDate: Integer;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\COllection Effectiveness Index.xlsx', 'COllection Effectiveness Index ', 'COllection Effectiveness Index', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\COllection Effectiveness Index.xlsx', 'COllection Effectiveness Index ', 'COllection Effectiveness Index', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('COllection Effectiveness Index', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        //ExcelBuf.AddColumn('Zone',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sr No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Name Of Contact Person',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Contact No',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Email-ID',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Bus. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertival Sub Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Business Format/Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Credit Period', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Credit Limit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Due Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Receipt Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days Post Due Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outstanding Balance', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;

        //ExcelBuf.AddColumn("Sales Invoice Header"."Shortcut Dimension 1 Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Sr_No, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(Contact,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(ContactNo,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(EMail_ID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(CustGroup,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustPostGroup, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GenBusPostGroup, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VerticalSubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustBusFormatOutletname, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CreditPeriod, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CreditLimit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesPersonCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Doctype, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Invoice Header"."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(PaymentReciptDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(DaysPostDueDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(OutstandingBal, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelTotal();
    begin
        ExcelBuf.NewRow;
        /*
        ExcelBuf.AddColumn('Total',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        */

    end;
}

