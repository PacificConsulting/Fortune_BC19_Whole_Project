report 50121 "Order Confirmation Client Base"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992

    DefaultLayout = RDLC;
    // RDLCLayout = 'src/reportlayout/OrderConfirmationNew.rdl';
    CaptionML = ENU = 'Order Confirmation New',
                ENN = 'Order Confirmation New';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeadingML = ENU = 'Sales Order',
                                     ENN = 'Sales Order';
            column(LocationCode_SalesHeader; "Sales Header"."Location Code")
            {
            }
            column(DocumentType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
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
            column(LineAmtCaption; LineAmtCaptionLbl)
            {
            }
            column(VATIdentCaption; VATIdentCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyInfo_GST_RegistrationNo; CompanyInfo."GST Registration No.")
                    {
                    }
                    column(Customer_GST_RegistrationNo; Customer."GST Registration No.")
                    {
                    }
                    column(CompanyRegistrationLbl; CompanyRegistrationLbl)
                    {
                    }
                    column(CustomerRegistrationLbl; CustomerRegistrationLbl)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(DocumentCaptionCopyText; STRSUBSTNO(Text004, CopyText))
                    {
                    }
                    column(CGST; CGST)
                    {

                    }
                    column(SGST; SGST)
                    {

                    }
                    column(IGST; IGST)
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
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(PrepmtPaymentTermsDescription; PrepmtPaymentTerms.Description)
                    {
                    }
                    column(CompanyInfoEMail; CompanyInfo."E-Mail")
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
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BillToCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                    {
                    }
                    column(Selltnam_SH; "Sales Header"."Sell-to Customer Name")
                    {
                    }
                    column(selltoname2_SH; "Sales Header"."Sell-to Customer Name 2")
                    {
                    }
                    column(selltoadd2_SH; "Sales Header"."Sell-to Address 2")
                    {
                    }
                    column(selltoadd_SH; "Sales Header"."Sell-to Address")
                    {
                    }
                    column(DocumentDate_SalesHeader; FORMAT("Sales Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShipmentDate_SalesHeader; FORMAT("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesHeader; "Sales Header"."Your Reference")
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
                    column(PricesInclVAT_SalesHeader; "Sales Header"."Prices Including VAT")
                    {
                        IncludeCaption = false;
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo; FORMAT("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(BillToCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(HomePageCaption; HomePageCaptionCap)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
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
                    column(ShpDateCaption; ShpDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(EMailCaption; EMailCaptionLbl)
                    {
                    }
                    column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
                    {
                    }
                    column(ShipMethodDescCaption; ShipMethodDescCaptionLbl)
                    {
                    }
                    column(PrepmtTermsDescCaption; PrepmtTermsDescCaptionLbl)
                    {
                    }
                    column(DocDateCaption; DocDateCaptionLbl)
                    {
                    }
                    column(AmtCaption; AmtCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number_Integer; Number)
                        {
                        }
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FIND('-') THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO(
                                      '%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
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
                            UNTIL (DimSetEntry1.NEXT = 0);
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Sales line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem();
                        begin
                            CurrReport.BREAK;
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(ConversionUOM_SalesLine; "Sales Line"."Conversion UOM")
                        {
                        }
                        column(QuantityinPCS; "Sales Line"."Main Quantity in PCS") //Nirmal
                        {
                        }
                        column(SalesLineAmt; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesLine; "Sales Line".Description)
                        {
                        }
                        column(NNCSalesLineLineAmt; NNC_SalesLineLineAmt)
                        {
                        }
                        column(NNCSalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                        {
                        }
                        column(NNCTotalLCY; NNC_TotalLCY)
                        {
                        }
                        column(NNCVATAmt; NNC_VATAmt)
                        {
                        }
                        column(NNCPmtDiscOnVAT; NNC_PmtDiscOnVAT)
                        {
                        }
                        column(NNCTotalInclVAT2; NNC_TotalInclVAT2)
                        {
                        }
                        column(NNCVatAmt2; NNC_VatAmt2)
                        {
                        }
                        column(NNCTotalExclVAT2; NNC_TotalExclVAT2)
                        {
                        }
                        column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(No2_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Qty_SalesLine; "Sales Line".Quantity)
                        {
                        }
                        column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                        {
                            IncludeCaption = false;
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                        {
                        }
                        column(LineAmt_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                            IncludeCaption = false;
                        }
                        column(LineDiscount_SalesLineAmount; "Sales Line"."Line Discount Amount")
                        {
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine; FORMAT("Sales Line".Type))
                        {
                        }
                        column(No_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AllowInvoiceDisYesNo; FORMAT("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(SalesLineInvDiscAmount; SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(SalesLineLineAmtInvDiscAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineTaxAmount; '')//"Sales Line.Tax Amount") //PCPL/MIG/NSW
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ChargesAmount; ChargesAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(OtherTaxesAmount; OtherTaxesAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount; '')//SalesLine."Service Tax SHE Cess Amount") //PCPL/MIG/NSW
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(NNCSalesLineExciseAmt; NNC_SalesLineExciseAmt)
                        {
                        }
                        column(NNCSalesLineTaxAmt; NNC_SalesLineTaxAmt)
                        {
                        }
                        column(NNCSalesLineSvcTaxAmt; NNC_SalesLineSvcTaxAmt)
                        {
                        }
                        column(NNCSalesLineSvcTaxeCessAmt; NNC_SalesLineSvcTaxeCessAmt)
                        {
                        }
                        column(NNCSalesLineSvcSHECessAmt; NNC_SalesLineSvcSHECessAmt)
                        {
                        }
                        column(NNCSalesLineTDSTCSSHECESS; NNC_SalesLineTDSTCSSHECESS)
                        {
                        }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(VATAmount1; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(No_SalesLineCaption; "Sales Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Description_SalesLineCaption; "Sales Line".FIELDCAPTION(Description))
                        {
                        }
                        column(Quantity_SalesLineCaption; "Sales Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesLineCaption; "Sales Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(AllowInvDisc_SalesLineCaption; "Sales Line".FIELDCAPTION("Allow Invoice Disc."))
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscPercentCaption; DiscPercentCaptionLbl)
                        {
                        }
                        column(LineDiscCaption; LineDiscCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
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
                        column(ServTaxeCessAmtCaption; ServTaxeCessAmtCaptionLbl)
                        {
                        }
                        column(TCSAmtCaption; TCSAmtCaptionLbl)
                        {
                        }
                        column(ServTaxSHECessAmtCaption; ServTaxSHECessAmtCaptionLbl)
                        {
                        }
                        column(VATDisctAmtCaption; VATDisctAmtCaptionLbl)
                        {
                        }
                        column(NNCSalesLineSvcTaxSBCAmt; NNC_SalesLineSvcTaxSBCAmt)
                        {
                        }
                        column(ServTaxSBCAmtCaption; ServTaxSBCAmtCaptionLbl)
                        {
                        }
                        column(NNCSalesLineKKCessAmt; NNC_SalesLineKKCessAmt)
                        {
                        }
                        column(KKCessAmtCaption; KKCessAmtCaptionLbl)
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimsCaption; LineDimsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin

                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDFIRST THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO(
                                          '%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
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
                                UNTIL (DimSetEntry2.NEXT = 0);
                                IF ShowInternalInfo THEN BEGIN
                                    NNC_SalesLineExciseAmt += 0;//SalesLine."Excise Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineTaxAmt += 0;//SalesLine."Tax Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcTaxAmt += 0;//SalesLine."Service Tax Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcTaxeCessAmt += 0;//SalesLine."Service Tax eCess Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcSHECessAmt += 0;//SalesLine."Service Tax SHE Cess Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineTDSTCSSHECESS += 0;//SalesLine."Total TDS/TCS Incl. SHE CESS"; //PCPL/MIG/NSW
                                    NNC_SalesLineAmtToCustomer += 0;//SalesLine."Amount To Customer"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcTaxSBCAmt += 0;//SalesLine."Service Tax SBC Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineKKCessAmt += 0;//SalesLine."KK Cess Amount"; //PCPL/MIG/NSW
                                    NNC_TotalGST += 0;//SalesLine."Total GST Amount"; //PCPL/MIG/NSW

                                    TotalAmount := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt + NNC_SalesLineExciseAmt + NNC_SalesLineTaxAmt +
                                      NNC_SalesLineSvcTaxAmt + NNC_SalesLineSvcTaxeCessAmt + ChargesAmount +
                                      OtherTaxesAmount +
                                      NNC_SalesLineTDSTCSSHECESS + NNC_SalesLineSvcSHECessAmt +
                                      NNC_SalesLineSvcTaxSBCAmt + NNC_SalesLineKKCessAmt + NNC_TotalGST;
                                END;
                            end;

                            trigger OnPostDataItem();
                            begin
                                IF NOT ShowInternalInfo THEN BEGIN
                                    NNC_SalesLineExciseAmt += 0;//SalesLine."Excise Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineTaxAmt += 0;//SalesLine."Tax Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcTaxAmt += 0;//SalesLine."Service Tax Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcTaxeCessAmt += 0;//SalesLine."Service Tax eCess Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcSHECessAmt += 0;//SalesLine."Service Tax SHE Cess Amount"; //PCPL/MIG/NSW
                                    NNC_SalesLineTDSTCSSHECESS += 0;//SalesLine."Total TDS/TCS Incl. SHE CESS"; //PCPL/MIG/NSW
                                    NNC_SalesLineAmtToCustomer += 0;//SalesLine."Amount To Customer"; //PCPL/MIG/NSW
                                    NNC_SalesLineSvcTaxSBCAmt += 0;//SalesLine."Service Tax SBC Amount";
                                    NNC_SalesLineKKCessAmt += 0;//SalesLine."KK Cess Amount"; //PCPL/MIG/NSW
                                    NNC_TotalGST += 0;// SalesLine."Total GST Amount"; //PCPL/MIG/NSW
                                    TotalAmount := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt + NNC_SalesLineExciseAmt + NNC_SalesLineTaxAmt +
                                      NNC_SalesLineSvcTaxAmt + NNC_SalesLineSvcTaxeCessAmt + ChargesAmount +
                                      OtherTaxesAmount +
                                      NNC_SalesLineTDSTCSSHECESS + NNC_SalesLineSvcSHECessAmt +
                                      NNC_SalesLineSvcTaxSBCAmt + NNC_SalesLineKKCessAmt + NNC_TotalGST;
                                END;
                            end;

                            trigger OnPreDataItem();
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number);
                            column(AsmLineUnitOfMeasureText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            column(AsmLineQuantity; AsmLine.Quantity)
                            {
                            }
                            column(AsmLineDescription; BlanksForIndent + AsmLine.Description)
                            {
                            }
                            column(AsmLineNo; BlanksForIndent + AsmLine."No.")
                            {
                            }
                            column(AsmLineType; AsmLine.Type)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN
                                    AsmLine.FINDSET
                                ELSE
                                    AsmLine.NEXT;
                            end;

                            trigger OnPreDataItem();
                            begin
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK;
                                IF NOT AsmInfoExistsForLine THEN
                                    CurrReport.BREAK;
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord();
                        var
                        // StructureLineDetails: Record 13795; //PCPL/MIG/NSW
                        begin
                            IF Number = 1 THEN
                                SalesLine.FIND('-')
                            ELSE
                                SalesLine.NEXT;
                            "Sales Line" := SalesLine;
                            IF DisplayAssemblyInformation THEN
                                AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);

                            IF NOT "Sales Header"."Prices Including VAT" AND
                               (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                            THEN
                                SalesLine."Line Amount" := 0;

                            IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "Sales Line"."No." := '';

                            NNC_SalesLineLineAmt += SalesLine."Line Amount";
                            NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";

                            NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;

                            NNC_TotalExclVAT := NNC_TotalLCY;
                            NNC_VATAmt := VATAmount;
                            NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;

                            NNC_PmtDiscOnVAT := -VATDiscountAmount;

                            NNC_TotalInclVAT2 := TotalAmountInclVAT;

                            NNC_VatAmt2 := VATAmount;
                            NNC_TotalExclVAT2 := VATBaseAmount;
                            IF IsGSTApplicable AND (SalesLine.Type <> SalesLine.Type::" ") THEN BEGIN
                                j := 1;
                                GSTComponent.RESET;
                                //GSTComponent.SETRANGE("GST Jurisdiction Type", SalesLine."GST Jurisdiction Type"); //PCPL/MIG/NSW
                                IF GSTComponent.FINDSET THEN
                                    REPEAT
                                        GSTComponentCode[j] := ''; //GSTComponent.Code; //PCPL/MIG/NSW
                                        DetailedGSTEntryBuffer.RESET;
                                        DetailedGSTEntryBuffer.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Line No.");
                                        DetailedGSTEntryBuffer.SETRANGE("Transaction Type", DetailedGSTEntryBuffer."Transaction Type"::Sales);
                                        //DetailedGSTEntryBuffer.SETRANGE(DetailedGSTEntryBuffer."Document Type", SalesLine."Document Type"); //PCPL/MIG/NSW
                                        DetailedGSTEntryBuffer.SETRANGE("Document No.", SalesLine."Document No.");
                                        DetailedGSTEntryBuffer.SETRANGE("Line No.", SalesLine."Line No.");
                                        DetailedGSTEntryBuffer.SETRANGE("GST Component Code", GSTComponentCode[j]);
                                        IF DetailedGSTEntryBuffer.FINDSET THEN BEGIN
                                            REPEAT
                                                GSTCompAmount[j] += DetailedGSTEntryBuffer."GST Amount";
                                            UNTIL DetailedGSTEntryBuffer.NEXT = 0;
                                            j += 1;
                                        END;
                                    UNTIL GSTComponent.NEXT = 0;
                            END;

                            //>>PCPL/BPPL/010
                            DetailedGSTEntryBuffer.RESET;
                            DetailedGSTEntryBuffer.SETRANGE(DetailedGSTEntryBuffer."Document No.", "Sales Line"."Document No.");
                            DetailedGSTEntryBuffer.SETRANGE(DetailedGSTEntryBuffer."Transaction Type", DetailedGSTEntryBuffer."Transaction Type"::Sales);
                            IF DetailedGSTEntryBuffer.FINDSET THEN
                                REPEAT
                                    IF DetailedGSTEntryBuffer."GST Component Code" = 'CGST' THEN BEGIN
                                        CGST += ABS(DetailedGSTEntryBuffer."GST Amount");
                                        CGSTPer := DetailedGSTEntryBuffer."GST %";
                                    END
                                    ELSE
                                        IF DetailedGSTEntryBuffer."GST Component Code" = 'IGST' THEN BEGIN
                                            IGST += ABS(DetailedGSTEntryBuffer."GST Amount");
                                            IGSTPer := DetailedGSTEntryBuffer."GST %";
                                        END
                                        ELSE
                                            IF DetailedGSTEntryBuffer."GST Component Code" = 'SGST' THEN BEGIN
                                                SGST += ABS(DetailedGSTEntryBuffer."GST Amount");
                                                SGSTPer := DetailedGSTEntryBuffer."GST %";
                                            END;
                                UNTIL DetailedGSTEntryBuffer.NEXT = 0;

                            //PCPL/MIG/NSW
                            /*
                            StructureLineDetails.RESET;
                            StructureLineDetails.SETRANGE(Type, StructureLineDetails.Type::Sale);
                            StructureLineDetails.SETRANGE("Document Type", SalesLine."Document Type");
                            StructureLineDetails.SETRANGE("Document No.", SalesLine."Document No.");
                            StructureLineDetails.SETRANGE("Item No.", SalesLine."No.");
                            StructureLineDetails.SETRANGE("Line No.", SalesLine."Line No.");
                            IF StructureLineDetails.FIND('-') THEN
                                REPEAT
                                    IF NOT StructureLineDetails."Payable to Third Party" THEN BEGIN
                                        IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::Charges THEN
                                            ChargesAmount := ChargesAmount + ROUND(StructureLineDetails.Amount);
                                        IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::"Other Taxes" THEN
                                            OtherTaxesAmount := OtherTaxesAmount + ROUND(StructureLineDetails.Amount);
                                    END;
                                UNTIL StructureLineDetails.NEXT = 0;
                                */
                            //PCPL/MIG/NSW
                            TotalAmount := SalesLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + /*SalesLine."Excise Amount" + SalesLine."Tax Amount"
                              + SalesLine."Service Tax Amount" + SalesLine."Service Tax eCess Amount" */+ChargesAmount + OtherTaxesAmount;
                            /*SalesLine."Total TDS/TCS Incl. SHE CESS" + SalesLine."Service Tax SHE Cess Amount" + SalesLine."Service Tax SBC Amount" +
                           SalesLine."KK Cess Amount" + SalesLine."Total GST Amount";*/
                        end;

                        trigger OnPostDataItem();
                        begin
                            SalesLine.DELETEALL;
                        end;

                        trigger OnPreDataItem();
                        begin
                            MoreLines := SalesLine.FIND('+');
                            WHILE MoreLines AND (SalesLine.Description = '') AND (SalesLine."Description 2" = '') AND
                                  (SalesLine."No." = '') AND (SalesLine.Quantity = 0) AND
                                  (SalesLine.Amount = 0)
                            DO
                                MoreLines := SalesLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SalesLine.SETRANGE("Line No.", 0, SalesLine."Line No.");
                            SETRANGE(Number, 1, SalesLine.COUNT);
                            CurrReport.CREATETOTALS(SalesLine."Line Amount", SalesLine."Inv. Discount Amount"/*, SalesLine."Excise Amount", SalesLine."Tax Amount",
                              SalesLine."Service Tax Amount", SalesLine."Service Tax eCess Amount",
                              SalesLine."Service Tax SHE Cess Amount",
                            SalesLine."Total TDS/TCS Incl. SHE CESS", SalesLine."Amount To Customer", SalesLine."Service Tax SBC Amount"*/); //PCPL/MIG/NSW
                            //CurrReport.CREATETOTALS(/*SalesLine."KK Cess Amount"*/); //PCPL/MIG/NSW
                            NNC_SalesLineExciseAmt := 0;
                            NNC_SalesLineTaxAmt := 0;
                            NNC_SalesLineSvcTaxAmt := 0;
                            NNC_SalesLineSvcTaxeCessAmt := 0;
                            NNC_SalesLineSvcSHECessAmt := 0;
                            NNC_SalesLineTDSTCSSHECESS := 0;
                            NNC_SalesLineAmtToCustomer := 0;
                            NNC_SalesLineSvcTaxSBCAmt := 0;
                            NNC_SalesLineKKCessAmt := 0;
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF VATAmount = 0 THEN
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT1; VATAmountLine."VAT %")
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
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Sales Header"."Currency Code" = '') OR
                               (VATAmountLine.GetTotalVATAmount = 0) THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := STRSUBSTNO(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(SellToCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                            IncludeCaption = false;
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddrCaption; ShipToAddrCaptionLbl)
                        {
                        }
                        column(SellToCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(PrepmtLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDescription; PrepmtInvBuf.Description)
                        {
                        }
                        column(PrepmtInvBufGLAccountNo; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(TotalExclVATText1; TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtText; PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText1; TotalInclVATText)
                        {
                        }
                        column(PrepmtInvBufAmount; PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmount; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufAmtPrepmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText1; VATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PmtTermsCaption; PmtTermsCaptionLbl)
                        {
                        }
                        column(GLAccNoCaption; GLAccNoCaptionLbl)
                        {
                        }
                        column(PrepmtSpecCaption; PrepmtSpecCaptionLbl)
                        {
                        }
                        dataitem(PrepmtDimLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText2; DimText)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT PrepmtDimSetEntry.FIND('-') THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO(
                                          '%1 %2', PrepmtDimSetEntry."Dimension Code", PrepmtDimSetEntry."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            PrepmtDimSetEntry."Dimension Code", PrepmtDimSetEntry."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL PrepmtDimSetEntry.NEXT = 0;
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT PrepmtInvBuf.FIND('-') THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF PrepmtInvBuf.NEXT = 0 THEN
                                    CurrReport.BREAK;

                            IF ShowInternalInfo THEN
                                DimMgt.GetDimensionSet(PrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");

                            IF "Sales Header"."Prices Including VAT" THEN
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            ELSE
                                PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        trigger OnPreDataItem();
                        begin
                            CurrReport.CREATETOTALS(
                              PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT",
                              PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT Base",
                              PrepmtVATAmountLine."VAT Amount",
                              PrepmtLineAmount);
                        end;
                    }
                    dataitem(PrepmtVATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmountLineVAT; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(PrepmtVATAmtLineVATIdentifier; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepmtVATAmtSpecCaption; PrepmtVATAmtSpecCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE(Number, 1, PrepmtVATAmountLine.COUNT);
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                var
                    PrepmtSalesLine: Record 37 temporary;
                    SalesPost: Codeunit 80;
                    TempSalesLine: Record 37 temporary;
                begin
                    CLEAR(SalesLine);
                    CLEAR(SalesPost);
                    VATAmountLine.DELETEALL;
                    SalesLine.DELETEALL;
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DELETEALL;
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);

                    IF NOT PrepmtSalesLine.ISEMPTY THEN BEGIN
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        IF NOT TempSalesLine.ISEMPTY THEN
                            SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    END;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrepmtVATAmountLineDeduct);
                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    //SalesPostPrepmt.BuildInvLineBuffer2("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf); //PCPL/MIG/NSW
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    NNC_SalesLineInvDiscAmt := 0;

                    ChargesAmount := 0;
                    TotalAmount := 0;
                    OtherTaxesAmount := 0;
                end;

                trigger OnPostDataItem();
                begin
                    IF Print THEN
                        SalesCountPrinted.RUN("Sales Header");
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
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code"); //PCPL/MIG/NSW
                // IsGSTApplicable := GSTManagement.IsGSTApplicable(Structure);
                Customer.GET("Bill-to Customer No.");
                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SETRANGE("Dimension Set ID", "Sales Header"."Dimension Set ID");

                IF "Salesperson Code" = '' THEN BEGIN
                    CLEAR(SalesPurchPerson);
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
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");

                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Header"."Language Code");
                END;
                IF "Prepmt. Payment Terms Code" = '' THEN
                    PrepmtPaymentTerms.INIT
                ELSE BEGIN
                    PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Sales Header"."Language Code");
                END;
                IF "Prepmt. Payment Terms Code" = '' THEN
                    PrepmtPaymentTerms.INIT
                ELSE BEGIN
                    PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Sales Header"."Language Code");
                END;
                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT
                ELSE BEGIN
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Header"."Language Code");
                END;

                //FormatAddr.SalesHeaderShipTo(ShipToAddr, "Sales Header");  //PCPL/MIG/NSW
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                    IF ShipToAddr[i] <> CustAddr[i] THEN
                        ShowShippingAddr := TRUE;

                IF Print THEN BEGIN
                    IF ShowRequestPage AND ArchiveDocument OR
                       NOT ShowRequestPage /*AND SalesSetup."Archive Quotes and Orders"*/  //PCPL/MIG/NSW Field not Exist in BC18
                    THEN
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                    IF LogInteraction THEN BEGIN
                        CALCFIELDS("No. of Archived Versions");
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              SegManagement.SalesOrderConfirmInterDocType, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No."
                              , "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        ELSE
                            SegManagement.LogDocument(
                              SegManagement.SalesOrderConfirmInterDocType, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                    END;
                END;
            end;

            trigger OnPreDataItem();
            begin
                Print := Print OR NOT CurrReport.PREVIEW;
                AsmInfoExistsForLine := FALSE;
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        CaptionML = ENU = 'No. of Copies',
                                    ENN = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        CaptionML = ENU = 'Show Internal Information',
                                    ENN = 'Show Internal Information';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        CaptionML = ENU = 'Archive Document',
                                    ENN = 'Archive Document';

                        trigger OnValidate();
                        begin
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        CaptionML = ENU = 'Log Interaction',
                                    ENN = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate();
                        begin
                            IF LogInteraction THEN
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                    field(ShowAssemblyComponents; DisplayAssemblyInformation)
                    {
                        CaptionML = ENU = 'Show Assembly Components',
                                    ENN = 'Show Assembly Components';
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
            ArchiveDocument := FALSE;//SalesSetup."Archive Quotes and Orders"; //PCPL/MIG/NSW False add bydefault
            LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';

            LogInteractionEnable := LogInteraction;
            ShowRequestPage := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;
    end;

    var
        Text000: TextConst ENU = 'Salesperson', ENN = 'Salesperson';
        Text001: TextConst ENU = 'Total %1', ENN = 'Total %1';
        Text003: TextConst ENU = ' COPY', ENN = ' COPY';
        Text004: TextConst ENU = 'Order Confirmation%1', ENN = 'Order Confirmation%1';
        PageCaptionCap: TextConst ENU = 'Page %1 of %2', ENN = 'Page %1 of %2';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        Customer: Record "Customer";
        SalesPurchPerson: Record "SalesPerson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables setup";
        GSTComponent: Record 18202;
        DetailedGSTEntryBuffer: Record "Detailed GST Entry Buffer";
        VATAmountLine: Record 290 temporary;
        PrepmtVATAmountLine: Record 290 temporary;
        PrepmtVATAmountLineDeduct: Record 290 temporary;
        SalesLine: Record 37 temporary;
        DimSetEntry1: Record 480;
        DimSetEntry2: Record 480;
        PrepmtDimSetEntry: Record 480 temporary;
        PrepmtInvBuf: Record 461 temporary;
        RespCenter: Record 5714;
        Language: Record 8;
        CurrExchRate: Record 330;
        AsmHeader: Record 900;
        AsmLine: Record 901;
        SalesCountPrinted: Codeunit 313;
        FormatAddr: Codeunit 365;
        SegManagement: Codeunit 5051;
        ArchiveManagement: Codeunit 5063;
        SalesPostPrepmt: Codeunit 442;
        DimMgt: Codeunit 408;
        //GSTManagement : Codeunit "16401";
        GSTCompAmount: array[20] of Decimal;
        GSTComponentCode: array[20] of Code[10];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
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
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: TextConst ENU = 'VAT Amount Specification in ', ENN = 'VAT Amount Specification in ';
        Text008: TextConst ENU = 'Local Currency', ENN = 'Local Currency';
        Text009: TextConst ENU = 'Exchange rate: %1/%2', ENN = 'Exchange rate: %1/%2';
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        OutputNo: Integer;
        NNC_TotalLCY: Decimal;
        NNC_TotalExclVAT: Decimal;
        NNC_VATAmt: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_PmtDiscOnVAT: Decimal;
        NNC_TotalInclVAT2: Decimal;
        NNC_VatAmt2: Decimal;
        NNC_TotalExclVAT2: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        NNC_SalesLineInvDiscAmt: Decimal;
        Print: Boolean;
        ChargesAmount: Decimal;
        OtherTaxesAmount: Decimal;
        Text13700: TextConst ENU = 'Total %1 Incl. Taxes', ENN = 'Total %1 Incl. Taxes';
        Text13701: TextConst ENU = 'Total %1 Excl. Taxes', ENN = 'Total %1 Excl. Taxes';
        TotalAmount: Decimal;
        NNC_SalesLineSvcTaxeCessAmt: Decimal;
        NNC_SalesLineExciseAmt: Decimal;
        NNC_SalesLineTaxAmt: Decimal;
        NNC_SalesLineSvcTaxAmt: Decimal;
        NNC_SalesLineSvcSHECessAmt: Decimal;
        NNC_SalesLineTDSTCSSHECESS: Decimal;
        NNC_SalesLineAmtToCustomer: Decimal;
        NNC_TotalGST: Decimal;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        PhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ENN = 'Phone No.';
        HomePageCaptionCap: TextConst ENU = 'Home Page', ENN = 'Home Page';
        VATRegNoCaptionLbl: TextConst ENU = 'VAT Registration No.', ENN = 'VAT Registration No.';
        GiroNoCaptionLbl: TextConst ENU = 'Giro No.', ENN = 'Giro No.';
        BankNameCaptionLbl: TextConst ENU = 'Bank', ENN = 'Bank';
        BankAccNoCaptionLbl: TextConst ENU = 'Account No.', ENN = 'Account No.';
        ShpDateCaptionLbl: TextConst ENU = 'Shipment Date', ENN = 'Shipment Date';
        OrderNoCaptionLbl: TextConst ENU = 'Order No.', ENN = 'Order No.';
        EMailCaptionLbl: TextConst ENU = 'E-Mail', ENN = 'E-Mail';
        PmtTermsDescCaptionLbl: TextConst ENU = 'Payment Terms', ENN = 'Payment Terms';
        ShipMethodDescCaptionLbl: TextConst ENU = 'Shipment Method', ENN = 'Shipment Method';
        PrepmtTermsDescCaptionLbl: TextConst ENU = 'Prepayment Payment Terms', ENN = 'Prepayment Payment Terms';
        DocDateCaptionLbl: TextConst ENU = 'Document Date', ENN = 'Document Date';
        AmtCaptionLbl: TextConst ENU = 'Amount', ENN = 'Amount';
        HdrDimsCaptionLbl: TextConst ENU = 'Header Dimensions', ENN = 'Header Dimensions';
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ENN = 'Unit Price';
        DiscPercentCaptionLbl: TextConst ENU = 'Discount %', ENN = 'Discount %';
        LineDiscCaptionLbl: TextConst ENU = 'Line Discount Amount', ENN = 'Line Discount Amount';
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ENN = 'Subtotal';
        ExciseAmtCaptionLbl: TextConst ENU = 'Excise Amount', ENN = 'Excise Amount';
        TaxAmtCaptionLbl: TextConst ENU = 'Tax Amount', ENN = 'Tax Amount';
        ServTaxAmtCaptionLbl: TextConst ENU = 'Service Tax Amount', ENN = 'Service Tax Amount';
        ChargesAmtCaptionLbl: TextConst ENU = 'Charges Amount', ENN = 'Charges Amount';
        OtherTaxesAmtCaptionLbl: TextConst ENU = 'Other Taxes Amount', ENN = 'Other Taxes Amount';
        ServTaxeCessAmtCaptionLbl: TextConst ENU = 'Service Tax eCess Amount', ENN = 'Service Tax eCess Amount';
        TCSAmtCaptionLbl: TextConst ENU = 'TCS Amount', ENN = 'TCS Amount';
        ServTaxSHECessAmtCaptionLbl: TextConst ENU = 'Service Tax SHECess Amount', ENN = 'Service Tax SHECess Amount';
        VATDisctAmtCaptionLbl: TextConst ENU = 'Payment Discount on VAT', ENN = 'Payment Discount on VAT';
        LineDimsCaptionLbl: TextConst ENU = 'Line Dimensions', ENN = 'Line Dimensions';
        VATAmtSpecCaptionLbl: TextConst ENU = 'VAT Amount Specification', ENN = 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ENN = 'Invoice Discount Base Amount';
        ShipToAddrCaptionLbl: TextConst ENU = 'Ship-to Address', ENN = 'Ship-to Address';
        PmtTermsCaptionLbl: TextConst ENU = 'Description', ENN = 'Description';
        GLAccNoCaptionLbl: TextConst ENU = 'G/L Account No.', ENN = 'G/L Account No.';
        PrepmtSpecCaptionLbl: TextConst ENU = 'Prepayment Specification', ENN = 'Prepayment Specification';
        PrepmtVATAmtSpecCaptionLbl: TextConst ENU = 'Prepayment VAT Amount Specification', ENN = 'Prepayment VAT Amount Specification';
        //InvDiscAmtCaptionLbl : Label ENU='Invoice Discount Amount',ENN='Invoice Discount Amount';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        VATPercentCaptionLbl: TextConst ENU = 'VAT %', ENN = 'VAT %';
        VATBaseCaptionLbl: TextConst ENU = 'VAT Base', ENN = 'VAT Base';
        VATAmtCaptionLbl: TextConst ENU = 'VAT Amount', ENN = 'VAT Amount';
        LineAmtCaptionLbl: TextConst ENU = 'Line Amount', ENN = 'Line Amount';
        VATIdentCaptionLbl: TextConst ENU = 'VAT Identifier', ENN = 'VAT Identifier';
        TotalCaptionLbl: TextConst ENU = 'Total', ENN = 'Total';
        ShowRequestPage: Boolean;
        ServTaxSBCAmtCaptionLbl: TextConst ENU = 'SBC Amount', ENN = 'SBC Amount';
        NNC_SalesLineSvcTaxSBCAmt: Decimal;
        NNC_SalesLineKKCessAmt: Decimal;
        KKCessAmtCaptionLbl: TextConst ENU = 'KK Cess Amount', ENN = 'KK Cess Amount';
        CompanyRegistrationLbl: TextConst ENU = 'Company Registration No.', ENN = 'Company Registration No.';
        CustomerRegistrationLbl: TextConst ENU = 'Customer GST Reg No.', ENN = 'Customer GST Reg No.';
        IsGSTApplicable: Boolean;
        j: Integer;
        CGSTPer: Decimal;
        CGST: Decimal;
        SGSTPer: Decimal;
        SGST: Decimal;
        IGSTPer: Decimal;
        IGST: Decimal;

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplAsmInfo: Boolean);
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplAsmInfo;
    end;

    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10];
    var
        UnitOfMeasure: Record "Unit Of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10];
    begin
        EXIT(PADSTR('', 2, ' '));
    end;
}

