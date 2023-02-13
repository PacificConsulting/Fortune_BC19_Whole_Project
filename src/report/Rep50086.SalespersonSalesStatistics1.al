report 50086 "Salesperson-Sales Statistics1"
{
    // version ccit san

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Salesperson-Sales Statistics1.rdl';
    CaptionML = ENU = 'Salesperson - Sales Statistics',
                ENN = 'Salesperson - Sales Statistics';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            MaxIteration = 0;
            RequestFilterFields = "Salesperson Code", "Posting Date", "Customer Posting Group", "Customer No.";
            column(STRSUBSTNO_Text000_PeriodText_; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CustLedgEntryFilter; CustLedgEntryFilter)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(SalespersonCode_CustLedgerEntry; "Cust. Ledger Entry"."Salesperson Code")
            {
            }
            column(SalesPersonName; SalesPersonName)
            {
            }
            column(CustomerNo_CustLedgerEntry; "Cust. Ledger Entry"."Customer No.")
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(CustomerPostingGroup_CustLedgerEntry; "Cust. Ledger Entry"."Customer Posting Group")
            {
            }
            column(SalesLCY_CustLedgerEntry; "Cust. Ledger Entry"."Sales (LCY)")
            {
            }
            column(ProfitLCY_CustLedgerEntry; "Cust. Ledger Entry"."Profit (LCY)")
            {
            }
            column(InvDiscountLCY_CustLedgerEntry; "Cust. Ledger Entry"."Inv. Discount (LCY)")
            {
            }
            column(PmtToleranceLCY_CustLedgerEntry; "Cust. Ledger Entry"."Pmt. Tolerance (LCY)")
            {
            }
            column(PmtDiscGivenLCY_CustLedgerEntry; "Cust. Ledger Entry"."Pmt. Disc. Given (LCY)")
            {
            }

            trigger OnAfterGetRecord();
            begin

                CustomerName := '';
                IF recCust.GET("Cust. Ledger Entry"."Customer No.") THEN
                    CustomerName := recCust.Name;

                SalesPersonName := '';
                IF recSalesPerson.GET("Cust. Ledger Entry"."Salesperson Code") THEN
                    SalesPersonName := recSalesPerson.Name;
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
        label(ReportLabel; ENU = 'Salesperson - Sales Statistics',
                          ENN = 'Salesperson - Sales Statistics')
        label(PageLabel; ENU = 'Page',
                        ENN = 'Page')
        label(AmountsInLCYLabel; ENU = 'All amounts are in LCY',
                                ENN = 'All amounts are in LCY')
        label(ProfitPctLabel; ENU = 'Profit %',
                             ENN = 'Profit %')
        label(InvDiscAmountLabel; ENU = 'Invoice Disc. Amount (LCY)',
                                 ENN = 'Invoice Disc. Amount (LCY)')
        label(PmtDiscGivenLabel; ENU = 'Payment Disc. Given (LCY)',
                                ENN = 'Payment Disc. Given (LCY)')
        label(PmtToleranceLabel; ENU = 'Pmt. Tolerance (LCY)',
                                ENN = 'Pmt. Tolerance (LCY)')
        label(AdjProfitPctLabel; ENU = 'Adjusted Profit %',
                                ENN = 'Adjusted Profit %')
        label(AdjProfitLCYLabel; ENU = 'Adjusted Profit (LCY)',
                                ENN = 'Adjusted Profit (LCY)')
        label(TotalLabel; ENU = 'Total',
                         ENN = 'Total')
        label(SalesLCYLabel; ENU = 'Sales (LCY)',
                            ENN = 'Sales (LCY)')
        label(ProfitLCYLabel; ENU = 'Profit (LCY)',
                             ENN = 'Profit (LCY)')
        label(CodeLabel; ENU = 'Code',
                        ENN = 'Code')
    }

    trigger OnPreReport();
    begin
        //SalespersonFilter := "Salesperson/Purchaser".GETFILTERS;
        CustLedgEntryFilter := "Cust. Ledger Entry".GETFILTERS;
        PeriodText := "Cust. Ledger Entry".GETFILTER("Posting Date");

        /*
        IF "Cust. Ledger Entry".GETFILTER("Cust. Ledger Entry"."Salesperson Code") = '' THEN
          ERROR('Select sales person code..');
        recSalesPerson.GET("Cust. Ledger Entry".GETFILTER("Cust. Ledger Entry"."Salesperson Code"));
        SalesPersonName := recSalesPerson.Name;
        */

    end;

    var
        Text000: TextConst ENU = 'Period: %1', ENN = 'Period: %1';
        SalespersonFilter: Text;
        CustLedgEntryFilter: Text;
        PeriodText: Text[30];
        AdjProfit: Decimal;
        ProfitPct: Decimal;
        AdjProfitPct: Decimal;
        SalesLCY: Decimal;
        ProfitLCY: Decimal;
        InvDiscLCY: Decimal;
        PmtDiscGivenLCY: Decimal;
        PmtToleranceLCY: Decimal;
        SalesPersonName: Text[200];
        recSalesPerson: Record 13;
        recCust: Record 18;
        CustomerName: Text[100];
}

