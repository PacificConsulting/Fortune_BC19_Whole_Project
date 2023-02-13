report 50096 "StockAgeingReports"
{
    // version To be deleted

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/StockAgeingReports.rdl';
    ShowPrintStatus = false;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Lot No.")
                                ORDER(Ascending)
                                WHERE("Entry Type" = FILTER(('Negative Adjmt.' | 'Transfer' | 'Purchase' | 'Sale' | 'Positive Adjmt.')),
                                      "Remaining Quantity" = FILTER(> 0));
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord();
            begin

                ProductDesc := '';
                Brand := '';

                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    ProductDesc := RecItem.Description;
                    Brand := RecItem."Brand Name";
                    VendNum := RecItem."Vendor No.";
                END;


                IF RecVend.GET(VendNum) THEN
                    Supplier := RecVend.Name;


                RecItemUOM.RESET;
                RecItemUOM.SETRANGE(RecItemUOM."Item No.", "Item Ledger Entry"."Item No.");
                IF RecItemUOM.FINDFIRST THEN
                    ItemWeight := RecItemUOM.Weight;

                RecItem.RESET;
                RecItem.SETRANGE(RecItem."No.", "Item Ledger Entry"."Item No.");
                IF RecItem.FINDFIRST THEN BEGIN
                    Vertical := RecItem."Gen. Prod. Posting Group";
                    SaleCategory := RecItem."Sales Category";
                END;

                RecItem.RESET;
                RecItem.SETRANGE(RecItem."No.", "Item Ledger Entry"."Item No.");
                RecItem.SETRANGE(RecItem."Storage Categories", "Item Ledger Entry"."Storage Categories");
                IF RecItem.FINDFIRST THEN
                    StorageCategory := RecItem."Storage Categories";



                IF ("Item Ledger Entry"."Expiration Date" <> 0D) AND ("Item Ledger Entry"."Manufacturing Date" <> 0D) THEN
                    TotalUseShelfLifeDays := "Item Ledger Entry"."Expiration Date" - "Item Ledger Entry"."Manufacturing Date";
                IF "Item Ledger Entry"."Expiration Date" <> 0D THEN
                    DaysToExpire := "Item Ledger Entry"."Expiration Date" - TODAY;

                IF TotalUseShelfLifeDays <> 0 THEN
                    ShelfLifePerAvailable := ROUND((DaysToExpire / TotalUseShelfLifeDays) * 100);
                /*
                IF (CurrLotNo = 'CRONUS LOT') AND (CurRecItem = 'CRONUS ITEM') THEN BEGIN
                  CurRecItem := "Item Ledger Entry"."Item No.";
                  CurrLotNo := "Item Ledger Entry"."Lot No.";
                  i := 0;
                  LotRecCounter := EntryCount(CurRecItem,CurrLotNo);
                END;
                
                i+=1;
                
                IF i=LotRecCounter THEN BEGIN
                
                  CurRecItem := 'CRONUS ITEM';
                  CurrLotNo := 'CRONUS LOT';
                  LotRecCounter :=0;
                END;
                */

                MakeExcelDataBody;

            end;

            trigger OnPostDataItem();
            begin
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


                RecLoc.RESET;
                IF Location_Code <> '' THEN
                    RecLoc.SETFILTER(Code, STRSUBSTNO('%1', Location_Code))
                ELSE
                    RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
                IF RecLoc.FINDFIRST THEN
                    REPEAT
                        Remainingqty := 0;
                        WeightinKG := 0;
                        RecItem.RESET;
                        /* IF ItemNoFilter <> '' THEN
                           RecItem.SETFILTER("No.",STRSUBSTNO('%1',ItemNoFilter));*/
                        IF RecItem.FINDFIRST THEN
                            REPEAT
                                RecILE.RESET;
                                RecILE.SETRANGE(RecILE."Posting Date", 99990101D, As_On_Date);
                                RecILE.SETRANGE(RecILE."Location Code", RecLoc.Code);
                                RecILE.SETRANGE(RecILE."Item No.", RecItem."No.");
                                RecILE.SETFILTER(RecILE."Entry Type", '%1|%2|%3|%4|%5', RecILE."Entry Type"::Purchase, RecILE."Entry Type"::Transfer, RecILE."Entry Type"::"Positive Adjmt.", RecILE."Entry Type"::"Negative Adjmt.", RecILE."Entry Type"::Sale);
                                RecILE.SETRANGE(RecILE."Lot No.", "Item Ledger Entry"."Lot No.");
                                RecILE.SETFILTER("Remaining Quantity", '<>%1', 0);
                                IF RecILE.FINDSET THEN
                                    REPEAT
                                        Remainingqty := Remainingqty + RecILE."Remaining Quantity";
                                        IF RecItem.GET(RecILE."Item No.") THEN BEGIN
                                            IF RecItemUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                                IF (RecItemUOM.Weight <> 0) THEN
                                                    WeightinKG := WeightinKG + ROUND((RecILE."Remaining Quantity" / RecItemUOM.Weight), 1, '=');
                                            END
                                        END;
                                    UNTIL RecILE.NEXT = 0;
                            UNTIL RecItem.NEXT = 0;
                        TotalQty += Remainingqty;// if not total not added
                        TotalWeight += WeightinKG;   //  if not total not added
                        ExcelBuf.AddColumn(ROUND(Remainingqty, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(WeightinKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    UNTIL RecLoc.NEXT = 0;

                ExcelBuf.AddColumn(ROUND(GrandTotalQty, 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(GrandTotalWeight, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                // MESSAGE('GrandTotalQty%1',GrandTotalQty);
                //  MESSAGE('GrandTotalWeight%2',GrandTotalWeight);

            end;

            trigger OnPreDataItem();
            begin

                IF As_On_Date <> 0D THEN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 99990101D, As_On_Date);


                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocationCode1 := LocationCode1 + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                MultipleLocations := DELCHR(LocationCode1, '<', '|');

                IF Location_Code = '' THEN
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", MultipleLocations)
                ELSE
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", Location_Code);

                //ItemNoFilter := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Item No.");
                MakeExcelDataHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control001)
                {
                    field(As_On_Date; As_On_Date)
                    {
                        Caption = 'Date';
                    }
                    field(Location_Code; Location_Code)
                    {
                        Caption = 'Location';
                        TableRelation = Location.Code;
                    }
                    field(ItemNo; ItemNoFilter)
                    {
                        Caption = 'Item No';
                        TableRelation = Item."No." WHERE(Blocked = FILTER(false));
                        Visible = false;
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
        CurRecItem := 'CRONUS ITEM';
        CurrLotNo := 'CRONUS LOT';


        // TotalQty:=0;
        // TotalWeight :=0;
        // GrandTotalQty :=0;
        // GrandTotalWeight :=0;
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
        As_On_Date: Date;
        Location_Code: Code[50];
        ItemNoFilter: Code[50];
        RecUserBranch: Record 50029;
        MultipleLocations: Code[50];
        ProductDesc: Text;
        Brand: Code[50];
        Supplier: Text[50];
        Vertical: Code[50];
        SaleCategory: Code[25];
        StorageCategory: Option;
        ItemWeight: Decimal;
        TotalUseShelfLifeDays: Decimal;
        DaysToExpire: Integer;
        ShelfLifePerAvailable: Decimal;
        ExcelBuf: Record 370 temporary;
        RecItem: Record 27;
        RecVend: Record 23;
        VendNum: Code[50];
        RecItemUOM: Record 5404;
        LocationCode1: Code[50];
        RecLoc: Record 14;
        RecILE: Record 32;
        Remainingqty: Decimal;
        WeightinKG: Decimal;
        GrandTotalQty: Decimal;
        GrandTotalWeight: Decimal;
        CurrLotNo: Code[50];
        CurrItem: Code[50];
        i: Integer;
        LotRecCounter: Integer;
        RecILE1: Record 32;
        RecILE33: Record 32;
        CurRecItem: Code[50];
        TotalWeight: Decimal;
        TotalQty: Decimal;
        ItemNo: Code[50];
        Remainingqtypcs: Decimal;
        WeightTotalKG: Decimal;

    local procedure CreateExcelBook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('STOCK AGEING REPORT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date :' + FORMAT(As_On_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Product Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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


        RecLoc.RESET;
        IF Location_Code <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', Location_Code))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;


        ExcelBuf.NewRow;
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
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        RecLoc.RESET;
        IF Location_Code <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', Location_Code))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('IOH in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('IOH in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;
        ExcelBuf.AddColumn('Total Closing Stock in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Closing Stock in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ProductDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/MIG/NSW Filed not Exist in BC18
        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SaleCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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


        RecLoc.RESET;
        IF Location_Code <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', Location_Code))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                // RecItem.RESET;
                /*IF ItemNoFilter <> '' THEN
                  RecItem.SETFILTER("No.",STRSUBSTNO('%1',ItemNoFilter));*/
                //IF RecItem.FINDFIRST THEN
                //REPEAT
                Remainingqtypcs := 0;
                WeightTotalKG := 0;
                RecILE.RESET;
                RecILE.SETRANGE(RecILE."Posting Date", 99990101D, As_On_Date);
                RecILE.SETRANGE(RecILE."Location Code", RecLoc.Code);
                RecILE.SETRANGE(RecILE."Item No.", RecItem."No.");
                RecILE.SETFILTER(RecILE."Entry Type", '%1|%2|%3|%4|%5', RecILE."Entry Type"::Purchase, RecILE."Entry Type"::Transfer, RecILE."Entry Type"::"Positive Adjmt.", RecILE."Entry Type"::"Negative Adjmt.", RecILE."Entry Type"::Sale);
                RecILE.SETRANGE(RecILE."Lot No.", "Item Ledger Entry"."Lot No.");
                RecILE.SETFILTER("Remaining Quantity", '<>%1', 0);
                IF RecILE.FINDSET THEN
                    REPEAT
                        Remainingqtypcs := Remainingqtypcs + RecILE."Remaining Quantity";//Row wise added  // IOH in PCS
                        IF RecItem.GET(RecILE."Item No.") THEN BEGIN
                            IF RecItemUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecItemUOM.Weight <> 0) THEN
                                    WeightTotalKG := WeightTotalKG + ROUND((RecILE."Remaining Quantity" / RecItemUOM.Weight), 1, '=');
                            END
                        END;
                    //MESSAGE('Remainingqtypcs%1',Remainingqtypcs);
                    //MESSAGE('WeightTotalKG%1',WeightTotalKG);
                    UNTIL RecILE.NEXT = 0;

                TotalQty += Remainingqtypcs;//Total Closing Stock in KG
                TotalWeight += WeightTotalKG;//Total Closing Stock in PCS
                                             // MESSAGE('TotalQty%1',TotalQty);
                                             // MESSAGE('TotalWeight%1',TotalWeight);

                ExcelBuf.AddColumn(ROUND(Remainingqtypcs, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(WeightTotalKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                GrandTotalQty := GrandTotalQty + Remainingqtypcs;
                GrandTotalWeight := GrandTotalWeight + WeightTotalKG;
            UNTIL RecLoc.NEXT = 0;


        ExcelBuf.AddColumn(ROUND(TotalQty, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalWeight, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


    end;

    procedure EntryCount(ItemNo: Code[20]; BatchNo: Code[20]): Integer;
    begin

        RecILE1.SETRANGE("Item No.", ItemNo);
        RecILE1.SETRANGE("Lot No.", BatchNo);
        RecILE1.SETFILTER("Remaining Quantity", '<>%1', 0);
        IF RecILE1.FINDSET THEN
            EXIT(RecILE1.COUNT);

        /*
        RecILE33.RESET;
        //RecILE33.SETRANGE(RecILE33."Posting Date",From_Date,To_Date);
        RecILE33.SETRANGE(RecILE33."Posting Date",010199D,To_Date);
        IF LocCode <> '' THEN
        RecILE33.SETFILTER("Location Code",STRSUBSTNO('%1',LocCode));
        RecILE33.SETFILTER(RecILE33."Entry Type",'%1|%2|%3|%4|%5',RecILE33."Entry Type"::Purchase,RecILE33."Entry Type"::Transfer,RecILE33."Entry Type"::"Positive Adjmt.",RecILE33."Entry Type"::"Negative Adjmt.",RecILE33."Entry Type"::Sale);
        RecILE33.SETRANGE("Item No.",ItemNo);
        RecILE33.SETRANGE("Lot No.",BatchNo);
        RecILE33.SETFILTER("Remaining Quantity",'<>%1',0);
        IF RecILE33.FINDSET THEN
           EXIT(RecILE33.COUNT);
        
        
        */

    end;
}

