report 50016 "Inventory Valuation Report"
{
    // version CCIT-JAGA

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin

                //VendNo := Item."Vendor No.";

                IF RecVend.GET(Item."Vendor No.") THEN
                    SourceName := RecVend.Name;

                //MESSAGE('%1',Item."No.");
                Item.CALCFIELDS(Inventory);

                ItemTotal := 0;
                RecILE3.RESET;
                RecILE3.SETRANGE(RecILE3."Item No.", Item."No.");
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    RecILE3.SETRANGE(RecILE3."Posting Date", From_Date, To_Date)
                ELSE
                    //RecILE3.SETRANGE(RecILE3."Posting Date",010199D,AsOnDate);
                   RecILE3.SETRANGE(RecILE3."Posting Date", 20200111D, AsOnDate);
                RecILE3.SETFILTER(RecILE3."Entry Type", '%1|%2|%3|%4|%5', RecILE3."Entry Type"::Purchase, RecILE3."Entry Type"::Transfer, RecILE3."Entry Type"::"Positive Adjmt.", RecILE3."Entry Type"::"Negative Adjmt.", RecILE3."Entry Type"::Sale);
                IF RecILE3.FINDFIRST THEN
                    REPEAT
                        //ItemTotal += RecILE3.Quantity;
                        ItemTotal += RecILE3.Quantity;
                    UNTIL RecILE3.NEXT = 0;

                IF ItemTotal = 0 THEN
                    CurrReport.SKIP;

                //GrandTotalInPCS := 0; //Last Column Total
                //GrandTotalInKGS := 0;

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//rdk180919
                ExcelBuf.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SourceName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Brand Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                //----------------------------------------------------
                // CCIT - Pratiksha 2012018
                ExcelBuf.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //----------------------------------------------------

                //-----------------

                //JAGA
                GrandLocQtyPCS := 0;
                GrandLocQtyKG := 0;

                TotalLocQtyPCS := 0;
                TotalLocQtyKG := 0;
                CLEAR(LocationFound);
                //JAGA

                //CCIT - Pratiksha 25012018

                RecLoc.RESET;
                IF LocCode = '' THEN BEGIN
                    RecLoc.SETRANGE(RecLoc."Used In Stock Ageing Report", TRUE);
                    RecLoc.SETRANGE(RecLoc.Loc_Block, FALSE);//rdk180919
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQtyPCS := 0;
                            LocQtyKG := 0;
                            LocRemainingQtyKG := 0;
                            RecILE2.RESET;
                            //RecILE2.SETRANGE(RecILE2."Document No.","Item Ledger Entry"."Document No.");
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                                RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date)
                            ELSE
                                //RecILE2.SETRANGE(RecILE2."Posting Date",010199D,AsOnDate);
                                RecILE2.SETRANGE(RecILE2."Posting Date", 20200111D, AsOnDate);
                            //RecILE2.SETRANGE(RecILE2."Lot No.",Item."Lot Nos.");
                            RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            //IF VendorNo <> '' THEN
                            //RecILE2.SETRANGE(RecILE2."Source No.",VendorNo);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQtyPCS := LocQtyPCS +( Item."Unit Cost" * Item.Inventory);
                                    //LocQtyKG := LocQtyKG + Item.Inventory;
                                    //LocQtyKG := LocQtyKG + RecILE2."Remainig Qty. In KG";
                                    LocQtyPCS := LocQtyPCS + (RecILE2.Quantity * Item."Unit Cost"); //vikas
                                    LocQtyKG := LocQtyKG + RecILE2.Quantity;
                                    LocRemainingQtyKG := LocRemainingQtyKG + RecILE2."Remaining Quantity"; // CCIT AN 27122021

                                UNTIL RecILE2.NEXT = 0;
                            TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                            TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                            ExcelBuf.AddColumn(LocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocRemainingQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); // CCIT AN 27122021
                            ExcelBuf.AddColumn((LocQtyPCS), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
                            GrandTotalInKGS := GrandTotalInKGS + LocQtyKG;
                        UNTIL RecLoc.NEXT = 0;

                END
                ELSE BEGIN
                    RecLoc.RESET;
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            FOR I := 1 TO 40 DO BEGIN
                                IF LocCodeArray[I] = RecLoc.Code THEN BEGIN
                                    LocationFound := TRUE;
                                    I := 40;
                                END
                                ELSE
                                    LocationFound := FALSE;
                            END;
                            IF LocationFound THEN BEGIN
                                LocQtyPCS := 0;
                                LocQtyKG := 0;
                                LocRemainingQtyKG := 0;  // CCIT AN 27122021
                                RecILE2.RESET;
                                //RecILE2.SETRANGE(RecILE2."Document No.","Item Ledger Entry"."Document No.");
                                RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                                    RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date)
                                ELSE
                                    //RecILE2.SETRANGE(RecILE2."Posting Date",010199D,AsOnDate);
                                    RecILE2.SETRANGE(RecILE2."Posting Date", 20200111D, AsOnDate);
                                // RecILE2.SETRANGE(RecILE2."Lot No.",Item."Lot Nos.");
                                RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                                RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                                //IF VendorNo <> '' THEN
                                //RecILE2.SETRANGE(RecILE2."Source No.",VendorNo);
                                IF RecILE2.FINDSET THEN
                                    REPEAT
                                        //LocQtyPCS := LocQtyPCS + (Item.Inventory * Item."Unit Cost");
                                        LocQtyPCS := LocQtyPCS + (RecILE2.Quantity * Item."Unit Cost"); //vikas
                                        LocQtyKG := LocQtyKG + RecILE2.Quantity;
                                        LocRemainingQtyKG := LocRemainingQtyKG + RecILE2."Remaining Quantity"; // CCIT AN 27122021
                                    UNTIL RecILE2.NEXT = 0;
                                //TotalLocQtyPCS := TotalLocQtyPCS + (Item.Inventory * Item."Unit Cost");
                                //TotalLocQtyKG := TotalLocQtyKG + Item.Inventory;
                                TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                                TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                                ExcelBuf.AddColumn(LocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(LocRemainingQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn((LocQtyPCS), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
                                GrandTotalInKGS := GrandTotalInKGS + LocQtyKG;
                            END;
                        UNTIL RecLoc.NEXT = 0;
                END;

                ExcelBuf.AddColumn(TotalLocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('RQT',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number); // CCIT AN 27122021
                ExcelBuf.AddColumn(TotalLocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            end;

            trigger OnPostDataItem();
            var
                RecItem: Record 27;
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



                RecLoc.RESET;
                RecLoc.SETRANGE(RecLoc."Used In Stock Ageing Report", TRUE);
                RecLoc.SETRANGE(RecLoc.Loc_Block, FALSE);//rdk180919
                IF RecLoc.FINDFIRST THEN
                    REPEAT
                        LocQtyPCS := 0;
                        LocQtyKG := 0;
                        LocRemainingQtyKG := 0; // CCIT AN 27122021

                        RecILE2.RESET;
                        //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Sale);
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date)
                        ELSE
                            //RecILE2.SETRANGE(RecILE2."Posting Date",010199D,AsOnDate);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 20200111D, AsOnDate);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF ItemFilter <> '' THEN
                            RecILE2.SETRANGE(RecILE2."Item No.", ItemFilter);
                        IF RecILE2.FINDSET THEN
                            REPEAT
                                //LocTotal := LocTotal + RecILE2.Quantity;
                                // LocTotal := LocTotal + RecILE2."Remainig Qty. In KG";
                                // LocQtyPCS := LocQtyPCS + (Item.Inventory * Item."Unit Cost");
                                // LocQtyKG := LocQtyKG +  Item.Inventory;
                                IF RecItem.GET(RecILE2."Item No.") THEN;
                                LocQtyPCS := LocQtyPCS + (RecILE2.Quantity * RecItem."Unit Cost"); //vikas
                                LocQtyKG := LocQtyKG + RecILE2.Quantity;
                                LocRemainingQtyKG := LocRemainingQtyKG + RecILE2."Remaining Quantity"; // CCIT AN 27122021

                            UNTIL RecILE2.NEXT = 0;
                        //IF Item.GET(RecILE2."Item No.") THEN
                        //  ValTot := ValTot + (Item."Unit Cost" * RecILE2."Remainig Qty. In KG"); // CCIT - Pratiksha 24012018
                        // MESSAGE('%1', ValTot);

                        //ExcelBuf.AddColumn(LocQtyKG,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(LocQtyKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(LocRemainingQtyKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); // CCIT AN 27122021
                        ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); // CCIT - Pratiksha 24012018
                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(GrandTotalInKGS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('GRANDRQT',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number); // CCIT AN 27122021
                ExcelBuf.AddColumn(GrandTotalInPCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            end;

            trigger OnPreDataItem();
            var
                REcLoc: Record 14;
                i: Integer;
                StrPosition: Integer;
            begin
                //GlobLoc := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");
                //IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                //"Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date",From_Date,To_Date);

                ILERec.RESET;
                ILERec.SETRANGE(ILERec."Item No.", Item."No.");
                LocCode := ILERec.GETFILTER(ILERec."Location Code");
                LocCodeFilter := LocCode;
                ItemFilter := Item.GETFILTER("No.");



                FOR i := 1 TO 40 DO BEGIN
                    StrPosition := STRPOS(LocCodeFilter, '|');
                    IF StrPosition > 0 THEN BEGIN
                        //IF LocCodeFilter = 'JWL M WH' THEN
                        LocCodeArray[i] := COPYSTR(LocCodeFilter, 1, StrPosition - 1);

                        IF StrPosition + 1 <= STRLEN(LocCodeFilter) THEN
                            LocCodeFilter := COPYSTR(LocCodeFilter, StrPosition + 1)
                        ELSE
                            LocCodeFilter := '';

                    END
                    ELSE BEGIN
                        LocCodeArray[i] := LocCodeFilter;
                        i := 40;
                    END;
                END;

                COMPRESSARRAY(LocCodeArray);
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
                group("From Date - TO Date Filters")
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
        //CurrItem := 'CRONUS BLANK';
        CurrLoc := 'FORTUNE BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
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
        AsOnDate: Date;
        ItemFilter: Code[20];
        LocRemainingQtyKG: Decimal;

    procedure CreateExcelBook();
    begin

        ExcelBuf.CreateBookAndOpenExcel('D:\INVENTORY VALUATION REPORT.xlsx', 'INVENTORY VALUATION REPORT', 'INVENTORY VALUATION REPORT', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('INVENTORY VALUATION REPORT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('Date : ' + FORMAT(From_Date) + '  To  ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('Date : ' + FORMAT(AsOnDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Item No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Category',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Landed Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        RecLoc.RESET;
        RecLoc.SETRANGE(RecLoc."Used In Stock Ageing Report", TRUE);
        RecLoc.SETRANGE(Loc_Block, FALSE);//rdk180919
        IF GlobLoc <> '' THEN
            RecLoc.SETFILTER(RecLoc.Code, CurrLoc);
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text); // CCIT AN 27122021
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;

        //P
        ExcelBuf.AddColumn('Total PAN INDIA', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);

        RecLocation.RESET;
        RecLocation.SETRANGE(RecLocation."Used In Stock Ageing Report", TRUE);
        RecLocation.SETRANGE(Loc_Block, FALSE);//rdk180919;
        IF GlobLoc <> '' THEN
            RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
        IF RecLocation.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Remaining Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text); //CCIT AN 27122021
                ExcelBuf.AddColumn('Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLocation.NEXT = 0;

        ExcelBuf.AddColumn('Total Qty In KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody(CurrLoc: Code[10]);
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        
        RecLoc.RESET;
        IF GlobLoc <> '' THEN
          RecLoc.SETFILTER(RecLoc.Code,CurrLoc);
        IF RecLoc.FINDSET THEN
         REPEAT
          ExcelBuf.AddColumn(RecLoc.Code,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
          ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
         UNTIL RecLoc.NEXT=0;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        
        RecLocation.RESET;
        IF GlobLoc <> '' THEN
        RecLocation.SETFILTER(RecLocation.Code,CurrLoc);
        IF RecLocation.FINDSET THEN
          REPEAT
            ExcelBuf.AddColumn('Qty In KG',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Value',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
          UNTIL RecLocation.NEXT=0 ;
        
        {
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        
        IF GlobLoc <> '' THEN
        RecLocation.SETFILTER(RecLocation.Code,GlobLoc);
        IF RecLocation.FINDSET THEN
         REPEAT
          ExcelBuf.AddColumn(LocQty,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
          ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
         UNTIL RecLocation.NEXT=0 ;
         }
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(ProductDesc,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RecILE4."Item Category Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RecILE4."Storage Categories",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RecILE4."Product Group Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RecILE4."Unit of Measure Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(LocQty,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        
        
        
        
        IF GlobLoc <> '' THEN
        RecLocation.SETFILTER(RecLocation.Code,CurrLoc);
        IF RecLocation.FINDSET THEN
         REPEAT
          ExcelBuf.AddColumn(LocQty,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
          ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
         UNTIL RecLocation.NEXT=0 ;
         */

    end;

    procedure MakeExcelTotal();
    begin
        /*
        ExcelBuf.NewRow;
        
        ExcelBuf.AddColumn('Total',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        */

    end;

    procedure EntryCount(ItemNo: Code[20]; LocCode: Code[20]): Integer;
    begin

        RecILE33.SETRANGE("Item No.", ItemNo);
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            RecILE33.SETRANGE(RecILE33."Posting Date", From_Date, To_Date)
        ELSE
            // RecILE33.SETRANGE(RecILE33."Posting Date",010199D,AsOnDate);
            RecILE33.SETRANGE(RecILE33."Posting Date", 20200111D, AsOnDate);
        //RecILE33.SETFILTER(RecILE33."Entry Type",'%1|%2|%3|%4|%5',RecILE33."Entry Type"::Purchase,RecILE33."Entry Type"::Transfer,RecILE33."Entry Type"::"Positive Adjmt.",RecILE33."Entry Type"::"Negative Adjmt.",RecILE33."Entry Type"::Sale);
        RecILE33.SETRANGE("Location Code", LocCode);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

