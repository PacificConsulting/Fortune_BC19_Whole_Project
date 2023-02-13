report 50028 "Inventory Planning HO"
{
    // version CCIT-JAGA

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Entry Type", "Posting Date", "Location Code")
                                ORDER(Ascending)
                                WHERE("Entry Type" = FILTER('Purchase' | 'Transfer' | 'Positive Adjmt.' | 'Negative Adjmt.' | 'Sale'));
            RequestFilterFields = "Item No.", "Location Code", "Source No.";

            trigger OnAfterGetRecord();
            begin

                //MESSAGE('%1',"Item Ledger Entry"."Item No.");
                ItemRec.RESET;
                ItemRec.SETRANGE("No.", "Item Ledger Entry"."Item No.");
                IF ItemRec.FINDFIRST THEN BEGIN
                    IF ItemRec.Blocked = TRUE THEN
                        CurrReport.SKIP;
                END;

                ItemFilter := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Item No.");

                ProductDesc := '';
                Brand := '';
                SupplProdDesc := '';
                Vertical := '';
                SalesCategory := '';

                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    ProductDesc := RecItem.Description;
                    Brand := RecItem."Brand Name";
                    SupplProdDesc := RecItem."Description 2";
                    Vertical := RecItem."Gen. Prod. Posting Group";
                    SalesCategory := RecItem."Sales Category";
                    VendNum1 := RecItem."Vendor No.";
                    UOM := RecItem."Conversion UOM";
                    ConUOM := RecItem."Base Unit of Measure";
                END;

                IF RecVend.GET(VendNum1) THEN
                    Supplier := RecVend.Name;


                ItemTotal := 0;
                RecILE3.RESET;
                RecILE3.SETCURRENTKEY("Item No.", "Entry Type");//CCIT-HG-080519
                RecILE3.SETRANGE(RecILE3."Item No.", "Item Ledger Entry"."Item No.");
                RecILE3.SETFILTER(RecILE3."Entry Type", '%1|%2|%3|%4|%5', RecILE3."Entry Type"::Purchase, RecILE3."Entry Type"::Transfer, RecILE3."Entry Type"::"Positive Adjmt.", RecILE3."Entry Type"::"Negative Adjmt.", RecILE3."Entry Type"::Sale);
                RecILE3.CALCSUMS(RecILE3."Remaining Quantity");
                ItemTotal += RecILE3."Remaining Quantity";



                IF (CurrItem = 'CRONUS BLANK') THEN BEGIN
                    CurrItem := "Item Ledger Entry"."Item No.";
                    I := 0;
                    ItemCounter := EntryCount(CurrItem);
                END;
                I += 1;


                IF I = ItemCounter THEN BEGIN
                    MakeExcelDataBody;
                    //MakeExcelTotal;
                    CurrItem := 'CRONUS BLANK';
                    ItemCounter := 0;
                END;
            end;

            trigger OnPostDataItem();
            begin
                MakeExcelTotal;
            end;

            trigger OnPreDataItem();
            begin
                LocFilters := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");
                IF (Date <> 0D) THEN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 99990101D, TODAY);

                MakeExcelDataHeader;
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
                group("Request Fields")
                {
                    field("From Date"; From_Date)
                    {
                        Visible = false;
                    }
                    field("To Date"; To_Date)
                    {
                        Visible = false;
                    }
                    field("Vendor No."; VendorNo)
                    {
                        TableRelation = Vendor."No.";
                        Visible = false;
                    }
                    field("Location Code"; LocCode)
                    {
                        TableRelation = Location.Code;
                        Visible = false;
                    }
                    field(Date; Date)
                    {
                    }
                    field("DAS Filter"; DAS_Filter)
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
        CurrItem := 'CRONUS BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        IF Date <> 0D THEN BEGIN
            IF (DAS_Filter = DAS_Filter::"1Month") THEN BEGIN
                To_Date := Date;
                Date1 := CALCDATE('<-30D>', Date);
                From_Date := Date1;
            END
            ELSE
                IF DAS_Filter = DAS_Filter::"2Month" THEN BEGIN
                    To_Date := Date;
                    Date2 := CALCDATE('<-60D>', Date);
                    From_Date := Date2;
                END;
        END;
    end;

    var
        From_Date: Date;
        To_Date: Date;
        ExcelBuf: Record 370 temporary;
        Supplier: Text[50];
        RecVend: Record 23;
        TotalUseShelfLifeDays: Decimal;
        DaysToExpire: Integer;
        ShelfLifePerAvailable: Decimal;
        ProductDesc: Text[100];
        RecItem: Record 27;
        RecILE: Record 32;
        RecILE33: Record 32;
        I: Integer;
        LocCount: Integer;
        Brand: Code[50];
        RecLoc: Record 14;
        RecLocation: Record 14;
        GlobLoc: Text[100];
        RecILE2: Record 32;
        LocQtyPCS: Decimal;
        RecILE3: Record 32;
        RecILE4: Record 32;
        ItemTotal: Decimal;
        LocTotalPCS: Decimal;
        QtyInKG: Decimal;
        QtyinPCS: Decimal;
        LocTotalKG: Decimal;
        LocQtyKG: Decimal;
        ItemCounter: Integer;
        VendorNo: Code[10];
        LocCode: Code[20];
        TotalLocQtyPCS: Decimal;
        TotalLocQtyKG: Decimal;
        CurrLoc: Code[20];
        CurrItem: Code[20];
        CurrBatch: Code[20];
        CurrDocNo: Code[20];
        PostingDateFilter: Text[50];
        GrandTotalInPCS: Decimal;
        GrandTotalInKGS: Decimal;
        GrandLocQtyPCS: Decimal;
        GrandLocQtyKG: Decimal;
        Date: Date;
        DAS_Filter: Option "1Month","2Month";
        SupplProdDesc: Text[100];
        Vertical: Code[20];
        SalesCategory: Code[20];
        Date1: Date;
        Date2: Date;
        DASValue1: Decimal;
        DASValue2: Decimal;
        DAYS1: Decimal;
        DAYS2: Integer;
        LocFilters: Text[250];
        PurchLine: Record 39;
        ItemTotal1: Decimal;
        RecILE5: Record 32;
        GrandTotalSales: Decimal;
        DASValue11: Decimal;
        DAYS11: Decimal;
        VendNum1: Code[20];
        RecUOM1: Record 5404;
        UOM: Code[10];
        ConUOM: Code[10];
        ItemRec: Record 27;
        ItemCounterTotal: Integer;
        M: Integer;
        CurrTotal: Code[20];
        CurrPostDate: Date;
        CurrEntryType: Option;
        ItemFilter: Text[250];
        TotalLocQtyPCS1: Decimal;
        TotalLocQtyKG1: Decimal;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\INVENTORY PLANNING PURCHASE HO REPORT.xlsx', 'INVENTORY PLANNING PURCHASE HO REPORT', 'INVENTORY PLANNING PURCHASE HO REPORT', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\INVENTORY PLANNING PURCHASE HO REPORT.xlsx', 'INVENTORY PLANNING PURCHASE HO REPORT', 'INVENTORY PLANNING PURCHASE HO REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('INVENTORY PLANNING PURCHASE HO', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date :' + FORMAT(From_Date) + '  To  ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time Of Loading :' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19-01-2018
        ExcelBuf.AddColumn('Fortune Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Conversion UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        RecLoc.RESET;
        //IF GlobLoc <> '' THEN
        //RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO",TRUE);
        IF LocFilters <> '' THEN
            RecLoc.SETFILTER(RecLoc.Code, STRSUBSTNO('%1', LocFilters))
        ELSE
            RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;
        ExcelBuf.AddColumn('Total PAN INDIA', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('TotalSales In KGs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//Total Sales

        ExcelBuf.AddColumn('DAS In KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days IOH WL Last1', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Today Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date IOH WL Last', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //>>
        ExcelBuf.AddColumn('Intransit 1', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Intransit 2', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Intransit 3', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Intransit 4', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Intransit 5', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);


        //<<
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//19-01-2018
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        RecLocation.RESET;
        IF LocFilters <> '' THEN
            RecLocation.SETFILTER(RecLocation.Code, STRSUBSTNO('%1', LocFilters))
        ELSE
            RecLocation.SETRANGE(RecLocation."Used In Inventory Planning HO", TRUE);
        IF RecLocation.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('IOH in KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('IOH in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLocation.NEXT = 0;
        ExcelBuf.AddColumn('IOH in KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IOH in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//Total Sales


        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //>> Intrasit -1
        ExcelBuf.AddColumn('PO No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Available for Sale ', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //<<

        //>> Intrasit -2
        ExcelBuf.AddColumn('PO No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Available for Sale ', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //<<

        //>> Intrasit -3
        ExcelBuf.AddColumn('PO No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Available for Sale ', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //<<

        //>> Intrasit -4
        ExcelBuf.AddColumn('PO No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Available for Sale ', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //<<

        //>> Intrasit -5
        ExcelBuf.AddColumn('PO No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Available for Sale ', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //<<
    end;

    procedure MakeExcelDataBody();
    var
        i: Integer;
        PurchHeader: Record 38;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19-01-2018
        ExcelBuf.AddColumn(ProductDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SupplProdDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(UOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ConUOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //JAGA
        GrandLocQtyPCS := 0;
        GrandLocQtyKG := 0;
        //JAGA
        TotalLocQtyPCS := 0;
        TotalLocQtyKG := 0;
        RecLoc.RESET;
        IF LocFilters <> '' THEN
            RecLoc.SETFILTER(RecLoc.Code, STRSUBSTNO('%1', LocFilters))
        ELSE
            RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO", TRUE);
        IF RecLoc.FINDFIRST THEN
            REPEAT
                LocQtyPCS := 0;
                LocQtyKG := 0;
                RecILE2.RESET;
                RecILE2.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                RecILE2.SETRANGE(RecILE2."Item No.", "Item Ledger Entry"."Item No.");
                RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, TODAY);
                RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                IF RecILE2.FINDSET THEN
                    REPEAT
                        LocQtyPCS := LocQtyPCS + RecILE2."Remaining Quantity";
                        IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                            IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM1.Weight <> 0) THEN BEGIN
                                    LocQtyKG := LocQtyKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                    //MESSAGE('%1...%2.. %3',RecILE2."Entry No.",RecLoc.Code,LocTotalKG);
                                END
                            END
                        END;
                    UNTIL RecILE2.NEXT = 0;
                TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;

                GrandTotalInPCS += LocQtyPCS;
                GrandTotalInKGS += LocQtyKG;

                // LOcation wise PCS and KG
                ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(LocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

            UNTIL RecLoc.NEXT = 0;
        // Line wise Total for Total PAN INDIA
        ExcelBuf.AddColumn(TotalLocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalLocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ItemTotal1 := 0;//Total Sales
        RecILE5.RESET;
        RecILE5.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");  //CCIT-JAGA 29/10/2018
        RecILE5.SETRANGE(RecILE5."Item No.", "Item Ledger Entry"."Item No.");
        RecILE5.SETRANGE(RecILE5."Entry Type", RecILE5."Entry Type"::Sale);
        RecILE5.SETRANGE(RecILE5."Posting Date", From_Date, To_Date);
        RecILE5.CALCSUMS(RecILE5.Quantity);
        ItemTotal1 += RecILE5.Quantity;
        GrandTotalSales += ABS(ItemTotal1); //Grand total for sales

        ExcelBuf.AddColumn(ABS(ItemTotal1), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Total Sales



        IF DAS_Filter = DAS_Filter::"1Month" THEN BEGIN
            //IF ItemTotal1 <> 0 THEN
            DASValue1 := ROUND((ABS(ItemTotal1) / 26), 0.1, '=');
            IF DASValue1 <> 0 THEN
                DAYS1 := ROUND(TotalLocQtyPCS / DASValue1, 1, '=');
            ExcelBuf.AddColumn(DASValue1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(DAYS1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
            ExcelBuf.AddColumn(TODAY + DAYS1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        END
        ELSE
            IF DAS_Filter = DAS_Filter::"2Month" THEN BEGIN
                //IF ItemTotal1 <> 0 THEN
                DASValue2 := ROUND(ABS(ItemTotal1) / 52, 0.1, '=');
                IF DASValue2 <> 0 THEN
                    DAYS2 := ROUND(TotalLocQtyPCS / DASValue2, 1, '=');
                ExcelBuf.AddColumn(DASValue2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(DAYS2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                ExcelBuf.AddColumn(TODAY + DAYS2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
            END;

        i := 0;
        PurchLine.RESET;
        PurchLine.SETRANGE("No.", "Item Ledger Entry"."Item No.");
        PurchLine.SETFILTER(PurchLine."Document Type", '%1', PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Quantity Received", 0);
        IF PurchLine.FINDFIRST THEN
            REPEAT
                IF PurchHeader.GET(PurchLine."Document Type", PurchLine."Document No.") THEN;
                i += 1;
                IF i <= 5 THEN BEGIN
                    ExcelBuf.AddColumn(PurchLine."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(PurchHeader."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                    ExcelBuf.AddColumn(PurchLine.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(PurchHeader."ETA - Availability for Sale", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date)//Date Available for Sale
                END;
            UNTIL PurchLine.NEXT = 0;

        //MakeExcelTotal;
    end;

    procedure MakeExcelTotal();
    begin

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19-01-2018
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //TotalLocQtyPCS := 0;
        //TotalLocQtyKG := 0;
        RecLoc.RESET;
        //RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO",TRUE);
        IF LocFilters <> '' THEN
            RecLoc.SETFILTER(RecLoc.Code, STRSUBSTNO('%1', LocFilters))
        ELSE
            RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO", TRUE);
        IF RecLoc.FINDFIRST THEN
            REPEAT
                LocTotalPCS := 0;
                LocTotalKG := 0;

                RecILE2.RESET;
                RecILE2.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                IF ItemFilter <> '' THEN
                    RecILE2.SETRANGE(RecILE2."Item No.", STRSUBSTNO('%1', ItemFilter));
                //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, TODAY);
                RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                IF RecILE2.FINDSET THEN
                    REPEAT
                        IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                            IF NOT (RecItem.Blocked = TRUE) THEN BEGIN
                                LocTotalPCS := LocTotalPCS + RecILE2."Remaining Quantity";
                                IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                    IF (RecUOM1.Weight <> 0) THEN BEGIN
                                        LocTotalKG := LocTotalKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                        //MESSAGE('%1...%2.. %3',RecILE2."Entry No.",RecLoc.Code,LocTotalKG);
                                    END
                                END
                            END;
                        END;

                    UNTIL RecILE2.NEXT = 0;
                TotalLocQtyPCS1 := TotalLocQtyPCS1 + LocTotalPCS;
                TotalLocQtyKG1 := TotalLocQtyKG1 + LocTotalKG;
                //MESSAGE('%1',TotalLocQtyKG);
                // Location wise total
                ExcelBuf.AddColumn(LocTotalPCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(LocTotalKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

            UNTIL RecLoc.NEXT = 0;

        // All Location Total PAN India Total
        ExcelBuf.AddColumn(TotalLocQtyPCS1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalLocQtyKG1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(GrandTotalSales, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //Grand Total Sales
    end;

    procedure EntryCount(ItemNo: Code[20]): Integer;
    begin
        RecILE33.RESET;
        RecILE33.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");  //CCIT-JAGA 29/10/2018
        RecILE33.SETRANGE(RecILE33."Item No.", ItemNo);
        IF LocFilters <> '' THEN
            RecILE33.SETFILTER(RecILE33."Location Code", STRSUBSTNO('%1', LocFilters));
        //RecILE33.SETRANGE(RecILE33."Posting Date",From_Date,To_Date);
        RecILE33.SETRANGE(RecILE33."Posting Date", 99990101D, TODAY);
        RecILE33.SETFILTER(RecILE33."Entry Type", '%1|%2|%3|%4|%5', RecILE33."Entry Type"::Purchase, RecILE33."Entry Type"::Transfer, RecILE33."Entry Type"::"Positive Adjmt.", RecILE33."Entry Type"::"Negative Adjmt.", RecILE33."Entry Type"::Sale);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

