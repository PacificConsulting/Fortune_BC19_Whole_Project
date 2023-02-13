report 50079 "Customer Detailed Aging1"
{
    // version NAVW19.00.00.45778

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Customer Detailed Aging1.rdl';
    CaptionML = ENU = 'Customer Detailed Aging',
                ENN = 'Customer Detailed Aging';
    EnableHyperlinks = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Customer Posting Group", "Currency Filter", "Payment Terms Code";
            column(STRSUBSTNO_Text000_FORMAT_EndDate_; STRSUBSTNO(Text000, FORMAT(EndDate)))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Customer_TABLECAPTION_CustFilter; TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer_Phone_No_; "Phone No.")
            {
            }
            column(CustomerContact; Contact)
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(Customer_Detailed_AgingCaption; Customer_Detailed_AgingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust_Ledger_Entry_Posting_Date_Caption; Cust_Ledger_Entry_Posting_Date_CaptionLbl)
            {
            }
            column(Cust_Ledger_Entry_Document_No_Caption; "Cust. Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(Cust_Ledger_Entry_DescriptionCaption; "Cust. Ledger Entry".FIELDCAPTION(Description))
            {
            }
            column(Cust_Ledger_Entry_Due_Date_Caption; Cust_Ledger_Entry_Due_Date_CaptionLbl)
            {
            }
            column(OverDueMonthsCaption; OverDueMonthsCaptionLbl)
            {
            }
            column(Cust_Ledger_Entry_Remaining_Amount_Caption; "Cust. Ledger Entry".FIELDCAPTION("Remaining Amount"))
            {
            }
            column(Cust_Ledger_Entry_Currency_Code_Caption; "Cust. Ledger Entry".FIELDCAPTION("Currency Code"))
            {
            }
            column(Cust_Ledger_Entry_Remaining_Amt_LCY_Caption; "Cust. Ledger Entry".FIELDCAPTION("Remaining Amt. (LCY)"))
            {
            }
            column(Customer_Phone_No_Caption; FIELDCAPTION("Phone No."))
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Currency Code" = FIELD("Currency Filter"),
                               "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");
                column(Cust_Ledger_Entry_Posting_Date_; FORMAT("Posting Date"))
                {
                }
                column(Cust_Ledger_Entry_Document_No_; "Document No.")
                {
                }
                column(Cust_Ledger_Entry_Description; Description)
                {
                }
                column(Cust_Ledger_Entry_Due_Date_; FORMAT("Due Date"))
                {
                }
                column(OverDueMonths; OverDueMonths)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Cust_Ledger_Entry_Remaining_Amount_; "Remaining Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Cust_Ledger_Entry_Currency_Code_; "Currency Code")
                {
                }
                column(Cust_Ledger_Entry_Remaining_Amt_LCY_; "Remaining Amt. (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(OverDueDays; OverDueDays)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF "Due Date" = 0D THEN
                        OverDueMonths := 0
                    ELSE BEGIN
                        OverDueMonths :=
                          (DATE2DMY(EndDate, 3) - DATE2DMY("Due Date", 3)) * 12 +
                          DATE2DMY(EndDate, 2) - DATE2DMY("Due Date", 2);
                        IF DATE2DMY(EndDate, 1) < DATE2DMY("Due Date", 1) THEN
                            OverDueMonths := OverDueMonths - 1;
                    END;
                    //CCIT-JAGA 05/11/2018
                    IF "Due Date" <> 0D THEN
                        OverDueDays := EndDate - "Cust. Ledger Entry"."Due Date";
                    //CCIT-JAGA 05/11/2018
                    SETRANGE("Date Filter", 0D, EndDate);
                    CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                    IF "Remaining Amount" = 0 THEN
                        CurrReport.SKIP;
                    CurrencyTotalBuffer.UpdateTotal(
                      "Currency Code", "Remaining Amount", "Remaining Amt. (LCY)", Counter);
                end;

                trigger OnPreDataItem();
                begin
                    IF OnlyOpen THEN BEGIN
                        SETRANGE(Open, TRUE);
                        SETRANGE("Due Date", 0D, EndDate);
                    END ELSE
                        SETRANGE("Due Date", 0D, EndDate);
                    CurrReport.CREATETOTALS("Remaining Amount", "Remaining Amt. (LCY)");
                    Counter := 0;
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 ..));
                column(CurrencyTotalBuffer_Total_Amount_; CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrencyTotalBuffer_Currency_Code_; CurrencyTotalBuffer."Currency Code")
                {
                }
                column(CurrencyTotalBuffer_Total_Amount_LCY_; CurrencyTotalBuffer."Total Amount (LCY)")
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord();
                begin
                    IF Number = 1 THEN
                        OK := CurrencyTotalBuffer.FIND('-')
                    ELSE
                        OK := CurrencyTotalBuffer.NEXT <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK;
                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      CurrencyTotalBuffer."Total Amount (LCY)", Counter1);
                end;

                trigger OnPostDataItem();
                begin
                    CurrencyTotalBuffer.DELETEALL;
                end;
            }

            trigger OnPreDataItem();
            begin
                CurrReport.CREATETOTALS("Cust. Ledger Entry"."Remaining Amt. (LCY)");
            end;
        }
        dataitem(Integer2; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(CurrencyTotalBuffer2_Currency_Code_; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(CurrencyTotalBuffer2_Total_Amount_; CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                AutoFormatType = 1;
            }
            column(CurrencyTotalBuffer2_Total_Amount_LCY_; CurrencyTotalBuffer2."Total Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN
                    OK := CurrencyTotalBuffer2.FIND('-')
                ELSE
                    OK := CurrencyTotalBuffer2.NEXT <> 0;
                IF NOT OK THEN
                    CurrReport.BREAK;
            end;

            trigger OnPostDataItem();
            begin
                CurrencyTotalBuffer2.DELETEALL;
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
                group(Options)
                {
                    CaptionML = ENU = 'Options',
                                ENN = 'Options';
                    field("Ending Date"; EndDate)
                    {
                        CaptionML = ENU = 'Ending Date',
                                    ENN = 'Ending Date';
                    }
                    field(ShowOpenEntriesOnly; OnlyOpen)
                    {
                        CaptionML = ENU = 'Show Open Entries Only',
                                    ENN = 'Show Open Entries Only';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            IF EndDate = 0D THEN
                EndDate := WORKDATE;
        end;
    }

    labels
    {
        label(CustomerContactCaption; ENU = 'Contact',
                                     ENN = 'Contact')
    }

    trigger OnPreReport();
    begin
        CustFilter := Customer.GETFILTERS;
    end;

    var
        Text000: TextConst ENU = 'As of %1', ENN = 'As of %1';
        CurrencyTotalBuffer: Record 332 temporary;
        CurrencyTotalBuffer2: Record 332 temporary;
        EndDate: Date;
        CustFilter: Text;
        OverDueMonths: Integer;
        OK: Boolean;
        Counter: Integer;
        Counter1: Integer;
        OnlyOpen: Boolean;
        Customer_Detailed_AgingCaptionLbl: TextConst ENU = 'Customer Detailed Aging', ENN = 'Customer Detailed Aging';
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ENN = 'Page';
        Cust_Ledger_Entry_Posting_Date_CaptionLbl: TextConst ENU = 'Posting Date', ENN = 'Posting Date';
        Cust_Ledger_Entry_Due_Date_CaptionLbl: TextConst ENU = 'Due Date', ENN = 'Due Date';
        OverDueMonthsCaptionLbl: TextConst ENU = 'Days Due', ENN = 'Months Due';
        TotalCaptionLbl: TextConst ENU = 'Total', ENN = 'Total';
        OverDueDays: Integer;

    procedure InitializeRequest(SetEndDate: Date; SetOnlyOpen: Boolean);
    begin
        EndDate := SetEndDate;
        OnlyOpen := SetOnlyOpen;
    end;
}

