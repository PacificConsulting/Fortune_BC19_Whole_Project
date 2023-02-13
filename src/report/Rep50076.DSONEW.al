report 50076 "DSO_NEW"
{
    // version RDK in use

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            CalcFields = "Sales (LCY)", "Balance (LCY)", "Invoice Amounts", "Cr. Memo Amounts";

            trigger OnAfterGetRecord();
            begin
                CLEAR(SalesPersonName);
                IF RecSalesPersonCode.GET(Customer."Salesperson Code") THEN
                    SalesPersonName := RecSalesPersonCode.Name;

                FunCreateExcelBody;
            end;

            trigger OnPostDataItem();
            begin
                GlbExcelBuffer.CreateBookAndOpenExcel('', 'sheet1', 'Collecion report', COMPANYNAME, USERID);
                //PCPL/MIG/NSW Filed not Exist in BC18
                ERROR('');
                GlbExcelBuffer.DELETEALL;
            end;

            trigger OnPreDataItem();
            begin
                Customer.SETFILTER("Date Filter", '%1..%2', FromDate, ToDate);
                Customer.CALCFIELDS("Balance Due", "Invoice Amounts", "Cr. Memo Amounts");

                FunCreateExcelHeader;

                NoOfDays := ToDate - FromDate;

                OldNoOFDays := NoOfDays; // rdk
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control00)
                {
                    field(GlbMonthType; GlbMonthType)
                    {
                        Caption = 'Avgerage Month';
                        Visible = false;
                    }
                    field("From Date"; FromDate)
                    {
                    }
                    field("To Date"; ToDate)
                    {
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CLEAR(GlbExcelBuffer);
        GlbExcelBuffer.DELETEALL;
    end;

    var
        GlbExcelBuffer: Record 370 temporary;
        GlbMonthType: Option "01 Month","03 Months","06 Months","09 Months","12 Months";
        RecSalesPersonCode: Record 13;
        SalesPersonName: Text[200];
        FromDate: Date;
        ToDate: Date;
        NoOfDays: Integer;
        OldNoOFDays: Integer;
        DCLE: Record 379;
        SDate: Date;

    local procedure FunCreateExcelHeader();
    begin
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(COMPANYNAME, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('Date Range ' + FORMAT(FromDate) + '  To  ' + FORMAT(ToDate), FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Debtors Sales Outstanding', FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Text);

        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer CODE', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Sales Person Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Branch Code', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit Days', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit Limit(Rs.)', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Invoices During the period', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Cr.Memos During the period', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Net Sales Amount', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Average Daily Sales', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outstanding', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outstanding/Average Daily Sales', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Cust. Trans.Start Date', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
    end;

    local procedure FunCreateExcelBody();
    var
        LCAvgMonthlySale: Decimal;
        LCDSOAmt: Decimal;
    begin
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."No.", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);//rdk 011019
        GlbExcelBuffer.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Outlet Area", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Credit Limit (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(Customer."Invoice Amounts", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(Customer."Cr. Memo Amounts", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts"), 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);



        /*
        IF (FromDate <> 0D) AND (ToDate <> 0D) THEN
           LCAvgMonthlySale:=ROUND((Customer."Invoice Amounts"-Customer."Cr. Memo Amounts")/NoOfDays,0.01,'=');
           */
        // rdk

        NoOfDays := OldNoOFDays;

        IF (FromDate <> 0D) AND (ToDate <> 0D) THEN BEGIN
            DCLE.RESET;
            DCLE.SETFILTER("Customer No.", Customer."No.");
            IF DCLE.FINDFIRST THEN BEGIN
                SDate := DCLE."Posting Date";
                IF SDate > FromDate THEN
                    NoOfDays := ToDate - SDate;
            END;

            IF NoOfDays = 0 THEN
                NoOfDays := 1;

            LCAvgMonthlySale := ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts") / NoOfDays, 0.01, '=');
        END;
        // rdk
        /*IF GlbMonthType = GlbMonthType::"03 Months" THEN
           LCAvgMonthlySale:=ROUND((Customer."Invoice Amounts"-Customer."Cr. Memo Amounts")/3,0.01,'=');
        IF GlbMonthType = GlbMonthType::"06 Months" THEN
           LCAvgMonthlySale:=ROUND((Customer."Invoice Amounts"-Customer."Cr. Memo Amounts")/6,0.01,'=');
        IF GlbMonthType = GlbMonthType::"09 Months" THEN
           LCAvgMonthlySale:=ROUND((Customer."Invoice Amounts"-Customer."Cr. Memo Amounts")/9,0.01,'=');
        IF GlbMonthType = GlbMonthType::"12 Months" THEN
           LCAvgMonthlySale:=ROUND((Customer."Invoice Amounts"-Customer."Cr. Memo Amounts")/12,0.01,'=');*/
        GlbExcelBuffer.AddColumn(LCAvgMonthlySale, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(Customer."Balance (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        IF LCAvgMonthlySale <> 0 THEN
            LCDSOAmt := ROUND((Customer."Balance (LCY)" / LCAvgMonthlySale), 0.01, '=');
        GlbExcelBuffer.AddColumn(LCDSOAmt, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(SDate, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Date);

    end;
}

