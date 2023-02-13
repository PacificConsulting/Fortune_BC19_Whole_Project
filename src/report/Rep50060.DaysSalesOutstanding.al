report 50060 "Days Sales Outstanding"
{
    // version CCIT-Fortune

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";

            trigger OnAfterGetRecord();
            begin
                Sr_No += 1;

                RecCust.RESET;
                IF RecCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                    CustName := RecCust.Name;
                    Contact := RecCust.Contact;
                    ContactNo := RecCust."Phone No.";
                    EMail_ID := RecCust."E-Mail";
                    CustPostGroup := RecCust."Customer Posting Group";
                    GenBusPostGroup := RecCust."Gen. Bus. Posting Group";
                    VerticalSubCategory := RecCust."Vertical Sub Category";
                    CustBusFormatOutletname := RecCust."Business Format / Outlet Name";
                    CreditPeriod := RecCust."Payment Terms Code";
                    CreditLimit := RecCust."Credit Limit (LCY)";
                    SalesPersonCode := RecCust."Salesperson Code";
                    CollectionPersonCode := RecCust."Responsible Collection Person";
                END;
                //MESSAGE('%1',CustName);
                MakeExcelDataBody;
            end;

            trigger OnPostDataItem();
            begin
                MakeExcelTotal;
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

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Days Sales Outstanding.xlsx', 'Days Sales Outstanding', 'Days Sales Outstanding', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Days Sales Outstanding.xlsx', 'Days Sales Outstanding', 'Days Sales Outstanding', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Days Sales Outstanding', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Branch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Bus. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertival Sub Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Business Format/Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Collection Person Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Credit Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Credit Period
        ExcelBuf.AddColumn('Credit Limit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Average Monthly Sales', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outstanding', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('DSO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn(RecCust."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustPostGroup, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GenBusPostGroup, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VerticalSubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustBusFormatOutletname, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Collaction Person Code', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CreditPeriod, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CreditLimit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Average Monthly SalesPersonCode', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outstanding', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('DSO', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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

