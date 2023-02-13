report 50083 "MA- Product-MoM"
{
    // version CCIT-Fortune-SG

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                IF RecVend.GET(Item."Vendor No.") THEN
                    SourceName := RecVend.Name;

                Item.CALCFIELDS(Inventory, "Sales (Qty.)");

                ItemTotal := Item."Sales (Qty.)";
                /*
                ItemTotal := 0;
                RecILE3.RESET;
                RecILE3.SETRANGE(RecILE3."Item No.",Item."No.");
                IF LocCodeText <> '' THEN
                  RecILE3.SETFILTER(RecILE3."Location Code",LocCodeText);
                
                RecILE3.SETFILTER(RecILE3."Entry Type",'%1',RecILE3."Entry Type"::Sale);
                RecILE3.SETFILTER(RecILE3."Document Type",'%1|%2',RecILE3."Document Type"::"Sales Shipment",RecILE3."Document Type"::"Sales Return Receipt");//New 21/11/2018
                IF RecILE3.FINDFIRST THEN
                  REPEAT
                    ItemTotal += RecILE3.Quantity;
                  UNTIL RecILE3.NEXT=0;
                
                IF ItemTotal = 0 THEN
                  CurrReport.SKIP;
                  */

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Sales Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SourceName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Brand Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/MIG/NSW Filed not Exist in BC18


                GrandLocQtyPCS := 0;
                GrandLocQtyKG := 0;
                GrandLocQtyAvgSellPrice := 0;
                GrandLocQtyDAS := 0;

                CLEAR(LocationFound);

                TotalLocQtyPCS := 0;
                TotalLocQtyKG := 0;
                TotalLocQtyDAS := 0;
                TotalLocQtyAvgSellPrice := 0;
                OriFromDate := From_Date;
                OriToDate := To_Date;

                FOR MonthI := 1 TO MonthCtr DO BEGIN
                    MonthFromDate[MonthI] := From_Date;
                    //MonthEndDate[MonthI] := CA


                END;

                RecLoc.RESET;
                RecLoc.SETRANGE(RecLoc."Used In MA-Product", TRUE);
                IF LocCodeText <> '' THEN
                    RecLoc.SETFILTER(RecLoc.Code, LocCodeText);

                IF RecLoc.FINDFIRST THEN
                    REPEAT
                        FOR I := 1 TO MonthCtr DO BEGIN

                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                            RecILE2.SETFILTER(RecILE2."Document Type", '%1|%2', RecILE2."Document Type"::"Sales Shipment", RecILE2."Document Type"::"Sales Return Receipt");
                            RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                    LocQtyPCS := LocQtyPCS + RecILE2."Sales Amount (Actual)";   //(RecILE2.Quantity * Item."Unit Cost"); CCIT-PRI-110119
                                    LocQtyKG := LocQtyKG + RecILE2.Quantity;
                                    IF (LocQtyKG <> 0) AND (NoofDays <> 0) THEN
                                        DASValue := DASValue + (LocQtyKG / NoofDays);
                                UNTIL RecILE2.NEXT = 0;
                            IF (LocQtyPCS <> 0) AND (LocQtyKG <> 0) THEN
                                AvgSellingPrice := AvgSellingPrice + (LocQtyPCS / LocQtyKG);

                            TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                            TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                            TotalLocQtyDAS := TotalLocQtyDAS + DASValue;
                            TotalLocQtyAvgSellPrice := TotalLocQtyAvgSellPrice + AvgSellingPrice;

                            ExcelBuf.AddColumn(ROUND(-(LocQtyKG), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(ROUND(ABS(DASValue),0.001,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                            IF (LocQtyKG <> 0) AND (NoofDays <> 0) THEN
                                ExcelBuf.AddColumn(ROUND((-(LocQtyKG) / NoofDays), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
                            ELSE
                                ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(ROUND((ABS(LocQtyPCS)), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(ROUND(ABS(AvgSellingPrice), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
                            GrandTotalInKGS := GrandTotalInKGS + LocQtyKG;
                            GrandTotalDAS := GrandTotalDAS + DASValue;
                            GrandTotalAvgSellingPrice := GrandTotalAvgSellingPrice + AvgSellingPrice;
                        END;

                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(ROUND(ABS(TotalLocQtyKG), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn(ROUND(ABS(TotalLocQtyDAS),0.001,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                IF (TotalLocQtyKG <> 0) AND (NoofDays <> 0) THEN
                    ExcelBuf.AddColumn(ROUND((ABS(TotalLocQtyKG) / NoofDays), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
                ELSE
                    ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ROUND(ABS(TotalLocQtyPCS), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ROUND(ABS(TotalLocQtyAvgSellPrice), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

            end;

            trigger OnPostDataItem();
            var
                RecItem: Record 27;
            begin
                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                RecLoc5.RESET;
                RecLoc5.SETRANGE(RecLoc5."Used In MA-Product", TRUE);
                //CCIT-PRI-030418
                IF LocCodeText <> '' THEN
                    RecLoc5.SETFILTER(RecLoc5.Code, LocCodeText);
                //CCIT-PRI-030418
                IF RecLoc5.FINDFIRST THEN
                    REPEAT
                        CLEAR(LocQtyPCSTot1);
                        CLEAR(LocQtyKGTot1);
                        CLEAR(DASValueTot1);
                        CLEAR(AvgSellingPriceTot1);
                        RecItem1.RESET;
                        RecItem1.SETCURRENTKEY(RecItem1."No.");
                        RecItem1.SETFILTER(RecItem1."No.", '<>%1', '');
                        IF ItemFilter <> '' THEN
                            RecItem1.SETFILTER(RecItem1."No.", ItemFilter);
                        IF RecItem1.FINDFIRST THEN
                            REPEAT
                                CLEAR(LocQtyPCSTot);
                                CLEAR(LocQtyKGTot);
                                CLEAR(DASValueTot);
                                CLEAR(AvgSellingPriceTot);

                                RecILE5.RESET;
                                RecILE5.SETFILTER(RecILE5."Entry Type", '%1', RecILE5."Entry Type"::Sale);
                                RecILE5.SETFILTER(RecILE5."Document Type", '%1|%2', RecILE5."Document Type"::"Sales Shipment", RecILE5."Document Type"::"Sales Return Receipt");
                                RecILE5.SETRANGE(RecILE5."Posting Date", From_Date, To_Date);
                                RecILE5.SETRANGE(RecILE5."Location Code", RecLoc5.Code);
                                RecILE5.SETRANGE(RecILE5."Item No.", RecItem1."No.");
                                IF RecILE5.FINDSET THEN
                                    REPEAT
                                        LocQtyPCSTot := LocQtyPCSTot + (RecILE5.Quantity * RecItem1."Unit Cost");
                                        LocQtyKGTot := LocQtyKGTot + (RecILE5.Quantity);
                                        IF (LocQtyKGTot <> 0) AND (NoofDays <> 0) THEN
                                            DASValueTot := DASValueTot + (LocQtyKGTot / NoofDays);
                                        IF (LocQtyPCSTot <> 0) AND (LocQtyKGTot <> 0) THEN
                                            AvgSellingPriceTot := AvgSellingPriceTot + (LocQtyPCSTot / LocQtyKGTot);

                                    UNTIL RecILE5.NEXT = 0;
                                LocQtyPCSTot1 := LocQtyPCSTot1 + LocQtyPCSTot;
                                LocQtyKGTot1 := LocQtyKGTot1 + LocQtyKGTot;
                                DASValueTot1 := DASValueTot1 + DASValueTot;
                                AvgSellingPriceTot1 := AvgSellingPriceTot1 + AvgSellingPriceTot;
                            UNTIL RecItem1.NEXT = 0;

                        ExcelBuf.AddColumn(ROUND(ABS(LocQtyKGTot1), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //ExcelBuf.AddColumn(ROUND(ABS(DASValueTot1),0.001,'='),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                        IF (LocQtyKGTot1 <> 0) AND (NoofDays <> 0) THEN
                            ExcelBuf.AddColumn(ROUND((ABS(LocQtyKGTot1) / NoofDays), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
                        ELSE
                            ExcelBuf.AddColumn(0, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(ROUND(ABS(LocQtyPCSTot1), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(ROUND(ABS(AvgSellingPriceTot1), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                    UNTIL RecLoc5.NEXT = 0;

                ExcelBuf.AddColumn(ROUND(ABS(GrandTotalInKGS), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn(ROUND(ABS(GrandTotalDAS),0.001,'='),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                IF (GrandTotalInKGS <> 0) AND (NoofDays <> 0) THEN
                    ExcelBuf.AddColumn(ROUND((ABS(GrandTotalInKGS) / NoofDays), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
                ELSE
                    ExcelBuf.AddColumn(0, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ROUND(ABS(GrandTotalInPCS), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ROUND(ABS(GrandTotalAvgSellingPrice), 0.001, '='), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            end;

            trigger OnPreDataItem();
            var
                REcLoc: Record 14;
                i: Integer;
                StrPosition: Integer;
            begin

                ILERec.RESET;
                ILERec.SETRANGE(ILERec."Item No.", Item."No.");
                IF LocCodeText <> '' THEN
                    ILERec.SETFILTER(ILERec."Location Code", LocCodeText);
                LocCode := ILERec.GETFILTER(ILERec."Location Code");
                LocCodeFilter := LocCode;
                NoofDays := To_Date - From_Date;
                MonthCtr := NoofDays / 30;
                ItemFilter := Item.GETFILTER(Item."No.");
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
                    }
                    field("To Date"; To_Date)
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
        //CurrItem := 'CRONUS BLANK';
        CurrLoc := 'FORTUNE BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        //CCIT-PRI-030418
        CLEAR(LocCode1);
        CLEAR(LocCodeText);

        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN
            REPEAT
                LocCode1 := LocCode1 + '|' + RecUserBranch."Location Code";
            UNTIL RecUserBranch.NEXT = 0;

        LocCodeText := DELCHR(LocCode1, '<', '|');
        //CCIT-PRI-030418

        MakeExcelDataHeader;
    end;

    var
        From_Date: Date;
        To_Date: Date;
        ExcelBuf: Record 370 temporary;
        Supplier: Text[50];
        RecVend: Record 23;
        TotalUseShelfLifeDays: Decimal;
        DaysToExpire: Decimal;
        ShelfLifePerAvailable: Decimal;
        ProductDesc: Text[100];
        RecItem: Record 27;
        RecILE: Record 32;
        RecILE33: Record 32;
        CurrLoc: Code[20];
        I: Integer;
        LocCount: Integer;
        Brand: Code[20];
        CurrItem: Code[20];
        RecLoc: Record 14;
        RecLocation1: Record 14;
        GlobLoc: Text[100];
        RecILE2: Record 32;
        LocQty: Decimal;
        RecILE3: Record 32;
        RecILE4: Record 32;
        ItemTotal: Decimal;
        LocTotal: Decimal;
        LocValue: Decimal;
        ValTot: Decimal;
        GrandTotalInPCS: Decimal;
        GrandTotalInKGS: Decimal;
        GrandLocQtyPCS: Decimal;
        GrandLocQtyKG: Decimal;
        LocCodeArray: array[40] of Code[20];
        LocQtyPCS: Decimal;
        TotalLocQtyPCS: Decimal;
        TotalLocQtyKG: Decimal;
        RecLoca: Record 14;
        RecLocation: Record 14;
        LocCodeFilter: Text[250];
        LocationFound: Boolean;
        LocCode: Text[250];
        LocQtyKG: Decimal;
        RecItem2: Record 27;
        ILERec: Record 32;
        SourceName: Text[50];
        VendNo: Code[20];
        NoofDays: Integer;
        DASValue: Decimal;
        AvgSellingPrice: Decimal;
        GrandTotalDAS: Decimal;
        GrandTotalAvgSellingPrice: Decimal;
        GrandLocQtyDAS: Decimal;
        GrandLocQtyAvgSellPrice: Decimal;
        TotalLocQtyDAS: Decimal;
        TotalLocQtyAvgSellPrice: Decimal;
        RecUserBranch: Record 50029;
        LocCode1: Code[1024];
        LocCodeText: Text[1024];
        LocQtyPCSTot: Decimal;
        LocQtyKGTot: Decimal;
        DASValueTot: Decimal;
        AvgSellingPriceTot: Decimal;
        RecItem1: Record 27;
        LocQtyPCSTot1: Decimal;
        LocQtyKGTot1: Decimal;
        DASValueTot1: Decimal;
        AvgSellingPriceTot1: Decimal;
        RecILE5: Record 32;
        RecLoc5: Record 14;
        ItemFilter: Text[1024];
        MonthCtr: Integer;
        MonthI: Integer;
        MonthFromDate: array[12] of Date;
        MonthEndDate: array[12] of Date;
        OriFromDate: Date;
        OriToDate: Date;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\MA-PRODUCT REPORT.xlsx', 'MA-PRODUCT REPORT', 'MA-PRODUCT REPORT', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\MA-PRODUCT REPORT.xlsx', 'MA-PRODUCT REPORT', 'MA-PRODUCT REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('MA-PRODUCT REPORT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date :' + FORMAT(From_Date) + '  To  ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('Product Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        RecLoc.RESET;
        RecLoc.SETRANGE(RecLoc."Used In MA-Product", TRUE);
        //CCIT-PRI-030418
        IF LocCodeText <> '' THEN
            RecLoc.SETFILTER(RecLoc.Code, LocCodeText);
        //CCIT-PRI-030418
        /*IF GlobLoc <> '' THEN
          RecLoc.SETFILTER(RecLoc.Code,CurrLoc);*/
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        RecLocation.RESET;
        RecLocation.SETRANGE(RecLocation."Used In MA-Product", TRUE);
        IF LocCodeText <> '' THEN
            RecLocation.SETFILTER(RecLocation.Code, LocCodeText);
        IF RecLocation.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('DAS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Avg Selling Price ', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLocation.NEXT = 0;

        ExcelBuf.AddColumn('Total Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total DAS Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Avg. Selling Price', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

    end;

    procedure MakeExcelDataBody(CurrLoc: Code[10]);
    begin
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(ItemNo: Code[20]; LocCode: Code[20]): Integer;
    begin

        RecILE33.SETRANGE("Item No.", ItemNo);
        RecILE33.SETRANGE("Location Code", LocCode);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

