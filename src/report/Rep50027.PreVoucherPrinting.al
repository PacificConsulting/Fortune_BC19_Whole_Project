report 50027 "Pre-Voucher Printing"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Pre-Voucher Printing.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Document No.";
            column(rsJnlBatch_Description; rsJnlBatch.Description)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(STRSUBSTNO_Text066_CompanyInformation__E_Mail__; STRSUBSTNO(Text066, CompanyInformation."E-Mail"))
            {
            }
            column(Date_______FORMAT__Gen__Journal_Line___Posting_Date__; 'Date : ' + FORMAT("Gen. Journal Line"."Posting Date"))
            {
            }
            column(Voucher_No_________Gen__Journal_Line___Document_No__; 'Voucher No. : ' + "Gen. Journal Line"."Document No.")
            {
            }
            column(txtLocationAddress; txtLocationAddress)
            {
            }
            column(dblBalCredit; dblBalCredit)
            {
            }
            column(dblBalDebit; ROUND(dblBalDebit, 0.01))
            {
            }
            column(strBalAccountName; strBalAccountName)
            {
            }
            column(strBalContactName; strBalContactName)
            {
            }
            column(strDescription; strDescription)
            {
            }
            column(TotalLineDr; TotalLineDr)
            {
            }
            column(TotalLineCr; TotalLineCr)
            {
            }
            column(To_____strBalAccountName; 'To ' + strBalAccountName)
            {
            }
            column(dblBalDebit_Control1000000079; dblBalDebit)
            {
            }
            column(dblBalCredit_Control1000000080; dblBalCredit)
            {
            }
            column(strBalContactName_Control1000000005; strBalContactName)
            {
            }
            column(Servis_Tax; dblServiceTax)
            {
            }
            column(dblTotalServiceTaxCr; dblTotalServiceTaxCr)
            {
            }
            column(strServiceTaxAccount; strServiceTaxAccount)
            {
            }
            column(VouchNarr; VouchNarr)
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(TotDebitAmt; TotDebitAmt)
            {
            }
            column(TotCreditAmt; ROUND(TotCreditAmt, 0.01))
            {
            }
            column(Credit__INR_Caption; Credit__INR_CaptionLbl)
            {
            }
            column(Debit__INR_Caption; Debit__INR_CaptionLbl)
            {
            }
            column(Account_NameCaption; Account_NameCaptionLbl)
            {
            }
            column(NARRATION_Caption; NARRATION_CaptionLbl)
            {
            }
            column(Prepared_ByCaption; Prepared_ByCaptionLbl)
            {
            }
            column(Posted_ByCaption; Posted_ByCaptionLbl)
            {
            }
            column(Authorised_SignatoryCaption; Authorised_SignatoryCaptionLbl)
            {
            }
            column(Gen__Journal_Line_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(Gen__Journal_Line_Line_No_; "Line No.")
            {
            }
            column(Gen__Journal_Line_Account_No_; "Account No.")
            {
            }
            column(Gen__Journal_Line_Document_No_; "Document No.")
            {
            }
            column(ChequeNo; "Gen. Journal Line"."Cheque No.")
            {
            }
            column(CurrencyFactor_GenJournalLine; CurrencyFactor)
            {
            }
            dataitem("Gen. Journal Line2"; "Gen. Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"),
                               "Journal Batch Name" = FIELD("Journal Batch Name"),
                               "Account No." = FIELD("Account No."),
                               "Document No." = FIELD("Document No.");
                DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Account No.", "Line No.");
                column(LineAmount; LineAmount)
                {
                }
                column(LineNarr; LineNarr)
                {
                }
                column(LineDrCr; LineDrCr)
                {
                }
                column(ChequeString; ChequeString)
                {
                }
                column(LineAmount_Control1000000113; LineAmount)
                {
                }
                column(LineDrCr_Control1000000114; LineDrCr)
                {
                }
                column(LineDrCr_Control1000000139; LineDrCr)
                {
                }
                column(LineAmount_Control1000000140; LineAmount)
                {
                }
                column(strExternal; strExternal)
                {
                }
                column(strMatter; strMatter)
                {
                }
                column(LineAmount_Control1000000115; LineAmount)
                {
                }
                column(LineDrCr_Control1000000116; LineDrCr)
                {
                }
                column(strTDSAccount; strTDSAccount)
                {
                }
                column(TxtTotalTDS; txtTdsTotal)
                {
                }
                column(dblTotalTDS; dblTotalTDS)
                {
                }
                column(dblTDS; dblTDS)
                {
                }
                column(TxtSurcharge; TxtSurcharge)
                {
                }
                column(dblSurcharge; dblSurcharge)
                {
                }
                column(TxtEcess; Txtecess)
                {
                }
                column(dblECess; dblECess)
                {
                }
                column(TxtSheCess; TxtSHECess)
                {
                }
                column(dblSHECess; dblSHECess)
                {
                }
                column(dblTotalWorkTaxDr; dblTotalWorkTaxDr)
                {
                }
                column(strWorkTaxAccount; strWorkTaxAccount)
                {
                }
                column(strServiceTaxAccount_Value; strServiceTaxAccount)
                {
                }
                column(dblTotalServiceTaxDr; dblTotalServiceTaxDr)
                {
                }
                column(TDS_AmountCaption; TDS_AmountCaptionLbl)
                {
                }
                column(SurchargeCaption; SurchargeCaptionLbl)
                {
                    IncludeCaption = false;
                }
                column(ECESSCaption; ECESSCaptionLbl)
                {
                }
                column(SHE_CessCaption; SHE_CessCaptionLbl)
                {
                }
                column(Gen__Journal_Line2_Journal_Template_Name; "Journal Template Name")
                {
                }
                column(Gen__Journal_Line2_Journal_Batch_Name; "Journal Batch Name")
                {
                }
                column(Gen__Journal_Line2_Line_No_; "Line No.")
                {
                }
                column(Gen__Journal_Line2_Account_No_; "Account No.")
                {
                }
                column(Gen__Journal_Line2_Document_No_; "Document No.")
                {
                }
                column(TdsDebitAmount; dblTDSDr)
                {
                }
                column(TdsCreditAmount; dblTDSCr)
                {
                }
                column(Serv_TaxDr; dblServiceTaxDr)
                {
                }
                column(Ser_TaxCr; dblServiceTaxCr)
                {
                }
                column(ChequeDate_GenJournalLine2; "Gen. Journal Line2"."Cheque Date")
                {
                }
                column(CurrencyFactor_GenJournalLine2; CurrencyFactor)
                {
                }
                column(ChequeNo_GenJournalLine2; "Gen. Journal Line2"."Cheque No.")
                {
                }
                dataitem("Dimension Set Entry"; "Dimension Set Entry")
                {
                    DataItemLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                    column(DimensionCode; "Dimension Set Entry"."Dimension Code")
                    {
                    }
                    column(DimensionValue; "Dimension Set Entry"."Dimension Value Code")
                    {
                    }
                    column(DimensionName; "Dimension Set Entry"."Dimension Name")
                    {
                    }
                    column(DimensionValueName; "Dimension Set Entry"."Dimension Value Name")
                    {
                     
                    }
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Applies-to ID" = FIELD("Document No."),
                                   "Customer No." = FIELD("Account No.");
                    DataItemTableView = SORTING("Entry No.");
                    column(LineAmount_Control1000000119; LineAmount)
                    {
                    }
                    column(LineDrCr_Control1000000120; LineDrCr)
                    {
                    }
                    column(Cust__Ledger_Entry__Cust__Ledger_Entry___Posting_Date_; "Cust. Ledger Entry"."Posting Date")
                    {
                    }
                    column(Cust__Ledger_Entry__Cust__Ledger_Entry__Description; "Cust. Ledger Entry".Description)
                    {
                    }
                    column(AMT_CUST; AMT_CUST)
                    {
                    }
                    column(CRDR1; CRDR1)
                    {
                    }
                    column(Cust__Ledger_Entry__Cust__Ledger_Entry___Remaining_Amount_; "Cust. Ledger Entry"."Remaining Amount")
                    {
                    }
                    column(Adjustment_DetailsCaption; Adjustment_DetailsCaptionLbl)
                    {
                    }
                    column(DateCaption; DateCaptionLbl)
                    {
                    }
                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {
                    }
                    column(Amt__AdjustedCaption; Amt__AdjustedCaptionLbl)
                    {
                    }
                    column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Cust__Ledger_Entry_Applies_to_ID; "Applies-to ID")
                    {
                    }
                    column(CustLedgEntry_DocNo; "Cust. Ledger Entry"."Document No.")
                    {
                    }
                    column(CustLedgEntry_RemainingAmt; "Cust. Ledger Entry"."Remaining Amount")
                    {
                    }
                }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Applies-to ID" = FIELD("Document No."),
                                   "Vendor No." = FIELD("Account No.");
                    DataItemTableView = SORTING("Entry No.");
                    column(LineAmount_Control1000000122; LineAmount)
                    {
                    }
                    column(LineDrCr_Control1000000124; LineDrCr)
                    {
                    }
                    column(Vendor_Ledger_Entry__Vendor_Ledger_Entry___Remaining_Amount_; "Vendor Ledger Entry"."Remaining Amount")
                    {
                    }
                    column(CRDR2; CRDR2)
                    {
                    }
                    column(AMT_VEN; AMT_VEN)
                    {
                    }
                    column(Vendor_Ledger_Entry__Vendor_Ledger_Entry__Description; "Vendor Ledger Entry".Description)
                    {
                    }
                    column(Vendor_Ledger_Entry__Vendor_Ledger_Entry___Posting_Date_; "Vendor Ledger Entry"."Posting Date")
                    {
                    }
                    column(Amt__AdjustedCaption_Control1000000090; Amt__AdjustedCaption_Control1000000090Lbl)
                    {
                    }
                    column(DescriptionCaption_Control1000000091; DescriptionCaption_Control1000000091Lbl)
                    {
                    }
                    column(DateCaption_Control1000000092; DateCaption_Control1000000092Lbl)
                    {
                    }
                    column(Adjustment_DetailsCaption_Control1000000094; Adjustment_DetailsCaption_Control1000000094Lbl)
                    {
                    }
                    column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                    {
                    }
                    column(DocNo; "Vendor Ledger Entry"."Document No.")
                    {
                    }
                    column(ExternalDocNo; "Vendor Ledger Entry"."External Document No.")
                    {
                    }
                    column(VendLedger_RemainingAmt; "Vendor Ledger Entry"."Remaining Amount")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        //MESSAGE('%1',"Vendor Ledger Entry"."Document No.");
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    //ccit san
                    IF "Gen. Journal Line2"."Currency Factor" <> 0 THEN
                        CurrencyFactor := "Gen. Journal Line2"."Currency Factor"
                    ELSE
                        CurrencyFactor := 1;
                    //--


                    //MESSAGE('%1',"Gen. Journal Line2"."Document No.");
                    LineDr := "Gen. Journal Line2"."Debit Amount";
                    LineCr := "Gen. Journal Line2"."Credit Amount";
                    blnLinePrint := FALSE;

                    ChequeString := '';
                    IF ("Cheque No." <> '') AND ("Cheque Date" <> 0D) THEN
                        ChequeString := STRSUBSTNO(Text068, "Cheque No.", "Cheque Date", '');

                    strExternal := '';
                    IF "External Document No." <> '' THEN
                        strExternal := 'Bill  No. ' + "External Document No." + ' Dated ' + FORMAT("Document Date");

                    strMatter := '';
                    IF "Job No." <> '' THEN BEGIN
                        rsJob.RESET;
                        IF rsJob.GET("Job No.") THEN
                            strMatter := 'Matter : ' + rsJob.Description;
                    END;

                    dblTotalTDS := 0;
                    dblTDS := 0;
                    dblSurcharge := 0;
                    dblECess := 0;
                    dblSHECess := 0;


                    /*
                    IF "Gen. Journal Line2"."Total TDS/TCS Incl. SHE CESS" <> 0 THEN BEGIN
                        rsTDSGroup.RESET;
                        rsTDSGroup.SETRANGE("TDS Group", "Gen. Journal Line2"."TDS Group");
                        rsTDSGroup.SETFILTER("Effective Date", '<=%1', "Gen. Journal Line2"."Posting Date");
                        IF rsTDSGroup.FIND('+') THEN BEGIN
                            GLAcc.RESET;
                            GLAcc.SETRANGE("No.", rsTDSGroup."TDS Account");
                            IF GLAcc.FIND('-') THEN BEGIN
                                IF blnPrintCodes THEN
                                    strTDSAccount := 'To ' + GLAcc."No." + ' - ' + GLAcc.Name
                                ELSE
                                    strTDSAccount := 'To ' + GLAcc.Name;
                            END;
                        END;
                        dblTotalTDS += "Gen. Journal Line2"."Total TDS/TCS Incl. SHE CESS";
                        dblTDS := ABS("Gen. Journal Line2"."TDS/TCS Amount");
                        dblSurcharge := ABS("Gen. Journal Line2"."Surcharge Amount");
                        dblECess := ABS("Gen. Journal Line2"."eCESS on TDS/TCS Amount");
                        dblSHECess := ABS("Gen. Journal Line2"."SHE Cess on TDS/TCS Amount");
                        dblGrandTotalTDS += ABS("Gen. Journal Line2"."Total TDS/TCS Incl. SHE CESS");
                    END;
                    */ //PCPL/MIG/NSW Filed not Exist in BC18


                    IF dblTotalTDS <> 0 THEN
                        txtTdsTotal := 'TDS Amount'
                    ELSE
                        txtTdsTotal := '';

                    IF dblSurcharge <> 0 THEN
                        TxtSurcharge := 'Surcharge'
                    ELSE
                        TxtSurcharge := '';

                    IF dblECess <> 0 THEN
                        Txtecess := 'ECess'
                    ELSE
                        Txtecess := '';

                    IF dblSHECess <> 0 THEN
                        TxtSHECess := 'SHECess'
                    ELSE
                        TxtSHECess := '';


                    TotDebitAmt += "Gen. Journal Line2"."Debit Amount";
                    //TotCreditAmt += "Gen. Journal Line2"."Credit Amount";
                    TotCreditAmt += "Gen. Journal Line2"."Credit Amount" + dblTotalTDS + dblTotalServiceTaxCr;

                    /*
                    //ccit san
                       TotDebitAmt += ConvertAmtToLCY("Gen. Journal Line2"."Currency Code","Gen. Journal Line2"."Debit Amount");
                       TotCreditAmt += ConvertAmtToLCY("Gen. Journal Line2"."Currency Code",("Gen. Journal Line2"."Credit Amount" + dblTotalTDS + dblTotalServiceTaxCr));
                    //--
                    */



                    InitTextVariable;
                    //FormatNoText(NumberText,ABS(TotDebitAmt),'');//ccit san'
                    IF "Gen. Journal Line2"."Currency Factor" <> 0 THEN BEGIN
                        IF TotDebitAmt <> 0 THEN
                            FormatNoText(NumberText, ROUND(ABS(TotDebitAmt) * (1 / "Gen. Journal Line2"."Currency Factor"), 0.01), '');//ccit san
                    END ELSE
                        FormatNoText(NumberText, ABS(TotDebitAmt), '');

                    dblWorkTax := 0;
                    dblTotalWorkTaxDr := 0;
                    dblTotalWorkTaxCr := 0;
                    strWorkTaxAccount := '';
                    /* //PCPL/MIG/NSW Filed not Exist in BC18
                    IF "Gen. Journal Line2"."Work Tax Amount" <> 0 THEN BEGIN
                        rsTDSGroup.RESET;
                        rsTDSGroup.SETRANGE("TDS Group", "Gen. Journal Line2"."Work Tax Group");
                        rsTDSGroup.SETFILTER("Effective Date", '<=%1', "Gen. Journal Line2"."Posting Date");
                        IF rsTDSGroup.FIND('+') THEN BEGIN
                            GLAcc.RESET;
                            GLAcc.SETRANGE("No.", rsTDSGroup."TDS Account");
                            IF GLAcc.FIND('-') THEN BEGIN
                                IF blnPrintCodes THEN
                                    strWorkTaxAccount := 'To ' + GLAcc."No." + ' - ' + GLAcc.Name
                                ELSE
                                    strWorkTaxAccount := 'To ' + GLAcc.Name;
                            END;
                        END;
                        *///PCPL/MIG/NSW Filed not Exist in BC18

                        dblWorkTax := 0;//"Gen. Journal Line2"."Service Tax Amount"; //PCPL/MIG/NSW Filed not Exist in BC18
                        dblTotalWorkTaxCr := 0;//ABS("Gen. Journal Line2"."Work Tax Amount"); //PCPL/MIG/NSW Filed not Exist in BC18
                    //END;


                    dblServiceTax := 0;
                    dblServiceTaxCESS := 0;
                    dblTotalServiceTaxDr := 0;
                    dblTotalServiceTaxCr := 0;
                    /* //PCPL/MIG/NSW Filed not Exist in BC18
                    IF "Gen. Journal Line2"."Service Tax Amount" <> 0 THEN BEGIN
                        rsServiceTaxSetup.RESET;
                        rsServiceTaxSetup.SETRANGE(Code, "Gen. Journal Line2"."Service Tax Group Code");
                        rsServiceTaxSetup.SETFILTER("From Date", '<=%1', "Gen. Journal Line2"."Posting Date");
                        IF rsServiceTaxSetup.FIND('+') THEN BEGIN
                            GLAcc.RESET;
                            IF "Gen. Journal Line2"."Service Tax Amount" + "Gen. Journal Line2"."Service Tax eCess Amount" > 0 THEN
                                GLAcc.SETRANGE("No.", rsServiceTaxSetup."Service Tax Receivable Account")
                            ELSE
                                GLAcc.SETRANGE("No.", rsServiceTaxSetup."Service Tax Payable Account");

                            IF GLAcc.FIND('-') THEN BEGIN
                                IF blnPrintCodes THEN
                                    strServiceTaxAccount := ' To ' + GLAcc."No." + ' - ' + GLAcc.Name
                                ELSE
                                    strServiceTaxAccount := ' To ' + GLAcc.Name;

                            END;
                        END;
                        */ //PCPL/MIG/NSW Filed not Exist in BC18

                        dblServiceTaxDr := 0;
                        dblServiceTaxCr := 0;
                        dblServiceTaxCESSDr := 0;
                        dblServiceTaxCESSCr := 0;

                        IF "Gen. Journal Line2".Amount > 0 THEN BEGIN
                            dblServiceTaxDr := 0;//"Gen. Journal Line2"."Service Tax Amount"; //PCPL/MIG/NSW Filed not Exist in BC18
                            dblServiceTaxCESSDr := 0;//"Gen. Journal Line2"."Service Tax eCess Amount"; //PCPL/MIG/NSW Filed not Exist in BC18

                            dblTotalServiceTaxDr := 0;//"Gen. Journal Line2"."Service Tax Amount" + "Gen. Journal Line2"."Service Tax eCess Amount" //PCPL/MIG/NSW Filed not Exist in BC18
                        END
                        ELSE BEGIN
                            dblServiceTaxCr := 0;//"Gen. Journal Line2"."Service Tax Amount"; //PCPL/MIG/NSW Filed not Exist in BC18
                            dblServiceTaxCESSCr := 0;//"Gen. Journal Line2"."Service Tax eCess Amount"; //PCPL/MIG/NSW Filed not Exist in BC18

                            dblTotalServiceTaxCr := 0;//ABS("Gen. Journal Line2"."Service Tax Amount" + "Gen. Journal Line2"."Service Tax eCess Amount"); //PCPL/MIG/NSW Filed not Exist in BC18
                        END;

                    //END;
                    /*
                    //ccit san
                       dblServiceTaxDr := ConvertAmtToLCY("Gen. Journal Line2"."Currency Code",dblServiceTaxDr);
                       dblServiceTaxCr := ConvertAmtToLCY("Gen. Journal Line2"."Currency Code",dblServiceTaxCr);
                    //--
                    
                    */
                    LineNarr := '';
                    GenJnlNarration.RESET;
                    GenJnlNarration.SETRANGE("Journal Template Name", "Journal Template Name");
                    GenJnlNarration.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    GenJnlNarration.SETRANGE("Gen. Journal Line No.", "Line No.");
                    GenJnlNarration.SETFILTER(Narration, '<>%1', '');
                    IF GenJnlNarration.FIND('-') THEN BEGIN
                        REPEAT
                            IF STRLEN(LineNarr) < MAXSTRLEN(LineNarr) THEN
                                LineNarr += GenJnlNarration.Narration + ' ';
                        UNTIL GenJnlNarration.NEXT = 0;
                    END;

                end;
            }

            trigger OnAfterGetRecord();
            begin
                //ccit san
                IF "Gen. Journal Line"."Currency Factor" <> 0 THEN
                    CurrencyFactor := "Gen. Journal Line"."Currency Factor"
                ELSE
                    CurrencyFactor := 1;
                //--

                rsJnlBatch.RESET;
                rsJnlBatch.SETRANGE(rsJnlBatch."Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                rsJnlBatch.SETRANGE(rsJnlBatch.Name, "Gen. Journal Line"."Journal Batch Name");
                rsJnlBatch.FIND('-');

                strDescription := '';
                IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::"G/L Account" THEN BEGIN
                    GLAcc.RESET;
                    IF GLAcc.GET("Gen. Journal Line"."Account No.") THEN BEGIN
                        IF blnPrintCodes THEN
                            strDescription := "Gen. Journal Line"."Account No." + ' - ' + GLAcc.Name
                        ELSE
                            strDescription := GLAcc.Name;
                    END;
                END
                ELSE BEGIN
                    IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Customer THEN BEGIN
                        rsCustomer.RESET;
                        IF rsCustomer.GET("Gen. Journal Line"."Account No.") THEN BEGIN
                            IF blnPrintCodes THEN
                                strDescription := "Gen. Journal Line"."Account No." + ' - ' + rsCustomer.Name
                            ELSE
                                strDescription := rsCustomer.Name;
                        END;
                    END
                    ELSE BEGIN
                        IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor THEN BEGIN
                            rsVendor.RESET;
                            IF rsVendor.GET("Gen. Journal Line"."Account No.") THEN BEGIN
                                IF blnPrintCodes THEN
                                    strDescription := "Gen. Journal Line"."Account No." + ' - ' + rsVendor.Name
                                ELSE
                                    strDescription := rsVendor.Name;
                            END;
                        END
                        ELSE BEGIN
                            IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::"Bank Account" THEN BEGIN
                                rsBank.RESET;
                                IF rsBank.GET("Gen. Journal Line"."Account No.") THEN BEGIN
                                    IF blnPrintCodes THEN
                                        strDescription := "Gen. Journal Line"."Account No." + ' - ' + rsBank.Name
                                    ELSE
                                        strDescription := rsBank.Name;
                                END;
                            END
                            ELSE BEGIN
                                IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::"Fixed Asset" THEN BEGIN
                                    rsFA.RESET;
                                    IF rsFA.GET("Gen. Journal Line"."Account No.") THEN BEGIN
                                        IF blnPrintCodes THEN
                                            strDescription := "Gen. Journal Line"."Account No." + ' - ' + rsFA.Description
                                        ELSE
                                            strDescription := rsFA.Description;
                                    END;
                                END;
                            END;
                        END;
                    END;
                END;

                strBalAccountName := '';
                IF "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"G/L Account" THEN BEGIN
                    GLAcc.RESET;
                    IF GLAcc.GET("Gen. Journal Line"."Bal. Account No.") THEN BEGIN
                        IF blnPrintCodes THEN
                            strBalAccountName := "Gen. Journal Line"."Bal. Account No." + ' - ' + GLAcc.Name
                        ELSE
                            strBalAccountName := GLAcc.Name;
                    END;
                END
                ELSE BEGIN
                    IF "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::Customer THEN BEGIN
                        rsCustomer.RESET;
                        IF rsCustomer.GET("Gen. Journal Line"."Bal. Account No.") THEN BEGIN
                            IF blnPrintCodes THEN
                                strBalAccountName := "Gen. Journal Line"."Bal. Account No." + ' - ' + rsCustomer.Name
                            ELSE
                                strBalAccountName := rsCustomer.Name;
                        END;
                    END
                    ELSE BEGIN
                        IF "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::Vendor THEN BEGIN
                            rsVendor.RESET;
                            IF rsVendor.GET("Gen. Journal Line"."Bal. Account No.") THEN BEGIN
                                IF blnPrintCodes THEN
                                    strBalAccountName := "Gen. Journal Line"."Bal. Account No." + ' - ' + rsVendor.Name
                                ELSE
                                    strBalAccountName := rsVendor.Name;
                            END;
                        END
                        ELSE BEGIN
                            IF "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"Bank Account" THEN BEGIN
                                rsBank.RESET;
                                IF rsBank.GET("Gen. Journal Line"."Bal. Account No.") THEN BEGIN
                                    IF blnPrintCodes THEN
                                        strBalAccountName := "Gen. Journal Line"."Bal. Account No." + ' - ' + rsBank.Name
                                    ELSE
                                        strBalAccountName := rsBank.Name;
                                END;
                            END
                            ELSE BEGIN
                                IF "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"Fixed Asset" THEN BEGIN
                                    rsFA.RESET;
                                    IF rsFA.GET("Gen. Journal Line"."Bal. Account No.") THEN BEGIN
                                        IF blnPrintCodes THEN
                                            strBalAccountName := "Gen. Journal Line"."Bal. Account No." + ' - ' + rsFA.Description
                                        ELSE
                                            strBalAccountName := rsFA.Description;
                                    END;
                                END;
                            END;
                        END;
                    END;
                END;



                VouchNarr := '';
                /*GenJnlNarration.RESET ;
                GenJnlNarration.SETRANGE("Journal Template Name", "Journal Template Name") ;
                GenJnlNarration.SETRANGE("Journal Batch Name", "Journal Batch Name") ;
                GenJnlNarration.SETRANGE("Document No.","Document No.");
                GenJnlNarration.SETRANGE("Gen. Journal Line No.", 0) ;
                GenJnlNarration.SETFILTER(Narration, '<>%1', '') ;
                IF GenJnlNarration.FIND('-') THEN BEGIN
                   REPEAT
                      IF STRLEN(VouchNarr) < MAXSTRLEN(VouchNarr) THEN
                         VouchNarr += GenJnlNarration.Narration + ' ';
                   UNTIL GenJnlNarration.NEXT = 0 ;
                END ELSE BEGIN
                  GenJnlNarration.RESET ;
                  GenJnlNarration.SETRANGE("Journal Template Name", "Journal Template Name") ;
                  GenJnlNarration.SETRANGE("Journal Batch Name", "Journal Batch Name") ;
                  GenJnlNarration.SETRANGE("Document No.","Document No.");
                  GenJnlNarration.SETRANGE("Gen. Journal Line No.", "Line No.") ;
                  GenJnlNarration.SETFILTER(Narration, '<>%1', '') ;
                  IF GenJnlNarration.FIND('-') THEN
                     REPEAT
                        IF STRLEN(VouchNarr) < MAXSTRLEN(VouchNarr) THEN
                           VouchNarr += GenJnlNarration.Narration + ' ';
                     UNTIL GenJnlNarration.NEXT = 0 ;
                END;
                */
                VouchNarr := "Gen. Journal Line".Comment;//CCIT-26112018

                blnPrint := TRUE;
                IF strLastAccountNo = '' THEN
                    strLastAccountNo := "Gen. Journal Line"."Account No."
                ELSE BEGIN
                    IF strLastAccountNo = "Gen. Journal Line"."Account No." THEN
                        blnPrint := FALSE
                    ELSE
                        strLastAccountNo := "Gen. Journal Line"."Account No.";
                END;

                IF blnPrint = FALSE THEN
                    CurrReport.SKIP;

                //For Balance Account Type
                dblBalDebit := 0;
                dblBalCredit := 0;
                dblBalAmount := 0;
                rsGenJnlLine2.RESET;
                rsGenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Account No.", "Line No.");
                rsGenJnlLine2.SETRANGE("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                rsGenJnlLine2.SETRANGE("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                rsGenJnlLine2.SETRANGE("Document No.", "Gen. Journal Line"."Document No.");
                IF rsGenJnlLine2.FIND('-') THEN
                    REPEAT
                        dblBalAmount += rsGenJnlLine2.Amount -0;// rsGenJnlLine2."Total TDS/TCS Incl. SHE CESS"; //PCPL/MIG/NSW Filed not Exist in BC18
                    UNTIL rsGenJnlLine2.NEXT = 0;
                IF dblBalAmount > 0 THEN
                    dblBalCredit := dblBalAmount
                ELSE
                    dblBalDebit := ABS(dblBalAmount);




                //Group Total
                TotalLineDr := 0;
                TotalLineCr := 0;
                rsGenJnlLine2.RESET;
                rsGenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Account No.", "Line No.");
                rsGenJnlLine2.SETRANGE("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                rsGenJnlLine2.SETRANGE("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                rsGenJnlLine2.SETRANGE("Account No.", "Gen. Journal Line"."Account No.");
                rsGenJnlLine2.SETRANGE("Document No.", "Gen. Journal Line"."Document No.");
                rsGenJnlLine2.FIND('-');
                IF rsGenJnlLine2.COUNT > 1 THEN
                    blnMultiple := TRUE
                ELSE
                    blnMultiple := FALSE;

                REPEAT
                    TotalLineDr += rsGenJnlLine2."Debit Amount";
                    TotalLineCr += rsGenJnlLine2."Credit Amount";

                    //ST//
                    IF /*(rsGenJnlLine2."Total TDS/TCS Incl. SHE CESS" <> 0) AND */(rsGenJnlLine2."Credit Amount" <> 0) THEN
                        TotalLineCr += 0;//rsGenJnlLine2."Total TDS/TCS Incl. SHE CESS";

                    //IF rsGenJnlLine2."Service Tax Amount" <> 0 THEN //PCPL/MIG/NSW Filed not Exist in BC18
                        TotalLineCr += 0;//rsGenJnlLine2."Service Tax Amount" + rsGenJnlLine2."Service Tax eCess Amount";//PCPL/MIG/NSW Filed not Exist in BC18

                UNTIL rsGenJnlLine2.NEXT = 0;
                /*
                //ccit san
                   TotalLineDr := ConvertAmtToLCY("Gen. Journal Line"."Currency Code",TotalLineDr);
                   TotalLineCr := ConvertAmtToLCY("Gen. Journal Line"."Currency Code",TotalLineCr);
                //--
                */

                //ST//
                //IF strBalAccountName<>'' THEN BEGIN
                IF dblBalDebit <> 0 THEN BEGIN
                    TotDebitAmt += dblBalDebit;
                    CurrReport.SHOWOUTPUT(TRUE)
                END;
                //ccit san
                //  dblBalDebit := ConvertAmtToLCY("Gen. Journal Line"."Currency Code",dblBalDebit);
                //--

                InitTextVariable;
                //FormatNoText(NumberText,ABS(TotDebitAmt),'');//comment by ccit

                //ccit san
                IF "Gen. Journal Line"."Currency Factor" <> 0 THEN BEGIN
                    IF TotDebitAmt <> 0 THEN
                        FormatNoText(NumberText, ROUND(ABS(TotDebitAmt) * (1 / "Gen. Journal Line"."Currency Factor"), 0.01), '');//comment by ccit
                END ELSE
                    FormatNoText(NumberText, ABS(TotDebitAmt), '');
                //--

                //IF strBalAccountName<>'' THEN BEGIN
                IF dblBalCredit <> 0 THEN BEGIN
                    TotCreditAmt += dblBalCredit;
                    TotCreditAmt += dblGrandTotalTDS;
                    CurrReport.SHOWOUTPUT(TRUE)
                END;
                // dblBalCredit := ConvertAmtToLCY("Gen. Journal Line"."Currency Code",dblBalCredit);   //ccit san

            end;

            trigger OnPreDataItem();
            begin
                CompanyInformation.RESET;
                CompanyInformation.GET();

                TotDebitAmt := 0;
                TotCreditAmt := 0;
                strLastAccountNo := '';
                dblGrandTotalTDS := 0;
                txtLocationAddress := '';
                recGenJournalLine.COPYFILTERS("Gen. Journal Line");
                recGenJournalLine.FIND('-');
                IF recGenJournalLine."Location Code" <> '' THEN
                    IF recLocation.GET(recGenJournalLine."Location Code") THEN BEGIN
                        txtLocationAddress := recLocation.Address + '  ' + recLocation."Address 2" + '  ' + recLocation.City + ' - ' +
                                        recLocation."Post Code" + ' Phone No.' + recLocation."Phone No." + ', ' + recLocation."Phone No. 2";
                    END
                    ELSE
                        txtLocationAddress := CompanyInformation.Address + '  ' + CompanyInformation."Address 2" + '  ' + CompanyInformation.City + ' - ' +
                                       CompanyInformation."Post Code" + ' Phone No.' + CompanyInformation."Phone No." + ', ' +
                                       CompanyInformation."Phone No. 2";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Print Codes"; blnPrintCodes)
                {
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
        blnPrintCodes := TRUE;
    end;

    var
        CompanyInformation: Record 79;
        Text066: Label 'E-Mail : %1';
        TotDebitAmt: Decimal;
        TotCreditAmt: Decimal;
        ChequeDate: Date;
        ChequeNo: Code[20];
        ChequeString: Text[80];
        //Check : Report 1401;
        NumberText: array[2] of Text[150];
        strLastAccountNo: Text[30];
        blnPrint: Boolean;
        Text067: Label 'Being Cheque No : %1 dated %2 payable at %3';
        Text068: Label 'Being Cheque No : %1 dated %2%3';
        Text069: Label '%1   %2';
        blnPrintCodes: Boolean;
        VouchNarr: Text[500];
        LineNarr: Text[500];
        strMatter: Text[100];
        rsJob: Record 167;
        rsDimension: Record 348;
        rsDimensionValue: Record 349;
        strDimension: Text[100];
        //rsTDSGroup: Record 13731;
        strTDSAccount: Text[100];
        GLAcc: Record 15;
        dblTDS: Decimal;
        dblSurcharge: Decimal;
        dblECess: Decimal;
        dblTotalTDS: Decimal;
        strDescription: Text[100];
        rsCustomer: Record 18;
        rsVendor: Record 23;
        rsFA: Record 5600;
        rsBank: Record 270;
        strBalAccountName: Text[100];
        strBalContactName: Text[100];
        dblBalDebit: Decimal;
        rsJnlBatch: Record 232;
        dblBalCredit: Decimal;
        CRDR1: Text[30];
        AMT_CUST: Decimal;
        CRDR2: Text[30];
        AMT_VEN: Decimal;
        LineDr: Decimal;
        LineCr: Decimal;
        blnLinePrint: Boolean;
        LineAmount: Decimal;
        LineDrCr: Text[30];
        blnMultiple: Boolean;
        rsGenJnlLine2: Record 81;
        TotalLineDr: Decimal;
        TotalLineCr: Decimal;
        blnPrintDimensions: Boolean;
        strExternal: Text[100];
        dblBalAmount: Decimal;
        dblGrandTotalTDS: Decimal;
        dblServiceTax: Decimal;
        dblServiceTaxCESS: Decimal;
        dblTotalServiceTaxDr: Decimal;
        dblTotalServiceTaxCr: Decimal;
        strServiceTaxAccount: Text[100];
        //rsServiceTaxSetup: Record 16472;
        dblWorkTax: Decimal;
        dblTotalWorkTaxDr: Decimal;
        dblTotalWorkTaxCr: Decimal;
        strWorkTaxAccount: Text[100];
        GenJnlNarration: Record 18550;
        dblSHECess: Decimal;
        recLocation: Record 14;
        txtLocationAddress: Text[250];
        recGenJournalLine: Record 81;
        Credit__INR_CaptionLbl: Label 'Credit (INR)';
        Debit__INR_CaptionLbl: Label 'Debit (INR)';
        Account_NameCaptionLbl: Label 'Account Name';
        NARRATION_CaptionLbl: Label 'NARRATION:';
        Prepared_ByCaptionLbl: Label 'Prepared By';
        Posted_ByCaptionLbl: Label 'Posted By';
        Authorised_SignatoryCaptionLbl: Label 'Authorised Signatory';
        TDS_AmountCaptionLbl: Label 'TDS Amount';
        SurchargeCaptionLbl: Label 'Surcharge';
        ECESSCaptionLbl: Label 'ECESS';
        SHE_CessCaptionLbl: Label 'SHE Cess';
        Adjustment_DetailsCaptionLbl: Label 'Adjustment Details';
        DateCaptionLbl: Label 'Date';
        DescriptionCaptionLbl: Label 'Description';
        Amt__AdjustedCaptionLbl: Label 'Amt. Adjusted';
        Amt__AdjustedCaption_Control1000000090Lbl: Label 'Amt. Adjusted';
        DescriptionCaption_Control1000000091Lbl: Label 'Description';
        DateCaption_Control1000000092Lbl: Label 'Date';
        Adjustment_DetailsCaption_Control1000000094Lbl: Label 'Adjustment Details';
        dblServiceTaxDr: Decimal;
        dblServiceTaxCr: Decimal;
        dblServiceTaxCESSDr: Decimal;
        dblServiceTaxCESSCr: Decimal;
        dblTDSDr: Decimal;
        dblTDSCr: Decimal;
        dblTotalTDS1: Decimal;
        txtTdsTotal: Text[50];
        TxtSurcharge: Text[50];
        Txtecess: Text[50];
        TxtSHECess: Text[50];
        Text16526: TextConst ENU = 'ZERO', ENN = 'ZERO';
        Text16527: TextConst ENU = 'HUNDRED', ENN = 'HUNDRED';
        Text16528: TextConst ENU = 'AND', ENN = 'AND';
        Text16529: TextConst ENU = '%1 results in a written number that is too long.', ENN = '%1 results in a written number that is too long.';
        Text16532: TextConst ENU = 'ONE', ENN = 'ONE';
        Text16533: TextConst ENU = 'TWO', ENN = 'TWO';
        Text16534: TextConst ENU = 'THREE', ENN = 'THREE';
        Text16535: TextConst ENU = 'FOUR', ENN = 'FOUR';
        Text16536: TextConst ENU = 'FIVE', ENN = 'FIVE';
        Text16537: TextConst ENU = 'SIX', ENN = 'SIX';
        Text16538: TextConst ENU = 'SEVEN', ENN = 'SEVEN';
        Text16539: TextConst ENU = 'EIGHT', ENN = 'EIGHT';
        Text16540: TextConst ENU = 'NINE', ENN = 'NINE';
        Text16541: TextConst ENU = 'TEN', ENN = 'TEN';
        Text16542: TextConst ENU = 'ELEVEN', ENN = 'ELEVEN';
        Text16543: TextConst ENU = 'TWELVE', ENN = 'TWELVE';
        Text16544: TextConst ENU = 'THIRTEEN', ENN = 'THIRTEEN';
        Text16545: TextConst ENU = 'FOURTEEN', ENN = 'FOURTEEN';
        Text16546: TextConst ENU = 'FIFTEEN', ENN = 'FIFTEEN';
        Text16547: TextConst ENU = 'SIXTEEN', ENN = 'SIXTEEN';
        Text16548: TextConst ENU = 'SEVENTEEN', ENN = 'SEVENTEEN';
        Text16549: TextConst ENU = 'EIGHTEEN', ENN = 'EIGHTEEN';
        Text16550: TextConst ENU = 'NINETEEN', ENN = 'NINETEEN';
        Text16551: TextConst ENU = 'TWENTY', ENN = 'TWENTY';
        Text16552: TextConst ENU = 'THIRTY', ENN = 'THIRTY';
        Text16553: TextConst ENU = 'FORTY', ENN = 'FORTY';
        Text16554: TextConst ENU = 'FIFTY', ENN = 'FIFTY';
        Text16555: TextConst ENU = 'SIXTY', ENN = 'SIXTY';
        Text16556: TextConst ENU = 'SEVENTY', ENN = 'SEVENTY';
        Text16557: TextConst ENU = 'EIGHTY', ENN = 'EIGHTY';
        Text16558: TextConst ENU = 'NINETY', ENN = 'NINETY';
        Text16559: TextConst ENU = 'THOUSAND', ENN = 'THOUSAND';
        Text16560: TextConst ENU = 'MILLION', ENN = 'MILLION';
        Text16561: TextConst ENU = 'BILLION', ENN = 'BILLION';
        Text16562: TextConst ENU = 'LAKH', ENN = 'LAKH';
        Text16563: TextConst ENU = 'CRORE', ENN = 'CRORE';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        CurrencyFactor: Decimal;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record 4;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        IF CurrencyCode <> '' THEN BEGIN
            Currency.GET(CurrencyCode);
            // PCPL/MIG/NSW "Currency Numeric Description" remove and Currency.Description Add
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency.Description);
        END ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);
        IF (CurrencyCode <> '') THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency.Description + ' ONLY') //PPCL/MIG/NSW "Currency Decimal Description" Remove and  Currency.Description Add
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text16529, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;

    local procedure ConvertAmtToLCY(CurrencyCode: Code[20]; Amt: Decimal) AmtLCY: Decimal;
    var
        Currency: Record 4;
        CurrExchRate: Record 330;
    begin

        //Sets the Defaults
        Currency.InitRoundingPrecision;
        IF CurrencyCode <> '' THEN
            AmtLCY :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  WORKDATE, CurrencyCode,
                  Amt, CurrExchRate.ExchangeRate(WORKDATE, CurrencyCode)),
                Currency."Amount Rounding Precision")
        ELSE
            AmtLCY :=
              ROUND(Amt, Currency."Amount Rounding Precision");
    end;
}

