report 50075 "Cust Cr.Limit"
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
            DataItemTableView = WHERE("Credit Limit (LCY)" = FILTER(<> 0));

            trigger OnAfterGetRecord();
            begin
                CreateExcelBody;
                IF RecSalesPersonCode.GET(Customer."Salesperson Code") THEN
                    SalesPersonName := RecSalesPersonCode.Name;
            end;

            trigger OnPostDataItem();
            begin
                GlbExcelBuffer.CreateBookAndOpenExcel('', 'sheet1', 'Customer Credit Limit', COMPANYNAME, USERID);
                //PCPL/MIG/NSW Filed not Exist in BC18
                ERROR('');
                GlbExcelBuffer.DELETEALL;
            end;

            trigger OnPreDataItem();
            begin
                CreateExcelHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control01)
                {
                    field(GlbMonthType; GlbMonthType)
                    {
                        Caption = 'Avgerage Month';
                        Visible = false;
                    }
                    field("From Date"; FromDate)
                    {
                        Visible = false;
                    }
                    field("To Date"; ToDate)
                    {
                        Visible = false;
                    }
                    field("Threshold Limit %"; ThresholdLimit)
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
        CrLimitAvailPerc: Decimal;
        BalCrLimitPerc: Decimal;
        ThresholdLimit: Decimal;

    local procedure CreateExcelHeader();
    begin
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(COMPANYNAME, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        //GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('Date Range ' + FORMAT(FromDate) + '  To  ' + FORMAT(ToDate) ,FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('As on Date ' + FORMAT(FromDate), FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Date);
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('%Limit for Highlighting:' + FORMAT(ThresholdLimit), FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Credit Limit', FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Text);

        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Sales Person Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Branch Code', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Payment Term', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit Limit(Rs.)', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outstanding', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Balance Credit Limit', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('% Cr.limit availed', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Balance Cr. Limit %', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBody();
    var
        LCAvgMonthlySale: Decimal;
        LCDSOAmt: Decimal;
    begin
        GlbExcelBuffer.NewRow;
        //GlbExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Outlet Area", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Credit Limit (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(Customer."Balance (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        LCDSOAmt := ROUND((Customer."Credit Limit (LCY)" - Customer."Balance (LCY)"), 0.01, '=');
        GlbExcelBuffer.AddColumn(LCDSOAmt, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        CrLimitAvailPerc := ROUND(Customer."Balance (LCY)" / Customer."Credit Limit (LCY)", 0.01, '=') * 100;
        BalCrLimitPerc := ROUND(LCDSOAmt / Customer."Credit Limit (LCY)", 0.01, '=') * 100;
        IF CrLimitAvailPerc < ThresholdLimit THEN
            GlbExcelBuffer.AddColumn(CrLimitAvailPerc, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number)
        ELSE
            GlbExcelBuffer.AddColumn(CrLimitAvailPerc, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);

        IF BalCrLimitPerc > ThresholdLimit THEN
            GlbExcelBuffer.AddColumn(BalCrLimitPerc, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number)
        ELSE
            GlbExcelBuffer.AddColumn(BalCrLimitPerc, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
    end;
}

