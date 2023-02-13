report 50007 "Purchase Order"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Purchase Order.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            column(LocationCode_PurchaseHeader; "Purchase Header"."Location Code")
            {
            }
            column(VendorPostingGroup_PurchaseHeader; "Purchase Header"."Vendor Posting Group")
            {
            }
            column(Structure_PurchaseHeader; '')//"Purchase Header".Structure)
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(ShiptoCode_PurchaseHeader; "Purchase Header"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchaseHeader; "Purchase Header"."Ship-to Name")
            {
            }
            column(ShiptoAddress_PurchaseHeader; "Purchase Header"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeader; "Purchase Header"."Ship-to Address 2")
            {
            }
            column(ShiptoCity_PurchaseHeader; "Purchase Header"."Ship-to City")
            {
            }
            column(ShiptoContact_PurchaseHeader; "Purchase Header"."Ship-to Contact")
            {
            }
            column(ShiptoPostCode_PurchaseHeader; "Purchase Header"."Ship-to Post Code")
            {
            }
            column(ShiptoCounty_PurchaseHeader; "Purchase Header"."Ship-to County")
            {
            }
            column(Vendor_OrderNo; "Purchase Header"."Vendor Order No.")
            {
            }
            column(Ship_GSTNo; Ship_GSTNo)
            {
            }
            column(Ship_ConctactNo; Ship_ConctactNo)
            {
            }
            column(PaymentTermsCode_PurchaseHeader; "Purchase Header"."Payment Terms Code")
            {
            }
            column(CurrencyCode_PurchaseHeader; "Purchase Header"."Currency Code")
            {
            }
            column(ContainerFilter_PurchaseHeader; "Purchase Header"."Container Filter")
            {
            }
            column(ShipmentMethodCode_PurchaseHeader; "Purchase Header"."Shipment Method Code")
            {
            }
            column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(PostingDate_PurchaseHeader; "Purchase Header"."Posting Date")
            {
            }
            column(TransportMethod_PurchaseHeader; "Purchase Header"."Transport Method")
            {
            }
            column(Vendor_Contact; Vendor_Contact)
            {
            }
            column(Vendor_ContactName; Vendor_ContactName)
            {
            }
            column(Vendor_Mail; Vendor_Mail)
            {
            }
            column(Vend_GSTNo; Vend_GSTNo)
            {
            }
            column(Comp_name; RecCompInfo.Name)
            {
            }
            column(Comp_addr; RecCompInfo.Address)
            {
            }
            column(Comp_Addr2; RecCompInfo."Address 2")
            {
            }
            column(Comp_contact; RecCompInfo."Phone No.")
            {
            }
            column(Comp_fax; RecCompInfo."Fax No.")
            {
            }
            column(Comp_GSTNo; RecCompInfo."GST Registration No.")
            {
            }
            column(Comp_email; RecCompInfo."E-Mail")
            {
            }
            column(Comp_PerchaseEmail; RecCompInfo."Purchase E mail")
            {
            }
            column(Comp_Picture; RecCompInfo.Picture)
            {
            }
            column(AmtCharge1; AmtCharge[1])
            {
            }
            column(AmtCharge2; AmtCharge[2])
            {
            }
            column(AmtCharge3; AmtCharge[3])
            {
            }
            column(txtCharge1; txtCharge[1])
            {
            }
            column(txtCharge2; txtCharge[2])
            {
            }
            column(txtCharge3; txtCharge[3])
            {
            }
            column(PortOfLoading; PortOfLoading)
            {
            }
            column(PortOfDesc; PortOfDesc)
            {
            }
            column(TransportMode; TransportMode)
            {
            }
            column(ShipDate1; ShipDate1)
            {
            }
            column(ShipByDate_PurchaseHeader; "Purchase Header"."Ship By Date")
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
            column(AmountInWords; AmountInWords[1])
            {
            }
            column(AmountInWords1; AmountInWords1[1])
            {

            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(TotalAmount1; TotalAmount1)
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(PaymentDesc; PaymentDesc)
            {
            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                column(Comment; "Purch. Comment Line".Comment)
                {
                }
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(GST_PurchaseLine; '')//"Purchase Line"."GST %")
                {
                }
                column(TotalGSTAmount_PurchaseLine; '')//"Purchase Line"."Total GST Amount")
                {
                }
                column(ConversionQty_PurchaseLine; "Purchase Line"."Conversion Qty")
                {
                }
                column(Description2_PurchaseLine; "Purchase Line"."Description 2")
                {
                }
                column(LineDiscountAmount_PurchaseLine; "Purchase Line"."Line Discount Amount")
                {
                }
                column(ConversionUOM_PurchaseLine; "Purchase Line"."Conversion UOM")
                {
                }
                column(LineDiscount_PurchaseLine; "Purchase Line"."Line Discount %")
                {
                }
                column(GSTJurisdictionType_PurchaseLine; "Purchase Line"."GST Jurisdiction Type")
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(DocumentNo_PurchaseLine; "Purchase Line"."Document No.")
                {
                }
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(LocationCode_PurchaseLine; "Purchase Line"."Location Code")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(Amount_PurchaseLine; "Purchase Line".Amount)
                {
                }
                column(POQtyKG; POQtyKG)
                {
                }
                column(POQtyPCS; POQtyPCS)
                {
                }
                column(TCSAmt; "Purchase Line"."TCS Amount")
                {
                }

                trigger OnAfterGetRecord();
                begin

                    POQtyPCS := 0;
                    POQtyKG := 0;
                    IF ("Purchase Line"."Unit of Measure Code" = 'PCS') THEN BEGIN
                        POQtyPCS := "Purchase Line".Quantity;
                        POQtyKG := "Purchase Line"."Conversion Qty";
                    END ELSE
                        IF ("Purchase Line"."Unit of Measure Code" = 'KG') THEN BEGIN
                            POQtyKG := "Purchase Line"."Conversion Qty";
                            POQtyPCS := "Purchase Line".Quantity;
                        END;

                    //---- CCIT-SG
                    //-------------- Calculate GST
                    CGST := 0;
                    SGST := 0;
                    IGST := 0;
                    Rate := 0;
                    Rate1 := 0;

                    //PCPL-0070 18Jan23 << 
                    TaxRate.Reset();
                    TaxRate.SetRange("Table ID Filter", 39);
                    TaxRate.SetRange("Document No. Filter", "Document No.");
                    TaxRate.SetRange("Document Type Filter", "Document Type");
                    TaxRate.SetRange("Line No. Filter", "Line No.");
                    if TaxRate.FindFirst() then;
                    //PCPL-0070 18Jan23 >>

                    IF ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                        Rate := TaxRate."Value ID";//"Purchase Line"."GST %"/2; //PCPL/MIG/NSW
                        CGST := ("Outstanding Amount" * Rate) / 100;// "Purchase Line"."Total GST Amount"/2; ////PCPL/MIG/NSW
                        SGST := ("Outstanding Amount" * Rate) / 100;
                        ;//"Purchase Line"."Total GST Amount"/2; //PCPL/MIG/NSW
                    END
                    ELSE
                        IF ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                            Rate1 := TaxRate."Value ID" * 2;//"Purchase Line"."GST %"; //PCPL/MIG/NSW
                            IGST := ("Outstanding Amount" * Rate1) / 100;
                            //"Purchase Line"."Total GST Amount"; //PCPL/MIG/NSW
                        END;


                    TotalCGST += CGST;
                    TotalSGST += SGST;
                    TotalIGST += IGST;
                    TOTALTCS += "Purchase Line"."TCS Amount";
                    TotalAmount += (("Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost") - "Purchase Line"."Line Discount Amount");
                    GrandTotal += TotalSGST + TotalCGST + TotalIGST;
                    TotalAmount1 := TotalAmount + TotalSGST + TotalCGST + TotalIGST + TOTALTCS;


                    // recCheck.InitTextVariable;
                    // recCheck.FormatNoText(AmountInWords, ROUND(TotalAmount1), '');//"Purchase Header"."Currency Code");
                    AmtInWords1.InitTextVariable();
                    AmtInWords1.FormatNoTextWithoutPaisa(AmountInWords, ROUND(TotalAmount1), ''); //PCPL-0070 18Jan23
                    //repCheck1.InitTextVariable;
                    //repCheck1.FormatNoText(AmountinWords1,GrandTotal,'');
                    AmtInWords2.InitTextVariable();
                    AmtInWords2.FormatNoTextWithoutPaisa(AmountInWords1, Round(TotalAmount), ''); //PCPL-064 20Jan23


                    //----------------------
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecVendor.GET("Purchase Header"."Buy-from Vendor No.") THEN BEGIN
                    Vendor_ContactName := RecVendor.Contact;
                    Vendor_Contact := RecVendor."Phone No.";
                    Vendor_Mail := RecVendor."E-Mail";
                    Vend_GSTNo := RecVendor."GST Registration No.";
                END;

                IF RecLoc.GET("Purchase Header"."Location Code") THEN BEGIN
                    Ship_ConctactNo := RecLoc."Phone No.";
                    Ship_GSTNo := RecLoc."GST Registration No.";
                END;

                IF "Purchase Header"."Port of Loading-Air" <> '' THEN BEGIN
                    PortOfLoading := "Purchase Header"."Port of Loading-Air";
                    TransportMode := 'AIR';
                END
                ELSE
                    IF "Purchase Header"."Port of Loading-Ocean" <> '' THEN BEGIN
                        PortOfLoading := "Purchase Header"."Port of Loading-Ocean";
                        TransportMode := 'OCEAN';
                    END;

                IF "Purchase Header"."Port of Destination-Air" <> '' THEN
                    PortOfDesc := "Purchase Header"."Port of Destination-Air"
                ELSE
                    IF "Purchase Header"."Port of Destination-Ocean" <> '' THEN
                        PortOfDesc := "Purchase Header"."Port of Destination-Ocean";

                /*
                IF ("Order Date" <> 0D) AND (FORMAT("Purchase Header"."Lead Time Calculation") <> '') THEN BEGIN
                    ShipDate := CALCDATE("Purchase Header"."Lead Time Calculation","Order Date");
                     ShipDate1 := ShipDate-1;
                END;
                */

                IF "Purchase Header"."Vendor Posting Group" = 'IMPORT' THEN
                    CurrCode := "Purchase Header"."Currency Code"
                ELSE
                    CurrCode := 'INR';

                IF RecPaymentTerms.GET("Purchase Header"."Payment Terms Code") THEN
                    PaymentDesc := RecPaymentTerms.Description;
                //--------- Charges
                //<<PCPL/MIG/NSW
                /*
                g := 1;
                recStrOrdDetails.RESET;
                recStrOrdDetails.SETRANGE(recStrOrdDetails."Document No.","Purchase Header"."No.");
                recStrOrdDetails.SETRANGE(recStrOrdDetails."Tax/Charge Type",recStrOrdDetails."Tax/Charge Type"::Charges);
                IF "Purchase Header"."GST Vendor Type" = "Purchase Header"."GST Vendor Type"::Import THEN
                  recStrOrdDetails.SETRANGE(recStrOrdDetails."Third Party Code",'');
                IF recStrOrdDetails.FINDFIRST THEN
                  REPEAT
                        txtCharge[g] :='';// recStrOrdDetails."Tax/Charge Group";
                
                        recStrOrdDetailsLine.RESET;
                        recStrOrdDetailsLine.SETRANGE(recStrOrdDetailsLine."Document No.",recStrOrdDetails."Document No.");
                        recStrOrdDetailsLine.SETRANGE(recStrOrdDetailsLine."Tax/Charge Type",recStrOrdDetails."Tax/Charge Type");
                        recStrOrdDetailsLine.SETRANGE(recStrOrdDetailsLine."Tax/Charge Group",recStrOrdDetails."Tax/Charge Group");
                        IF recStrOrdDetailsLine.FINDFIRST THEN REPEAT
                            AmtCharge[g] += recStrOrdDetailsLine.Amount;
                            TotalAmtCharges += recStrOrdDetailsLine.Amount;
                        UNTIL recStrOrdDetailsLine.NEXT=0;
                        g += 1;
                  UNTIL recStrOrdDetails.NEXT=0;
                */
                //>>PCPL/MIG/NSW
                //---------

            end;

            trigger OnPreDataItem();
            begin
                TotalAmount := 0;
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
    }

    trigger OnInitReport();
    begin
        RecCompInfo.GET;
        RecCompInfo.CALCFIELDS(Picture);
    end;

    var
        RecVendor: Record 23;
        RecCompInfo: Record 79;
        Vendor_Contact: Code[20];
        Vendor_ContactName: Text[100];
        Vendor_Mail: Code[50];
        Comp_name: Text[100];
        Comp_addr: Text[200];
        Comp_contact: Code[20];
        Comp_fax: Code[20];
        Comp_email: Text[100];
        Comp_web: Text[50];
        POQtyPCS: Decimal;
        POQtyKG: Decimal;
        RecUOM: Record 5404;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        Rate: Decimal;
        Rate1: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TotalAmount: Decimal;
        GrandTotal: Decimal;
        //recStrOrdDetails : Record "13794";
        txtCharge: array[10] of Code[20];
        AmtCharge: array[7] of Decimal;
        g: Integer;
        //recStrOrdDetailsLine : Record "13795";
        PortOfLoading: Code[20];
        PortOfDesc: Code[20];
        TransportMode: Code[10];
        ShipDate: Date;
        ShipDate1: Date;
        Vend_GSTNo: Code[15];
        RecLoc: Record 14;
        Ship_ConctactNo: Text[20];
        Ship_GSTNo: Code[15];
        AmountInWords: array[2] of Text[200];
        AmountInWords1: array[2] of Text[200];
        recCheck: Report 1401;
        Total: Decimal;
        TotalAmtCharges: Decimal;
        TotalAmount1: Decimal;
        CurrCode: Code[20];
        RecCurrency: Record 4;
        CurrCode1: Code[10];
        RecPaymentTerms: Record 3;
        PaymentDesc: Text[200];
        TOTALTCS: Decimal;
        TotalGST: Decimal;
        AmtInWords1: Codeunit 50000;
        AmtInWords2: Codeunit 50000;
        TaxRate: Record 20261;

}

