report 50040 "Sales - Credit Memo ERP Base"
{
    // version To be deleted

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales - Credit Memo ERP Base.rdl';
    Permissions = TableData 7190 = rimd;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            // ReqFilterHeading = 'Posted Sales Credit Memo';
            column(OrderDate_SalesCrMemoHeader; '')//"Sales Cr.Memo Header"."Order Date")
            {
            }
            column(ExternalDocumentNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."External Document No.")
            {
            }
            column(OutletArea_SalesCrMemoHeader; "Sales Cr.Memo Header"."Outlet Area")
            {
            }
            column(No_SalesCrMemoHeader; "No.")
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(Loc_Email; Loc_Email)
            {
            }
            column(Loc_PhoneNo; Loc_PhoneNo)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(DocCaptionCopyText; STRSUBSTNO(DocumentCaption, CopyText))
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyRegistrationLbl; CompanyRegistrationLbl)
                    {
                    }
                    column(CompanyInfo_GST_RegistrationNo; CompanyInfo."GST Registration No.")
                    {
                    }
                    column(CustomerRegistrationLbl; CustomerRegistrationLbl)
                    {
                    }
                    column(Customer_GST_RegistrationNo; Customer."GST Registration No.")
                    {
                    }
                    column(GSTComponentCode1; GSTComponentCode[1] + ' Amount')
                    {
                    }
                    column(GSTComponentCode2; GSTComponentCode[2] + ' Amount')
                    {
                    }
                    column(GSTComponentCode3; GSTComponentCode[3] + ' Amount')
                    {
                    }
                    column(GSTComponentCode4; GSTComponentCode[4] + 'Amount')
                    {
                    }
                    column(GSTCompAmount1; ABS(GSTCompAmount[1]))
                    {
                    }
                    column(GSTCompAmount2; ABS(GSTCompAmount[2]))
                    {
                    }
                    column(GSTCompAmount3; ABS(GSTCompAmount[3]))
                    {
                    }
                    column(GSTCompAmount4; ABS(GSTCompAmount[4]))
                    {
                    }
                    column(IsGSTApplicable; IsGSTApplicable)
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostDate_SalesCrMemoHeader; FORMAT("Sales Cr.Memo Header"."Posting Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(No1_SalesCrMemoHeader; "Sales Cr.Memo Header"."No.")
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(AppliedToText; AppliedToText)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_SalesCrMemoHeader; "Sales Cr.Memo Header"."Your Reference")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(DocDate_SalesCrMemoHeader; FORMAT("Sales Cr.Memo Header"."Document Date", 0, 4))
                    {
                    }
                    column(PricIncVAT_SalesCrMemoHeader; "Sales Cr.Memo Header"."Prices Including VAT")
                    {
                    }
                    column(ReturnOrderNoText; ReturnOrderNoText)
                    {
                    }
                    column(RetOrderNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Return Order No.")
                    {
                    }
                    column(SupplementaryText; SupplementaryText)
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricInclVAT1_SalesCrMemoHeader; FORMAT("Sales Cr.Memo Header"."Prices Including VAT"))
                    {
                    }
                    column(VATBaseDiscPct_SalesCrMemoHeader; "Sales Cr.Memo Header"."VAT Base Discount %")
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(RegNoCaption; RegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(CrMemoNoCaption; CrMemoNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricIncVAT_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number_IntegerLine; Number)
                        {
                        }
                        column(HdrDimCaption; HdrDimCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(ReturnReasonCode_SalesCrMemoLine; ReasonDes)
                        {
                        }
                        column(ConversionUOM_SalesCrMemoLine; "Sales Cr.Memo Line"."Conversion UOM")
                        {
                        }
                        column(LineAmt_SalesCrMemoLine; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesCrMemoLine; Description)
                        {
                        }
                        column(No_SalesCrMemoLine; "No.")
                        {
                        }
                        column(Qty_SalesCrMemoLine; Quantity)
                        {
                        }
                        column(UOM_SalesCrMemoLine; "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesCrMemoLine; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesCrMemoLine; "Line Discount %")
                        {
                        }
                        column(DiscAmt_SalesCrMemoLineLine; "Line Discount Amount")
                        {
                        }
                        column(PostedReceiptDate; FORMAT(PostedReceiptDate))
                        {
                        }
                        column(Type_SalesCrMemoLine; FORMAT(Type))
                        {
                        }
                        column(NNCTotalLineAmt; NNC_TotalLineAmount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalAmtInclVat; NNC_TotalAmountInclVat)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalInvDiscAmt; NNC_TotalInvDiscAmount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalAmt; NNC_TotalAmount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }

                        column(TotalText; TotalText)
                        {
                        }
                        column(Amt_SalesCrMemoLine; Amount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }

                        column(ChargesAmount; ChargesAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(OtherTaxesAmount; OtherTaxesAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }

                        column(NNCTotalAmtToCust; NNC_TotalAmountToCustomer)
                        {
                        }
                        column(NNCTotalExciseAmt; NNC_TotalExciseAmount)
                        {
                        }
                        column(NNCTotalTaxAmt; NNC_TotalTaxAmount)
                        {
                        }
                        column(NNCTotalServTaxAmt; NNC_TotalServiceTaxAmount)
                        {
                        }
                        column(NNCTSTaxeCessAmt; NNC_TSTaxeCessAmount)
                        {
                        }
                        column(NNCTSTSHECessAmt; NNC_TSTSHECessAmount)
                        {
                        }
                        column(NNCttdstcsishecess; NNC_TTDSTCSISHECESS)
                        {
                        }
                        column(AmountIncludingVATAmt1; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText1; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText1; TotalExclVATText)
                        {
                        }
                        column(LineNo_SalesCrMemoLine; "Line No.")
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscPercentCaption; DiscPercentCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(DiscAmtCaption; DiscAmtCaptionLbl)
                        {
                        }
                        column(PostedReceiptDateCaption; PostedReceiptDateCaptionLbl)
                        {
                        }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubTotalCaption; SubTotalCaptionLbl)
                        {
                        }
                        column(ExciseAmtCaption; ExciseAmtCaptionLbl)
                        {
                        }
                        column(TaxAmtCaption; TaxAmtCaptionLbl)
                        {
                        }
                        column(ServTaxAmtCaption; ServTaxAmtCaptionLbl)
                        {
                        }
                        column(ChargesAmtCaption; ChargesAmtCaptionLbl)
                        {
                        }
                        column(OtherTaxesAmtCaption; OtherTaxesAmtCaptionLbl)
                        {
                        }
                        column(ServiceTaxeCessAmtCaption; ServiceTaxeCessAmtCaptionLbl)
                        {
                        }
                        column(TotalTDSIncludingeCessCaption; TotalTDSIncludingeCessCaptionLbl)
                        {
                        }
                        column(TCSAmountCaption; TCSAmountCaptionLbl)
                        {
                        }
                        column(ServiceTaxSHECessAmtCaption; ServiceTaxSHECessAmtCaptionLbl)
                        {
                        }
                        column(PaymentDiscOnVATCaption; PaymentDiscOnVATCaptionLbl)
                        {
                        }
                        column(Desc_SalesCrMemoLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(No_SalesCrMemoLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(Qty_SalesCrMemoLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_SalesCrMemoLineCaption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(NNCTotalServTaxSBCAmt; NNC_TotalServiceTaxSBCAmount)
                        {
                        }
                        column(ServTaxSBCAmtCaption; ServTaxSBCAmtCaptionLbl)
                        {
                        }
                        column(NNCTotalKKCessAmt; NNC_TotalKKCessAmount)
                        {
                        }
                        column(KKCessAmtCaption; KKCessAmtCaptionLbl)
                        {
                        }
                        column(Batch; Batch)
                        {
                        }
                        column(MFG; MFG)
                        {
                        }
                        column(EXP; EXP)
                        {
                        }
                        dataitem("Sales Shipment Buffer"; Integer)
                        {
                            DataItemTableView = SORTING(Number);
                            column(SalesShipmentBufferQuantity; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN
                                    SalesShipmentBuffer.FIND('-')
                                ELSE
                                    SalesShipmentBuffer.NEXT;
                            end;

                            trigger OnPreDataItem();
                            begin
                                SETRANGE(Number, 1, SalesShipmentBuffer.COUNT);
                            end;
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FIND('-') THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem();
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Cr.Memo Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord();
                        var
                        // StructureLineDetails: Record 13798;
                        begin
                            //CCIT-JAGA 07/1/2018
                            CLEAR(ReasonDes);
                            IF RecRetReason.GET("Sales Cr.Memo Line"."Return Reason Code") THEN
                                ReasonDes := RecRetReason.Description;
                            //CCIT-JAGA 07/1/2018

                            NNC_TotalLineAmount += "Line Amount";
                            NNC_TotalAmountInclVat += "Amount Including VAT";
                            NNC_TotalInvDiscAmount += "Inv. Discount Amount";
                            NNC_TotalAmount += Amount;
                            NNC_TotalAmountToCustomer += 0;//"Amount To Customer";
                            NNC_TotalExciseAmount += 0;//"Excise Amount";
                            NNC_TotalTaxAmount += 0;//"Tax Amount";
                            NNC_TotalServiceTaxAmount += 0;//"Service Tax Amount" ;
                            NNC_TSTaxeCessAmount += 0;//"Service Tax eCess Amount";
                            NNC_TSTSHECessAmount += 0;//"Service Tax SHE Cess Amount";
                            NNC_TTDSTCSISHECESS += 0;//"Total TDS/TCS Incl SHE CESS";
                            NNC_TotalServiceTaxSBCAmount += 0;//"Sales Cr.Memo Line"."Service Tax SBC Amount";
                            NNC_TotalKKCessAmount += 0;//"Sales Cr.Memo Line"."KK Cess Amount";

                            SalesShipmentBuffer.DELETEALL;
                            PostedReceiptDate := 0D;
                            IF Quantity <> 0 THEN
                                PostedReceiptDate := FindPostedShipmentDate;

                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            VATAmountLine.INIT;
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            IF "Allow Invoice Disc." THEN
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;
                            IF IsGSTApplicable AND (Type <> Type::" ") THEN BEGIN
                                J := 1;
                                GSTComponent.RESET;
                                // GSTComponent.SETRANGE("GST Jurisdiction Type", "GST Jurisdiction Type"); //PCPL/MIG/NSW Filed not Exist in BC18
                                IF GSTComponent.FINDSET THEN
                                    REPEAT
                                        // GSTComponentCode[J] := GSTComponent.Code; //PCPL/MIG/NSW Filed not Exist in BC18
                                        DetailedGSTLedgerEntry.RESET;
                                        DetailedGSTLedgerEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                                        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                                        DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                                        DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                                        DetailedGSTLedgerEntry.SETRANGE("GST Component Code", GSTComponentCode[J]);
                                        IF DetailedGSTLedgerEntry.FINDSET THEN BEGIN
                                            REPEAT
                                                GSTCompAmount[J] +=
                                                  CurrExchRate.ExchangeAmtLCYToFCY(
                                                    DetailedGSTLedgerEntry."Posting Date", DetailedGSTLedgerEntry."Currency Code",
                                                    DetailedGSTLedgerEntry."GST Amount", DetailedGSTLedgerEntry."Currency Factor");
                                            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                                            J += 1;
                                        END;
                                    UNTIL GSTComponent.NEXT = 0;
                            END;
                            /* //PCPL/MIG/NSW Filed not Exist in BC18
                            StructureLineDetails.RESET;
                            StructureLineDetails.SETRANGE(Type, StructureLineDetails.Type::Sale);
                            StructureLineDetails.SETRANGE("Document Type", StructureLineDetails."Document Type"::"Credit Memo");
                            StructureLineDetails.SETRANGE("Invoice No.", "Document No.");
                            StructureLineDetails.SETRANGE("Item No.", "No.");
                            StructureLineDetails.SETRANGE("Line No.", "Line No.");
                            IF StructureLineDetails.FIND('-') THEN
                                REPEAT
                                    IF NOT StructureLineDetails."Payable to Third Party" THEN BEGIN
                                        IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::Charges THEN
                                            ChargesAmount := ChargesAmount + ROUND(StructureLineDetails.Amount);
                                        IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::"Other Taxes" THEN
                                            OtherTaxesAmount := OtherTaxesAmount + ROUND(StructureLineDetails.Amount);
                                    END;
                                UNTIL StructureLineDetails.NEXT = 0;
                            */ //PCPL/MIG/NSW Filed not Exist in BC18
                            IF ("Sales Cr.Memo Line".Type <> "Sales Cr.Memo Line".Type::"G/L Account") THEN BEGIN
                                Batch := '';
                                MFG := 0D;
                                EXP := 0D;
                                RecILE.RESET;
                                RecILE.SETRANGE(RecILE."Document No.", "Sales Cr.Memo Line"."Document No.");
                                RecILE.SETRANGE(RecILE."Item No.", "Sales Cr.Memo Line"."No.");
                                RecILE.SETRANGE(RecILE."Document Line No.", "Sales Cr.Memo Line"."Line No.");
                                IF RecILE.FINDSET THEN
                                    REPEAT
                                        Batch := RecILE."Lot No.";
                                        MFG := RecILE."Manufacturing Date";
                                        EXP := RecILE."Expiration Date";
                                    UNTIL RecILE.NEXT = 0;
                            END;
                        end;

                        trigger OnPreDataItem();
                        begin
                            VATAmountLine.DELETEALL;
                            SalesShipmentBuffer.RESET;
                            SalesShipmentBuffer.DELETEALL;
                            FirstValueEntryNo := 0;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SETRANGE("Line No.", 0, "Line No.");
                            /* //PCPL/MIG/NSW Filed not Exist in BC18
                            CurrReport.CREATETOTALS(Amount, "Amount Including VAT", "Inv. Discount Amount", "Excise Amount", "Tax Amount",
                              "Service Tax Amount", "Service Tax eCess Amount", "Total TDS/TCS Incl SHE CESS", "Service Tax SBC Amount");
                            CurrReport.CREATETOTALS("KK Cess Amount");
                            CurrReport.CREATETOTALS("Amount To Customer", "Service Tax SHE Cess Amount");
                            */ //PCPL/MIG/NSW Filed not Exist in BC18
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATPercentCaption; VATPercentCaptionLbl)
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(InvDiscAmt1Caption; InvDiscAmt1CaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Sales Cr.Memo Header"."Currency Code" = '')
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text008 + Text009
                            ELSE
                                VALSpecLCYHeader := Text008 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := STRSUBSTNO(Text010, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(SelltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    CurrReport.PAGENO := 1;
                    IF Number > 1 THEN BEGIN
                        CopyText := Text004;
                        OutputNo += 1;
                    END;

                    NNC_TotalLineAmount := 0;
                    NNC_TotalAmountInclVat := 0;
                    NNC_TotalInvDiscAmount := 0;
                    NNC_TotalAmount := 0;
                    NNC_TotalAmountToCustomer := 0;
                    NNC_TotalExciseAmount := 0;
                    NNC_TotalTaxAmount := 0;
                    NNC_TotalServiceTaxAmount := 0;
                    NNC_TSTaxeCessAmount := 0;
                    NNC_TSTSHECessAmount := 0;
                    NNC_TTDSTCSISHECESS := 0;
                    ChargesAmount := 0;
                    OtherTaxesAmount := 0;
                    NNC_TotalServiceTaxSBCAmount := 0;
                    NNC_TotalKKCessAmount := 0;
                end;

                trigger OnPostDataItem();
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        SalesCrMemoCountPrinted.RUN("Sales Cr.Memo Header");
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                SalesCrMemoLine: Record 115;
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                //IsGSTApplicable := GSTManagement.IsGSTApplicable(Structure); //PCPL/MIG/NSW Filed not Exist in BC18
                Customer.GET("Bill-to Customer No.");
                CompanyInfo.GET;

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                IF "Return Order No." = '' THEN
                    ReturnOrderNoText := ''
                ELSE
                    ReturnOrderNoText := FIELDCAPTION("Return Order No.");
                IF "Salesperson Code" = '' THEN BEGIN
                    SalesPurchPerson.INIT;
                    SalesPersonText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Salesperson Code");
                    SalesPersonText := Text000;
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text13700, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text13701, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text13700, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text13701, "Currency Code");
                END;
                FormatAddr.SalesCrMemoBillTo(CustAddr, "Sales Cr.Memo Header");
                IF "Applies-to Doc. No." = '' THEN
                    AppliedToText := ''
                ELSE
                    AppliedToText := STRSUBSTNO(Text003, "Applies-to Doc. Type", "Applies-to Doc. No.");

                //FormatAddr.SalesCrMemoShipTo(ShipToAddr, "Sales Cr.Memo Header"); //PCPL/MIG/NSW Filed not Exist in BC18
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                    IF ShipToAddr[i] <> CustAddr[i] THEN
                        ShowShippingAddr := TRUE;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              6, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              6, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');

                SupplementaryText := '';
                SalesCrMemoLine.SETRANGE("Document No.", "No.");
                //SalesCrMemoLine.SETRANGE(Supplementary, TRUE);//PCPL/MIG/NSW Filed not Exist in BC18
                IF SalesCrMemoLine.FINDFIRST THEN
                    SupplementaryText := Text16500;

                IF RecLoc.GET("Sales Cr.Memo Header"."Location Code") THEN BEGIN
                    Loc_PhoneNo := RecLoc."Phone No.";
                    Loc_Email := RecLoc."E-Mail";
                END;
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
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage();
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
        SalesSetup.GET;
        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
        END;
    end;

    trigger OnPreReport();
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text003: Label '(Applies to %1 %2)';
        Text004: Label 'COPY';
        Text005: Label 'Sales - Credit Memo %1';
        PageCaptionCap: Label 'Page %1 of %2';
        GLSetup: Record 98;
        SalesPurchPerson: Record 13;
        CompanyInfo: Record 79;
        CompanyInfo1: Record 79;
        CompanyInfo2: Record 79;
        CompanyInfo3: Record 79;
        GSTComponent: Record 18202;
        Customer: Record 18;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        SalesSetup: Record 311;
        VATAmountLine: Record 290 temporary;
        DimSetEntry1: Record 480;
        DimSetEntry2: Record 480;
        Language: Record 8;
        SalesShipmentBuffer: Record 7190 temporary;
        CurrExchRate: Record 330;
        RespCenter: Record 5714;
        GSTManagement: Codeunit 18015;
        SalesCrMemoCountPrinted: Codeunit 316;
        FormatAddr: Codeunit 365;
        SegManagement: Codeunit 5051;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        ReturnOrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        AppliedToText: Text;
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        FirstValueEntryNo: Integer;
        PostedReceiptDate: Date;
        NextEntryNo: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        Text008: Label '"VAT Amount Specification in "';
        Text009: Label 'Local Currency';
        Text010: Label 'Exchange rate: %1/%2';
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CalculatedExchRate: Decimal;
        Text011: Label 'Sales - Prepmt. Credit Memo %1';
        OutputNo: Integer;
        NNC_TotalLineAmount: Decimal;
        NNC_TotalAmountInclVat: Decimal;
        NNC_TotalInvDiscAmount: Decimal;
        NNC_TotalAmount: Decimal;
        ChargesAmount: Decimal;
        OtherTaxesAmount: Decimal;
        Text13700: Label 'Total %1 Incl. Taxes';
        Text13701: Label 'Total %1 Excl. Taxes';
        SupplementaryText: Text[30];
        Text16500: Label 'Supplementary Credit Memo';
        NNC_TotalAmountToCustomer: Decimal;
        NNC_TotalExciseAmount: Decimal;
        NNC_TotalTaxAmount: Decimal;
        NNC_TotalServiceTaxAmount: Decimal;
        NNC_TSTaxeCessAmount: Decimal;
        NNC_TSTSHECessAmount: Decimal;
        NNC_TTDSTCSISHECESS: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        PhoneNoCaptionLbl: Label 'Phone No.';
        RegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        CrMemoNoCaptionLbl: Label 'Credit Memo No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        HdrDimCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        DiscPercentCaptionLbl: Label 'Discount %';
        AmountCaptionLbl: Label 'Amount';
        DiscAmtCaptionLbl: Label 'Line Discount Amount';
        PostedReceiptDateCaptionLbl: Label 'Posted Return Receipt Date';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        SubTotalCaptionLbl: Label 'Subtotal';
        ExciseAmtCaptionLbl: Label 'Excise Amount';
        TaxAmtCaptionLbl: Label 'Tax Amount';
        ServTaxAmtCaptionLbl: Label 'Service Tax Amount';
        ChargesAmtCaptionLbl: Label 'Charges Amount';
        OtherTaxesAmtCaptionLbl: Label 'Other Taxes Amount';
        ServiceTaxeCessAmtCaptionLbl: Label 'Service Tax eCess Amount';
        TotalTDSIncludingeCessCaptionLbl: Label 'Total TDS Including eCess';
        TCSAmountCaptionLbl: Label 'TCS Amount';
        ServiceTaxSHECessAmtCaptionLbl: Label 'Service Tax SHE Cess Amount';
        PaymentDiscOnVATCaptionLbl: Label 'Payment Discount on VAT';
        LineDimCaptionLbl: Label 'Line Dimensions';
        VATPercentCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        InvDiscAmt1CaptionLbl: Label 'Invoice Discount Amount';
        TotalCaptionLbl: Label 'Total';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        DocumentDateCaptionLbl: Label 'Document Date';
        NNC_TotalServiceTaxSBCAmount: Decimal;
        ServTaxSBCAmtCaptionLbl: Label 'SBC Amount';
        NNC_TotalKKCessAmount: Decimal;
        KKCessAmtCaptionLbl: Label 'KK Cess Amount';
        IsGSTApplicable: Boolean;
        J: Integer;
        CompanyRegistrationLbl: Label 'Company Registration No.';
        CustomerRegistrationLbl: Label 'Customer GST Reg No.';
        GSTCompAmount: array[20] of Decimal;
        GSTComponentCode: array[20] of Code[10];
        RecLoc: Record 14;
        Loc_PhoneNo: Text[50];
        Loc_Email: Text[50];
        RecILE: Record 32;
        Batch: Code[20];
        MFG: Date;
        EXP: Date;
        RecRetReason: Record 6635;
        ReasonDes: Text[50];

    procedure InitLogInteraction();
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
    end;

    procedure FindPostedShipmentDate(): Date;
    var
        ReturnReceiptHeader: Record 6660;
        SalesShipmentBuffer2: Record 7190 temporary;
    begin
        NextEntryNo := 1;
        IF "Sales Cr.Memo Line"."Return Receipt No." <> '' THEN
            IF ReturnReceiptHeader.GET("Sales Cr.Memo Line"."Return Receipt No.") THEN
                EXIT(ReturnReceiptHeader."Posting Date");
        IF "Sales Cr.Memo Header"."Return Order No." = '' THEN
            EXIT("Sales Cr.Memo Header"."Posting Date");

        CASE "Sales Cr.Memo Line".Type OF
            "Sales Cr.Memo Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::"G/L Account", "Sales Cr.Memo Line".Type::Resource,
          "Sales Cr.Memo Line".Type::"Charge (Item)", "Sales Cr.Memo Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::" ":
                EXIT(0D);
        END;

        SalesShipmentBuffer.RESET;
        SalesShipmentBuffer.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        SalesShipmentBuffer.SETRANGE("Line No.", "Sales Cr.Memo Line"."Line No.");

        IF SalesShipmentBuffer.FIND('-') THEN BEGIN
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            IF SalesShipmentBuffer.NEXT = 0 THEN BEGIN
                SalesShipmentBuffer.GET(SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.DELETE;
                EXIT(SalesShipmentBuffer2."Posting Date");
            END;
            SalesShipmentBuffer.CALCSUMS(Quantity);
            IF SalesShipmentBuffer.Quantity <> "Sales Cr.Memo Line".Quantity THEN BEGIN
                SalesShipmentBuffer.DELETEALL;
                EXIT("Sales Cr.Memo Header"."Posting Date");
            END;
        END ELSE
            EXIT("Sales Cr.Memo Header"."Posting Date");
    end;

    procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record 115);
    var
        ValueEntry: Record 5802;
        ItemLedgerEntry: Record 32;
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.", SalesCrMemoLine2."Document No.");
        ValueEntry.SETRANGE("Posting Date", "Sales Cr.Memo Header"."Posting Date");
        ValueEntry.SETRANGE("Item Charge No.", '');
        ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
        IF ValueEntry.FIND('-') THEN
            REPEAT
                IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                    IF SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 THEN
                        Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
                    ELSE
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesCrMemoLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
                END;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            UNTIL (ValueEntry.NEXT = 0) OR (TotalQuantity = 0);
    end;

    procedure GenerateBufferFromShipment(SalesCrMemoLine: Record 115);
    var
        SalesCrMemoHeader: Record 114;
        SalesCrMemoLine2: Record 115;
        ReturnReceiptHeader: Record 6660;
        ReturnReceiptLine: Record 6661;
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesCrMemoHeader.SETCURRENTKEY("Return Order No.");
        SalesCrMemoHeader.SETFILTER("No.", '..%1', "Sales Cr.Memo Header"."No.");
        SalesCrMemoHeader.SETRANGE("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        IF SalesCrMemoHeader.FIND('-') THEN
            REPEAT
                SalesCrMemoLine2.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                SalesCrMemoLine2.SETRANGE("Line No.", SalesCrMemoLine."Line No.");
                SalesCrMemoLine2.SETRANGE(Type, SalesCrMemoLine.Type);
                SalesCrMemoLine2.SETRANGE("No.", SalesCrMemoLine."No.");
                SalesCrMemoLine2.SETRANGE("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
                IF SalesCrMemoLine2.FIND('-') THEN
                    REPEAT
                        TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
                    UNTIL SalesCrMemoLine2.NEXT = 0;
            UNTIL SalesCrMemoHeader.NEXT = 0;

        ReturnReceiptLine.SETCURRENTKEY("Return Order No.", "Return Order Line No.");
        ReturnReceiptLine.SETRANGE("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        ReturnReceiptLine.SETRANGE("Return Order Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SETRANGE("Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SETRANGE(Type, SalesCrMemoLine.Type);
        ReturnReceiptLine.SETRANGE("No.", SalesCrMemoLine."No.");
        ReturnReceiptLine.SETRANGE("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
        ReturnReceiptLine.SETFILTER(Quantity, '<>%1', 0);

        IF ReturnReceiptLine.FIND('-') THEN
            REPEAT
                IF "Sales Cr.Memo Header"."Get Return Receipt Used" THEN
                    CorrectShipment(ReturnReceiptLine);
                IF ABS(ReturnReceiptLine.Quantity) <= ABS(TotalQuantity - SalesCrMemoLine.Quantity) THEN
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
                ELSE BEGIN
                    IF ABS(ReturnReceiptLine.Quantity) > ABS(TotalQuantity) THEN
                        ReturnReceiptLine.Quantity := TotalQuantity;
                    Quantity :=
                      ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);

                    SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;

                    IF ReturnReceiptHeader.GET(ReturnReceiptLine."Document No.") THEN
                        AddBufferEntry(
                          SalesCrMemoLine,
                          -Quantity,
                          ReturnReceiptHeader."Posting Date");
                END;
            UNTIL (ReturnReceiptLine.NEXT = 0) OR (TotalQuantity = 0);
    end;

    procedure CorrectShipment(var ReturnReceiptLine: Record 6661);
    var
        SalesCrMemoLine: Record 115;
    begin
        SalesCrMemoLine.SETCURRENTKEY("Return Receipt No.", "Return Receipt Line No.");
        SalesCrMemoLine.SETRANGE("Return Receipt No.", ReturnReceiptLine."Document No.");
        SalesCrMemoLine.SETRANGE("Return Receipt Line No.", ReturnReceiptLine."Line No.");
        IF SalesCrMemoLine.FIND('-') THEN
            REPEAT
                ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
            UNTIL SalesCrMemoLine.NEXT = 0;
    end;

    procedure AddBufferEntry(SalesCrMemoLine: Record 115; QtyOnShipment: Decimal; PostingDate: Date);
    begin
        SalesShipmentBuffer.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
        SalesShipmentBuffer.SETRANGE("Line No.", SalesCrMemoLine."Line No.");
        SalesShipmentBuffer.SETRANGE("Posting Date", PostingDate);
        IF SalesShipmentBuffer.FIND('-') THEN BEGIN
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity - QtyOnShipment;
            SalesShipmentBuffer.MODIFY;
            EXIT;
        END;

        WITH SalesShipmentBuffer DO BEGIN
            INIT;
            "Document No." := SalesCrMemoLine."Document No.";
            "Line No." := SalesCrMemoLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := SalesCrMemoLine.Type;
            "No." := SalesCrMemoLine."No.";
            Quantity := -QtyOnShipment;
            "Posting Date" := PostingDate;
            INSERT;
            NextEntryNo := NextEntryNo + 1
        END;
    end;

    local procedure DocumentCaption(): Text[250];
    begin
        IF "Sales Cr.Memo Header"."Prepayment Credit Memo" THEN
            EXIT(Text011);
        EXIT(Text005);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean);
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;
}

