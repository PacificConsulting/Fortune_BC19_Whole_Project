report 50030 "DSO"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Customer"; "Customer")
        {
            CalcFields = "Sales (LCY)", "Balance (LCY)", "Invoice Amounts", "Cr. Memo Amounts";

            trigger OnAfterGetRecord();
            begin
                FunCreateExcelBody;
                IF RecSalesPersonCode.GET(Customer."Salesperson Code") THEN
                    SalesPersonName := RecSalesPersonCode.Name;
            end;

            trigger OnPostDataItem();
            begin
                GlbExcelBuffer.CreateBookAndOpenExcel('', 'sheet1', 'Collecion report', COMPANYNAME, USERID);
                //PCPl/MIG/NSW
                ERROR('');
                GlbExcelBuffer.DELETEALL;
            end;

            trigger OnPreDataItem();
            begin
                FunCreateExcelHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1)
                {
                    field(GlbMonthType; GlbMonthType)
                    {
                        Caption = 'Avgerage Month';
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

    local procedure FunCreateExcelHeader();
    begin
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(COMPANYNAME, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Debtors Sales Outstanding', FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Text);

        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Sales Person Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Branch Code', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit Days', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit Limit(Rs.)', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Average Monthly Sales', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outstanding', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Outstanding/Average Monthly Sales * 30 Days', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
    end;

    local procedure FunCreateExcelBody();
    var
        LCAvgMonthlySale: Decimal;
        LCDSOAmt: Decimal;
    begin
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Outlet Area", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Credit Limit (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);

        IF GlbMonthType = GlbMonthType::"01 Month" THEN
            LCAvgMonthlySale := ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts") / 1, 0.01, '=');
        IF GlbMonthType = GlbMonthType::"03 Months" THEN
            LCAvgMonthlySale := ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts") / 3, 0.01, '=');
        IF GlbMonthType = GlbMonthType::"06 Months" THEN
            LCAvgMonthlySale := ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts") / 6, 0.01, '=');
        IF GlbMonthType = GlbMonthType::"09 Months" THEN
            LCAvgMonthlySale := ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts") / 9, 0.01, '=');
        IF GlbMonthType = GlbMonthType::"12 Months" THEN
            LCAvgMonthlySale := ROUND((Customer."Invoice Amounts" - Customer."Cr. Memo Amounts") / 12, 0.01, '=');
        GlbExcelBuffer.AddColumn(LCAvgMonthlySale, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(Customer."Balance (LCY)", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        IF LCAvgMonthlySale <> 0 THEN
            LCDSOAmt := ROUND((Customer."Balance (LCY)" / LCAvgMonthlySale) * 30, 0.01, '=');
        GlbExcelBuffer.AddColumn(LCDSOAmt, FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
    end;
}

