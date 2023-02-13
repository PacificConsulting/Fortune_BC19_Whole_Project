report 50022 "Vendor Ageing New"
{
    // version NAVW19..48067 CCIT AN

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Vendor Ageing New.rdl';
    CaptionML = ENU='Aged Accounts Payable',
                ENN='Aged Accounts Payable';
                ApplicationArea=all;
                UsageCategory=ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyName;COMPANYNAME)
            {
            }
            column(NewPagePerVendor;NewPagePerVendor)
            {
            }
            column(AgesAsOfEndingDate;STRSUBSTNO(Text006,FORMAT(EndingDate,0,4)))
            {
            }
            column(SelectAgeByDuePostngDocDt;STRSUBSTNO(Text007,SELECTSTR(AgingBy + 1,Text009)))
            {
            }
            column(PrintAmountInLCY;PrintAmountInLCY)
            {
            }
            column(CaptionVendorFilter;TABLECAPTION + ': ' + VendorFilter)
            {
            }
            column(VendorFilter;VendorFilter)
            {
            }
            column(AgingBy;AgingBy)
            {
            }
            column(SelctAgeByDuePostngDocDt1;STRSUBSTNO(Text004,SELECTSTR(AgingBy + 1,Text009)))
            {
            }
            column(HeaderText9;HeaderText[9])
            {
            }
            column(HeaderText8;HeaderText[8])
            {
            }
            column(HeaderText7;HeaderText[7])
            {
            }
            column(HeaderText6;HeaderText[6])
            {
            }
            column(HeaderText5;HeaderText[5])
            {
            }
            column(HeaderText4;HeaderText[4])
            {
            }
            column(HeaderText3;HeaderText[3])
            {
            }
            column(HeaderText2;HeaderText[2])
            {
            }
            column(HeaderText1;HeaderText[1])
            {
            }
            column(PrintDetails;PrintDetails)
            {
            }
            column(GrandTotalVLE9RemAmtLCY;GrandTotalVLERemaingAmtLCY[9])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE8RemAmtLCY;GrandTotalVLERemaingAmtLCY[8])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE7RemAmtLCY;GrandTotalVLERemaingAmtLCY[7])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE6RemAmtLCY;GrandTotalVLERemaingAmtLCY[6])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE5RemAmtLCY;GrandTotalVLERemaingAmtLCY[5])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE4RemAmtLCY;GrandTotalVLERemaingAmtLCY[4])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE3RemAmtLCY;GrandTotalVLERemaingAmtLCY[3])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE2RemAmtLCY;GrandTotalVLERemaingAmtLCY[2])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1RemAmtLCY;GrandTotalVLERemaingAmtLCY[1])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1AmtLCY;GrandTotalVLEAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(No_Vendor;"No.")
            {
            }
            column(AgedAcctPayableCaption;AgedAcctPayableCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(AllAmtsinLCYCaption;AllAmtsinLCYCaptionLbl)
            {
            }
            column(AgedOverdueAmsCaption;AgedOverdueAmsCaptionLbl)
            {
            }
            column(GrandTotalVLE5RemAmtLCYCaption;GrandTotalVLE5RemAmtLCYCaptionLbl)
            {
            }
            column(AmountLCYCaption;AmountLCYCaptionLbl)
            {
            }
            column(DocDateCaption;DocDateCaptionLbl)
            {
            }
            column(DueDateCaption;DueDateCaptionLbl)
            {
            }
            column(DocumentNoCaption;DocumentNoCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption;DocumentTypeCaptionLbl)
            {
            }
            column(VendorNoCaption;FIELDCAPTION("No."))
            {
            }
            column(VendorNameCaption;FIELDCAPTION(Name))
            {
            }
            column(CurrencyCaption;CurrencyCaptionLbl)
            {
            }
            column(PostingGroupCaption;PostingGroupCaptionLbl)
            {
            }
            column(PurchaserCodeCaption;PurchaserCodeCaptionLbl)
            {
            }
            column(CreditPeriodCaption;CreditPeriodCaptionLbl)
            {
            }
            column(FCBookedCaption;FCBookedCaptionLbl)
            {
            }
            column(FCAMTCaption;FCAmtCaptionLbl)
            {
            }
            column(LocationCaption;LocationCaptionLbl)
            {
            }
            column(TotalLCYCaption;TotalLCYCaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=FIELD("No.");
                DataItemTableView = SORTING("Vendor No.","Posting Date","Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord();
                var
                    VendorLedgEntry : Record 25;
                begin
                    VendorLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                    VendorLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
                    VendorLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
                    IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        InsertTemp(VendorLedgEntry);
                      UNTIL VendorLedgEntry.NEXT = 0;

                    IF "Closed by Entry No." <> 0 THEN BEGIN
                      VendorLedgEntry.SETRANGE("Closed by Entry No.","Closed by Entry No.");
                      IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                        REPEAT
                          InsertTemp(VendorLedgEntry);
                        UNTIL VendorLedgEntry.NEXT = 0;
                    END;

                    VendorLedgEntry.RESET;
                    VendorLedgEntry.SETRANGE("Entry No.","Closed by Entry No.");
                    VendorLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
                    IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                      REPEAT
                        InsertTemp(VendorLedgEntry);
                      UNTIL VendorLedgEntry.NEXT = 0;
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE("Posting Date",EndingDate + 1,99991231D);
                end;
            }
            dataitem(OpenVendorLedgEntry;"Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=FIELD("No.");
                DataItemTableView = SORTING("Vendor No.",Open,Positive,"Due Date","Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord();
                begin
                    IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                      CALCFIELDS("Remaining Amt. (LCY)");
                      IF "Remaining Amt. (LCY)" = 0 THEN
                        CurrReport.SKIP;
                    END;
                    InsertTemp(OpenVendorLedgEntry);
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem();
                begin
                    IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                      SETRANGE("Posting Date",0D,EndingDate);
                      SETRANGE("Date Filter",0D,EndingDate);
                    END
                end;
            }
            dataitem(CurrencyLoop;Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number=FILTER(1..));
                PrintOnlyIfDetail = true;
                dataitem(TempVendortLedgEntryLoop;Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number=FILTER(1..));
                    column(VendorName;Vendor.Name)
                    {
                    }
                    column(VendorNo;Vendor."No.")
                    {
                    }
                    column(PostingGroup;Vendor."Vendor Posting Group")
                    {
                    }
                    column(PurchPersonCode;Vendor."Purchaser Code")
                    {
                    }
                    column(Location_code;Vendor."Location Code")
                    {
                    }
                    column(Location;Location)
                    {
                    }
                    column(City;City)
                    {
                    }
                    column(PaymentTerms;Vendor."Payment Terms Code")
                    {
                    }
                    column(CurrencyCode;Vendor."Currency Code")
                    {
                    }
                    column(VLEEndingDateRemAmtLCY;VendorLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVLE1RemAmtLCY;AgedVendorLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmtLCY;AgedVendorLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmtLCY;AgedVendorLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmtLCY;AgedVendorLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmtLCY;AgedVendorLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt6RemAmtLCY;AgedVendorLedgEntry[6]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt7RemAmtLCY;AgedVendorLedgEntry[7]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt8RemAmtLCY;AgedVendorLedgEntry[8]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt9RemAmtLCY;AgedVendorLedgEntry[9]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtAmtLCY;VendorLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtDueDate;FORMAT(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocNo;VendorLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(VendLedgEntyEndgDtDocType;FORMAT(VendorLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(VendLedgEntryEndDtPostgDt;FORMAT(VendorLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocDate;FORMAT(VendorLedgEntryEndingDate."Document Date"))
                    {
                    }
                    column(AgedVendLedgEnt9RemAmt;AgedVendorLedgEntry[9]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt8RemAmt;AgedVendorLedgEntry[8]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt7RemAmt;AgedVendorLedgEntry[7]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt6RemAmt;AgedVendorLedgEntry[6]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmt;AgedVendorLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmt;AgedVendorLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmt;AgedVendorLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmt;AgedVendorLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt1RemAmt;AgedVendorLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VLEEndingDateRemAmt;VendorLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndingDtAmt;VendorLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalVendorName;STRSUBSTNO(Text005,Vendor.Name))
                    {
                    }
                    column(CurrCode_TempVenLedgEntryLoop;CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord();
                    var
                        PeriodIndex : Integer;
                    begin
                        IF Number = 1 THEN BEGIN
                          IF NOT TempVendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                            CurrReport.BREAK;
                        END ELSE
                          IF TempVendorLedgEntry.NEXT = 0 THEN
                            CurrReport.BREAK;

                        //CCIT AN
                        CLEAR(Location);
                        CLEAR(City);
                        Rec_Location.RESET;
                        Rec_Location.SETRANGE(Rec_Location.Code,Vendor."Location Code");
                          IF Rec_Location.FINDFIRST THEN   BEGIN
                             Location := Rec_Location.Name;
                             City := Rec_Location.City;
                          END;
                        //CCIT AN--

                        VendorLedgEntryEndingDate := TempVendorLedgEntry;
                        DetailedVendorLedgerEntry.SETRANGE(DetailedVendorLedgerEntry."Vendor Ledger Entry No.",VendorLedgEntryEndingDate."Entry No.");
                        IF DetailedVendorLedgerEntry.FINDSET(FALSE,FALSE) THEN
                          REPEAT
                            IF (DetailedVendorLedgerEntry."Entry Type" =
                                DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") AND
                               (VendorLedgEntryEndingDate."Posting Date" > EndingDate) AND
                               (AgingBy <> AgingBy::"Posting Date")
                            THEN BEGIN
                              IF VendorLedgEntryEndingDate."Document Date" <= EndingDate THEN
                                DetailedVendorLedgerEntry."Posting Date" :=
                                  VendorLedgEntryEndingDate."Document Date"
                              ELSE
                                IF (VendorLedgEntryEndingDate."Due Date" <= EndingDate) AND
                                   (AgingBy = AgingBy::"Due Date")
                                THEN
                                  DetailedVendorLedgerEntry."Posting Date" :=
                                    VendorLedgEntryEndingDate."Due Date"
                            END;

                            IF (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) OR
                               (TempVendorLedgEntry.Open AND
                                (AgingBy = AgingBy::"Due Date") AND
                                (VendorLedgEntryEndingDate."Due Date" > EndingDate) AND
                                (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                            THEN BEGIN
                              IF DetailedVendorLedgerEntry."Entry Type" IN
                                 [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                  DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                  DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                  DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                  DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                  DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                              THEN BEGIN
                                VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                VendorLedgEntryEndingDate."Amount (LCY)" :=
                                  VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                              END;
                              IF DetailedVendorLedgerEntry."Posting Date" <= EndingDate THEN BEGIN
                                VendorLedgEntryEndingDate."Remaining Amount" :=
                                  VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                  VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                              END;
                            END;
                          UNTIL DetailedVendorLedgerEntry.NEXT = 0;

                        IF VendorLedgEntryEndingDate."Remaining Amount" = 0 THEN
                          CurrReport.SKIP;

                        CASE AgingBy OF
                          AgingBy::"Due Date":
                            PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                          AgingBy::"Posting Date":
                            PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                          AgingBy::"Document Date":
                            BEGIN
                              IF VendorLedgEntryEndingDate."Document Date" > EndingDate THEN BEGIN
                                VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                              END;
                              PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                            END;
                        END;
                        CLEAR(AgedVendorLedgEntry);
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        //  Excel
                        MakeExcelDataBody;
                    end;

                    trigger OnPostDataItem();
                    var
                        VendorRow : Integer;
                        LedgerRow : Integer;
                    begin
                        IF NOT PrintAmountInLCY THEN
                          UpdateCurrencyTotals;
                        // Excel
                        /*ExcelBuffer.UTgetGlobalValue('CurrentRow',CurrentLedgerEntryRow);
                        EVALUATE(VendorRow,FORMAT(CurrentVendorRow));
                        EVALUATE(LedgerRow,FORMAT(CurrentLedgerEntryRow));
                        IF  VendorRow < LedgerRow THEN BEGIN
                            ExcelBuffer.SetCurrent(CurrentVendorRow,0);
                            CreateVendorRow;
                        END;
                        ExcelBuffer.SetCurrent(CurrentLedgerEntryRow,0);*/
                        CreateTotalRow;

                    end;

                    trigger OnPreDataItem();
                    begin
                        IF NOT PrintAmountInLCY THEN
                          TempVendorLedgEntry.SETRANGE(TempVendorLedgEntry."Currency Code",TempCurrency.Code);
                        // Excel
                        /*ExcelBuffer.UTgetGlobalValue('CurrentRow',CurrentVendorRow);
                        ExcelBuffer.NewRow;*/

                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    CLEAR(TotalVendorLedgEntry);

                    IF Number = 1 THEN BEGIN
                      IF NOT TempCurrency.FINDSET(FALSE,FALSE) THEN
                        CurrReport.BREAK;
                    END ELSE
                      IF TempCurrency.NEXT = 0 THEN
                        CurrReport.BREAK;

                    IF TempCurrency.Code <> '' THEN
                      CurrencyCode := TempCurrency.Code
                    ELSE
                      CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPostDataItem();
                begin
                    IF NewPagePerVendor AND (NumberOfCurrencies > 0) THEN
                      CurrReport.NEWPAGE;
                end;

                trigger OnPreDataItem();
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF NewPagePerVendor THEN
                  PageGroupNo := PageGroupNo + 1;

                TempCurrency.RESET;
                TempCurrency.DELETEALL;
                TempVendorLedgEntry.RESET;
                TempVendorLedgEntry.DELETEALL;
                CLEAR(GrandTotalVLERemaingAmtLCY);
                GrandTotalVLEAmtLCY := 0;
            end;

            trigger OnPostDataItem();
            begin
                // Excel
                CreateTotal;
            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 1;
                //  Excel
                SrNo := 0;
                MakeExcelInfo;
            end;
        }
        dataitem(CurrencyTotals;Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number=FILTER(1..));
            column(Number_CurrencyTotals;Number)
            {
            }
            column(NewPagePerVend_CurrTotal;NewPagePerVendor)
            {
            }
            column(TempCurrency2Code;TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt10RemAmtLCY1;AgedVendorLedgEntry[10]."Remaining Amount")
            {
            }
            column(AgedVendLedgEnt1RemAmtLCY1;AgedVendorLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt2RemAmtLCY2;AgedVendorLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt3RemAmtLCY3;AgedVendorLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt4RemAmtLCY4;AgedVendorLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt5RemAmtLCY5;AgedVendorLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt6RemAmtLCY6;AgedVendorLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt7RemAmtLCY7;AgedVendorLedgEntry[7]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt8RemAmtLCY8;AgedVendorLedgEntry[8]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt9RemAmtLCY9;AgedVendorLedgEntry[9]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrencySpecificationCaption;CurrencySpecificationCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                  IF NOT TempCurrency2.FINDSET(FALSE,FALSE) THEN
                    CurrReport.BREAK;
                END ELSE
                  IF TempCurrency2.NEXT = 0 THEN
                    CurrReport.BREAK;

                CLEAR(AgedVendorLedgEntry);
                TempCurrencyAmount.SETRANGE("Currency Code",TempCurrency2.Code);
                IF TempCurrencyAmount.FINDSET(FALSE,FALSE) THEN
                  REPEAT
                    IF TempCurrencyAmount.Date <> 99991231D THEN   //12319999D //PCPL/MIG/NSW
                      AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                        TempCurrencyAmount.Amount
                    ELSE
                      AgedVendorLedgEntry[10]."Remaining Amount" := TempCurrencyAmount.Amount;
                  UNTIL TempCurrencyAmount.NEXT = 0;
            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 0;
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
                    CaptionML = ENU='Options',
                                ENN='Options';
                    field(AgedAsOf;EndingDate)
                    {
                        CaptionML = ENU='Aged As Of',
                                    ENN='Aged As Of';
                    }
                    field(AgingBy;AgingBy)
                    {
                        CaptionML = ENU='Aging by',
                                    ENN='Aging by';
                        OptionCaptionML = ENU='Due Date,Posting Date,Document Date',
                                          ENN='Due Date,Posting Date,Document Date';
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        CaptionML = ENU='Period Length',
                                    ENN='Period Length';
                        Editable = false;
                        //OptionCaption = '30D'; //PCPL/MIG/NSW
                        
                    }
                    field(PrintAmountInLCY;PrintAmountInLCY)
                    {
                        CaptionML = ENU='Print Amounts in LCY',
                                    ENN='Print Amounts in LCY';
                    }
                    field(PrintDetails;PrintDetails)
                    {
                        CaptionML = ENU='Print Details',
                                    ENN='Print Details';
                    }
                    field(HeadingType;HeadingType)
                    {
                        CaptionML = ENU='Heading Type',
                                    ENN='Heading Type';
                        Editable = false;
                        OptionCaptionML = ENU='Number of Days,Date Interval',
                                          ENN='Number of Days,Date Interval';
                    }
                    field(NewPagePerVendor;NewPagePerVendor)
                    {
                        CaptionML = ENU='New Page per Vendor',
                                    ENN='New Page per Vendor';
                    }
                    field("Print To Excel";ExcelData)
                    {
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            IF EndingDate = 0D THEN
              EndingDate := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        //  Excel
        IF ExcelData = TRUE  THEN
           CreateExcel;
    end;

    trigger OnPreReport();
    begin
        VendorFilter := Vendor.GETFILTERS;

        GLSetup.GET;

        CalcDates;
        CreateHeadings;
        // Excel
        ExcelBuffer.DELETEALL;
    end;

    var
        GLSetup : Record 98;
        TempVendorLedgEntry : Record 25 temporary;
        VendorLedgEntryEndingDate : Record 25;
        TotalVendorLedgEntry : array [9] of Record 25;
        AgedVendorLedgEntry : array [10] of Record 25;
        TempCurrency : Record 4 temporary;
        TempCurrency2 : Record 4 temporary;
        TempCurrencyAmount : Record 264 temporary;
        DetailedVendorLedgerEntry : Record 380;
        GrandTotalVLERemaingAmtLCY : array [9] of Decimal;
        GrandTotalVLEAmtLCY : Decimal;
        VendorFilter : Text;
        PrintAmountInLCY : Boolean;
        EndingDate : Date;
        AgingBy : Option "Due Date","Posting Date","Document Date";
        PeriodLength : DateFormula;
        PrintDetails : Boolean;
        HeadingType : Option "Number of Days","Date Interval";
        NewPagePerVendor : Boolean;
        PeriodStartDate : array [9] of Date;
        PeriodEndDate : array [9] of Date;
        HeaderText : array [9] of Text[30];
        Text000 : TextConst ENU='Not Due',ENN='Not Due';
        Text001 : TextConst ENU='Before',ENN='Before';
        CurrencyCode : Code[10];
        Text002 : TextConst ENU='days',ENN='days';
        Text003 : TextConst ENU='More than',ENN='More than';
        Text004 : TextConst ENU='Aged by %1',ENN='Aged by %1';
        Text005 : TextConst ENU='Total for %1',ENN='Total for %1';
        Text006 : TextConst ENU='Aged as of %1',ENN='Aged as of %1';
        Text007 : TextConst ENU='Aged by %1',ENN='Aged by %1';
        NumberOfCurrencies : Integer;
        Text009 : TextConst ENU='Due Date,Posting Date,Document Date',ENN='Due Date,Posting Date,Document Date';
        Text010 : TextConst ENU='The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.',ENN='The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
        PageGroupNo : Integer;
        EnterDateFormulaErr : TextConst ENU='Enter a date formula in the Period Length field.',ENN='Enter a date formula in the Period Length field.';
        Text027 : TextConst Comment='Negating the period length: %1 is the period length',ENU='-%1',ENN='-%1';
        AgedAcctPayableCaptionLbl : TextConst ENU='Aged Accounts Payable',ENN='Aged Accounts Payable';
        CurrReportPageNoCaptionLbl : TextConst ENU='Page',ENN='Page';
        AllAmtsinLCYCaptionLbl : TextConst ENU='All Amounts in LCY',ENN='All Amounts in LCY';
        AgedOverdueAmsCaptionLbl : TextConst ENU='Aged Overdue Amounts',ENN='Aged Overdue Amounts';
        GrandTotalVLE5RemAmtLCYCaptionLbl : TextConst ENU='Balance',ENN='Balance';
        AmountLCYCaptionLbl : TextConst ENU='Original Amount',ENN='Original Amount';
        DueDateCaptionLbl : TextConst ENU='Due Date',ENN='Due Date';
        DocDateCaptionLbl : Label 'Document Date';
        DocumentNoCaptionLbl : TextConst ENU='Document No.',ENN='Document No.';
        PostingDateCaptionLbl : TextConst ENU='Posting Date',ENN='Posting Date';
        DocumentTypeCaptionLbl : TextConst ENU='Document Type',ENN='Document Type';
        CurrencyCaptionLbl : TextConst ENU='Currency Code',ENN='Currency Code';
        TotalLCYCaptionLbl : TextConst ENU='Total (LCY)',ENN='Total (LCY)';
        CurrencySpecificationCaptionLbl : TextConst ENU='Currency Specification',ENN='Currency Specification';
        PostingGroupCaptionLbl : Label 'Vendor Posting Group';
        PurchaserCodeCaptionLbl : Label 'Purchase  Person Code';
        LocationCaptionLbl : Label 'Location';
        Rec_Location : Record 14;
        Location : Text[50];
        CreditPeriodCaptionLbl : Label '"Credit Period of Customer "';
        FCBookedCaptionLbl : Label 'FC Booked Rete';
        FCAmtCaptionLbl : Label 'FC Amount';
        City : Text[50];
        ExcelBuffer : Record 370;
        ExcelData : Boolean;
        Company_Info : Record 79;
        Date : Date;
        SrNo : Integer;
        CurrentLedgerEntryRow : Variant;
        CurrentVendorRow : Variant;
        BalanceTotal : Decimal;
        AgedByArrayTotal : array [9] of Decimal;

    local procedure CalcDates();
    var
        i : Integer;
        PeriodLength2 : DateFormula;
    begin
        //IF NOT EVALUATE(PeriodLength2,STRSUBSTNO(Text027,PeriodLength)) THEN   // CCIT AN Standard code
        IF NOT EVALUATE(PeriodLength2,STRSUBSTNO(Text027,'30D')) THEN //CCIT AN To hide Period Length from request Page, so made by default 30D
          ERROR(EnterDateFormulaErr);
        IF AgingBy = AgingBy::"Due Date" THEN BEGIN
          PeriodEndDate[1] := 99991231D;  //12319999D //PCPL/MIG/NSW
          PeriodStartDate[1] := EndingDate + 1;
        END ELSE BEGIN
          PeriodEndDate[1] := EndingDate;
          PeriodStartDate[1] := CALCDATE(PeriodLength2,EndingDate + 1);
        END;
        FOR i := 2 TO ARRAYLEN(PeriodEndDate) DO BEGIN
          PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
          PeriodStartDate[i] := CALCDATE(PeriodLength2,PeriodEndDate[i] + 1);
        END;

        i := ARRAYLEN(PeriodEndDate);

        PeriodStartDate[i] := 0D;

        FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
          IF PeriodEndDate[i] < PeriodStartDate[i] THEN
            ERROR(Text010,PeriodLength);
    end;

    local procedure CreateHeadings();
    var
        i : Integer;
    begin
        IF AgingBy = AgingBy::"Due Date" THEN BEGIN
          HeaderText[1] := Text000;
          i := 2;
        END ELSE
          i := 1;
        WHILE i < ARRAYLEN(PeriodEndDate) DO BEGIN
          IF HeadingType = HeadingType::"Date Interval" THEN
            HeaderText[i] := STRSUBSTNO('%1\..%2',PeriodStartDate[i],PeriodEndDate[i])
          ELSE
            /*HeaderText[i] :=
              STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
          i := i + 1;
        END;
        IF HeadingType = HeadingType::"Date Interval" THEN
          HeaderText[i] := STRSUBSTNO('%1\%2',Text001,PeriodStartDate[i - 1])
        ELSE
          HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);*/  // CCIT AN standard commented
        
        // CCIT AN -----
          //For Ading = Posting Date and Doccument date+++
            IF NOT (AgingBy = AgingBy::"Due Date") THEN BEGIN
             IF i = 7 THEN
              HeaderText[i] := STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] +156 ,Text002) //CCIT AN 181-365days
             ELSE
              IF i = 8 THEN
                HeaderText[i] := STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 155,EndingDate - PeriodStartDate[i]+491 ,Text002) //CCIT AN 365-730days
              ELSE
             HeaderText[i] :=
              STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
              END ELSE
              //For Ading = Posting Date and Doccument date------
        
               //For Ading = Due Date++++
               IF AgingBy = AgingBy::"Due Date" THEN BEGIN
                 IF i= 8 THEN
                 HeaderText[i] := STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] +156 ,Text002) //CCIT AN 181-365days
                 ELSE
                  HeaderText[i] :=
                     STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
                END ELSE
        
                  HeaderText[i] :=
                     STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
              //For Ading = Due Date-----
          i := i + 1;
        END;
        IF HeadingType = HeadingType::"Date Interval" THEN
          HeaderText[i] := STRSUBSTNO('%1\%2',Text001,PeriodStartDate[i - 1])
        ELSE
        
        //For Ading = Posting Date and Doccument date+++
        IF NOT (AgingBy = AgingBy::"Due Date") THEN BEGIN
          IF i = 9 THEN
            HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 491,Text002) // CCIT AN More than 730
          ELSE
          HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
        END ELSE
        
          //For Ading = Due Date+++
               IF AgingBy = AgingBy::"Due Date" THEN BEGIN
               IF i = 9 THEN
            HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 156,Text002) // More than
              ELSE
                HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
              END ELSE
        
               HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
        // CCIT AN

    end;

    local procedure InsertTemp(var VendorLedgEntry : Record 25);
    var
        Currency : Record 4;
    begin
        WITH TempVendorLedgEntry DO BEGIN
          IF GET(VendorLedgEntry."Entry No.") THEN
            EXIT;
          TempVendorLedgEntry := VendorLedgEntry;
          INSERT;
          IF PrintAmountInLCY THEN BEGIN
            CLEAR(TempCurrency);
            TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            IF TempCurrency.INSERT THEN;
            EXIT;
          END;
          IF TempCurrency.GET("Currency Code") THEN
            EXIT;
          IF "Currency Code" <> '' THEN
            Currency.GET("Currency Code")
          ELSE BEGIN
            CLEAR(Currency);
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
          END;
          TempCurrency := Currency;
          TempCurrency.INSERT;
        END;
    end;

    local procedure GetPeriodIndex(Date : Date) : Integer;
    var
        i : Integer;
    begin
        FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
          IF Date IN [PeriodStartDate[i]..PeriodEndDate[i]] THEN
            EXIT(i);
    end;

    local procedure UpdateCurrencyTotals();
    var
        i : Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        IF TempCurrency2.INSERT THEN;
        WITH TempCurrencyAmount DO BEGIN
          FOR i := 1 TO ARRAYLEN(TotalVendorLedgEntry) DO BEGIN
            "Currency Code" := CurrencyCode;
            Date := PeriodStartDate[i];
            IF FIND THEN BEGIN
              Amount := Amount + TotalVendorLedgEntry[i]."Remaining Amount";
              MODIFY;
            END ELSE BEGIN
              "Currency Code" := CurrencyCode;
              Date := PeriodStartDate[i];
              Amount := TotalVendorLedgEntry[i]."Remaining Amount";
              INSERT;
            END;
          END;
          "Currency Code" := CurrencyCode;
          Date := 99991231D;  //12319999D //PCPL/MIG/NSW
          IF FIND THEN BEGIN
            Amount := Amount + TotalVendorLedgEntry[1].Amount;
            MODIFY;
          END ELSE BEGIN
            "Currency Code" := CurrencyCode;
            Date := 99991231D;  //12319999D //PCPL/MIG/NSW
            Amount := TotalVendorLedgEntry[1].Amount;
            INSERT;
          END;
        END;
    end;

    procedure InitializeRequest(NewEndingDate : Date;NewAgingBy : Option;NewPeriodLength : DateFormula;NewPrintAmountInLCY : Boolean;NewPrintDetails : Boolean;NewHeadingType : Option;NewNewPagePerVendor : Boolean);
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePerVendor := NewNewPagePerVendor;
    end;

    procedure MakeExcelInfo();
    begin
        Company_Info.GET;
        Date := TODAY;
        ExcelBuffer.AddColumn(Company_Info.Name,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Page 1',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Vendor Aging Report',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Date,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Aging By',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(AgingBy,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Vendor',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(VendorFilter,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Vendor No.',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Name',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Posting Date',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document Type',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document Date',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document No',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Due Date',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Credit Period Of Cust.',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Location',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('City',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Currancy Code',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FC Booked Rate ',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FC Amount',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Posting Group',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Person Name',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Amount',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Balance',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        IF AgingBy = AgingBy::"Due Date" THEN
          BEGIN
              ExcelBuffer.AddColumn('Not Due',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('1-30 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('31-60 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('61-90 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('91-120 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('121-150 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('151-180 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('181-365 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('More Than\365 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
          END
          ELSE IF NOT (AgingBy = AgingBy::"Due Date") THEN
             BEGIN
              ExcelBuffer.AddColumn('1-30 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('31-60 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('61-90 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('91-120 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('121-150 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('151-180 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('181-365 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('365-730 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
              ExcelBuffer.AddColumn('More Than\730 Days',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
          END;
    end;

    local procedure MakeExcelDataBody();
    begin
        IF PrintDetails = TRUE THEN  BEGIN
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(Vendor."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Vendor.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate."Document Type",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate."Document Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate."Due Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(Vendor."Payment Terms Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Vendor."Location Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(City,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Vendor."Currency Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(Vendor."Vendor Posting Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Vendor."Purchaser Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate.Amount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(VendorLedgEntryEndingDate."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
            IF AgingBy = AgingBy::"Due Date" THEN   BEGIN
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[1]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[2]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[3]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[4]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[5]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[6]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[7]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[8]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                 ExcelBuffer.AddColumn(AgedVendorLedgEntry[9]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
              END
            ELSE IF NOT (AgingBy = AgingBy::"Due Date") THEN      BEGIN
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[1]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[2]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[3]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[4]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[5]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[6]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[7]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[8]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  ExcelBuffer.AddColumn(AgedVendorLedgEntry[9]."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
             END;
            BalanceTotal := BalanceTotal + VendorLedgEntryEndingDate."Remaining Amount";
            AgedByArrayTotal[1] := AgedByArrayTotal[1] + AgedVendorLedgEntry[1]."Remaining Amount";
            AgedByArrayTotal[2] := AgedByArrayTotal[2] + AgedVendorLedgEntry[2]."Remaining Amount";
            AgedByArrayTotal[3] := AgedByArrayTotal[3] + AgedVendorLedgEntry[3]."Remaining Amount";
            AgedByArrayTotal[4] := AgedByArrayTotal[4] + AgedVendorLedgEntry[4]."Remaining Amount";
            AgedByArrayTotal[5] := AgedByArrayTotal[5] + AgedVendorLedgEntry[5]."Remaining Amount";
            AgedByArrayTotal[6] := AgedByArrayTotal[6] + AgedVendorLedgEntry[6]."Remaining Amount";
            AgedByArrayTotal[7] := AgedByArrayTotal[7] + AgedVendorLedgEntry[7]."Remaining Amount";
            AgedByArrayTotal[8] := AgedByArrayTotal[8] + AgedVendorLedgEntry[8]."Remaining Amount";
            AgedByArrayTotal[9] := AgedByArrayTotal[9] + AgedVendorLedgEntry[9]."Remaining Amount";
         END;
    end;

    local procedure CreateTotalRow();
    begin
        IF PrintDetails = FALSE   THEN //IF PrintAmountInLCY = TRUE AND PrintDetails = TRUE THEN
          BEGIN
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(Vendor."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Vendor.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Vendor."Location Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(City,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(Vendor."Vendor Posting Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Vendor."Purchaser Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                //ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CurrencyCode,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(GrandTotalVLEAmtLCY,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[1],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[2],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[3],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[4],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[5],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[6],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[7],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[8],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[9],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
           END;
           IF PrintDetails = TRUE THEN BEGIN
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CurrencyCode,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(BalanceTotal,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            IF AgingBy = AgingBy::"Due Date" THEN  BEGIN
                ExcelBuffer.AddColumn(AgedByArrayTotal[1],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[2],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[3],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[4],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[5],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[6],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[7],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[8],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[9],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
             END
          ELSE IF NOT (AgingBy = AgingBy::"Due Date") THEN     BEGIN
                ExcelBuffer.AddColumn(AgedByArrayTotal[1],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[2],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[3],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[4],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[5],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[6],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[7],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[8],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(AgedByArrayTotal[9],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            END;
         END;
    end;

    local procedure CreateTotal();
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total (LCY)',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrandTotalVLEAmtLCY,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
        IF AgingBy = AgingBy::"Due Date" THEN
          BEGIN
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[1],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[2],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[3],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[4],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[5],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[6],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[7],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[8],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[9],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
          END
          ELSE IF NOT (AgingBy = AgingBy::"Due Date") THEN   BEGIN
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[1],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[2],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[3],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[4],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[5],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[6],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[7],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[8],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(GrandTotalVLERemaingAmtLCY[9],FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Number);
            END;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        IF AgingBy = AgingBy::"Due Date" THEN  BEGIN
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[1],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[2],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[3],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[4],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[5],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[6],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[7],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[8],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[9],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
               END
          ELSE IF NOT (AgingBy = AgingBy::"Due Date") THEN  BEGIN
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[1],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[2],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[3],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[4],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[5],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[6],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[7],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[8],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(AgedByArrayTotal[9],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                /*ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[1],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[2],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[3],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[4],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[5],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[6],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[7],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[8],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Pct(GrandTotalVLERemaingAmtLCY[9],VendorLedgEntryEndingDate."Remaining Amt. (LCY)"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
               */END;//GrandTotalVLERemaingAmtLCY[1]   AgedByArrayTotal[1]

    end;

    local procedure CreateExcel();
    begin
        ExcelBuffer.CreateBookAndOpenExcel('','Vendor Aging','Vendor Aging Report',COMPANYNAME,USERID);
         //PCPL/MIG/NSW
        ERROR('');
    end;

    local procedure Pct(a : Decimal;b : Decimal) : Text[30];
    begin
         // Excel for to 2 Decimal points
        IF b <> 0 THEN
          EXIT(FORMAT(ROUND(100 * a / b,0.01)) + '%');
    end;
}

