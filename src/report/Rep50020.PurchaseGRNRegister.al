report 50020 "Purchase GRN Register"
{
    // version CCIT-JAGA-Using

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            RequestFilterFields = "No.", "Location Code";
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    Sr_No1 += 1;

                    //<<PCPL/NSW/MIG 18July22
                    IF ItemParent.Get("Purch. Cr. Memo Line"."Item Category Code") then;

                    //>>PCPL/NSW/MIG 18July22

                    RecSalesPrice.RESET;
                    IF RecSalesPrice.GET("Purch. Cr. Memo Line"."No.") THEN
                        PricePerKG1 := RecSalesPrice."Conversion Price Per PCS";

                    CLEAR(LaunchMonth);
                    RecItem.RESET;
                    IF RecItem.GET("Purch. Cr. Memo Line"."No.") THEN BEGIN
                        BrandName1 := RecItem."Brand Name";
                        SalesCategory1 := RecItem."Sales Category";
                        LaunchMonth := FORMAT(RecItem."Launch Month", 0, '<Month Text,20><Year4>');
                    END;

                    RecILE.RESET;
                    //RecILE.SETRANGE("Document No.","Purchase Line"."Document No.");
                    RecILE.SETRANGE(RecILE."Item No.", "Purch. Cr. Memo Line"."No.");
                    IF RecILE.FINDFIRST THEN BEGIN
                        Batch1 := RecILE."Lot No.";
                        MFGDate1 := RecILE."Manufacturing Date";
                        EXPDate1 := RecILE."Expiration Date";
                    END;


                    TotalQty1 += "Purch. Cr. Memo Line".Quantity;
                    TotalDiscount1 += "Purch. Cr. Memo Line"."Line Discount Amount";
                    TotalAmount1 += "Purch. Cr. Memo Line".Amount;

                    MakeExcelDataBody1;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecVend.GET("Purch. Cr. Memo Hdr."."Buy-from Vendor No.") THEN BEGIN
                    VendName1 := RecVend.Name;
                    VendCountry1 := RecVend."Country/Region Code";
                END;
            end;

            trigger OnPostDataItem();
            begin
                IF Document_Type = Document_Type::"Credit Note" THEN;


                //MakeExcelTotal1;
            end;

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCodeText <> '' THEN
                    "Purch. Cr. Memo Hdr.".SETFILTER("Purch. Cr. Memo Hdr."."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF Document_Type <> Document_Type::"Credit Note" THEN
                    "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."No.", '', '');

                //---

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."Posting Date", 99990101D, AsOnDate);

                //---
            end;
        }
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.", "Location Code";
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0));
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Document Line No." = FIELD("Line No.");

                    trigger OnAfterGetRecord();
                    begin
                        Sr_No2 += 1;
                        CLEAR(QtyNSinKGS);
                        CLEAR(QtyNSinPCS);
                        CLEAR(ReasonDes); //CCIT-JAGA 07/12/2018

                        //<<PCPL/NSW/MIG 18July22
                        IF ItemParent1.Get("Item Ledger Entry"."Item Category Code") then;

                        //>>PCPL/NSW/MIG 18July22

                        //Sr_No2 += 1;

                        RecPRL.RESET;
                        RecPRL.SETRANGE(RecPRL."Document No.", "Item Ledger Entry"."Document No.");
                        RecPRL.SETRANGE(RecPRL."Line No.", "Item Ledger Entry"."Document Line No.");
                        IF RecPRL.FINDFIRST THEN
                            DaysTaken := "Purch. Rcpt. Line"."Order Date" - "Purch. Rcpt. Line"."Posting Date";

                        RecSalesPrice.RESET;
                        IF RecSalesPrice.GET("Item Ledger Entry"."Item No.") THEN
                            PricePerKG2 := RecSalesPrice."Conversion Price Per PCS";

                        RecItem.RESET;
                        IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                            BrandName2 := RecItem."Brand Name";
                            SalesCategory2 := RecItem."Sales Category";
                            Desc1 := RecItem.Description;
                            Desc2 := RecItem."Description 2";
                            Vertical := RecItem."Gen. Prod. Posting Group";
                            ProdType := RecItem."Product Type";
                        END;


                        TotalQty2 += "Item Ledger Entry".Quantity;
                        TotalConQty2 += ROUND("Item Ledger Entry"."Conversion Qty", 1, '=');

                        TotalVarQtyKG += "Item Ledger Entry"."Damage Qty. In KG";
                        TotalVarQtyPCS += ROUND("Item Ledger Entry"."Damage Qty. In PCS", 1, '=');

                        //TotalDiscount2 += "Purch. Rcpt. Line";


                        //MakeExcelDataBody2;

                        //>>>
                        DamageKG := 0;
                        DamagePCS := 0;
                        POQtyKG := 0;
                        POQtyPCS := 0;
                        RecPostInvPutAwayLine.RESET;
                        RecPostInvPutAwayLine.SETRANGE(RecPostInvPutAwayLine."Source No.", "Purch. Rcpt. Line"."Order No.");
                        RecPostInvPutAwayLine.SETRANGE(RecPostInvPutAwayLine."Source Line No.", "Purch. Rcpt. Line"."Order Line No.");
                        RecPostInvPutAwayLine.SETRANGE(RecPostInvPutAwayLine."Lot No.", "Item Ledger Entry"."Lot No.");
                        IF RecPostInvPutAwayLine.FINDSET THEN
                            REPEAT
                                POQtyKG := RecPostInvPutAwayLine.Quantity + RecPostInvPutAwayLine."Damage Qty. In PCS";
                                POTotQty += RecPostInvPutAwayLine.Quantity + RecPostInvPutAwayLine."Damage Qty. In PCS";
                                DamageKG := RecPostInvPutAwayLine."Damage Qty. In KG";
                                DamagePCS := RecPostInvPutAwayLine."Damage Qty. In PCS";
                                TotDamageKG += DamageKG;
                                TotDamagePCS += DamagePCS;
                                IF ItemRec.GET(RecPostInvPutAwayLine."Item No.") THEN BEGIN
                                    IF UOMRec.GET(ItemRec."No.", ItemRec."Base Unit of Measure") THEN BEGIN
                                        IF (UOMRec.Weight <> 0) THEN BEGIN
                                            //MESSAGE('%1  %2',"Posted Invt. Put-away Line"."Item No.","Posted Invt. Put-away Line".Quantity);
                                            POQtyPCS := (RecPostInvPutAwayLine.Quantity / UOMRec.Weight) + RecPostInvPutAwayLine."Damage Qty. In KG";
                                            TotQtyPCS += (RecPostInvPutAwayLine.Quantity / UOMRec.Weight) + RecPostInvPutAwayLine."Damage Qty. In KG";
                                            //GRNQtyPCS += RecPostInvPutAwayLine.Quantity / UOMRec.Weight;
                                        END;
                                    END;
                                END;
                            UNTIL RecPostInvPutAwayLine.NEXT = 0;
                        //END;

                        RecILE.RESET;
                        RecILE.SETRANGE(RecILE."Document No.", "Item Ledger Entry"."Document No.");
                        RecILE.SETFILTER(RecILE."Entry Type", 'Transfer');
                        RecILE.SETRANGE(RecILE."Item No.", "Item Ledger Entry"."Item No.");
                        RecILE.SETRANGE(RecILE."Lot No.", "Item Ledger Entry"."Lot No.");
                        IF RecILE.FINDFIRST THEN BEGIN
                            QtyNSinKGS := ABS(RecILE.Quantity);
                        END;

                        IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                            IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM.Weight <> 0) THEN BEGIN
                                    QtyNSinPCS := ROUND((QtyNSinKGS / RecUOM.Weight), 1, '=');
                                END
                            END
                        END;


                        MakeExcelDataBody2
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    CLEAR(PO_Qty_KG);
                    CLEAR(PO_Qty_PCS);
                    CLEAR(DUC); //02122021 CCIT AN

                    RecPL.RESET;
                    RecPL.SETRANGE(RecPL."Document No.", "Purch. Rcpt. Line"."Order No.");
                    RecPL.SETRANGE(RecPL."Line No.", "Purch. Rcpt. Line"."Line No.");
                    RecPL.SETRANGE(RecPL."No.", "Purch. Rcpt. Line"."No.");
                    IF RecPL.FINDSET THEN BEGIN
                        PO_Qty_KG := RecPL.Quantity;
                        PO_Qty_PCS := RecPL."Conversion Qty";
                        DUC := RecPL."Direct Unit Cost";     //02122021 CCIT AN

                    END;

                    CLEAR(LaunchMonth1);
                    RecItem.RESET;
                    IF RecItem.GET("Purch. Rcpt. Line"."No.") THEN BEGIN
                        LaunchMonth1 := FORMAT(RecItem."Launch Month", 0, '<Month Text,20><Year4>');
                    END;
                    //MakeExcelDataBody2;
                end;

                trigger OnPostDataItem();
                begin
                    IF Document_Type = Document_Type::GRN THEN;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecVend.GET("Purch. Rcpt. Header"."Buy-from Vendor No.") THEN BEGIN
                    VendName2 := RecVend.Name;
                    VendCountry2 := RecVend."Country/Region Code";
                END;

                IF RecPaymentTerms.GET("Purch. Rcpt. Header"."Payment Terms Code") THEN
                    PaymentDesc := RecPaymentTerms.Description;

                //16112021 CCIT AN
                CLEAR(InvNo);
                CLEAR(InvDate);
                CLEAR(CurrencyCode);

                PurchHeader.RESET;
                PurchHeader.SETRANGE("No.", "Purch. Rcpt. Header"."Order No.");
                PurchHeader.SETRANGE("Buy-from Vendor No.", "Purch. Rcpt. Header"."Buy-from Vendor No.");
                IF PurchHeader.FINDFIRST THEN
                    REPEAT
                        InvNo := PurchHeader."Vendor Invoice No.";
                        InvDate := PurchHeader."Vendor Invoiced Date";
                        CurrencyCode := PurchHeader."Currency Code";
                    UNTIL PurchHeader.NEXT = 0;
                //16112021 CCIT AN
            end;

            trigger OnPostDataItem();
            begin

                MakeExcelTotal2;
            end;

            trigger OnPreDataItem();
            begin
                IF Document_Type <> Document_Type::GRN THEN
                    "Purch. Rcpt. Header".SETRANGE("Purch. Rcpt. Header"."No.", '', '');

                //CCIT-PRI-280318
                "Purch. Rcpt. Header".SETFILTER("Purch. Rcpt. Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                //---
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Purch. Rcpt. Header".SETRANGE("Purch. Rcpt. Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Purch. Rcpt. Header".SETRANGE("Purch. Rcpt. Header"."Posting Date", 99990101D, AsOnDate);
                //---
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
                group("From Date - To Date Filter")
                {
                    field("Document Type"; Document_Type)
                    {
                    }
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

    trigger OnPostReport();
    begin


        IF Document_Type = Document_Type::"Credit Note" THEN
            CreateExcelBook1
        ELSE
            IF Document_Type = Document_Type::GRN THEN
                CreateExcelBook2;
    end;

    trigger OnPreReport();
    begin

        IF Document_Type = Document_Type::"Credit Note" THEN
            MakeExcelDataHeader1
        ELSE
            IF Document_Type = Document_Type::GRN THEN
                MakeExcelDataHeader2;

        Sr_No := 0;
        Sr_No1 := 0;
        Sr_No2 := 0;

        TotalQty := 0;
        TotalDiscount := 0;
        TotalAmount := 0;

        TotalQty2 := 0;
        TotalConQty2 := 0;
        TotalVarQtyPCS := 0;
        TotalVarQtyKG := 0;
    end;

    var
        ItemParent: Record 5722;
        ItemParent1: Record 5722;
        AsOnDate: Date;
        From_Date: Date;
        To_Date: Date;
        RecUOM: Record 5404;
        QtyNSinPCS: Decimal;
        QtyNSinKGS: Decimal;
        ExcelBuf: Record 370 temporary;
        Document_Type: Option " ","Credit Note",GRN;
        Sr_No: Integer;
        Sr_No1: Integer;
        RecVend: Record 23;
        VendName: Text[50];
        TotalQty: Decimal;
        TotalDiscount: Decimal;
        TotalAmount: Decimal;
        TotalQty1: Decimal;
        TotalDiscount1: Decimal;
        TotalAmount1: Decimal;
        VendName1: Text[50];
        RecItem: Record 27;
        BrandName: Code[20];
        BrandName1: Code[20];
        RecSalesPrice: Record 7002;
        PricePerKG: Decimal;
        PricePerKG1: Decimal;
        Sr_No2: Integer;
        PricePerKG2: Decimal;
        TotalQty2: Decimal;
        TotalDiscount2: Decimal;
        TotalAmount2: Decimal;
        VendCountry: Code[20];
        VendCountry1: Code[20];
        VendCountry2: Code[20];
        VendName2: Text[50];
        BrandName2: Code[20];
        SalesCategory2: Code[20];
        RecILE: Record 32;
        Batch2: Code[20];
        MFGDate2: Date;
        EXPDate2: Date;
        SalesCategory1: Code[20];
        Batch1: Code[20];
        MFGDate1: Date;
        EXPDate1: Date;
        VarQtyKGS: Decimal;
        VarQtyPCS: Decimal;
        DaysTaken: Integer;
        POBatch2: Code[20];
        POMFGDate2: Date;
        POEXPDate2: Date;
        Desc1: Text[50];
        Desc2: Text[50];
        Vertical: Code[10];
        ProdType: Code[20];
        RecPRL: Record 121;
        TotalConQty2: Decimal;
        TotalVarQtyKG: Decimal;
        TotalVarQtyPCS: Decimal;
        RecPL: Record 39;
        PO_Qty_KG: Decimal;
        PO_Qty_PCS: Decimal;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RecPostInvPutAwayHeader: Record 7340;
        RecPostInvPutAwayLine: Record 7341;
        POTotQty: Decimal;
        ItemRec: Record 27;
        UOMRec: Record 5404;
        TotQtyPCS: Decimal;
        GRNQtyPCS: Decimal;
        DamageKG: Decimal;
        DamagePCS: Decimal;
        TotDamageKG: Decimal;
        TotDamagePCS: Decimal;
        POQtyKG: Decimal;
        POQtyPCS: Decimal;
        RecPaymentTerms: Record 3;
        PaymentDesc: Text[200];
        RecReasonCode: Record 231;
        ReasonDes: Text[50];
        LaunchMonth: Code[50];
        LaunchMonth1: Code[50];
        PurchHeader: Record 38;
        InvNo: Code[50];
        InvDate: Date;
        CurrencyCode: Code[10];
        DUC: Decimal;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Purchase GRN Register.xlsx', 'Purchase GRN Register', 'Purchase GRN Register', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Purchase GRN Register.xlsx', 'Purchase GRN Register', 'Purchase GRN Register', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure CreateExcelBook1();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Purchase Register Credit Note.xlsx', 'Purchase Register Credit Note', 'Purchase Register Credit Note', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Purchase Register Credit Note.xlsx', 'Purchase Register Credit Note', 'Purchase Register Credit Note', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader1();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Register Credit Note', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Serial Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Import/Local', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country/Region Of Origin Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Transport Mode', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('In Location', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Bond w/h in Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN No-Fortune', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.O.Date-Fortune', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Number(Fortune)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Service/Product', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mode Of Shipment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Prod. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Parent Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//PCPL/NSW/MIG 18July22 New Field Addd

        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Qty in KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Qty in PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('PO Batch Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Expiry Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SNW GRN Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SNW GRN Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Days Taken to Complete GRN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Qty in KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Qty in PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Batch Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('GRN Expiry Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Date(Booking)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variance Qty in KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variance Qty in PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Launch Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT-02-11-2021
    end;

    procedure MakeExcelDataBody1();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Sr_No1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."VAT Country/Region Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Transport Method", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Bond Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Shipment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemParent."Parent Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22

        ExcelBuf.AddColumn("Purch. Rcpt. Line"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BrandName1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Purch. Cr. Memo Line"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Batch1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MFGDate1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(EXPDate1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."JWL BOND GRN No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."JWL BOND GRN Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn('Days Taken to Complete GRN', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Purch. Cr. Memo Line"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('GRN Batch Number', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN MFG Date', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('GRN Expiry Date', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Date(Booking)', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variance Qty in PCS', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variance Qty in KGS', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LaunchMonth, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelTotal1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TotalQty1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TotalDiscount1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalAmount1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
    end;

    procedure CreateExcelBook2();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Purchase Register GRN.xlsx', 'Purchase Register GRN', 'Purchase Register GRN', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Purchase Register GRN.xlsx', 'Purchase Register GRN', 'Purchase Register GRN', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader2();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Register GRN', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('SR No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country/Region Of Origin Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Import/Local', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mode Of Shipment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Transport Mode', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Container Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Terms', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Terms Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Vendor Order No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('P.O.No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.O.Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('In Location', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fortune Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Vertical', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Parent Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('PO QTY-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO QTY-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ERP GRN QTY-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP GRN QTY-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Batch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('PO Exp. Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETD-Supplier Warehouse', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETD-Origin Port', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Port Of Loading-Air', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Port Of Loading-Ocean', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Destination Port-Air', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Destinaion Port-Ocean', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETA-Destination Port', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETA-Destination CFS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETA-Bond', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ETA-Availability For Sale', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SNW GRN NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SNW GRN DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('In Date Bond', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('ERP In Location',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ERP GRN No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP GRN Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN BATCH', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN MFG DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN EXP. DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Qurantine QTY-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qurantine QTY-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Actual QTY-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Actual QTY-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Variance In KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variance In PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Launch Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //16112021 CCIT AN
        ExcelBuf.AddColumn('Vendor Invoice No ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //16112021 CCIT AN
        //02122021 CCIT AN
        ExcelBuf.AddColumn('Price in KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Currency Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //02122021 CCIT AN
    end;

    procedure MakeExcelDataBody2();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Sr_No2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."VAT Country/Region Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Shipment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Transport Method", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Container Filter", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(PaymentDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Vendor Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Desc2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Desc1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemParent1."Parent Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22

        ExcelBuf.AddColumn("Item Ledger Entry"."Gen.Prod.Post.Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ProdType, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(BrandName2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(POQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(POQtyPCS, 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Item Ledger Entry".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Item Ledger Entry"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Item Ledger Entry"."PO Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."PO Manufacturing Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Item Ledger Entry"."PO Expiration Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."ETD - Supplier Warehouse", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."ETD - Origin Port", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Port of Loading-Air", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Port of Loading-Ocean", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Port of Destination-Air", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Port of Destination-Ocean", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."ETA - Destination Port", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."ETA - Destination CFS", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."ETA - Bond", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Purch. Rcpt. Header"."ETA - Availability for Sale", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."JWL BOND GRN No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."JWL BOND GRN Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Item Ledger Entry"."In-Bond BOE Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('ERP In Location',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purch. Rcpt. Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Rcpt. Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Item Ledger Entry"."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Warranty Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Item Ledger Entry"."Expiration Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn(QtyNSinKGS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(QtyNSinPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Item Ledger Entry".Quantity - QtyNSinKGS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Item Ledger Entry"."Conversion Qty", 1, '=') - QtyNSinPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //MESSAGE('%1  %2',DamageKG,DamagePCS);
        ExcelBuf.AddColumn(ROUND(DamagePCS, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(DamageKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn("Item Ledger Entry"."Reason Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);  //CCIT-JAGA 07/12/2018
        //CCIT-JAGA 07/12/2018
        IF RecReasonCode.GET("Item Ledger Entry"."Return Reason Code") THEN //PCPL/MIG/NSW
            ReasonDes := RecReasonCode.Description;
        ExcelBuf.AddColumn(ReasonDes, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LaunchMonth1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CCIT-JAGA 07/12/2018
        //16112021 CCIT AN
        ExcelBuf.AddColumn(InvNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(InvDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //16112021 CCIT AN
        //02122021 CCIT AN
        ExcelBuf.AddColumn(DUC, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrencyCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //02122021 CCIT AN
    end;

    procedure MakeExcelTotal2();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(POTotQty, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotQtyPCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(TotalQty2, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalConQty2, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('ERP In Location',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TotDamagePCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotDamageKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;
}

