report 50023 "Stock Ageing Report-Excel"
{
    // version CCIT-JAGA
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Lot No.")
                                ORDER(Descending)
                                WHERE("Entry Type" = FILTER('Purchase' | 'Transfer' | 'Positive Adjmt.' | 'Negative Adjmt.' | 'Sale'),
                                      "Remaining Quantity" = FILTER(<> 0));
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord();
            begin
                ProductDesc := '';
                Brand := '';
                LaunchMonth := '';


                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    ProductDesc := RecItem.Description;
                    Brand := RecItem."Brand Name";
                    VendNum1 := RecItem."Vendor No.";
                    LaunchMonth := FORMAT(RecItem."Launch Month", 0, '<Month Text,20><Year4>');
                    SaftyStock := RecItem."Safety Stock";    //23112021 CCIT AN
                END;

                IUM.RESET;
                IUM.SETRANGE(IUM."Item No.", "Item Ledger Entry"."Item No.");
                IF IUM.FINDFIRST THEN
                    ItemWeight := IUM.Weight;


                IF RecVend.GET(VendNum1) THEN
                    Supplier := RecVend.Name;

                IF ("Item Ledger Entry"."Expiration Date" <> 0D) AND ("Item Ledger Entry"."Warranty Date" <> 0D) THEN
                    TotalUseShelfLifeDays := ("Item Ledger Entry"."Expiration Date" - "Item Ledger Entry"."Warranty Date");
                IF "Item Ledger Entry"."Expiration Date" <> 0D THEN
                    DaysToExpire := "Item Ledger Entry"."Expiration Date" - TODAY;

                //23112021 CCIT AN
                IF DaysToExpire <= 0 THEN
                    AgeBuckets := '< 0';
                IF (DaysToExpire >= 1) AND (DaysToExpire <= 60) THEN
                    AgeBuckets := '01-60 Days';
                IF (DaysToExpire >= 61) AND (DaysToExpire <= 90) THEN
                    AgeBuckets := '61-90 Days';
                IF (DaysToExpire >= 91) AND (DaysToExpire <= 120) THEN
                    AgeBuckets := '91-120 Days';
                IF (DaysToExpire > 120) THEN
                    AgeBuckets := '> 120 Days';
                //23112021 CCIT AN

                IF TotalUseShelfLifeDays <> 0 THEN
                    ShelfLifePerAvailable := ROUND((DaysToExpire / TotalUseShelfLifeDays) * 100);

                ItemTotal := 0;
                RecILE3.RESET;
                RecILE3.SETRANGE("Posting Date", 20200111D, To_Date);//CCIT-021120
                RecILE3.SETRANGE(RecILE3."Item No.", "Item Ledger Entry"."Item No.");
                RecILE3.SETRANGE(RecILE3."Lot No.", "Item Ledger Entry"."Lot No.");
                RecILE3.SETFILTER(RecILE3."Entry Type", '%1|%2|%3|%4|%5', RecILE3."Entry Type"::Purchase, RecILE3."Entry Type"::Transfer, RecILE3."Entry Type"::"Positive Adjmt.", RecILE3."Entry Type"::"Negative Adjmt.", RecILE3."Entry Type"::Sale);
                IF RecILE3.FINDFIRST THEN
                    REPEAT
                        ItemTotal += RecILE3."Remaining Quantity";
                    UNTIL RecILE3.NEXT = 0;


                IF (CurrItem = 'CRONUS BLANK') AND (CurrBatch = 'FORTUNE BLANK') THEN BEGIN
                    CurrItem := "Item Ledger Entry"."Item No.";
                    CurrBatch := "Item Ledger Entry"."Lot No.";
                    I := 0;
                    ItemCounter := EntryCount(CurrItem, CurrBatch);
                END;
                I += 1;

                IF (I = ItemCounter) THEN BEGIN
                    MakeExcelDataBody;
                    CurrItem := 'CRONUS BLANK';
                    CurrBatch := 'FORTUNE BLANK';
                    ItemCounter := 0;
                END;
            end;

            trigger OnPostDataItem();
            var
                i: Integer;
                LocationFound: Boolean;
                RecItem: Record 27;
                LOcCount: Integer;
            begin
            end;

            trigger OnPreDataItem();
            var
                REcLoc: Record 14;
                i: Integer;
                StrPosition: Integer;
            begin
                //CCIT-PRI-280318
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode1 := LocCode1 + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode1, '<', '|');

                /*//<<
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        NewILE.SetRange("Location Code", RecUserBranch."Location Code");
                        IF NewILE.FindFirst() then
                            NewILE.Mark(true);
                    UNTIL RecUserBranch.NEXT = 0;
                //>>
                */
                IF LocFilter = '' THEN
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCodeText)
                ELSE
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocFilter);


                LocCode := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");

                ItemNoFilter := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Item No.");

                MakeExcelDataHeader;

                IF (To_Date <> 0D) THEN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 20200111D, To_Date); //CCIT-03112020
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
                    field("As On Date"; To_Date)
                    {
                    }
                    field("Vendor No."; VendorNo)
                    {
                        TableRelation = Vendor."No.";
                        Visible = false;

                    }
                    field("Location Code"; LocFilter)
                    {
                        TableRelation = Location.Code;
                    }
                    field(PrintZeroQtyItemsAlso; PrintZeroQtyItemsAlso)
                    {
                        Caption = '<Print 0 Qty Items Also>';
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
        CurrBatch := 'FORTUNE BLANK';

        GrandTotalInPCS := 0;
        GrandTotalInKGS := 0;
        TotalLocQtyPCS := 0;
        TotalLocQtyKG := 0;
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        ItemNoFilter := '';
        ExcelBuf.NumberFormat := '0.00'  //25112021 CCIT AN
    end;

    var
        NewILE: Record 32;
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
        VendorNo: Code[50];
        LocCode: Text[1024];
        TotalLocQtyPCS: Decimal;
        TotalLocQtyKG: Decimal;
        CurrLoc: Code[50];
        CurrItem: Code[50];
        CurrBatch: Code[50];
        CurrDocNo: Code[50];
        PostingDateFilter: Text[50];
        GrandTotalInPCS: Decimal;
        GrandTotalInKGS: Decimal;
        GrandLocQtyPCS: Decimal;
        GrandLocQtyKG: Decimal;
        LocCodeArray: array[40] of Code[50];
        LocCodeFilter: Text[250];
        LocationFound: Boolean;
        RItem: Record 27;
        Vertical: Code[50];
        SaleCat: Code[25];
        StorageCat: Code[20];
        VendNum1: Code[20];
        RecItem2: Record 27;
        RecUOM1: Record 5404;
        LocQtyKG1: Decimal;
        ItemNoFilter: Text[250];
        RecUserBranch: Record 50029;
        LocCode1: Code[1024];
        LocCodeText: Text[1024];
        LocFilter: Code[50];
        IUM: Record 5404;
        ItemWeight: Decimal;
        StorageCategory: Option " ",FREEZER,CHILLED,DRY,"ROOM TEMP";
        Item: Record 27;
        AsOnDate: Date;
        PrintZeroQtyItemsAlso: Boolean;
        ItemNum: Code[20];
        LaunchMonth: Code[50];
        SaftyStock: Code[20];
        AgeBuckets: Text;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('STOCK AGEING REPORT', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Product Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Weight', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Batch No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Expire Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Usable Shelf Life in Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Todays Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days To Expire', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Age Buckets', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //23112021 CCIT AN
        ExcelBuf.AddColumn('Safety Stock', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //23112021 CCIT AN
        ExcelBuf.AddColumn('% Shelf Life Available', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        RecLoc.RESET;
        IF LocCode <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;

        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Launch Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
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
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text); //23112021 CCIT AN
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text); //23112021 CCIT AN


        RecLoc.RESET;
        IF LocCode <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('IOH in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;
        ExcelBuf.AddColumn('Total Closing Stock in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin


        RItem.RESET;
        RItem.SETRANGE(RItem."No.", "Item Ledger Entry"."Item No.");
        IF RItem.FINDFIRST THEN BEGIN
            Vertical := RItem."Gen. Prod. Posting Group";
            SaleCat := RItem."Sales Category";
        END;

        RItem.RESET;
        RItem.SETRANGE(RItem."No.", "Item Ledger Entry"."Item No.");
        RItem.SETRANGE(RItem."Storage Categories", "Item Ledger Entry"."Storage Categories");
        IF RItem.FINDFIRST THEN
            StorageCategory := RItem."Storage Categories";


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ProductDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SaleCat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StorageCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemWeight, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Warranty Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Item Ledger Entry"."Expiration Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(TotalUseShelfLifeDays, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(DaysToExpire, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(AgeBuckets, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //23112021 CCIT AN
        ExcelBuf.AddColumn(SaftyStock, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number); //23112021 CCIT AN
        ExcelBuf.AddColumn(ShelfLifePerAvailable, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);


        GrandLocQtyPCS := 0;
        GrandLocQtyKG := 0;
        TotalLocQtyPCS := 0;
        TotalLocQtyKG := 0;
        CLEAR(LocationFound);



        RecLoc.RESET;
        IF LocCode <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                LocQtyPCS := 0;
                LocQtyKG := 0;
                RecILE2.RESET;
                RecILE2.SETRANGE(RecILE2."Posting Date", 20200111D, To_Date);  //110120D //PCPL/MIG/NSW
                RecILE2.SETRANGE(RecILE2."Item No.", "Item Ledger Entry"."Item No.");
                RecILE2.SETRANGE(RecILE2."Lot No.", "Item Ledger Entry"."Lot No.");
                RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                IF VendorNo <> '' THEN
                    RecILE2.SETRANGE(RecILE2."Source No.", VendorNo);
                IF RecILE2.FINDSET THEN
                    REPEAT
                        LocQtyPCS := LocQtyPCS + RecILE2."Remaining Quantity";
                        //
                        IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                            IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM1.Weight <> 0) THEN BEGIN

                                    LocQtyKG := LocQtyKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                END
                            END
                        END;

                    UNTIL RecILE2.NEXT = 0;
                TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                //ExcelBuf.AddColumn(ROUND(LocQtyPCS,0.001,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ROUND(LocQtyPCS, 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);


                GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
            UNTIL RecLoc.NEXT = 0;


        //ExcelBuf.AddColumn(ROUND(TotalLocQtyPCS,0.001,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(TotalLocQtyPCS, 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(LaunchMonth, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(ItemNo: Code[20]; BatchNo: Code[20]): Integer;
    var
        "count": Integer;
    begin
        RecILE33.RESET;
        RecILE33.SETCURRENTKEY("Lot No.");
        RecILE33.SETRANGE(RecILE33."Posting Date", 20200111D, To_Date); //110120D //PCPL/MIG/NSW
        IF LocCode <> '' THEN
            RecILE33.SETFILTER("Location Code", LocCode);
        RecILE33.SETFILTER(RecILE33."Entry Type", '%1|%2|%3|%4|%5', RecILE33."Entry Type"::Purchase, RecILE33."Entry Type"::Transfer, RecILE33."Entry Type"::"Positive Adjmt.", RecILE33."Entry Type"::"Negative Adjmt.", RecILE33."Entry Type"::Sale);
        RecILE33.SETRANGE("Item No.", ItemNo);
        RecILE33.SETRANGE("Lot No.", BatchNo);
        RecILE33.SETFILTER("Remaining Quantity", '<>%1', 0);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

