report 50072 "Vendor Ledger"
{
    // version CCIT

    // // VKJ 8-01-07  - Location wise view
    // 
    // **CFL1.00.47**CUSTMISC**001**140708**TJ
    // --ADDED CODE TO PRINT STRUCTURE DETAILS
    // 
    // **CFL1.00.48**CUSTMISC**002**180708**Nitin
    // - Formatting Changes and Correct TDS Amount
    // - Display total CR amount and its bifurcation
    // 
    // **CFL1.00.49**CUSTMISC**003**210708**Nitin
    // - Changes the font of Invoice Break ups, Debit & Credit Caption
    // - Added code in 'Vendor Ledger Entry - OnAfterGetRecord()' trigger to capture 'Charges Amout'
    //   from structure
    // 
    // **MAYA1.09**CUSTMISC**004**260908**PP
    // --CODE ADDED TO PRINT BREAKUP OF AMOUNT AS "Realized loss" AND "Realized gain".
    // --ADDED A NEW DATAITEM AFTER "Vender Ledger Entry" AS "Detailed VLE GainLoss".
    // 
    // **JDIL1.39**CUSTMISC**005**200509**AB
    // --ADDED DESCRIPTION 2
    // 
    // **MWORLD1.00**CUSTMISC**003**270311**AM
    // ---Report Exported to Excel Sheet
    // 
    // **MWORLD1.00**CUSTMISC**060511**MD
    // --Added fields of Dimension to excel sheet
    // 
    // **MWORLD1.11**CUSTMISC**081211**SSP
    // FORMATING CHANGES DONE AS PER THE REQUIREMENT
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Vendor Ledger.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    Caption = 'Vendor - Ledger';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(CompanyAddr_2_______CompanyAddr_3_______CompanyAddr_4_; CompanyAddr[2] + '  ' + CompanyAddr[3] + '  ' + CompanyAddr[4])
            {
            }
            column(for_the_period_________VendDateFilter; VendDateFilter)
            {
            }
            column(Vendor_TABLECAPTION__________VendFilter; Vendor.TABLECAPTION + ': ' + VendFilter)
            {
            }
            column(BalanceCaption; BalanceCaption)
            {
            }
            column(CreditCaption; CreditCaption)
            {
            }
            column(DebitCaption; DebitCaption)
            {
            }
            column(VendName; Vendor.Name)
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(ABS_StartBalanceLCY_; ABS(StartBalanceLCY))
            {
                AutoFormatType = 1;
            }
            column(DrCrBalanceText; DrCrBalanceText)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_LedgerCaption; Vendor_LedgerCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(This_report_also_includes_vendors_that_only_have_balances_Caption; This_report_also_includes_vendors_that_only_have_balances_CaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Vendor_Bill_No__Cheque_No_Caption; Vendor_Bill_No__Cheque_No_CaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Opening_BalanceCaption; Opening_BalanceCaptionLbl)
            {
            }
            column(Vendor_Date_Filter; FORMAT("Date Filter", 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(PrintVoucherNarr; PrintVoucherNarr)
            {
            }
            column(PrintLineNarr; PrintLineNarr)
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter"),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                               "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Vendor No.", "Posting Date");
                RequestFilterFields = "Document No.";
                column(Vendor_Ledger_Entry__Posting_Date_; FORMAT("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
                {
                }
                column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(ABS_VendorBalance_; ABS(VendorBalance))
                {
                    AutoFormatType = 1;
                }
                column(VendDBAmount; VendDBAmount)
                {
                }
                column(VendCRAmount; VendCRAmount)
                {
                }
                column(ControlAccountName; ControlAccountName)
                {
                }
                column(VendInvChequeNo; VendInvChequeNo)
                {
                }
                column(VendInvChequedate; VendInvChequedate)
                {
                }
                column(DrCrBalanceText_Control1000000020; DrCrBalanceText)
                {
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Vendor_Ledger_Entry_Date_Filter; FORMAT("Date Filter", 0, '<Day,2>-<Month Text,3>-<Year4>'))
                {
                }
                column(Vendor_Ledger_Entry_Transaction_No_; "Transaction No.")
                {
                }
                column(TDSAmt; "Total TDS Including SHE CESS")
                {
                }
                dataitem(Integerloop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        ORDER(Ascending);
                    column(AccountName; AccountName)
                    {
                    }
                    column(ABS_DetailAmt_; ABS(DetailAmt))
                    {
                    }
                    column(DrCrText; DrCrText)
                    {
                    }
                    column(Integerloop_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        DrCrText := '';

                        IF Number > 1 THEN
                            GLEntry.NEXT;


                        DetailAmt := 0;
                        DetailAmt := GLEntry.Amount;
                        IF DetailAmt > 0 THEN
                            DrCrText := 'Dr';
                        IF DetailAmt < 0 THEN
                            DrCrText := 'Cr';
                        AccountName := Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.");//a
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETRANGE(Number, 1, GLEntry.COUNT);


                        //IF GLEntry.COUNT = 1 THEN
                        //  CurrReport.BREAK;
                    end;
                }
                dataitem("Posted Narration"; "Posted Narration")
                {
                    DataItemLink = "Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.")
                                        ORDER(Ascending);
                    column(Posted_Narration_Narration; Narration)
                    {
                    }
                    column(Posted_Narration_Entry_No_; "Entry No.")
                    {
                    }
                    column(Posted_Narration_Transaction_No_; "Transaction No.")
                    {
                    }
                    column(Posted_Narration_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem();
                    begin
                        IF NOT PrintLineNarr THEN
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Posted Narration1"; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD("Transaction No.");
                    DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.")
                                        WHERE("Entry No." = FILTER(0));
                    column(Posted_Narration1_Narration; Narration)
                    {
                    }
                    column(Posted_Narration1_Entry_No_; "Entry No.")
                    {
                    }
                    column(Posted_Narration1_Transaction_No_; "Transaction No.")
                    {
                    }
                    column(Posted_Narration1_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem();
                    begin
                        IF NOT PrintVoucherNarr THEN
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
                {
                    DataItemLink = "No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No.")
                                        ORDER(Ascending);
                    column(Purch__Inv__Header__Posting_Description_; "Posting Description")
                    {
                    }
                    column(Purch__Inv__Header__Purch__Inv__Header__Narration; '')
                    {
                    }
                    column(Purch__Inv__Header_No_; "No.")
                    {
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    //NMS 25Mar09 start
                    //GLEntry.SETRANGE(GLEntry."Document No.","Vendor Ledger Entry"."Document No.");
                    GLEntry.SETRANGE(GLEntry."Transaction No.", "Vendor Ledger Entry"."Transaction No.");
                    IF GLEntry.FINDFIRST THEN;

                    IF "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Payment THEN BEGIN
                        BankLedger.RESET;
                        BankLedger.SETRANGE(BankLedger."Document No.", "Vendor Ledger Entry"."Document No.");
                        IF BankLedger.FINDFIRST THEN
                            IF BankAcc.GET(BankLedger."Bank Account No.") THEN
                                ControlAccountName := BankAcc.Name;
                    END ELSE BEGIN
                        NewGLEntry.RESET;
                        NewGLEntry.SETRANGE(NewGLEntry."Document No.", "Vendor Ledger Entry"."Document No.");
                        IF NewGLEntry.FINDFIRST THEN BEGIN
                            NewGLEntry.CALCFIELDS(NewGLEntry."G/L Account Name");
                            ControlAccountName := NewGLEntry."G/L Account Name";
                        END;
                    END;

                    IF "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Payment THEN BEGIN
                        recBankAccountLedgerEntry.RESET;
                        recBankAccountLedgerEntry.SETRANGE(recBankAccountLedgerEntry."Document No.", "Vendor Ledger Entry"."Document No.");
                        IF recBankAccountLedgerEntry.FINDFIRST THEN BEGIN
                            VendInvChequeNo := recBankAccountLedgerEntry."Cheque No.";
                            VendInvChequedate := recBankAccountLedgerEntry."Cheque Date";
                        END;
                    END ELSE BEGIN
                        recPurchaseInvHeader.RESET;
                        recPurchaseInvHeader.SETRANGE(recPurchaseInvHeader."No.", "Vendor Ledger Entry"."Document No.");
                        IF recPurchaseInvHeader.FINDFIRST THEN BEGIN
                            VendInvChequeNo := recPurchaseInvHeader."Vendor Invoice No.";
                            VendInvChequedate := recPurchaseInvHeader."Document Date";
                        END;
                    END;


                    //NMS 25Mar09 end

                    CALCFIELDS(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)");
                    CALCFIELDS("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
                    VendLedgEntryExists := TRUE;
                    //NMS start
                    VendAmount := "Amount (LCY)";
                    VendDBAmount := "Debit Amount (LCY)";
                    VendCRAmount := "Credit Amount (LCY)";
                    VendRemainAmount := "Remaining Amt. (LCY)";
                    VendorBalance := VendorBalance + "Amount (LCY)";
                    VendCurrencyCode := '';

                    //NMS End
                    VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    //VendBalance := VendBalance + Amount;

                    IF ("Document Type" = "Document Type"::Payment) OR ("Document Type" = "Document Type"::Refund) THEN
                        VendEntryDueDate := 0D
                    ELSE
                        VendEntryDueDate := "Due Date";

                    TotDBAmount := TotDBAmount + VendDBAmount;
                    TotCRAmount := TotCRAmount + VendCRAmount;
                    //MESSAGE(FORMAT((AccountName)));
                end;

                trigger OnPreDataItem();
                begin
                    VendLedgEntryExists := FALSE;
                    CurrReport.CREATETOTALS(VendAmount, "Amount (LCY)");
                    CurrReport.CREATETOTALS(VendDBAmount, "Debit Amount (LCY)");        // vikas 030206
                    CurrReport.CREATETOTALS(VendCRAmount, "Credit Amount (LCY)");       // vikas 030206

                    GLEntry.RESET;//NMS 25Mar09
                    GLEntry.SETCURRENTKEY("Transaction No.");
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(ABS_VendorBalance__Control1000000029; ABS(VendorBalance))
                {
                    AutoFormatType = 1;
                }
                column(Vendor_Name_Control1000000031; Vendor.Name)
                {
                }
                column(DrCrBalanceText_Control1000000022; DrCrBalanceText)
                {
                }
                column(Closing_BalanceCaption; Closing_BalanceCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF NOT VendLedgEntryExists AND ((StartBalanceLCY = 0) OR ExcludeBalanceOnly) THEN BEGIN
                        StartBalanceLCY := 0;
                        CurrReport.SKIP;
                    END;
                    // vikas 030306
                    IF NOT VendLedgEntryExists AND ((StartBalance = 0) OR ExcludeBalanceOnly) THEN BEGIN
                        StartBalance := 0;
                        CurrReport.SKIP;
                    END;
                    // vikas 030306
                end;
            }

            trigger OnAfterGetRecord();
            begin
                //Vendor.SETFILTER(Vendor."No.",VendNo);
                StartBalanceLCY := 0;
                StartBalAdjLCY := 0;
                StartBalance := 0;              // vikas 030306
                StartBalAdj := 0;               // vikas 030306
                VendorBalance := 0;

                IF VendDateFilter <> '' THEN BEGIN
                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("Net Change (LCY)");
                        CALCFIELDS("Net Change");                        // vikas 030306
                        StartBalanceLCY := -1 * "Net Change (LCY)";   // Madhav 13-05-2006 -1 * is added as the CalcFormula contain (-)ve sign
                        StartBalance := -1 * "Net Change";                  // vikas 030306
                    END;
                    SETFILTER("Date Filter", VendDateFilter);
                    CALCFIELDS("Net Change (LCY)");
                    CALCFIELDS("Net Change");                      // vikas 030306
                    StartBalAdjLCY := -1 * "Net Change (LCY)";     // Madhav 13-05-2006 -1 * is added as the CalcFormula contain (-)ve sign
                    StartBalAdj := -1 * "Net Change";                 // vikas 030306
                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                    VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                    VendorLedgerEntry.SETFILTER("Posting Date", VendDateFilter);
                    IF VendorLedgerEntry.FIND('-') THEN
                        REPEAT
                            VendorLedgerEntry.SETFILTER("Date Filter", VendDateFilter);
                            VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
                            VendorLedgerEntry.CALCFIELDS(Amount);                 // vikas 030306
                            StartBalAdjLCY := StartBalAdjLCY - VendorLedgerEntry."Amount (LCY)";
                            StartBalAdj := StartBalAdj - VendorLedgerEntry.Amount;
                        UNTIL VendorLedgerEntry.NEXT = 0;
                END;
                //CurrReport.PRINTONLYIFDETAIL :=  ExcludeBalanceOnly OR (StartBalanceLCY = 0); //PCPL/MIG/NSW Filed not Exist in BC18
                //CurrReport.PRINTONLYIFDETAIL :=  ExcludeBalanceOnly OR (StartBalance = 0);    //PCPL/MIG/NSW Filed not Exist in BC18
                // vikas 030306
                VendBalanceLCY := StartBalanceLCY + StartBalAdjLCY;
                VendBalance := StartBalance + StartBalAdj;                        // vikas 030306

                IF NOT PrintAmountsInLCY THEN
                    VendorBalance := StartBalance
                ELSE                                        // vikas 030306
                    VendorBalance := StartBalanceLCY;

                IF StartBalanceLCY > 0 THEN
                    DrCrBalanceText := 'Dr'
                ELSE
                    DrCrBalanceText := 'Cr';
            end;

            trigger OnPreDataItem();
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                CurrReport.CREATETOTALS("Vendor Ledger Entry"."Amount (LCY)", StartBalanceLCY, Correction, ApplicationRounding);
                CurrReport.CREATETOTALS("Vendor Ledger Entry"."Debit Amount (LCY)", "Vendor Ledger Entry"."Credit Amount (LCY)");
                CurrReport.CREATETOTALS(StartBalance, StartBalAdj, Correct, AppRounding);

                companyInfo.GET;
                FormatAddr.Company(CompanyAddr, companyInfo);

                //Vendor.SETFILTER(Vendor."No.",VendNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    CaptionML = ENU = 'Options',
                                ENN = 'Options';
                    field(PrintLineNarr; PrintLineNarr)
                    {
                        CaptionML = ENU = 'Print Line Narration',
                                    ENN = 'Show Amounts in LCY';
                    }
                    field(PrintVoucherNarr; PrintVoucherNarr)
                    {
                        Caption = 'Print Vouche rNarration';
                    }
                    field(PrintDetail; PrintDetail)
                    {
                        Caption = 'Print Detail';
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
        //PrintExcel:=TRUE;
    end;

    trigger OnPostReport();
    begin
        IF PrintExcel THEN
            ViewBook('', '');
    end;

    trigger OnPreReport();
    begin
        // **MWORLD1.00**CUSTMISC**003**270311**AM   start

        IF PrintExcel THEN BEGIN
            CreateBook;
            companyInfo.GET;
            FormatAddr.Company(CompanyAddr, companyInfo);
            PrintCell(ColNo, RowNo, CompanyAddr[1], 0, 1, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, CompanyAddr[2], 1, 0, FALSE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, CompanyAddr[3], 1, 0, FALSE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, CompanyAddr[4], 5, 1, FALSE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, FORMAT(TODAY), -7, 1, FALSE, FALSE, FALSE, '');

            PrintCell(ColNo, RowNo, 'Vendor Ledger for the period', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, Vendor.GETFILTER(Vendor."Date Filter"), -1, 1, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Vendor No', 1, 0, FALSE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, Vendor.GETFILTER(Vendor."No."), -1, 2, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'All Amounts are in LCY', 0, 1, FALSE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'This report also includes vendors that only have balances.', 0, 2, FALSE, FALSE, FALSE, '');

            //PrintCell(ColNo,RowNo,'Date Filter :',1,0,FALSE,FALSE,FALSE,'');
            //PrintCell(ColNo,RowNo,Vendor.GETFILTER(Vendor."Date Filter"),-3,2,FALSE,FALSE,FALSE,'');

            PrintCell(ColNo, RowNo, 'Posting Date', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Document No.', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Description', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Vendor Bill No./Cheque No.', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Date', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Debit Amount(LCY)', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Credit Amount(LCY)', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Balance (LCY)', 1, 0, TRUE, FALSE, FALSE, '');
            //**MWORLD1.00**CUSTMISC**060511**MD Start
            grecGnlLedSetup.GET;
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 1 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 2 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 3 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 4 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 5 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 6 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 7 Code", 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Employee Code', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'FD Code', 1, 0, TRUE, FALSE, FALSE, '');
            PrintCell(ColNo, RowNo, 'Telephone Code', -17, 1, TRUE, FALSE, FALSE, '');
            //**MWORLD1.00**CUSTMISC**060511**MD End

        END;

        // **MWORLD1.00**CUSTMISC**003**270311**AM   end

        VendFilter := Vendor.GETFILTERS;
        VendDateFilter := Vendor.GETFILTER("Date Filter");

        WITH "Vendor Ledger Entry" DO
            IF PrintAmountsInLCY THEN BEGIN
                AmountCaption := FIELDCAPTION("Amount (LCY)");
                //**CFL1.00.49**CUSTMISC**003**210708**Nitin Start
                /*Code Commented
                DebitCaption := FIELDCAPTION("Debit Amount (LCY)");            // vikas 030306
                CreditCaption := FIELDCAPTION("Credit Amount (LCY)");          // vikas 030306
                */
                DebitCaption := 'Debit Amt. (LCY)';
                CreditCaption := 'Credit Amt. (LCY)';
                //**CFL1.00.49**CUSTMISC**003**210708**Nitin End
                RemainingAmtCaption := FIELDCAPTION("Remaining Amt. (LCY)");
                BalanceCaption := Vendor.FIELDCAPTION(Vendor."Balance (LCY)");            //  vikas 030306
            END ELSE BEGIN
                AmountCaption := FIELDCAPTION(Amount);
                DebitCaption := FIELDCAPTION("Debit Amount");            // vikas 030306
                CreditCaption := FIELDCAPTION("Credit Amount");          // vikas 030306
                RemainingAmtCaption := FIELDCAPTION("Remaining Amount");
                BalanceCaption := Vendor.FIELDCAPTION(Vendor.Balance);            //  vikas 030306
            END;

    end;

    var
        Text000: Label 'Period: %1';
        VendorLedgerEntry: Record 25;
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        VendAmount: Decimal;
        VendRemainAmount: Decimal;
        VendBalanceLCY: Decimal;
        VendEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        ExcludeBalanceOnly: Boolean;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        VendLedgEntryExists: Boolean;
        AmountCaption: Text[30];
        RemainingAmtCaption: Text[30];
        VendCurrencyCode: Code[10];
        "----vikas -----": Integer;
        StartBalance: Decimal;
        StartBalAdj: Decimal;
        Correct: Decimal;
        AppRounding: Decimal;
        BalanceCaption: Text[40];
        VendBalance: Decimal;
        VendDBAmount: Decimal;
        VendCRAmount: Decimal;
        VendorBalance: Decimal;
        TotDBAmount: Decimal;
        TotCRAmount: Decimal;
        DebitCaption: Text[40];
        CreditCaption: Text[40];
        Text001: Label 'Appln Rounding:';
        Text002: Label 'Application Rounding';
        CompanyAddr: array[8] of Text[50];
        companyInfo: Record 79;
        FormatAddr: Codeunit 365;
        App2DocNo: Text[1024];
        BankLedger: Record 271;
        ok: Boolean;
        DBCR: Text[2];
        "--JDIL---": Integer;
        PrintLineNarr: Boolean;
        PrintVoucherNarr: Boolean;
        GLEntry: Record 17;
        FirstRecord: Boolean;
        DrCrText: Text[2];
        ControlAccountName: Text[50];
        AccountName: Text[50];
        DetailAmt: Decimal;
        PrintDetail: Boolean;
        Text16500: Label 'As per Details';
        Daybook: Report 18929;
        NewGLEntry: Record 17;
        BankAcc: Record 270;
        recPurchaseInvHeader: Record 122;
        VendInvChequeNo: Code[20];
        VendInvChequedate: Date;
        recBankAccountLedgerEntry: Record 271;
        DrCrBalanceText: Text[2];
        grecGnlLedSetup: Record 98;
        "--Automation--": Integer;
        ColumnName: Text[30];
        x: Integer;
        grecexcelbuffer: Record 370;
        ColNo: Integer;
        RowNo: Integer;
        PrintExcel: Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Vendor_LedgerCaptionLbl: Label 'Vendor Ledger';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        This_report_also_includes_vendors_that_only_have_balances_CaptionLbl: Label 'This report also includes vendors that only have balances.';
        Document_No_CaptionLbl: Label 'Document No.';
        Posting_DateCaptionLbl: Label 'Posting Date';
        Vendor_Bill_No__Cheque_No_CaptionLbl: Label 'Vendor Bill No./Cheque No.';
        DateCaptionLbl: Label 'Date';
        DescriptionCaptionLbl: Label 'Description';
        Opening_BalanceCaptionLbl: Label 'Opening Balance';
        Closing_BalanceCaptionLbl: Label 'Closing Balance';
        VendNo: Code[20];

    procedure CreateBook();
    begin
        /*IF NOT CREATE(XlApp,TRUE) THEN
           ERROR('');
        XlApp.Visible(FALSE);
        XlWrkbk := XlApp.Workbooks.Add;
        Xlwrksht := XlWrkbk.Worksheets.Add;
         */
        ColNo := 1;
        RowNo := 1;

    end;

    procedure PrintCell(Column: Integer; Row: Integer; Text: Text[100]; IncCol: Integer; IncRow: Integer; IsBold: Boolean; IsItalic: Boolean; IsUnderline: Boolean; NumberFormat: Text[30]);
    var
        xlUnderlineStyleSingle: Text[30];
    begin
        x := Column;
        ColID();
        /*
        IF NumberFormat <> '' THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).NumberFormat := NumberFormat;
        
        Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Value:=Text;
        IF IsBold THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Font.Bold :=TRUE;
        IF IsItalic THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Font.Italic :=TRUE;
        IF IsUnderline THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Font.Underline := TRUE;
         */
        ColNo += IncCol;
        RowNo += IncRow;

    end;

    procedure ColID();
    var
        i: Integer;
        y: Integer;
        c: Char;
        t: Text[30];
    begin
        ColumnName := '';
        WHILE x > 26 DO BEGIN
            y := x MOD 26;
            IF y = 0 THEN
                y := 26;
            c := 64 + y;
            i := i + 1;
            t[i] := c;
            x := (x - y) DIV 26;
        END;
        IF x > 0 THEN BEGIN
            c := 64 + x;
            i := i + 1;
            t[i] := c;
        END;
        FOR x := 1 TO i DO
            ColumnName[x] := t[1 + i - x];
    end;

    procedure ViewBook(BookName: Text[30]; SheetName: Text[30]);
    begin
        /*IF BookName <> '' THEN
        XlWrkbk.SaveAs(BookName);
        IF SheetName <> '' THEN
        Xlwrksht.Name :=SheetName;
        XlApp.Visible(TRUE);
        XlApp.UserControl(TRUE);
        CLEAR(XlApp);
         */

    end;

    procedure SetDocumentNo(DocNo: Code[20]);
    begin
        VendNo := DocNo;
    end;
}

