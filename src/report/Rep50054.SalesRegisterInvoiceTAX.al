report 50054 "Sales Register Invoice-TAX"
{
    // version CCIT-JAGA,CITS_RS

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Register Invoice-TAX.rdl';
    ProcessingOnly = false;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Location Code", "Salesperson Code";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          Type = FILTER('Item' | 'G/L Account' | 'Charge (Item)'));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord();
                begin
                    /*//CCIT-SG-07052019
                    IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account" THEN BEGIN
                      IF NOT ("Sales Invoice Line"."No." = '3011001')OR ("Sales Invoice Line"."No." ='301110')OR ("Sales Invoice Line"."No." ='301120')
                        OR ("Sales Invoice Line"."No." ='301130')OR ("Sales Invoice Line"."No." ='301140')OR ("Sales Invoice Line"."No." ='301170') THEN
                          CurrReport.SKIP;
                    END;
                    //CCIT-SG-07052019*/  //ccit vivek

                    CLEAR(FreightChargesTot);
                    CLEAR(FreightCharges);
                    CLEAR(PackingCharges);
                    CLEAR(ForwardingCharges);
                    CLEAR(SHIPPINGCharges);

                    Sr_No += 1;

                    CGST := 0;
                    SGST := 0;
                    IGST := 0;
                    Rate := 0;
                    Rate1 := 0;
                    InvoiceValue := 0;

                    RecSalesPrice.RESET;
                    IF RecSalesPrice.GET("Sales Invoice Line"."No.") THEN
                        PriceperKG := RecSalesPrice."Conversion Price Per PCS";

                    QtyPerKg := 0;
                    RecSalesPric1.RESET;
                    RecSalesPric1.SETRANGE(RecSalesPric1."Item No.", "Sales Invoice Line"."No.");
                    RecSalesPric1.SETRANGE(RecSalesPric1."Sales Code", "Sales Invoice Line"."Customer Price Group");
                    IF RecSalesPric1.FINDFIRST THEN BEGIN
                        // QtyPerKg:=RecSalesPric1."Quantity in KG";
                        //QtyPerKg:= RecSalesPric1."Monthly Qty in Kgs"; // rdk 140819
                        QtyPerKg := ROUND(RecSalesPric1."Target Qty in Kgs", 0.01, '>'); //kj_ccit_24082021
                    END;

                    RecItem.RESET;
                    IF RecItem.GET("Sales Invoice Line"."No.") THEN BEGIN
                        BrandName := RecItem."Brand Name";
                        StorageCategory := FORMAT(RecItem."Storage Categories");
                        VendorNo := RecItem."Vendor No.";
                        SalesCategory := RecItem."Sales Category";

                    END;
                    IF "Sales Invoice Line".Type <> "Sales Invoice Line".Type::"G/L Account" THEN BEGIN //ccit-tk
                        CLEAR(VendName);
                        IF RecVend.GET(VendorNo) THEN
                            VendName := RecVend.Name;
                    END ELSE BEGIN
                        VendName := '';
                    END;

                    IF ("Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                        Rate := 0;//"Sales Invoice Line"."GST %"/2;
                        CGST := 0;//"Sales Invoice Line"."Total GST Amount"/2;
                        SGST := 0;//"Sales Invoice Line"."Total GST Amount"/2;
                    END
                    ELSE
                        IF ("Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                            Rate1 := 0;//"Sales Invoice Line"."GST %";
                            IGST := 0;//"Sales Invoice Line"."Total GST Amount";
                        END;

                    TotalCGST += CGST;
                    TotalSGST += SGST;
                    TotalIGST += IGST;
                    //13082020//
                    /*
                    RecSIL.RESET;
                    RecSIL.SETRANGE(RecSIL.Type,RecSIL.Type::"Charge (Item)");
                    RecSIL.SETRANGE(RecSIL."Document No.","Document No.");
                    IF RecSIL.FINDFIRST THEN
                      REPEAT
                        IF RecSIL."No." = 'FREIGHT' THEN
                          FreightCharges := FreightCharges + ROUND(RecSIL.Amount)
                        //ELSE IF RecSOLD."Tax/Charge Group" = 'TRANSPORT' THEN
                          //TransportCharges := TransportCharges + ROUND(RecSOLD.Amount)
                        ELSE IF RecSIL."No." = 'PACKING CHARGES' THEN
                          PackingCharges := PackingCharges + ROUND(RecSIL.Amount)
                        ELSE IF RecSIL."No." = 'FORWARDING CHARGES' THEN
                          ForwardingCharges := ForwardingCharges + ROUND(RecSIL.Amount);
                        FreightChargesTot := FreightCharges + TransportCharges;
                      UNTIL RecSIL."Net Weight"=0;
                    */

                    RecVLE.RESET;
                    RecVLE.SETRANGE(RecVLE."Document No.", "Document No.");
                    RecVLE.SETRANGE("Item No.", "No.");
                    RecVLE.SETFILTER("Gen. Prod. Posting Group", '<>%1', 'RETAIL');
                    IF RecVLE.FINDFIRST THEN
                        REPEAT
                            IF RecVLE."Gen. Prod. Posting Group" = 'FREIGHT' THEN
                                FreightCharges := FreightCharges + ROUND(RecVLE."Sales Amount (Actual)")
                            ELSE
                                IF RecVLE."Gen. Prod. Posting Group" = 'PACK CHAR' THEN
                                    PackingCharges := PackingCharges + ROUND(RecVLE."Sales Amount (Actual)")
                                ELSE
                                    IF RecVLE."Gen. Prod. Posting Group" = 'FOR&CHAR' THEN
                                        ForwardingCharges := ForwardingCharges + ROUND(RecVLE."Sales Amount (Actual)")
                                    ELSE
                                        IF RecVLE."Gen. Prod. Posting Group" = 'SHIPPING' THEN
                                            SHIPPINGCharges := SHIPPINGCharges + ROUND(RecVLE."Sales Amount (Actual)");
                            FreightChargesTot := FreightCharges + TransportCharges;
                        UNTIL RecVLE.NEXT = 0;
                    //13082020//

                    /*
                    RecSOLD.RESET;
                    RecSOLD.SETRANGE(RecSOLD.Type,RecSOLD.Type::Sale);
                    RecSOLD.SETRANGE(RecSOLD."Invoice No.","Sales Invoice Line"."Document No.");
                    RecSOLD.SETRANGE(RecSOLD."Item No.","Sales Invoice Line"."No.");
                    RecSOLD.SETRANGE(RecSOLD."Tax/Charge Type",RecSOLD."Tax/Charge Type"::Charges);
                    RecSOLD.SETRANGE(RecSOLD."Line No.","Sales Invoice Line"."Line No.");
                    RecSOLD.SETRANGE(RecSOLD."Document Type",RecSOLD."Document Type"::Invoice);
                    IF RecSOLD.FIND('-') THEN
                      REPEAT
                        IF RecSOLD."Tax/Charge Group" = 'FREIGHT' THEN
                          FreightCharges := FreightCharges + ROUND(RecSOLD.Amount)
                        ELSE IF RecSOLD."Tax/Charge Group" = 'TRANSPORT' THEN
                          TransportCharges := TransportCharges + ROUND(RecSOLD.Amount)
                        ELSE IF RecSOLD."Tax/Charge Group" = 'PACKING' THEN
                          PackingCharges := PackingCharges + ROUND(RecSOLD.Amount)
                        ELSE IF RecSOLD."Tax/Charge Group" = 'FORWARDING' THEN
                          ForwardingCharges := ForwardingCharges + ROUND(RecSOLD.Amount);
                        FreightChargesTot := FreightCharges + TransportCharges;
                      UNTIL RecSOLD.NEXT = 0;
                    */
                    TotalConvQty += ROUND("Sales Invoice Line"."Conversion Qty", 1, '=');

                    IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item THEN //19-04-2019
                        TotalQty += "Sales Invoice Line".Quantity;
                    TotalBaseValue += "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                    InvoiceValue := (("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price") + FreightChargesTot + PackingCharges + SHIPPINGCharges + ForwardingCharges + IGST + CGST + 0/*SGST+"Sales Invoice Line"."TDS/TCS Amount"*/- "Sales Invoice Line"."Line Discount Amount");
                    TotalInvoiceValue += InvoiceValue;

                    //20092021
                    RefInvNo_Invoice := '';
                    RefInvDate_Invoice := 0D;
                    GSTExGoods_Invoice := FALSE;
                    RecDetailedGSTLedgEntry.RESET;
                    RecDetailedGSTLedgEntry.SETFILTER(RecDetailedGSTLedgEntry."Document Type", '=%1', RecDetailedGSTLedgEntry."Document Type"::Invoice);
                    RecDetailedGSTLedgEntry.SETRANGE(RecDetailedGSTLedgEntry."Document No.", "Sales Invoice Line"."Document No.");
                    RecDetailedGSTLedgEntry.SETRANGE(RecDetailedGSTLedgEntry."No.", "Sales Invoice Line"."No.");
                    IF RecDetailedGSTLedgEntry.FINDFIRST THEN BEGIN
                        RefInvNo_Invoice := RecDetailedGSTLedgEntry."Original Invoice No.";
                        RefInvDate_Invoice := 0D;//RecDetailedGSTLedgEntry."Original Invoice Date";
                        GSTExGoods_Invoice := RecDetailedGSTLedgEntry."GST Exempted Goods";
                    END;
                    //20092021
                    MakeExcelDataBody;

                end;

                trigger OnPostDataItem();
                begin
                    //MakeExcelDataBody;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(CustPanNo);
                CLEAR(CustGSTNo_Invoice);
                CLEAR(CustLocCode_Invoice);
                IF RecCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                    CustomerBusinessFormat := RecCust."Business Format / Outlet Name";
                    CustName := RecCust.Name;
                    CustName2 := RecCust."Name 2";
                    CustPanNo := RecCust."P.A.N. No.";//CCIT_TK
                    SalesReporting := RecCust."Sales Reporting Field";
                    SalespersonCode := RecCust."Salesperson Code";
                    CustLocCode_Invoice := RecCust."Location Code";
                    CustGSTNo_Invoice := RecCust."GST Registration No.";
                END;

                RecSalesPerson.RESET;
                IF RecSalesPerson.GET(SalespersonCode) THEN
                    SalesPersonName := RecSalesPerson.Name;

                SalesPerson_Trans := '';

                IF RecSalesPerson.GET("Sales Invoice Header"."Salesperson Code") THEN
                    SalesPerson_Trans := RecSalesPerson.Name;
                /*IF RecShip.GET("Sales Invoice Header"."Order No.") THEN BEGIN
                  ShipmentNo:=RecShip."No.";
                END;*/
                //tk
                CLEAR(ShipmentNo);
                RecShip.RESET();
                RecShip.SETRANGE(RecShip."Order No.", "Sales Invoice Header"."Order No.");
                IF RecShip.FIND('-') THEN BEGIN
                    ShipmentNo := RecShip."No.";
                END;

                CLEAR(LocGSTNo_Invoice);
                IF RecLocation1.GET("Sales Invoice Header"."Location Code") THEN
                    LocGSTNo_Invoice := RecLocation1."GST Registration No.";
                //++CCIT-TK-TICKETID-311221
                CLEAR(OrderNo);
                IF "Sales Invoice Header"."Order No." <> '' THEN BEGIN
                    OrderNo := "Sales Invoice Header"."Order No.";
                END ELSE BEGIN
                    RecSIL.RESET();
                    RecSIL.SETRANGE(RecSIL."Document No.", "Sales Invoice Header"."No.");
                    IF RecSIL.FIND('-') THEN BEGIN
                        RECSSH.RESET();
                        RECSSH.SETRANGE(RECSSH."No.", RecSIL."Shipment No.");
                        IF RECSSH.FIND('-') THEN BEGIN
                            OrderNo := RECSSH."Order No.";
                        END;
                    END;
                END;

                //--CCIT-TK-TICKETID-311221
                //++CCIT-TK-TICKETID-010121
                CLEAR(txtExternalDoc);
                IF "Sales Invoice Header"."External Document No." <> '' THEN BEGIN
                    txtExternalDoc := "Sales Invoice Header"."External Document No.";
                END ELSE BEGIN
                    RecSIL.RESET();
                    RecSIL.SETRANGE(RecSIL."Document No.", "Sales Invoice Header"."No.");
                    IF RecSIL.FIND('-') THEN BEGIN
                        RECSSH.RESET();
                        RECSSH.SETRANGE(RECSSH."No.", RecSIL."Shipment No.");
                        IF RECSSH.FIND('-') THEN BEGIN
                            txtExternalDoc := RECSSH."External Document No.";
                        END;
                    END;
                END;

                //--CCIT-TK-TICKETID-010121

            end;

            trigger OnPostDataItem();
            begin

                //IF Document_Type = Document_Type :: Invoice THEN
                //MakeExcelDataFooter;
            end;

            trigger OnPreDataItem();
            begin
                Smpls := TRUE;
                //CCIT-PRI-280318
                CLEAR(LocCode);
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCodeText <> '' THEN
                    "Sales Invoice Header".SETFILTER("Sales Invoice Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318
                /*
                IF Document_Type <> Document_Type :: Invoice THEN
                "Sales Invoice Header".SETRANGE  ("No.",'','');
                */
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", 99990101D, AsOnDate);

                IF NOT Smpls THEN BEGIN
                    "Sales Invoice Header".SETFILTER("Sell-to Customer Name", '<>%1', '@*FREE*');
                    CurrReport.SKIP;
                END;

                IF OnlySmpls THEN BEGIN
                    "Sales Invoice Header".SETFILTER("Sell-to Customer Name", '%1', '@*FREE*');
                END;

            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.", "Location Code", "Salesperson Code";
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          Type = FILTER('Item' | 'G/L Account'));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord();
                begin
                    /*//CCIT-SG-07052019
                    IF "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::"G/L Account" THEN BEGIN
                      IF NOT ("Sales Cr.Memo Line"."No." = '3011001')OR ("Sales Cr.Memo Line"."No." ='301110')OR ("Sales Cr.Memo Line"."No." ='301120')
                        OR ("Sales Cr.Memo Line"."No." ='301130')OR ("Sales Cr.Memo Line"."No." ='301140')OR ("Sales Cr.Memo Line"."No." ='301170') THEN
                          CurrReport.SKIP;
                    END;
                    //CCIT-SG-07052019*/ // ccit vivek


                    CLEAR(FreightChargesTot1);
                    CLEAR(FreightCharges1);
                    CLEAR(PackingCharges1);
                    CLEAR(ForwardingCharges1);

                    Sr_No1 += 1;

                    CGST1 := 0;
                    SGST1 := 0;
                    IGST1 := 0;
                    Rate01 := 0;
                    Rate101 := 0;
                    InvoiceValue1 := 0;

                    RecSalesPrice.RESET;
                    IF RecSalesPrice.GET("Sales Cr.Memo Line"."No.") THEN
                        PriceperKG1 := RecSalesPrice."Conversion Price Per PCS";
                    //QtyPerKg1:= RecSalesPrice."Quantity in KG";

                    QtyPerKg1 := 0;
                    RecSalesPric1.RESET;
                    RecSalesPric1.SETRANGE(RecSalesPric1."Item No.", "Sales Cr.Memo Line"."No.");
                    RecSalesPric1.SETRANGE(RecSalesPric1."Sales Code", "Sales Cr.Memo Line"."Customer Price Group");
                    IF RecSalesPric1.FINDFIRST THEN BEGIN
                        // QtyPerKg1:= RecSalesPric1."Quantity in KG";
                        //QtyPerKg1 := RecSalesPric1."Monthly Qty in Kgs"; // rdk 140819
                        QtyPerKg1 := ROUND(RecSalesPric1."Target Qty in Kgs", 0.01, '>'); //kj_ccit_24082021
                    END;

                    IF "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item THEN BEGIN
                        RecItem.RESET;
                        IF RecItem.GET("Sales Cr.Memo Line"."No.") THEN BEGIN
                            BrandName1 := RecItem."Brand Name";
                            StorageCategory1 := FORMAT(RecItem."Storage Categories");
                            VendorNo1 := RecItem."Vendor No.";
                            SalesCategory := RecItem."Sales Category";
                        END;
                    END ELSE
                        IF "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::"G/L Account" THEN BEGIN
                            RecItem1.RESET;
                            IF RecItem1.GET("Sales Cr.Memo Line"."Item code") THEN BEGIN
                                BrandName1 := RecItem1."Brand Name";
                                VendorNo1 := RecItem1."Vendor No.";
                            END;
                        END;
                    IF "Sales Cr.Memo Line".Type <> "Sales Cr.Memo Line".Type::"G/L Account" THEN BEGIN //CCIT_TK
                        CLEAR(VendName1);
                        IF RecVend.GET(VendorNo1) THEN
                            VendName1 := RecVend.Name;
                    END ELSE BEGIN //CCIT_TK
                        VendName1 := '';//CCIT_TK
                    END;//CCIT_TK


                    RecGSTSetup1.RESET;
                    RecLocation1.RESET;

                    IF RecLocation1.GET("Sales Cr.Memo Header"."Location Code") THEN
                        GST_Location_Code1 := RecLocation1."State Code";


                    IF RecCust.GET("Sales Cr.Memo Header"."Bill-to Customer No.") THEN
                        GST_Bill_Code1 := RecCust."State Code";

                    IF ("Sales Cr.Memo Line"."GST Jurisdiction Type" = "Sales Cr.Memo Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                        Rate01 := 0;//"Sales Cr.Memo Line"."GST %"/2;
                        CGST1 := 0;//"Sales Cr.Memo Line"."Total GST Amount"/2;
                        SGST1 := 0;//"Sales Cr.Memo Line"."Total GST Amount"/2;
                    END
                    ELSE
                        IF ("Sales Cr.Memo Line"."GST Jurisdiction Type" = "Sales Cr.Memo Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                            Rate101 := 0;//"Sales Cr.Memo Line"."GST %";
                            IGST1 := 0;//"Sales Cr.Memo Line"."Total GST Amount";
                        END;

                    TotalCGST1 += CGST1;
                    TotalSGST1 += SGST1;
                    TotalIGST1 += IGST1;
                    //13082020//
                    /*RecSCML.RESET;
                    RecSCML.SETRANGE(RecSCML.Type,RecSCML.Type::"Charge (Item)");
                    RecSCML.SETRANGE(RecSCML."Document No.","Document No.");
                    IF RecSCML.FINDFIRST THEN
                      REPEAT
                        IF RecSCML."No." = 'FREIGHT' THEN
                          FreightCharges := FreightCharges + ROUND(RecSCML.Amount)
                        //ELSE IF RecSOLD."Tax/Charge Group" = 'TRANSPORT' THEN
                          //TransportCharges := TransportCharges + ROUND(RecSOLD.Amount)
                        ELSE IF RecSCML."No." = 'PACKING CHARGES' THEN
                          PackingCharges := PackingCharges + ROUND(RecSCML.Amount)
                        ELSE IF RecSCML."No." = 'FORWARDING CHARGES' THEN
                          ForwardingCharges := ForwardingCharges + ROUND(RecSCML.Amount);
                        FreightChargesTot := FreightCharges + TransportCharges;
                      UNTIL RecSCML."Net Weight"=0;*/

                    RecVLE.RESET;
                    RecVLE.SETRANGE(RecVLE."Document No.", "Document No.");
                    RecVLE.SETRANGE("Item No.", "No.");
                    RecVLE.SETFILTER("Gen. Prod. Posting Group", '<>%1', 'RETAIL');
                    IF RecVLE.FINDFIRST THEN
                        REPEAT
                            IF RecVLE."Gen. Prod. Posting Group" = 'FREIGHT' THEN
                                FreightCharges := FreightCharges + ROUND(RecVLE."Sales Amount (Actual)")
                            ELSE
                                IF RecVLE."Gen. Prod. Posting Group" = 'PACK CHAR' THEN
                                    PackingCharges := PackingCharges + ROUND(RecVLE."Sales Amount (Actual)")
                                ELSE
                                    IF RecVLE."Gen. Prod. Posting Group" = 'FOR&CHAR' THEN
                                        ForwardingCharges := ForwardingCharges + ROUND(RecVLE."Sales Amount (Actual)")
                                    ELSE
                                        IF RecVLE."Gen. Prod. Posting Group" = 'SHIPPING' THEN
                                            SHIPPINGCharges := SHIPPINGCharges + ROUND(RecVLE."Sales Amount (Actual)");

                            FreightChargesTot := FreightCharges + TransportCharges;
                        UNTIL RecVLE.NEXT = 0;
                    //13082020//

                    /*
                    RecSOLD.RESET;
                    RecSOLD.SETRANGE(RecSOLD.Type,RecSOLD.Type::Sale);
                    RecSOLD.SETRANGE(RecSOLD."Invoice No.","Sales Cr.Memo Line"."Document No.");
                    RecSOLD.SETRANGE(RecSOLD."Item No.","Sales Cr.Memo Line"."No.");
                    RecSOLD.SETRANGE(RecSOLD."Tax/Charge Type",RecSOLD."Tax/Charge Type"::Charges);
                    RecSOLD.SETRANGE(RecSOLD."Line No.","Sales Cr.Memo Line"."Line No.");
                    RecSOLD.SETRANGE(RecSOLD."Document Type",RecSOLD."Document Type"::Invoice);
                    IF RecSOLD.FINDFIRST THEN
                      REPEAT
                        IF (RecSOLD."Tax/Charge Group" = 'FREIGHT') THEN
                          FreightCharges1 := FreightCharges1 + ROUND(RecSOLD.Amount)
                         ELSE IF RecSOLD."Tax/Charge Group" = 'TRANSPORT' THEN
                          TransportCharges1 := TransportCharges1 + ROUND(RecSOLD.Amount)
                        ELSE IF RecSOLD."Tax/Charge Group" = 'PACKING' THEN
                          PackingCharges1 := PackingCharges1 + ROUND(RecSOLD.Amount)
                        ELSE IF RecSOLD."Tax/Charge Group" = 'FORWARDING' THEN
                          ForwardingCharges1 := ForwardingCharges1 + ROUND(RecSOLD.Amount);
                     //MESSAGE('%1',FreightCharges1);
                       FreightChargesTot1 += FreightCharges1 + TransportCharges1;
                     UNTIL RecSOLD.NEXT = 0;
                    */
                    IF "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item THEN //19-04-2019
                        TotalQty1 += "Sales Cr.Memo Line".Quantity;

                    TotalConvQty1 += ROUND("Sales Cr.Memo Line"."Conversion Qty", 1, '=');
                    TotalBaseValue1 += "Sales Cr.Memo Line"."Unit Price" * "Sales Cr.Memo Line".Quantity;

                    InvoiceValue1 := (("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price") + FreightChargesTot1 + PackingCharges1 + ForwardingCharges1 + IGST1 + CGST1 + SGST1 + (0/*"Sales Cr.Memo Line"."TDS/TCS Amount"*/) - "Sales Cr.Memo Line"."Line Discount Amount");
                    TotalInvoiceValue1 += InvoiceValue1;
                    /*
                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Document No.","Sales Cr.Memo Line"."Document No.");
                    RecILE.SETRANGE(RecILE."Item No.","Sales Cr.Memo Line"."No.");
                    RecILE.SETRANGE(RecILE."Lot No.","Sales Cr.Memo Line"."Lot No.");
                    */


                    //20092021
                    RefInvNo_Credit := '';
                    RefInvDate_Credit := 0D;
                    GSTExGoods_Credit := FALSE;
                    RecDetailedGSTLedgEntry.RESET;
                    RecDetailedGSTLedgEntry.SETFILTER(RecDetailedGSTLedgEntry."Document Type", '=%1', RecDetailedGSTLedgEntry."Document Type"::"Credit Memo");
                    RecDetailedGSTLedgEntry.SETRANGE(RecDetailedGSTLedgEntry."Document No.", "Sales Cr.Memo Line"."Document No.");
                    RecDetailedGSTLedgEntry.SETRANGE(RecDetailedGSTLedgEntry."No.", "Sales Cr.Memo Line"."No.");
                    IF RecDetailedGSTLedgEntry.FINDFIRST THEN BEGIN
                        RefInvNo_Credit := RecDetailedGSTLedgEntry."Original Invoice No.";
                        RefInvDate_Credit := 0D;// RecDetailedGSTLedgEntry."Original Invoice Date";
                        GSTExGoods_Credit := RecDetailedGSTLedgEntry."GST Exempted Goods";
                    END;
                    //20092021

                    MakeExcelDataBody1;

                end;
            }

            trigger OnAfterGetRecord();
            begin
                //CLEAR(CustPanNo1);
                CLEAR(CustGSTNo_Credit);
                CLEAR(CustLocCode_Credit);
                CLEAR(CustPanNo1);
                IF RecCust.GET("Sales Cr.Memo Header"."Sell-to Customer No.") THEN BEGIN
                    CustomerBusinessFormat1 := RecCust."Business Format / Outlet Name";
                    CustName1 := RecCust.Name;
                    CustName22 := RecCust."Name 2";
                    //CustPanNo1:=RecCust."P.A.N. No.";//CCIT_TK
                    SalesReporting1 := RecCust."Sales Reporting Field";
                    SalespersonCode1 := RecCust."Salesperson Code";
                    CustPanNo1 := RecCust."P.A.N. No.";//CCIT_TK
                    CustGSTNo_Credit := RecCust."GST Registration No.";
                    CustLocCode_Credit := RecCust."Location Code";
                END;
                /*CLEAR(CustPanNo1);
                IF RecCust.GET("Sales Cr.Memo Header"."Sell-to Customer No.") THEN BEGIN
                 CustPanNo1:=RecCust."P.A.N. No.";//CCIT_TK
                END;
                */
                RecSalesPerson.RESET;
                IF RecSalesPerson.GET(SalespersonCode1) THEN
                    SalesPersonName1 := RecSalesPerson.Name;

                SalesPerson_Trans := '';

                IF RecSalesPerson.GET("Sales Cr.Memo Header"."Salesperson Code") THEN
                    SalesPerson_Trans := RecSalesPerson.Name;
                //tk
                CLEAR(ReturnReceiptNo);
                RecReturnRecep.RESET();
                RecReturnRecep.SETRANGE(RecReturnRecep."Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
                IF RecReturnRecep.FIND('-') THEN BEGIN
                    ReturnReceiptNo := RecReturnRecep."No.";
                END;
                //CCIT-Tk
                CLEAR(PreNo);
                IF "Sales Cr.Memo Header"."Pre-Assigned No." <> '' THEN BEGIN
                    PreNo := "Sales Cr.Memo Header"."Pre-Assigned No.";
                END ELSE BEGIN
                    PreNo := "Sales Cr.Memo Header"."Return Order No.";
                END;

                CLEAR(LocGSTNo_Credit);
                IF RecLocation1.GET("Sales Cr.Memo Header"."Location Code") THEN
                    LocGSTNo_Credit := RecLocation1."GST Registration No.";

            end;

            trigger OnPostDataItem();
            begin
                //IF Document_Type = Document_Type :: "Credit Note" THEN
                MakeExcelDataFooter1;
            end;

            trigger OnPreDataItem();
            begin
                Smpls := TRUE;
                //CCIT-PRI-280318
                IF LocCodeText <> '' THEN
                    "Sales Cr.Memo Header".SETFILTER("Sales Cr.Memo Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318
                /*
                IF Document_Type <> Document_Type :: "Credit Note" THEN
                "Sales Cr.Memo Header".SETRANGE  ("No.",'','');
                */
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", 99990101D, AsOnDate); //010199D


                IF NOT Smpls THEN BEGIN
                    "Sales Cr.Memo Header".SETFILTER("Sell-to Customer Name", '<>%1', '@*FREE*');
                    CurrReport.SKIP;
                END;


                IF OnlySmpls THEN BEGIN
                    "Sales Cr.Memo Header".SETFILTER("Sell-to Customer Name", '%1', '@*FREE*');
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
                field("Document Type"; Document_Type)
                {
                    Visible = false;
                }
                group("From Date - To Date Filters")
                {
                    field("From Date"; From_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (AsOnDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
                            END;
                        end;
                    }
                    field("To Date"; To_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (AsOnDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
                            END;
                        end;
                    }
                    field("Include Samples"; Smpls)
                    {
                        Editable = false;
                    }
                    field("Only Samples"; OnlySmpls)
                    {
                    }
                }
                group("As On Date Filter")
                {
                    field("As On Date"; AsOnDate)
                    {

                        trigger OnValidate();
                        begin
                            IF (From_Date <> 0D) AND (To_Date <> 0D) THEN BEGIN
                                AsOnDate := 0D;
                                MESSAGE('From Date - To Date allready Entered...');
                            END;
                        end;
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
        Smpls := TRUE;
    end;

    trigger OnPostReport();
    begin
        //IF Document_Type = Document_Type :: Invoice THEN
        CreateExcelbook;
        //ELSE IF Document_Type = Document_Type :: "Credit Note" THEN
        // CreateExcelbook1;
    end;

    trigger OnPreReport();
    begin
        //MakeExcelInfo;
        //IF Document_Type = Document_Type :: Invoice THEN
        MakeExcelDataHeader;
        //ELSE IF Document_Type = Document_Type :: "Credit Note" THEN
        //MakeExcelDataHeader1;

        Sr_No := 0;
        Sr_No1 := 0;

        TotalCGST := 0;
        TotalSGST := 0;
        TotalIGST := 0;
        TotalConvQty := 0;
        TotalQty := 0;
        TotalBaseValue := 0;
        TotalInvoiceValue := 0;

        TotalCGST1 := 0;
        TotalSGST1 := 0;
        TotalIGST1 := 0;
        TotalConvQty1 := 0;
        TotalQty1 := 0;
        TotalBaseValue1 := 0;
        TotalInvoiceValue1 := 0;

    end;

    var
        txtExternalDoc: Text;
        RECSSH: Record 110;
        OrderNo: Code[20];
        CustPanNo1: Text;
        CustPanNo: Text;
        PreNo: Code[20];
        RecShip: Record 110;
        RecReturnRecep: Record 6660;
        ShipmentNo: Code[20];
        ReturnReceiptNo: Code[20];
        RecItem1: Record 27;
        CustName22: Text[50];
        CustName2: Text[50];
        RecILE: Record 32;
        Document_Type: Option " ",Invoice,"Credit Note";
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        RecCust: Record 18;
        CustomerBusinessFormat: Text[100];
        CustName: Text[100];
        VerticalSubCategory: Code[50];
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        Rate: Decimal;
        Rate1: Decimal;
        RecGSTSetup: Record "GST Setup";
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TotalConvQty: Decimal;
        TotalQty: Decimal;
        TotalBaseValue: Decimal;
        TotalInvoiceValue: Decimal;
        Sr_No1: Integer;
        CGST1: Decimal;
        SGST1: Decimal;
        IGST1: Decimal;
        Rate01: Decimal;
        Rate101: Decimal;
        RecGSTSetup1: Record "GST Setup";
        RecLocation1: Record 14;
        GST_Location_Code1: Code[20];
        GST_Bill_Code1: Code[20];
        CustomerBusinessFormat1: Text[100];
        CustName1: Text[100];
        TotalCGST1: Decimal;
        TotalSGST1: Decimal;
        TotalIGST1: Decimal;
        TotalConvQty1: Decimal;
        TotalQty1: Decimal;
        TotalBaseValue1: Decimal;
        TotalInvoiceValue1: Decimal;
        //RecSOLD : Record "Posted Str Order Line Details";
        FreightCharges: Decimal;
        PackingCharges: Decimal;
        ForwardingCharges: Decimal;
        FreightCharges1: Decimal;
        PackingCharges1: Decimal;
        ForwardingCharges1: Decimal;
        RecItem: Record 27;
        BrandName: Code[20];
        BrandName1: Code[20];
        RecSalesPrice: Record 7002;
        PriceperKG: Decimal;
        PriceperKG1: Decimal;
        RecSalesPerson: Record 13;
        SalesPersonName: Text[50];
        SalesPersonName1: Text[50];
        StorageCategory: Text[20];
        StorageCategory1: Text[20];
        RecVend: Record 23;
        VendorNo: Code[20];
        VendName: Text[50];
        VendorNo1: Code[20];
        VendName1: Text[50];
        InvoiceValue1: Decimal;
        InvoiceValue: Decimal;
        TransportCharges: Decimal;
        TransportCharges1: Decimal;
        FreightChargesTot: Decimal;
        FreightChargesTot1: Decimal;
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RecSIL: Record 113;
        RecSCML: Record 115;
        SalesReporting: Text[200];
        SalesReporting1: Text[200];
        MonthDateChr: Text[50];
        SalesCategory: Text[200];
        SalespersonCode: Code[20];
        SalespersonCode1: Code[20];
        RecReasonCode: Record 231;
        ReasonCodeTxt: Text[250];
        SalesPerson_Trans: Text[50];
        QtyPerKg: Decimal;
        QtyPerKg1: Decimal;
        RecSalesPric1: Record 7002;
        Smpls: Boolean;
        OnlySmpls: Boolean;
        RecRetReasonCode: Record 6635;
        RecVLE: Record 5802;
        ReasonDesc: Text[50];
        CustLocCode_Invoice: Code[20];
        CustGSTNo_Invoice: Code[20];
        CustLocCode_Credit: Code[20];
        CustGSTNo_Credit: Code[20];
        LocGSTNo_Invoice: Code[20];
        LocGSTNo_Credit: Code[20];
        RecDetailedGSTLedgEntry: Record "Detailed GST Ledger Entry";
        RefInvNo_Invoice: Code[20];
        RefInvDate_Invoice: Date;
        RefInvNo_Credit: Code[20];
        RefInvDate_Credit: Date;
        GSTExGoods_Invoice: Boolean;
        GSTExGoods_Credit: Boolean;
        SHIPPINGCharges: Decimal;

    procedure MakeExcelInfo();
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('SALES REGISTER',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */

    end;

    procedure CreateExcelbook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Sales Register.xlsx', 'Sales Register', 'Sales Register', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Sales Register.xlsx', 'Sales Register', 'Sales Register', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Register', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('From Date : ' + FORMAT(From_Date) + '  TO   ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            IF (AsOnDate <> 0D) THEN
                ExcelBuf.AddColumn('As On Date : ' + FORMAT(AsOnDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        //ExcelBuf.AddColumn('Document Number',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Serial Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person Trans', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//03-06-2019
        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn('Fortune Location GST No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer GST No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn('Sales Reporting Field', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New
        ExcelBuf.AddColumn('Customer Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Order No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Order Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Extra in Sales Invoice

        ExcelBuf.AddColumn('ERP SO No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP SO Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ERP INV No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP INV DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP INV Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10-04-2019
        ExcelBuf.AddColumn('Ref.INV No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Ref.INV Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
        ExcelBuf.AddColumn('E-Way Bill No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('E-Way Bill Date.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Zone',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Business format / Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer posting group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Bus. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Sub Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase vendor name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn('Nature of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Customer Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price Group QTY In KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales In PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales In KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Fill Rate%',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Price per kg', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Freight', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Packing charges', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Shpping charges', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Forwarding charges', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn('GST Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Jurisdiction Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
        //RL
        //ExcelBuf.AddColumn('DP/DF',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn('IGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('CGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('SGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Base value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//RL
        //20092021
        ExcelBuf.AddColumn('IGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Discount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TCS Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CR Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Shipment No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Return Receipt No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('HSN/SAC Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        //ExcelBuf.AddColumn('E-Invoice IRN',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Acknowledgement No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Acknowledgement Dt', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        ExcelBuf.AddColumn('Special Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Tally/Temp Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer GRN/RTV No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN/RTV Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PAY REF', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PAY REF Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer PAN No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Exempted Goods', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        //ExcelBuf.AddColumn("Sales Invoice Line"."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Sr_No, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPerson_Trans, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //03-06-2019

        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer Name" + "Sales Invoice Header"."Sell-to Customer Name 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn(LocGSTNo_Invoice, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustGSTNo_Invoice, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustLocCode_Invoice, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn(SalesReporting, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New
        ExcelBuf.AddColumn("Sales Invoice Header"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(txtExternalDoc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn(OrderNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        MonthDateChr := FORMAT("Sales Invoice Header"."Posting Date", 0, '<Month Text>-<Year>');//10-04-2019
        ExcelBuf.AddColumn(MonthDateChr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10-04-2019

        ExcelBuf.AddColumn(RefInvNo_Invoice, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(RefInvDate_Invoice, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//20092021
        ExcelBuf.AddColumn("Sales Invoice Header"."E-Way Bill No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."E-Way Bill Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Shortcut Dimension 2 Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustomerBusinessFormat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Vertical Sub Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(VendName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn("Sales Invoice Header"."Nature of Supply", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."GST Customer Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        //ExcelBuf.AddColumn("Sales Invoice Line"."Sales Category",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BrandName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StorageCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(QtyPerKg, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ROUND("Sales Invoice Line"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item THEN //19-04-2019
            ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
        ELSE
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        //ExcelBuf.AddColumn("Sales Invoice Line"."Fill Rate %",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Sales Invoice Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(FreightChargesTot, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(PackingCharges, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SHIPPINGCharges, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ForwardingCharges, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line"."GST Group Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
        //ExcelBuf.AddColumn('DP/DF',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn(Rate1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Rate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Rate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//RL
        //20092021
        ExcelBuf.AddColumn(IGST, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CGST, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SGST, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //RL Discount
        ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(InvoiceValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        // CCIT AN
        IF RecReasonCode.GET("Sales Invoice Line"."Reason Code") THEN
            ReasonDesc := RecReasonCode.Description;
        ExcelBuf.AddColumn(ReasonDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CCIT AN
        //ExcelBuf.AddColumn("Sales Invoice Line"."Reason Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn(ShipmentNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        //ExcelBuf.AddColumn("Sales Invoice Header"."E-Invoice IRN",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Acknowledgement No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Acknowledgement Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        ExcelBuf.AddColumn("Sales Invoice Line"."Special Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Customer GRN/RTV No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."GRN/RTV Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Your Reference", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."PAY REF DATE", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustPanNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn(GSTExGoods_Invoice, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
    end;

    procedure MakeExcelDataFooter();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //03-06-2019
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//New
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalConvQty, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalQty, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        //ExcelBuf.AddColumn(TotalBaseValue,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//RL
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//RL
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalIGST, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalCGST, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalSGST, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalInvoiceValue, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelInfo1();
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('SALES REGISTER',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */

    end;

    procedure CreateExcelbook1();
    begin
        ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Sales Register Credit Note.xlsx', 'Sales Register Credit Note', 'Sales Register Credit Note', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Register Credit Note', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        //ExcelBuf.AddColumn('Document Number',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Serial Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Person Trans', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Sales Reporting Field', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New

        ExcelBuf.AddColumn('Customer Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Order No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Order Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP SO No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP SO Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ERP INV No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP INV Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn('Zone',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Business format / Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer posting group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Bus. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Sub Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase vendor name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price Group Qty In KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales In PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales In KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Fill Rate%',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Price per kg', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        ExcelBuf.AddColumn('Freight', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Packing charges', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Forwarding charges', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('DP/DF',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Jurisdiction Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
        ExcelBuf.AddColumn('IGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Base value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//RL
        ExcelBuf.AddColumn('Discount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TCS Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CR Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Return Receipt No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('HSN/SAC Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        //ExcelBuf.AddColumn('E-Invoice IRN',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Acknowledgement No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GST Acknowledgement Dt', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        ExcelBuf.AddColumn('Special Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Tally/Temp Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer GRN/RTV No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN/RTV Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer PAN No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody1();
    begin
        ExcelBuf.NewRow;
        //ExcelBuf.AddColumn("Sales Cr.Memo Header"."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Sr_No1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPerson_Trans, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //03-06/2019
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer Name" + "Sales Cr.Memo Header"."Sell-to Customer Name 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn(LocGSTNo_Credit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustGSTNo_Credit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustLocCode_Credit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn(SalesReporting1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Credit Note', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Order Date',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        /*IF "Sales Cr.Memo Header"."Pre-Assigned No." <> '' THEN
           ExcelBuf.AddColumn("Sales Cr.Memo Header"."Pre-Assigned No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text)
        ELSE
           ExcelBuf.AddColumn("Sales Cr.Memo Header"."Return Order No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);*/
        ExcelBuf.AddColumn(PreNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Cr.Memo Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        MonthDateChr := FORMAT("Sales Cr.Memo Header"."Posting Date", 0, '<Month Text>-<Year>');//10-04-2019
        ExcelBuf.AddColumn(MonthDateChr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10-04-2019

        //ExcelBuf.AddColumn("Sales Cr.Memo Header"."Applies-to Doc. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RefInvNo_Credit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RefInvDate_Credit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//20092021
        //ExcelBuf.AddColumn("Sales Cr.Memo Header"."Shortcut Dimension 2 Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Business Format / Outlet Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Vertical Sub Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VendName1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //20092021
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Nature of Supply", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."GST Customer Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        //ExcelBuf.AddColumn("Sales Cr.Memo Line"."Sales Category",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BrandName1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StorageCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(QtyPerKg1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-ROUND("Sales Cr.Memo Line"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        IF "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item THEN
            ExcelBuf.AddColumn(-"Sales Cr.Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
        ELSE
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(-"Sales Cr.Memo Line"."Fill Rate %",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);


        ExcelBuf.AddColumn(FreightChargesTot1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(PackingCharges1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(PackingCharges1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ForwardingCharges1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."GST Group Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
        //ExcelBuf.AddColumn('DP/DF',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //20092021
        ExcelBuf.AddColumn(Rate101, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Rate01, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Rate01, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//RL
        //20092021
        ExcelBuf.AddColumn(-IGST1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-CGST1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-SGST1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-0/*"Sales Cr.Memo Line"."TDS/TCS Amount"*/, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-InvoiceValue1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        // CCIT AN
        //ExcelBuf.AddColumn("Sales Cr.Memo Line"."Reason Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        IF RecReasonCode.GET("Sales Cr.Memo Line"."Reason Code") THEN
            ReasonCodeTxt := RecReasonCode.Description
        ELSE
            IF RecRetReasonCode.GET("Sales Cr.Memo Line"."Return Reason Code") THEN
                ReasonCodeTxt := RecRetReasonCode.Description
            ELSE
                ReasonCodeTxt := '';
        ExcelBuf.AddColumn(ReasonCodeTxt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CCIT AN
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ReturnReceiptNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Cr.Memo Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //CITS_RS 090221
        //ExcelBuf.AddColumn("Sales Cr.Memo Header"."E-Invoice IRN",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."E-Invoice Acknowledgment No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."E-Invoice Acknowledement Dt", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CITS_RS 090221
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Special Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Tally Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Customer GRN/RTV No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."GRN/RTV Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn(CustPanNo1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//123
        ExcelBuf.AddColumn(GSTExGoods_Credit, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021

    end;

    procedure MakeExcelDataFooter1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //03-06-2019
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//New
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        //20092021
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(TotalConvQty - TotalConvQty1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalQty - TotalQty1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(TotalBaseValue1,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//RL
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//RL

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //20092021
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //20092021
        ExcelBuf.AddColumn(TotalIGST - TotalIGST1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalCGST - TotalCGST1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(TotalSGST - TotalSGST1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20092021
        ExcelBuf.AddColumn(TotalInvoiceValue - TotalInvoiceValue1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //20092021
    end;
}

