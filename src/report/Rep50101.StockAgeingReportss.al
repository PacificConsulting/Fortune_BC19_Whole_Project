report 50101 "Stock Ageing Report-ss"
{
    // version CCIT-JAGA

    Permissions = TableData 32 = rimd;
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Lot No.")
                                ORDER(Ascending)
                                WHERE("Entry Type" = FILTER('Purchase' | 'Transfer' | 'Positive Adjmt.' | 'Negative Adjmt.' | 'Sale'),
                                      "Remaining Quantity" = FILTER(> 0));
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord();
            begin
                ProductDesc := '';
                Brand := '';

                /*
                IF RecVend.GET("Item Ledger Entry"."Source No.") THEN
                  Supplier := RecVend.Name;
                */
                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    ProductDesc := RecItem.Description;
                    Brand := RecItem."Brand Name";
                    VendNum1 := RecItem."Vendor No.";
                END;

                //CCIT-HG-Start-06/02/2019
                IUM.RESET;
                IUM.SETRANGE(IUM."Item No.", "Item Ledger Entry"."Item No.");
                IF IUM.FINDFIRST THEN
                    ItemWeight := IUM.Weight;
                //CCIT-HG-End-06/02/2019

                IF RecVend.GET(VendNum1) THEN
                    Supplier := RecVend.Name;

                IF ("Item Ledger Entry"."Expiration Date" <> 0D) AND ("Item Ledger Entry"."Manufacturing Date" <> 0D) THEN
                    TotalUseShelfLifeDays := "Item Ledger Entry"."Expiration Date" - "Item Ledger Entry"."Manufacturing Date";
                IF "Item Ledger Entry"."Expiration Date" <> 0D THEN
                    DaysToExpire := "Item Ledger Entry"."Expiration Date" - TODAY;

                IF TotalUseShelfLifeDays <> 0 THEN
                    ShelfLifePerAvailable := ROUND((DaysToExpire / TotalUseShelfLifeDays) * 100);

                ItemTotal := 0;
                RecILE3.RESET;
                //RecILE3.SETRANGE(RecILE3."Entry No.","Item Ledger Entry"."Entry No.");
                //RecILE3.SETRANGE("Posting Date",From_Date,To_Date);
                //RecILE3.SETRANGE("Posting Date",010199D,To_Date);
                RecILE3.SETRANGE("Posting Date", 20200111D, To_Date);//CCIT-021120 110120D
                //RecILE3.SETRANGE(RecILE3."Document No.","Item Ledger Entry"."Document No.");
                RecILE3.SETRANGE(RecILE3."Item No.", "Item Ledger Entry"."Item No.");
                RecILE3.SETRANGE(RecILE3."Lot No.", "Item Ledger Entry"."Lot No.");
                RecILE3.SETFILTER(RecILE3."Entry Type", '%1|%2|%3|%4|%5', RecILE3."Entry Type"::Purchase, RecILE3."Entry Type"::Transfer, RecILE3."Entry Type"::"Positive Adjmt.", RecILE3."Entry Type"::"Negative Adjmt.", RecILE3."Entry Type"::Sale);
                IF RecILE3.FINDFIRST THEN
                    REPEAT
                        ItemTotal += RecILE3."Remaining Quantity";
                    UNTIL RecILE3.NEXT = 0;

                /*
                IF ItemTotal = 0 THEN
                  CurrReport.SKIP;
                */

                IF (CurrItem = 'CRONUS BLANK') AND (CurrBatch = 'FORTUNE BLANK') THEN BEGIN
                    CurrItem := "Item Ledger Entry"."Item No.";
                    CurrBatch := "Item Ledger Entry"."Lot No.";
                    //CurrLoc := "Item Ledger Entry"."Location Code";
                    //CurrDocNo := "Item Ledger Entry"."Document No.";
                    I := 0;
                    ItemCounter := EntryCount(CurrItem, CurrBatch);
                END;
                I += 1;

                IF I = ItemCounter THEN BEGIN
                    MakeExcelDataBody;
                    CurrItem := 'CRONUS BLANK';
                    CurrBatch := 'FORTUNE BLANK';
                    CurrLoc := 'FORTUNE1 BLANK';
                    CurrDocNo := 'FORTUNE2 BLANK';
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
                /*
                ExcelBuf.NewRow;
                ExcelBuf.NewRow;
                
                ExcelBuf.AddColumn('TOTAL',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                //TotalLocQtyPCS := 0;
                //TotalLocQtyKG := 0;
                
                RecLoc.RESET;
                IF LocCode <> '' THEN
                RecLoc.SETFILTER(Code,STRSUBSTNO('%1',LocCode))
                ELSE
                RecLoc.SETRANGE("Used In Stock Ageing Report",TRUE);
                IF RecLoc.FINDFIRST THEN
                  REPEAT
                      LOcCount := 0;
                      LocTotalPCS :=0;
                      LocTotalKG :=0;
                      RecItem.RESET;
                      IF ItemNoFilter <> '' THEN
                        RecItem.SETFILTER("No.",STRSUBSTNO('%1',ItemNoFilter));
                      //LocTotalPCS :=0;
                      //LocTotalKG :=0;
                      IF RecItem.FINDFIRST THEN
                        REPEAT
                      RecILE2.RESET;
                      //RecILE2.SETRANGE(RecILE2."Entry No.","Item Ledger Entry"."Entry No.");
                      //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                      RecILE2.SETRANGE(RecILE2."Posting Date",010199D,To_Date);
                      RecILE2.SETRANGE(RecILE2."Item No.",RecItem."No.");
                      RecILE2.SETRANGE(RecILE2."Location Code",RecLoc.Code);
                      //RecILE2.SETRANGE(RecILE2."Lot No.","Item Ledger Entry"."Lot No.");
                      RecILE2.SETFILTER(RecILE2."Entry Type",'%1|%2|%3|%4|%5',RecILE2."Entry Type"::Purchase,RecILE2."Entry Type"::Transfer,RecILE2."Entry Type"::"Positive Adjmt.",RecILE2."Entry Type"::"Negative Adjmt.",RecILE2."Entry Type"::Sale);
                      IF VendorNo <> '' THEN
                      RecILE2.SETRANGE(RecILE2."Source No.",VendorNo);
                      RecILE2.SETFILTER("Remaining Quantity",'<>%1',0);
                      IF RecILE2.FINDSET THEN
                        REPEAT
                            LocTotalPCS := LocTotalPCS + RecILE2."Remaining Quantity";
                            // Conv
                
                             IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                               IF RecUOM1.GET(RecItem2."No.",RecItem2."Base Unit of Measure") THEN BEGIN
                                  IF (RecUOM1.Weight <> 0) THEN BEGIN
                                    LocTotalKG := LocTotalKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight),1,'=');
                                    //MESSAGE('%1...%2.. %3',RecILE2."Entry No.",RecLoc.Code,LocTotalKG);
                                  END
                              END
                            END;
                
                            //Conv
                            //LocTotalKG := LocTotalKG + RecILE2."Remainig Qty. In KG";
                
                        UNTIL RecILE2.NEXT=0;
                       UNTIL RecItem.NEXT=0;
                        TotalLocQtyPCS := TotalLocQtyPCS + LocTotalPCS;
                        TotalLocQtyKG := TotalLocQtyKG + LocTotalKG;
                        ExcelBuf.AddColumn(ROUND(LocTotalPCS,0.001,'='),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number); //Sum Commented
                        ExcelBuf.AddColumn(LocTotalKG,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);  //Sum Commented
                  UNTIL RecLoc.NEXT=0;
                
                ExcelBuf.AddColumn(ROUND(GrandTotalInPCS,0.001,'='),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(GrandTotalInKGS,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                */

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

                //IF LocCodeText <> '' THEN
                IF LocFilter = '' THEN
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCodeText)
                ELSE
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocFilter);
                //CCIT-PRI-280318


                LocCode := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");

                ItemNoFilter := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Item No.");

                MakeExcelDataHeader;

                IF (To_Date <> 0D) THEN
                    //"Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date",From_Date,To_Date);
                    //"Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date",010199D,To_Date);
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 20200111D, To_Date); //CCIT-03112020//110120D
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
        CurrLoc := 'FORTUNE1 BLANK';
        //CurrDocNo := 'FORTUNE2 BLANK';

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
        LocCode: Text[250];
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

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\STOCK AGEING REPORT.xlsx','STOCK AGEING REPORT','STOCK AGEING REPORT',COMPANYNAME,USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\STOCK AGEING REPORT.xlsx', 'STOCK AGEING REPORT', 'STOCK AGEING REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
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
        //ExcelBuf.AddColumn('Branch',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Product Group Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
        //----------------------------
        //CCIT - Pratiksha 23/01/2018
        ExcelBuf.AddColumn('Vertical Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //----------------------------
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('UOM',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
        ExcelBuf.AddColumn('Item Weight', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Batch No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Expire Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Usable Shelf Life in Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Todays Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days To Expire', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('% Shelf Life Available', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Total Closing Stock in PCS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Total Closing Stock in KG',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Daily Avg Sale',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Inventory will last for in Days',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Required Daily Avg Sales to Clear Stock',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);


        RecLoc.RESET;
        IF LocCode <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                //IF RecLoc.Code <> 'JWL M WH' THEN  BEGIN //CCIT - Pratiksha 23/01/2018
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
            //ExcelBuf.AddColumn('PAN INDIA',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
            //END
            UNTIL RecLoc.NEXT = 0;

        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('DAS PAN INDIA',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Days IOH WL Last',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
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



        RecLoc.RESET;
        IF LocCode <> '' THEN
            RecLoc.SETFILTER(Code, STRSUBSTNO('%1', LocCode))
        ELSE
            RecLoc.SETRANGE("Used In Stock Ageing Report", TRUE);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('IOH in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            //    ExcelBuf.AddColumn('IOH in PCS',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
            UNTIL RecLoc.NEXT = 0;
        ExcelBuf.AddColumn('Total Closing Stock in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Total Closing Stock in PCS',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin


        //--------------------------------
        // CCIT - Pratiksha 23/01/2017
        RItem.RESET;
        RItem.SETRANGE(RItem."No.", "Item Ledger Entry"."Item No.");
        IF RItem.FINDFIRST THEN BEGIN
            Vertical := RItem."Gen. Prod. Posting Group";
            SaleCat := RItem."Sales Category";
        END;
        //--------------------------------
        //CCIT-HG-Start-06/02/2019
        RItem.RESET;
        RItem.SETRANGE(RItem."No.", "Item Ledger Entry"."Item No.");
        RItem.SETRANGE(RItem."Storage Categories", "Item Ledger Entry"."Storage Categories");
        IF RItem.FINDFIRST THEN
            StorageCategory := RItem."Storage Categories";
        //CCIT-HG-End-06/02/2019

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ProductDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Item Ledger Entry"."Product Group Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
        //------------------------------------------
        // CCIT- Pratiksha
        //MESSAGE("Item Ledger Entry"."Gen.Prod.Post.Group");
        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SaleCat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        // CCIT
        ExcelBuf.AddColumn(StorageCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Item Ledger Entry"."Unit of Measure Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//09-09-19 rdk line commented
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
                //RecILE2.SETRANGE(RecILE2."Entry No.","Item Ledger Entry"."Entry No.");
                //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                //RecILE2.SETRANGE(RecILE2."Posting Date",010199D,To_Date);
                RecILE2.SETRANGE(RecILE2."Posting Date", 20200111D, To_Date); //CCIT-031120 //110120D
                                                                              //RecILE2.SETRANGE(RecILE2."Document No.","Item Ledger Entry"."Document No.");
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
                                    //LocQtyKG := LocQtyKG + ROUND((LocQtyPCS / RecUOM1.Weight),1,'=');
                                    LocQtyKG := LocQtyKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                END
                            END
                        END;
                    //
                    // LocQtyKG := LocQtyKG + LocQtyKG1;
                    //LocQtyKG := LocQtyKG + RecILE2."Remainig Qty. In KG";
                    UNTIL RecILE2.NEXT = 0;
                TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                ExcelBuf.AddColumn(ROUND(LocQtyPCS, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //        ExcelBuf.AddColumn(LocQtyKG,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//09-09-19 rdk line commented

                GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
            //        GrandTotalInKGS := GrandTotalInKGS + LocQtyKG;//09-09-19 rdk line commented
            UNTIL RecLoc.NEXT = 0;


        ExcelBuf.AddColumn(ROUND(TotalLocQtyPCS, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(TotalLocQtyKG,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//09-09-19 rdk line commented
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(ItemNo: Code[20]; BatchNo: Code[20]): Integer;
    begin
        RecILE33.RESET;
        //RecILE33.SETRANGE(RecILE33."Posting Date",From_Date,To_Date);
        //RecILE33.SETRANGE(RecILE33."Posting Date",010199D,To_Date);
        RecILE33.SETRANGE(RecILE33."Posting Date", 20200111D, To_Date);//CCIT-031120//110120D
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

