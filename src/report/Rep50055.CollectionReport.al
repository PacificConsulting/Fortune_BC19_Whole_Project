report 50055 "Collection Report"
{
    // version CCIT AN

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = WHERE("Document Type" = FILTER('Payment'));
            RequestFilterFields = "Customer No.";

            trigger OnAfterGetRecord();
            begin
                CLEAR(CustName);
                CLEAR(SalesPerName);
                CLEAR(AMT);
                CLEAR(CustName);
                CLEAR(ChequeDate);
                CLEAR(ChequeNo);

                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn("Cust. Ledger Entry"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("Cust. Ledger Entry"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Cust. Ledger Entry"."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                RecCustomer.RESET;
                RecCustomer.SETRANGE("No.", "Cust. Ledger Entry"."Customer No.");
                IF RecCustomer.FIND('-') THEN BEGIN
                    CustName := RecCustomer.Name;
                END;
                ExcelBuffer.AddColumn(CustName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Cust. Ledger Entry"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                "Cust. Ledger Entry".CALCFIELDS("Amount (LCY)");
                AMT := "Cust. Ledger Entry"."Amount (LCY)";
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                BankLedgerEntries.RESET;
                BankLedgerEntries.SETRANGE("Document No.", InvNo);
                BankLedgerEntries.SETRANGE("Posting Date", InvDate);
                BankLedgerEntries.SETRANGE("Document Type", CustLedEntries."Document Type"::Payment);
                BankLedgerEntries.SETRANGE("Transaction No.", CustLedEntries."Transaction No.");//BankLedgerEntries.SETRANGE("Statement Line No.");
                IF BankLedgerEntries.FIND('-') THEN BEGIN
                    ChequeNo := BankLedgerEntries."Cheque No.";
                    ChequeDate := BankLedgerEntries."Cheque Date";
                END;
                ExcelBuffer.AddColumn(ChequeNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(ChequeDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(AMT, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                RecSalesPerson.RESET;
                RecSalesPerson.SETRANGE(Code, "Cust. Ledger Entry"."Salesperson Code");
                IF RecSalesPerson.FIND('-') THEN BEGIN
                    SalesPerName := RecSalesPerson.Name;
                END;
                ExcelBuffer.AddColumn(SalesPerName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);


                MakeExcelDataBody;
            end;

            trigger OnPostDataItem();
            var
                CustRow: Integer;
                LedgerRow: Integer;
            begin
            end;

            trigger OnPreDataItem();
            begin
                //"Cust. Ledger Entry".SETFILTER("Cust. Ledger Entry"."Posting Date",'%1..%2,',FromDate,ToDate);
                "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date", FromDate, ToDate);
                TextDate := 'From' + FORMAT(FromDate, 0, '<Day,2>-<Month,2>-<Year4>') + ' To ' + FORMAT(ToDate, 0, '<Day,2>-<Month,2>-<Year4>');
                MakeExcelInfo;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control001)
                {
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

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        ExcelBuffer.DELETEALL;
    end;

    var
        Company_Info: Record 79;
        Date: Date;
        ExcelBuffer: Record 370;
        RecSalesPerson: Record 13;
        SalesPerName: Text[30];
        No_Days: Integer;
        RecCustomer: Record 18;
        CustName: Text;
        FromDate: Date;
        ToDate: Date;
        TextDate: Text;
        CustLedEntries: Record 21;
        InvNo: Code[20];
        InvAmt: Decimal;
        InvDate: Date;
        AppliedAmt: Decimal;
        SRNO: Integer;
        CurrentCustRow: Variant;
        CurrentLedgerEntryRow: Variant;
        AMT: Decimal;
        DueDate: Date;
        BankLedgerEntries: Record 271;
        ChequeNo: Code[25];
        ChequeDate: Date;
        CustLedEntries1: Record 21;
        InvNo1: Code[20];
        InvAmt1: Decimal;
        InvDate1: Date;
        AppliedAmt1: Decimal;
        No_Days1: Integer;
        DueDate1: Date;
        RecDetailedCustLedEntry: Record 379;

    procedure MakeExcelInfo();
    begin
        Company_Info.GET;
        ExcelBuffer.SetUseInfoSheet;
        Date := TODAY;
        ExcelBuffer.AddColumn(Company_Info.Name, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Page 1', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Collection Report', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Date, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(TextDate, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(USERID, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuffer.AddColumn('Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Voucher No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cust. Posting Group', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bill Details', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Due Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('No. of Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Amt.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applied Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cheque No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cheque Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SalesPerson Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody();
    begin
        CLEAR(InvNo);
        CLEAR(InvDate);
        CLEAR(InvAmt);
        CLEAR(AppliedAmt);
        CLEAR(No_Days);

        CustLedEntries.RESET;
        CustLedEntries.SETRANGE("Closed by Entry No.", "Cust. Ledger Entry"."Entry No.");
        //CustLedEntries.SETRANGE(cust);
        IF CustLedEntries.FIND('-') THEN
            REPEAT
                InvNo := CustLedEntries."Document No.";
                InvDate := CustLedEntries."Posting Date";
                DueDate := CustLedEntries."Due Date";
                CustLedEntries.CALCFIELDS("Original Amount");
                InvAmt := CustLedEntries."Original Amount";
                AppliedAmt := CustLedEntries."Closed by Amount (LCY)";

                /*RecDetailedCustLedEntry.RESET;
                RecDetailedCustLedEntry.SETRANGE("Cust. Ledger Entry No.",CustLedEntries."Entry No.");
                RecDetailedCustLedEntry.SETRANGE("Document No.",CustLedEntries."Document No.");
                IF RecDetailedCustLedEntry.FINDFIRST THEN
                  MESSAGE('1  %1 %2',RecDetailedCustLedEntry."Cust. Ledger Entry No.",RecDetailedCustLedEntry.Amount);
                   AppliedAmt := RecDetailedCustLedEntry.Amount
                ELSE
                   AppliedAmt := 0;*/
                No_Days := DueDate - InvDate;  // CustLedEntries."Due Date" - CustLedEntries."Posting Date";
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(DueDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(No_Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AppliedAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            UNTIL CustLedEntries.NEXT = 0;

        //
        CLEAR(InvNo1);
        CLEAR(InvDate1);
        CLEAR(InvAmt1);
        CLEAR(AppliedAmt1);
        CLEAR(No_Days1);

        CustLedEntries1.RESET;
        CustLedEntries1.SETRANGE("Entry No.", "Cust. Ledger Entry"."Closed by Entry No.");
        //CustLedEntries.SETRANGE(cust);
        IF CustLedEntries1.FIND('-') THEN
            REPEAT
                InvNo1 := CustLedEntries1."Document No.";
                InvDate1 := CustLedEntries1."Posting Date";
                DueDate1 := CustLedEntries1."Due Date";
                CustLedEntries1.CALCFIELDS("Original Amount");
                InvAmt1 := CustLedEntries1."Original Amount";
                //AppliedAmt1 := CustLedEntries1."Closed by Amount (LCY)";
                AppliedAmt1 := CustLedEntries1."Original Amount" - CustLedEntries1."Closed by Amount (LCY)";
                /*RecDetailedCustLedEntry.RESET;
                RecDetailedCustLedEntry.SETRANGE("Cust. Ledger Entry No.","Cust. Ledger Entry"."Closed by Entry No.");
                RecDetailedCustLedEntry.SETRANGE("Document No.",CustLedEntries1."Document No.");
                IF RecDetailedCustLedEntry.FINDFIRST THEN
                   MESSAGE('2  %1 %2',RecDetailedCustLedEntry."Cust. Ledger Entry No.",RecDetailedCustLedEntry.Amount);
                   AppliedAmt1 := RecDetailedCustLedEntry.Amount
                ELSE
                   AppliedAmt1 := 0;*/

                No_Days1 := DueDate1 - InvDate1;  // CustLedEntries."Due Date" - CustLedEntries."Posting Date";
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvNo1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvDate1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(DueDate1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(No_Days1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(InvAmt1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AppliedAmt1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            UNTIL CustLedEntries1.NEXT = 0;
        //

    end;

    local procedure CreateExcelBook();
    begin
        ExcelBuffer.CreateBookAndOpenExcel('', 'Collection Report', '', COMPANYNAME, USERID);
        ERROR('');
        //PCPL/MIG/NSW
    end;
}

