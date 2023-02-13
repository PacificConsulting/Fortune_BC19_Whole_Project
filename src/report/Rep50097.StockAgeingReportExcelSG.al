report 50097 "Stock Ageing Report-Excel-SG"
{
    // version To be deleted

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Blocked = CONST(false));
            RequestFilterFields = "No.";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Lot No.")
                                    ORDER(Ascending)
                                    WHERE("Entry Type" = FILTER('Purchase' | 'Transfer' | 'Positive Adjmt.' | 'Negative Adjmt.' | 'Sale'),
                                          "Remaining Quantity" = FILTER(> 0));

                trigger OnAfterGetRecord();
                begin


                    IF ("Item Ledger Entry"."Expiration Date" <> 0D) AND ("Item Ledger Entry"."Manufacturing Date" <> 0D) THEN
                        TotalUseShelfLifeDays := "Item Ledger Entry"."Expiration Date" - "Item Ledger Entry"."Manufacturing Date";
                    IF "Item Ledger Entry"."Expiration Date" <> 0D THEN
                        DaysToExpire := "Item Ledger Entry"."Expiration Date" - TODAY;

                    IF TotalUseShelfLifeDays <> 0 THEN
                        ShelfLifePerAvailable := ROUND((DaysToExpire / TotalUseShelfLifeDays) * 100);


                    IF (CurrItem = 'ITEM BLANK') AND (CurrBatch = 'BATCH BLANK') THEN BEGIN
                        CurrItem := "Item Ledger Entry"."Item No.";
                        CurrBatch := "Item Ledger Entry"."Lot No.";
                        I := 0;
                        ItemCounter := EntryCount(CurrItem, CurrBatch);
                    END;
                    I += 1;

                    IF I = ItemCounter THEN BEGIN
                        MakeExcelDataBody;
                        CurrItem := 'ITEM BLANK';
                        CurrBatch := 'BATCH BLANK';
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

                    ExcelBuf.NewRow;
                    ExcelBuf.NewRow;

                    ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


                    TotalLocQtyPCS := 0;
                    TotalLocQtyKG := 0;
                    RecLoc1.RESET;
                    IF LocCode <> '' THEN
                        RecLoc1.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
                    ELSE
                        RecLoc1.SETRANGE("Used In Stock Ageing Report", TRUE);
                    IF RecLoc1.FINDFIRST THEN
                        REPEAT
                            LOcCount := 0;
                            LocTotalPCS := 0;
                            LocTotalKG := 0;
                            RecItem.RESET;
                            // RecItem.SETRANGE(RecItem."No.",Item."No.");
                            IF RecItem.FINDFIRST THEN
                                REPEAT

                                    RecILE1.RESET;
                                    RecILE1.SETRANGE(RecILE1."Posting Date", 99990101D, To_Date);
                                    RecILE1.SETRANGE(RecILE1."Item No.", RecItem."No.");
                                    RecILE1.SETRANGE(RecILE1."Location Code", RecLoc1.Code);
                                    RecILE1.SETRANGE(RecILE1."Lot No.", "Item Ledger Entry"."Lot No.");
                                    RecILE1.SETFILTER(RecILE1."Entry Type", '%1|%2|%3|%4|%5', RecILE1."Entry Type"::Purchase, RecILE1."Entry Type"::Transfer, RecILE1."Entry Type"::"Positive Adjmt.", RecILE1."Entry Type"::"Negative Adjmt.", RecILE1."Entry Type"::Sale);
                                    RecILE1.SETFILTER("Remaining Quantity", '<>%1', 0);
                                    IF RecILE1.FINDSET THEN
                                        REPEAT
                                            LocTotalPCS := LocTotalPCS + RecILE1."Remaining Quantity";
                                            IF RecItem2.GET(RecILE1."Item No.") THEN BEGIN
                                                IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                                    IF (RecUOM1.Weight <> 0) THEN BEGIN
                                                        LocTotalKG := LocTotalKG + ROUND((RecILE1."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                                        //MESSAGE('%1...%2.. %3',RecILE2."Entry No.",RecLoc.Code,LocTotalKG);
                                                    END
                                                END
                                            END;
                                        UNTIL RecILE1.NEXT = 0;
                                UNTIL RecItem.NEXT = 0;
                            TotalLocQtyPCS := TotalLocQtyPCS + LocTotalPCS;
                            TotalLocQtyKG := TotalLocQtyKG + LocTotalKG;
                            ExcelBuf.AddColumn(ROUND(LocTotalPCS, 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //Sum Commented
                            ExcelBuf.AddColumn(LocTotalKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //Sum Commented
                        UNTIL RecLoc1.NEXT = 0;

                    ExcelBuf.AddColumn(ROUND(GrandTotalInPCS, 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(GrandTotalInKGS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                end;

                trigger OnPreDataItem();
                var
                    REcLoc: Record 14;
                    i: Integer;
                    StrPosition: Integer;
                begin

                    RecUserBranch.RESET;
                    RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                    IF RecUserBranch.FINDFIRST THEN
                        REPEAT
                            LocCode1 := LocCode1 + '|' + RecUserBranch."Location Code";
                        UNTIL RecUserBranch.NEXT = 0;
                    LocCodeText := DELCHR(LocCode1, '<', '|');

                    IF LocFilter = '' THEN
                        "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCodeText)
                    ELSE
                        "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocFilter);


                    LocCode := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");

                    ItemNoFilter := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Item No.");

                    IF (To_Date <> 0D) THEN
                        "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 99990101D, To_Date);

                    MakeExcelDataHeader;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                ProductDesc := '';
                Brand := '';
                IF RecItem.GET(Item."No.") THEN BEGIN
                    ProductDesc := RecItem.Description;
                    Brand := RecItem."Brand Name";
                    VendNum1 := RecItem."Vendor No.";
                    Vertical := RecItem."Gen. Prod. Posting Group";
                    SaleCat := RecItem."Sales Category";
                    StorageCategory := RecItem."Storage Categories";
                END;

                IUM.RESET;
                IUM.SETRANGE(IUM."Item No.", Item."No.");
                IF IUM.FINDFIRST THEN
                    ItemWeight := IUM.Weight;

                IF RecVend.GET(VendNum1) THEN
                    Supplier := RecVend.Name;
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
        CurrItem := 'ITEM BLANK';
        CurrBatch := 'BATCH BLANK';


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
        Brand: Code[20];
        RecLoc1: Record 14;
        RecLoc2: Record 14;
        GlobLoc: Text[100];
        RecILE2: Record 32;
        LocQtyPCS: Decimal;
        RecILE3: Record 32;
        RecILE1: Record 32;
        ItemTotal: Decimal;
        LocTotalPCS: Decimal;
        QtyInKG: Decimal;
        QtyinPCS: Decimal;
        LocTotalKG: Decimal;
        LocQtyKG: Decimal;
        ItemCounter: Integer;
        VendorNo: Code[10];
        LocCode: Text[250];
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
        LocCodeArray: array[40] of Code[20];
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
        LocFilter: Code[20];
        IUM: Record 5404;
        ItemWeight: Decimal;
        StorageCategory: Option " ",FREEZER,CHILLED,DRY,"ROOM TEMP";
        RecLoc3: Record 14;
        RecLoc4: Record 14;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('STOCK AGEING REPORT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date :' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Product Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Branch',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Weight', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Batch No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Expire Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Usable Shelf Life in Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Todays Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days To Expire', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('% Shelf Life Available', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        RecLoc2.RESET;
        IF LocCode <> '' THEN
            RecLoc2.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc2.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc2.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn(RecLoc2.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc2.NEXT = 0;

        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);



        RecLoc3.RESET;
        IF LocCode <> '' THEN
            RecLoc3.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc3.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc3.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('IOH in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('IOH in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc3.NEXT = 0;
        ExcelBuf.AddColumn('Total Closing Stock in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Closing Stock in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin



        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ProductDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//PCPL/MIG/NSW Filed not Exist in BC18
        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SaleCat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StorageCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemWeight, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Manufacturing Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Item Ledger Entry"."Expiration Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(TotalUseShelfLifeDays, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(DaysToExpire, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ShelfLifePerAvailable, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        //JAGA
        GrandLocQtyPCS := 0;
        GrandLocQtyKG := 0;




        TotalLocQtyPCS := 0;
        TotalLocQtyKG := 0;
        CLEAR(LocationFound);
        //JAGA


        RecLoc4.RESET;
        IF LocCode <> '' THEN
            RecLoc4.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc4.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc4.FINDSET THEN
            REPEAT
                LocQtyPCS := 0;
                LocQtyKG := 0;
                RecItem.RESET;
                RecItem.SETRANGE(RecItem."No.", Item."No.");
                IF RecItem.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                        RecILE2.SETRANGE(RecILE2."Item No.", RecItem."No.");
                        RecILE2.SETRANGE(RecILE2."Lot No.", "Item Ledger Entry"."Lot No.");
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc4.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT
                                LocQtyPCS := LocQtyPCS + RecILE2."Remaining Quantity";
                                //
                                IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                                            //LocQtyKG := LocQtyKG + ROUND((LocQtyPCS / RecUOM1.Weight),1,'=');
                                            LocQtyKG := LocQtyKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                        END
                                    END
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecItem.NEXT = 0;
                TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                ExcelBuf.AddColumn(ROUND(LocQtyPCS, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(LocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
                GrandTotalInKGS := GrandTotalInKGS + LocQtyKG;
            UNTIL RecLoc4.NEXT = 0;

        GrandLocQtyPCS := GrandLocQtyPCS + LocQtyPCS;
        GrandLocQtyKG := GrandLocQtyKG + LocQtyKG;


        ExcelBuf.AddColumn(ROUND(TotalLocQtyPCS, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalLocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(ItemNo: Code[20]; BatchNo: Code[20]): Integer;
    begin
        RecILE33.RESET;
        RecILE33.SETRANGE(RecILE33."Posting Date", 99990101D, To_Date);
        IF LocCode <> '' THEN
            RecILE33.SETFILTER("Location Code", STRSUBSTNO('%1', LocCode));
        RecILE33.SETFILTER(RecILE33."Entry Type", '%1|%2|%3|%4|%5', RecILE33."Entry Type"::Purchase, RecILE33."Entry Type"::Transfer, RecILE33."Entry Type"::"Positive Adjmt.", RecILE33."Entry Type"::"Negative Adjmt.", RecILE33."Entry Type"::Sale);
        RecILE33.SETRANGE("Item No.", ItemNo);
        RecILE33.SETRANGE("Lot No.", BatchNo);
        RecILE33.SETFILTER("Remaining Quantity", '<>%1', 0);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

