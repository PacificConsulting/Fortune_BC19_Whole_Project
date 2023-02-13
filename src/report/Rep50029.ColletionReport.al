report 50029 "Colletion Report"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Customer"; "Customer")
        {
            RequestFilterFields = "No.";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = "Remaining Amt. (LCY)";
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");

                trigger OnAfterGetRecord();
                begin
                    CLEAR(GlbAgeingAmount);
                    IF "Cust. Ledger Entry"."Remaining Amt. (LCY)" = 0 THEN
                        CurrReport.SKIP;
                    FunCalculateAgeing;
                    FunCreateExcelBody;
                end;

                trigger OnPostDataItem();
                var
                    LCCustomerRow: Integer;
                    LCLedgerRow: Integer;
                begin
                    GlbExcelBuffer.UTgetGlobalValue('CurrentRow', GlbCurrentLedgerEntryRow);
                    EVALUATE(LCCustomerRow, FORMAT(GlbCurrentCustomerRow));
                    EVALUATE(LCLedgerRow, FORMAT(GlbCurrentLedgerEntryRow));
                    IF LCCustomerRow < LCLedgerRow THEN BEGIN
                        GlbExcelBuffer.SetCurrent(GlbCurrentCustomerRow, 0);
                        FunCreateCustomerTotalRow;
                        GlbAgeingAmountTotal[1] := GlbAgeingAmountTotal[1] + GlbAgeingAmountCustomerTotal[1];
                        GlbAgeingAmountTotal[2] := GlbAgeingAmountTotal[2] + GlbAgeingAmountCustomerTotal[2];
                        GlbAgeingAmountTotal[3] := GlbAgeingAmountTotal[3] + GlbAgeingAmountCustomerTotal[3];
                        GlbAgeingAmountTotal[4] := GlbAgeingAmountTotal[4] + GlbAgeingAmountCustomerTotal[4];
                        GlbAgeingAmountTotal[5] := GlbAgeingAmountTotal[5] + GlbAgeingAmountCustomerTotal[5];
                        GlbAgeingAmountTotal[6] := GlbAgeingAmountTotal[6] + GlbAgeingAmountCustomerTotal[6];
                        GlbAgeingAmountTotal[7] := GlbAgeingAmountTotal[7] + GlbAgeingAmountCustomerTotal[7];
                        GlbAgeingAmountTotal[8] := GlbAgeingAmountTotal[8] + GlbAgeingAmountCustomerTotal[8];
                        GlbAgeingAmountTotal[9] := GlbAgeingAmountTotal[9] + GlbAgeingAmountCustomerTotal[9];
                        GlbAgeingAmountTotal[10] := GlbAgeingAmountTotal[10] + GlbAgeingAmountCustomerTotal[10];
                        GlbAgeingAmountTotal[11] := GlbAgeingAmountTotal[11] + GlbAgeingAmountCustomerTotal[11];
                    END;
                    GlbExcelBuffer.SetCurrent(GlbCurrentLedgerEntryRow, 0);
                end;

                trigger OnPreDataItem();
                begin
                    "Cust. Ledger Entry".SETRANGE("Posting Date", 0D, GlbAsOnDate);
                    "Cust. Ledger Entry".SETRANGE("Date Filter", 0D, GlbAsOnDate);

                    GlbExcelBuffer.UTgetGlobalValue('CurrentRow', GlbCurrentCustomerRow);
                    GlbExcelBuffer.NewRow;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(GlbAgeingAmountCustomerTotal);
            end;

            trigger OnPostDataItem();
            begin
                FunCreateTotalRow;
                GlbExcelBuffer.CreateBookAndOpenExcel('', 'sheet1', 'Collecion report', COMPANYNAME, USERID);
                //PCPL/MIG/NSW
                ERROR('');
                GlbExcelBuffer.DELETEALL;
                MESSAGE('Process Complete');
            end;

            trigger OnPreDataItem();
            begin
                Customer.SETRANGE("Date Filter", 0D, GlbAsOnDate);
                GlbSrNo := 0;
                FunCreateExcelHeader;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Ageing Parameter")
                {
                    Caption = 'Ageing Parameter';
                    field(GlbAgeingOn; GlbAgeingOn)
                    {
                        Caption = 'Ageing On';
                    }
                    field(GlbAsOnDate; GlbAsOnDate)
                    {
                        Caption = 'Ageing As on';
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

    trigger OnInitReport();
    begin
        GlbAsOnDate := WORKDATE;
    end;

    trigger OnPreReport();
    begin
        CLEAR(GlbExcelBuffer);
        GlbExcelBuffer.DELETEALL;
        IF GlbAsOnDate = 0D THEN
            ERROR('Ageing As on date cannot be blank');
    end;

    var
        GlbAsOnDate: Date;
        GlbAgeingOn: Option "Due Date","Posting Date";
        GlbExcelBuffer: Record 370 temporary;
        GlbSrNo: Integer;
        GlbCurrentCustomerRow: Variant;
        GlbCurrentLedgerEntryRow: Variant;
        GlbAgeingAmount: array[11] of Decimal;
        GlbAgeingAmountCustomerTotal: array[11] of Decimal;
        GlbAgeingAmountTotal: array[11] of Decimal;

    local procedure FunCreateExcelHeader();
    begin
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(COMPANYNAME, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Debtors outstanding & ageing report', FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Text);

        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Sr. No.', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customers Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Branch', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Name of Contact Person', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Contact No.', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Email-ID', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Group', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Gen. Bus. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Vertical Sub Category', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Customer Business format/Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit period', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Credit Limit', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('SalesPerson Code', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Document Number', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Document Date', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Document Due Date', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Total Outstanding', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Not Due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('0-30 days due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('30-60 days due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('60-90 days due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('90-180 days due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('180-365 days due', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('More than 1 year', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('More than 2 year', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('More than 3 year', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
    end;

    local procedure FunCreateExcelBody();
    begin
        GlbExcelBuffer.NewRow;
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn("Cust. Ledger Entry"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn("Cust. Ledger Entry"."Document Type", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn("Cust. Ledger Entry"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Date);
        GlbExcelBuffer.AddColumn("Cust. Ledger Entry"."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Date);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[1], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[2], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[4], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[5], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[6], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[7], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[8], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[9], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[10], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmount[11], FALSE, '', FALSE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);

        GlbAgeingAmountCustomerTotal[1] := GlbAgeingAmountCustomerTotal[1] + GlbAgeingAmount[1];
        GlbAgeingAmountCustomerTotal[2] := GlbAgeingAmountCustomerTotal[2] + GlbAgeingAmount[2];
        GlbAgeingAmountCustomerTotal[3] := GlbAgeingAmountCustomerTotal[3] + GlbAgeingAmount[3];
        GlbAgeingAmountCustomerTotal[4] := GlbAgeingAmountCustomerTotal[4] + GlbAgeingAmount[4];
        GlbAgeingAmountCustomerTotal[5] := GlbAgeingAmountCustomerTotal[5] + GlbAgeingAmount[5];
        GlbAgeingAmountCustomerTotal[6] := GlbAgeingAmountCustomerTotal[6] + GlbAgeingAmount[6];
        GlbAgeingAmountCustomerTotal[7] := GlbAgeingAmountCustomerTotal[7] + GlbAgeingAmount[7];
        GlbAgeingAmountCustomerTotal[8] := GlbAgeingAmountCustomerTotal[8] + GlbAgeingAmount[8];
        GlbAgeingAmountCustomerTotal[9] := GlbAgeingAmountCustomerTotal[9] + GlbAgeingAmount[9];
        GlbAgeingAmountCustomerTotal[10] := GlbAgeingAmountCustomerTotal[10] + GlbAgeingAmount[10];
        GlbAgeingAmountCustomerTotal[11] := GlbAgeingAmountCustomerTotal[11] + GlbAgeingAmount[11];
    end;

    local procedure FunCreateCustomerTotalRow();
    var
        LCRecSalesPurchaseCode: Record 13;
        LCRecDefDim: Record 352;
        LcRecDimValue: Record 349;
    begin
        GlbSrNo := GlbSrNo + 1;
        GlbExcelBuffer.NewRow;

        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(GlbSrNo, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(Customer.Name, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Location Code", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer.Contact, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Contact No.(Accounts)", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."E-Mail", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        LCRecDefDim.RESET;
        LCRecDefDim.SETRANGE("Table ID", 18);
        LCRecDefDim.SETRANGE("No.", Customer."No.");
        LCRecDefDim.SETRANGE("Dimension Code", 'Customer Gropup');
        IF LCRecDefDim.FINDFIRST THEN BEGIN
            LcRecDimValue.RESET;
            LcRecDimValue.SETRANGE(Code, 'Customer Gropup');
            LcRecDimValue.SETRANGE("Dimension Code", LCRecDefDim."Dimension Value Code");
            IF LcRecDimValue.FINDFIRST THEN
                GlbExcelBuffer.AddColumn(LcRecDimValue.Name, FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text)
            ELSE
                GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text)
        END
        ELSE
            GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Customer Posting Group", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Gen. Bus. Posting Group", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Vertical Sub Category", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Business Format / Outlet Name", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Payment Terms Code", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(Customer."Credit Limit (LCY)", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        IF LCRecSalesPurchaseCode.GET(Customer."Salesperson Code") THEN
            GlbExcelBuffer.AddColumn(Customer."Salesperson Code", FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text)
        ELSE
            GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[1], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[2], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[3], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[4], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[5], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[6], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[7], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[8], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[9], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[10], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountCustomerTotal[11], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
    end;

    local procedure FunCalculateAgeing();
    var
        LCNoOfDays: Integer;
        LCRecCustLedgEntry: Record 21;
    begin
        IF LCRecCustLedgEntry.GET("Cust. Ledger Entry"."Entry No.") THEN BEGIN
            LCRecCustLedgEntry.CALCFIELDS("Original Amt. (LCY)");
            LCRecCustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
            GlbAgeingAmount[1] := LCRecCustLedgEntry."Original Amt. (LCY)";
            GlbAgeingAmount[3] := LCRecCustLedgEntry."Remaining Amt. (LCY)";
        END;

        GlbAgeingAmount[2] := GlbAgeingAmount[1] - GlbAgeingAmount[3];

        IF GlbAgeingOn = GlbAgeingOn::"Due Date" THEN
            LCNoOfDays := GlbAsOnDate - "Cust. Ledger Entry"."Due Date";

        IF GlbAgeingOn = GlbAgeingOn::"Posting Date" THEN
            LCNoOfDays := GlbAsOnDate - "Cust. Ledger Entry"."Posting Date";

        IF (LCNoOfDays >= 0) AND (LCNoOfDays <= 30) THEN
            GlbAgeingAmount[4] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 30) AND (LCNoOfDays <= 60) THEN
            GlbAgeingAmount[5] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 60) AND (LCNoOfDays <= 90) THEN
            GlbAgeingAmount[6] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 90) AND (LCNoOfDays <= 180) THEN
            GlbAgeingAmount[7] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 180) AND (LCNoOfDays <= 365) THEN
            GlbAgeingAmount[8] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 365) AND (LCNoOfDays <= 730) THEN
            GlbAgeingAmount[9] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 730) AND (LCNoOfDays <= 1095) THEN
            GlbAgeingAmount[10] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";

        IF (LCNoOfDays > 1095) AND (LCNoOfDays <= 1460) THEN
            GlbAgeingAmount[11] := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
    end;

    local procedure FunCreateTotalRow();
    begin
        GlbExcelBuffer.NewRow;

        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', GlbExcelBuffer."Cell Type"::Text);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[1], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[2], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[3], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[4], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[5], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[6], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[7], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[8], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[9], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[10], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
        GlbExcelBuffer.AddColumn(GlbAgeingAmountTotal[11], FALSE, '', TRUE, FALSE, TRUE, '', GlbExcelBuffer."Cell Type"::Number);
    end;
}

