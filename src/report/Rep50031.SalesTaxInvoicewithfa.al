report 50031 "Sales Tax Invoice with fa"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Tax Invoice with fa.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(TEXT005; TEXT005)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(OutPutNo; OutPutNo)
                {
                }
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CopyText; COPYTEXT)
                    {
                    }
                    column(LocationCode_SalesInvoiceHeader; "Sales Invoice Header"."Location Code")
                    {
                    }
                    column(TransportVendor_SalesInvoiceHeader; "Sales Invoice Header"."Transport Vendor")
                    {
                    }
                    column(Structure_SalesInvoiceHeader; '')//"Sales Invoice Header".Structure)
                    {
                    }
                    column(PaymentTermsCode_SalesInvoiceHeader; "Sales Invoice Header"."Payment Terms Code")
                    {
                    }
                    column(OrderDate_SalesInvoiceHeader; "Sales Invoice Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvoiceHeader; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
                    {
                    }
                    column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
                    {
                    }
                    column(CompanyLogo; CompanyInfo.Picture)
                    {
                    }
                    column(CIN_N0; CIN_N0)
                    {
                    }
                    column(PAN_No1; PAN_No1)
                    {
                    }
                    column(StateCode; StateCode)
                    {
                    }
                    column(StateName; StateName)
                    {
                    }
                    column(StateCodeTIN; StateCodeTIN)
                    {
                    }
                    column(PageCaption; PageCaption)
                    {
                    }
                    column(CompName; CompanyInfo.Name)
                    {
                    }
                    column(CompName2; CompanyInfo."Name 2")
                    {
                    }
                    column(CompAddres; CompanyInfo.Address)
                    {
                    }
                    column(CompAddres2; CompanyInfo."Address 2")
                    {
                    }
                    column(CompCity; CompanyInfo.City)
                    {
                    }
                    column(CompPostCode; CompanyInfo."Post Code")
                    {
                    }
                    column(CompCountry; CompanyInfo.County)
                    {
                    }
                    column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
                    {
                    }
                    column(SelltoCustomerName2_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name 2")
                    {
                    }
                    column(SelltoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address")
                    {
                    }
                    column(SelltoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address 2")
                    {
                    }
                    column(SelltoCity_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to City")
                    {
                    }
                    column(SelltoContact_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Contact")
                    {
                    }
                    column(SelltoPostCode_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Post Code")
                    {
                    }
                    column(SelltoCountryRegionCode_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Country/Region Code")
                    {
                    }
                    column(CustStatename; CustStatename)
                    {
                    }
                    column(CustStatecode; CustStatecode)
                    {
                    }
                    column(ExternalDocumentNo_SalesInvoiceHeader; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(DocumentDate_SalesInvoiceHeader; "Sales Invoice Header"."Document Date")
                    {
                    }
                    column(ShiptoPostCode_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Post Code")
                    {
                    }
                    column(ShiptoCode_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Code")
                    {
                    }
                    column(ShiptoName_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Name")
                    {
                    }
                    column(ShiptoName2_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Name 2")
                    {
                    }
                    column(ShiptoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Address")
                    {
                    }
                    column(ShiptoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(ShiptoContact; "Sales Invoice Header"."Ship-to Contact")
                    {
                    }
                    column(LocName; LocName)
                    {
                    }
                    column(LocAddr1; LocAddr1)
                    {
                    }
                    column(LocAddr2; LocAddr2)
                    {
                    }
                    column(LocCity; LocCity)
                    {
                    }
                    column(LocPhone; LocPhone)
                    {
                    }
                    column(LocEmail; LocEmail)
                    {
                    }
                    column(LocCountry; LocCountry)
                    {
                    }
                    column(LocFssaiNo; LocFssaiNo)
                    {
                    }
                    column(LocPinCode; LocPinCode)
                    {
                    }
                    column(LocGSTNoS; LocGSTNo)
                    {
                    }
                    column(custname; custname)
                    {
                    }
                    column(custaddr; custaddr)
                    {
                    }
                    column(custaddr1; custaddr1)
                    {
                    }
                    column(custaddr2; custaddr2)
                    {
                    }
                    column(custaddr3; custaddr3)
                    {
                    }
                    column(custcity; custcity)
                    {
                    }
                    column(custcountry; custcountry)
                    {
                    }
                    column(custphone; custphone)
                    {
                    }
                    column(custpincode; custpincode)
                    {
                    }
                    column(custgstno; custgstno)
                    {
                    }
                    column(custfssaino; custfssaino)
                    {
                    }
                    column(custemail; custemail)
                    {
                    }
                    column(custpancard; custpancard)
                    {
                    }
                    column(custpersonname; custpersonname)
                    {
                    }
                    column(UINNo; UINNo)
                    {
                    }
                    column(Batch; Batch)
                    {
                    }
                    column(MFGDate; MFGDate)
                    {
                    }
                    column(EXPDate; EXPDate)
                    {
                    }
                    column(ShiptoCity_SalesInvoiceHeader; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(DueDate_SalesInvoiceHeader; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(LRRRNo_SalesInvoiceHeader; "Sales Invoice Header"."LR/RR No.")
                    {
                    }
                    column(LRRRDate_SalesInvoiceHeader; "Sales Invoice Header"."LR/RR Date")
                    {
                    }
                    column(VehicleNo_SalesInvoiceHeader; "Sales Invoice Header"."Vehicle No.")
                    {
                    }
                    column(ModeofTransport_SalesInvoiceHeader; "Sales Invoice Header"."Mode of Transport")
                    {
                    }
                    column(PTDesc; PTDesc)
                    {
                    }
                    column(EWayBillNo_SalesInvoiceHeader; "Sales Invoice Header"."E-Way Bill No.")
                    {
                    }
                    column(EWayBillDate_SalesInvoiceHeader; "Sales Invoice Header"."E-Way Bill Date")
                    {
                    }
                    column(SealNo_SalesInvoiceHeader; "Sales Invoice Header"."Seal No.")
                    {
                    }
                    column(Shipcustname; Shipcustname)
                    {
                    }
                    column(Shipcustaddr; Shipcustaddr)
                    {
                    }
                    column(Shipcustaddr1; Shipcustaddr1)
                    {
                    }
                    column(Shipcustaddr2; Shipcustaddr2)
                    {
                    }
                    column(Shipcustcity; Shipcustcity)
                    {
                    }
                    column(Shipcustcountry; Shipcustcountry)
                    {
                    }
                    column(Shipcustphone; Shipcustphone)
                    {
                    }
                    column(Shipcustpincode; Shipcustpincode)
                    {
                    }
                    column(Shcustgstnoip; Shcustgstnoip)
                    {
                    }
                    column(Shipcustfssaino; Shipcustfssaino)
                    {
                    }
                    column(Shipcustemail; Shipcustemail)
                    {
                    }
                    column(Shipcustpersonname; Shipcustpersonname)
                    {
                    }
                    column(Shipcustpancard; ShipcustPostCode)
                    {
                    }
                    column(Shipcustgstno; Shipcustgstno)
                    {
                    }
                    column(ShipStatename; ShipStatename)
                    {
                    }
                    column(ShipStatecode; ShipStateCode)
                    {
                    }
                    column(AmountinWords11; AmountinWords1[1])
                    {
                    }
                    column(AmountinWords1; AmountinWords[1])
                    {
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = WHERE(Quantity = FILTER(<> 0));
                        column(Type_SalesInvoiceLine; "Sales Invoice Line".Type)
                        {
                        }
                        column(InvDiscountAmount_SalesInvoiceLine; "Sales Invoice Line"."Inv. Discount Amount")
                        {
                        }
                        column(SlNo; SlNo)
                        {
                        }
                        column(RateInPCS_SalesInvoiceLine; "Sales Invoice Line"."Rate In PCS")
                        {
                        }
                        column(AmountInPCS_SalesInvoiceLine; "Sales Invoice Line"."Amount In PCS")
                        {
                        }
                        column(GSTBaseAmount_SalesInvoiceLine; '')//"Sales Invoice Line"."GST Base Amount")
                        {
                        }
                        column(ConversionUOM_SalesInvoiceLine; "Sales Invoice Line"."Conversion UOM")
                        {
                        }
                        column(LineDiscountAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Discount Amount")
                        {
                        }
                        column(GSTJurisdictionType_SalesInvoiceLine; "Sales Invoice Line"."GST Jurisdiction Type")
                        {
                        }
                        column(SL_MRP_PRICE; '')//"Sales Invoice Line"."MRP Price")
                        {
                        }
                        column(TotalValue; TotalValue)
                        {
                        }
                        column(TaxBaseAmount_SalesInvoiceLine; '')//"Sales Invoice Line"."Tax Base Amount")
                        {
                        }
                        column(LineAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Amount")
                        {
                        }
                        column(LineDiscount_SalesInvoiceLine; "Sales Invoice Line"."Line Discount %")
                        {
                        }
                        column(HSNSACCode_SalesInvoiceLine; "Sales Invoice Line"."HSN/SAC Code")
                        {
                        }
                        column(DocumentNo_SalesInvoiceLine; "Sales Invoice Line"."Document No.")
                        {
                        }
                        column(No_SalesInvoiceLine; "Sales Invoice Line"."No.")
                        {
                        }
                        column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                        {
                        }
                        column(UnitofMeasure_SalesInvoiceLine; "Sales Invoice Line"."Unit of Measure")
                        {
                        }
                        column(GLquantity; GLquantity)
                        {
                        }
                        column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
                        {
                        }
                        column(ConversionQty_SalesInvoiceLine; "Sales Invoice Line"."Conversion Qty")
                        {
                        }
                        column(UnitPrice_SalesInvoiceLine; "Sales Invoice Line"."Unit Price")
                        {
                        }
                        column(Amount_SalesInvoiceLine; "Sales Invoice Line".Amount)
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
                        column(Rate; Rate)
                        {
                        }
                        column(Rate1; Rate1)
                        {
                        }
                        column(QtyKG; QtyKG)
                        {
                        }
                        column(QtyPCS; QtyPCS)
                        {
                        }
                        column(LineDiscAmt; LineDiscAmt)
                        {
                        }
                        column(LineTotAmt; LineTotAmt)
                        {
                        }
                        column(StorageTemp; StorageTemp)
                        {
                        }
                        column(EANCode; EANCode)
                        {
                        }
                        column(BrandName; BrandName)
                        {
                        }
                        column(InvDiscAmt; InvDiscAmt)
                        {
                        }
                        column(MRP_Price; MRP_Price)
                        {
                        }
                        column(ChargesTotal; ChargesTotal)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            SlNo += 1;

                            IF RecItem.GET("Sales Invoice Line"."No.") THEN BEGIN
                                //Descp := RecItem.Description;
                                StorageTemp := RecItem."Storage Temperature";
                                EANCode := RecItem."EAN Code No.";
                                BrandName := RecItem."Brand Name";
                                MRP_Price := 0;//RecItem."MRP Price";- //PCPL/MIG/NSW
                            END;
                            IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::"Charge (Item)" THEN
                                ChargesTotal += "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                            //TotalInKGAmt += TotalInKG;
                            LineTotAmt := 0;
                            LineDiscAmt := 0;
                            IF RecItem.GET("Sales Invoice Line"."No.") THEN BEGIN
                                IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                    LineDiscAmt := ("Sales Invoice Line"."Rate In PCS" * "Sales Invoice Line"."Conversion Qty") * ("Sales Invoice Line"."Line Discount %" / 100);
                                    LineTotAmt := ("Sales Invoice Line"."Rate In PCS" * "Sales Invoice Line"."Conversion Qty") - LineDiscAmt;
                                END
                                ELSE BEGIN
                                    LineTotAmt := "Sales Invoice Line"."Line Amount";
                                    LineDiscAmt := "Sales Invoice Line"."Line Discount Amount";
                                END
                            END;

                            IF RecFA.GET("Sales Invoice Line"."No.") THEN BEGIN
                                LineTotAmt := "Sales Invoice Line"."Line Amount";
                                LineDiscAmt := "Sales Invoice Line"."Line Discount Amount";
                            END;


                            CGST := 0;
                            SGST := 0;
                            IGST := 0;
                            Rate := 0;
                            Rate1 := 0;


                            IF "Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Intrastate THEN BEGIN
                                Rate := 0;//"Sales Invoice Line"."GST %"/2; //PCPL/MIG/NSW
                                CGST := 0;// "Sales Invoice Line"."Total GST Amount"/2; //PCPL/MIG/NSW
                                SGST := 0;//"Sales Invoice Line"."Total GST Amount"/2; //PCPL/MIG/NSW
                            END
                            ELSE
                                IF ("Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                                    Rate1 := 0;// "Sales Invoice Line"."GST %"; //PCPL/MIG/NSW
                                    IGST := 0;//"Sales Invoice Line"."Total GST Amount"; //PCPL/MIG/NSW
                                END;
                            TotalCGST += CGST;
                            TotalSGST += SGST;
                            TotalIGST += IGST;

                            IF ("Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account") THEN
                                GLquantity := "Sales Invoice Line"."Unit Price";
                            //MESSAGE('%1', GLquantity);

                            // IF "Sales Invoice Line"."Tax Base Amount" > 0 THEN BEGIN //PCPL/MIG/NSW
                            TotalValue += 0;//"Sales Invoice Line"."Tax Base Amount"; //PCPL/MIG/NSW

                            //END; //PCPL/MIG/NSW

                            //InvDiscAmt += "Sales Invoice Line"."Inv. Discount Amount";
                            "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."Invoice Discount Amount");
                            InvDiscAmt := "Sales Invoice Header"."Invoice Discount Amount";
                            LineTotAmt1 += LineTotAmt;
                            TotalAmount := ABS(LineTotAmt1 - InvDiscAmt) + TotalCGST + TotalSGST + TotalIGST + GLquantity + ChargesTotal;
                            GrandTotal += SGST + CGST + IGST;

                            repCheck.InitTextVariable;
                            repCheck.FormatNoText(AmountinWords, ROUND(TotalAmount), '');

                            repCheck1.InitTextVariable;
                            repCheck1.FormatNoText(AmountinWords1, ROUND(GrandTotal), '');
                        end;

                        trigger OnPreDataItem();
                        begin

                            SlNo := 0;
                            LineTotAmt1 := 0;
                            TotalCGST := 0;
                            TotalSGST := 0;
                            TotalIGST := 0;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    IF Number = 1 THEN BEGIN
                        COPYTEXT := TEXT001;
                        OutPutNo += 1;
                    END

                    ELSE
                        IF Number = 2 THEN BEGIN
                            COPYTEXT := TEXT002;
                            OutPutNo += 1;
                        END

                        ELSE
                            IF Number = 3 THEN BEGIN
                                COPYTEXT := TEXT003;
                                OutPutNo += 1;
                            END;

                    /*ELSE IF Number = 4 THEN BEGIN
                       COPYTEXT := TEXT004;
                       OutPutNo += 1;
                    END;*/

                    CurrReport.PAGENO := 1;
                    GrandTotal := 0;

                    ChargesTotal := 0;
                    CLEAR(GLquantity);
                    CLEAR(TotalValue);

                end;

                trigger OnPreDataItem();
                begin
                    IF NoOfCopies <> 0 THEN
                        NoOfLoops := NoOfCopies
                    ELSE
                        NoOfLoops := 2;
                    //MESSAGE('%1',NoOfLoops);                          // ABS(NoOfCopies) + 1;
                    IF NoOfLoops <= 1 THEN
                        NoOfLoops := 1;
                    COPYTEXT := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutPutNo := 1;
                    TotalAmount := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                // FormatAddr.SalesHeaderShipTo(CustAddr,"Sales Header");
                SlNo := 0;
                TotalSales := 0;
                TotalInKGAmt := 0;


                CLEAR(PTDesc);

                CIN_N0 := CompanyInfo."CIN No.";
                PAN_No1 := CompanyInfo."P.A.N. No.";

                Reclocation.RESET;
                IF Reclocation.GET("Sales Invoice Header"."Location Code") THEN BEGIN
                    LocName := Reclocation.Name;
                    LocAddr1 := Reclocation.Address;
                    LocAddr2 := Reclocation."Address 2";
                    LocCity := Reclocation.City;
                    LocCountry := Reclocation.County;
                    LocEmail := Reclocation."E-Mail";
                    LocGSTNo := Reclocation."GST Registration No.";
                    // PAN_No1 := Reclocation."P.A.N No";
                    StateCode := Reclocation."State Code";
                    LocFssaiNo := Reclocation."FSSAI No";
                    LocPhone := Reclocation."Phone No.";
                    LocPinCode := Reclocation."Post Code";
                END;

                RecState.RESET;
                IF RecState.GET(StateCode) THEN BEGIN
                    StateName := RecState.Description;
                    StateCodeTIN := '';//RecState."State Code for TIN"; //PCPL/MIG/NSW
                END;
                RecCust1.RESET;
                //IF RecCust1.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                IF RecCust1.GET("Sales Invoice Header"."Bill-to Customer No.") THEN BEGIN
                    CustStatename := RecCust1."State Code";
                    custname := RecCust1.Name;
                    custaddr := RecCust1.Address;
                    custaddr1 := RecCust1."Address 2";
                    custaddr2 := RecCust1."Address 3";
                    custaddr3 := RecCust1."Address 4";
                    custcity := RecCust1.City;
                    custcountry := RecCust1.County;
                    custphone := RecCust1."Phone No.";
                    custemail := RecCust1."E-Mail";
                    custfssaino := RecCust1."FSSAI License No";
                    custgstno := RecCust1."GST Registration No.";
                    custpancard := RecCust1."P.A.N. No.";
                    custpersonname := RecCust1.Contact;
                    UINNo := RecCust1."UIN Number";
                    custpincode := RecCust1."Post Code";
                END;
                //CCIT-SG-16042018+
                IF ("Sales Invoice Header"."Ship-to Code" <> '') THEN BEGIN
                    RecShipToAddr.RESET;
                    IF RecShipToAddr.GET("Sales Invoice Header"."Sell-to Customer No.", "Sales Invoice Header"."Ship-to Code") THEN BEGIN
                        ShipStatename := RecShipToAddr.State;
                        Shipcustname := RecShipToAddr.Name;
                        Shipcustaddr1 := RecShipToAddr.Address;
                        Shipcustaddr2 := RecShipToAddr."Address 2";
                        Shipcustcity := RecShipToAddr.City;
                        Shipcustcountry := RecShipToAddr.County;
                        Shipcustphone := RecShipToAddr."Phone No.";
                        Shipcustemail := RecShipToAddr."E-Mail";
                        Shipcustgstno := RecShipToAddr."GST Registration No.";
                        ShipcustPostCode := RecShipToAddr."Post Code";
                        Shipcustpersonname := RecShipToAddr.Contact;
                        //custpincode := RecCust1.
                    END;
                END;
                //CCIT-SG-16042018-

                RecState1.RESET;
                IF RecState1.GET(CustStatename) THEN
                    CustStatecode := RecState1."State Code (GST Reg. No.)";

                RecState1.RESET;
                IF RecState1.GET(ShipStatename) THEN
                    ShipStateCode := RecState1."State Code (GST Reg. No.)";


                RecPT.RESET;
                IF RecPT.GET("Sales Invoice Header"."Payment Terms Code") THEN
                    PTDesc := RecPT.Description;

                //repCheck1.InitTextVariable;
                //repCheck1.FormatNoText(AmountinWords1,ROUND(TotalGSTAmountinWords,1),'');
            end;

            trigger OnPreDataItem();
            begin
                // FormatAddr.SalesHeaderShipTo(CustAddr,"Sales Header");
                //GrandTotal :=0;
                //TotalAmount := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Functions)
                {
                    field("No Of Copies"; NoOfCopies)
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

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        //FormatAddr.Company(CompanyAddr,CompanyInfo);
    end;

    var
        TEXT001: Label 'Original';
        TEXT002: Label 'Duplicate';
        TEXT003: Label 'Triplicate';
        TEXT004: Label 'Quadraplicate';
        PageCaption: Label 'Page %1 of %2';
        TEXT005: Label '"“SUPPLY MEANT FOR EXPORT SUPPLY TO SEZ UNIT OR SEZ DEVELOPER FOR AUTHORISED OPERATIONS UNDER BOND OR LETTER OF UNDERTAKING WITHOUT PAYMENT OF INTEGRATED TAX” "';
        TotalValue: Decimal;
        GLquantity: Decimal;
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        CompanyAddr: array[8] of Text;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutPutNo: Integer;
        COPYTEXT: Text;
        NoOfRows: Integer;
        NoOfRecords: Integer;
        recCust: Record 18;
        repCheck: Report 1401;
        AmountinWords: array[5] of Text[250];
        TotalAmount: Decimal;
        recSalesLine: Record 37;
        TransferShipLine: Record 5745;
        SlNo: Integer;
        RecSalesInvLine: Record 113;
        Reclocation: Record 14;
        RecGSTSetup: Record "GST Setup";
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        Rate: Decimal;
        Rate1: Decimal;
        GrandTotal: Decimal;
        LocName: Text[100];
        LocAddr1: Text[200];
        LocAddr2: Text[200];
        LocCity: Text[30];
        LocPhone: Text[30];
        LocEmail: Text[100];
        LocCountry: Text[10];
        LocPinCode: Code[20];
        LocGSTNo: Code[15];
        RecCust1: Record 18;
        CustStatecode: Code[10];
        CustStatename: Text[20];
        RecState1: Record State;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        custname: Text[100];
        custaddr: Text[200];
        custaddr1: Text[200];
        custaddr2: Text[200];
        custaddr3: Text[200];
        custcity: Text[30];
        custcountry: Text[30];
        custphone: Code[30];
        custpincode: Code[20];
        custgstno: Code[15];
        custfssaino: Code[20];
        custemail: Text[100];
        custpersonname: Text[100];
        custpancard: Code[20];
        repCheck1: Report 1401;
        AmountinWords1: array[5] of Text[250];
        QtyPCS: Decimal;
        QtyKG: Decimal;
        RecILE: Record 32;
        Batch: Code[20];
        MFGDate: Date;
        EXPDate: Date;
        RecPT: Record 3;
        PTDesc: Text[50];
        RecItem: Record 27;
        Descp: Text[50];
        PAN_No1: Code[15];
        StateCode: Code[10];
        RecState: Record State;
        StateName: Text[50];
        StateCodeTIN: Code[2];
        CIN_N0: Code[25];
        SalesInvoiceLine: Record 113;
        TotalSales: Decimal;
        TotalGSTAmountinWords: Decimal;
        TotalAmountinWords: Decimal;
        RecItem2: Record 27;
        RecUOM1: Record 5404;
        RateInPCS: Decimal;
        TotalInPCS: Decimal;
        TotalInKG: Decimal;
        TotalInKGAmt: Decimal;
        StorageTemp: Code[20];
        LocFssaiNo: Code[20];
        EANCode: Code[20];
        RecSIH: Record 112;
        RecSILC: Record 113;
        SalesInvLine_DiscountAmt: Decimal;
        RecILE1: Record 32;
        TotalInKG1: Decimal;
        SalesInvLine_DiscountAmt1: Decimal;
        LineDiscAmt: Decimal;
        LineTotAmt: Decimal;
        LineTotAmt1: Decimal;
        BrandName: Code[20];
        InvDiscAmt: Decimal;
        Shipcustname: Text[100];
        Shipcustaddr: Text[200];
        Shipcustaddr1: Text[200];
        Shipcustaddr2: Text[200];
        Shipcustaddr3: Text[200];
        Shipcustcity: Text[30];
        Shipcustcountry: Text[30];
        Shipcustphone: Code[30];
        Shipcustpincode: Code[20];
        Shcustgstnoip: Code[15];
        Shipcustfssaino: Code[20];
        Shipcustemail: Text[100];
        Shipcustpersonname: Text[100];
        ShipcustPostCode: Code[20];
        Shipcustgstno: Code[15];
        ShipStatename: Code[30];
        RecShipToAddr: Record 222;
        ShipStateCode: Code[20];
        MRP_Price: Decimal;
        ChargesTotal: Decimal;
        UINNo: Code[20];
        CustPostCode: Code[20];
        RecFA: Record 5600;
}

