report 50026 "Quarantaine Report Final"
{
    // version To be deleted

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.")
                                ORDER(Ascending);
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord();
            begin
                ProductDesc := '';
                Brand := '';
                CLEAR(Vertical);

                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    VendNum := RecItem."Vendor No.";
                    SalesCategory := RecItem."Sales Category";
                END;
                IF RecVend.GET(VendNum) THEN
                    Supplier := RecVend.Name;

                /*
                IF RecVend.GET("Item Ledger Entry"."Source No.") THEN
                  Supplier := RecVend.Name;
                */

                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    ProductDesc := RecItem.Description;
                    Brand := RecItem."Brand Name";
                    Vertical := RecItem."Gen. Prod. Posting Group";
                END;


                ItemTotal := 0;
                RecILE3.RESET;
                RecILE3.SETRANGE(RecILE3."Item No.", "Item Ledger Entry"."Item No.");
                IF RecILE3.FINDFIRST THEN
                    REPEAT
                        ItemTotal += RecILE3."Remainig Qty. In KG";
                    UNTIL RecILE3.NEXT = 0;


                IF ItemTotal = 0 THEN
                    CurrReport.SKIP;

                IF (CurrItem = 'CRONUS BLANK') THEN BEGIN
                    CurrItem := "Item Ledger Entry"."Item No.";
                    I := 0;
                    ItemCounter := EntryCount(CurrItem);

                END;
                I += 1;

                IF I = ItemCounter THEN BEGIN
                    MakeExcelDataBody;
                    CurrItem := 'CRONUS BLANK';
                    //CurrLoc := 'FORTUNE1 BLANK';
                    ItemCounter := 0;
                END;

            end;

            trigger OnPostDataItem();
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

                TotalLocQtyPCS := 0;
                TotalLocQtyKG := 0;
                RecLoc.RESET;
                //RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO",TRUE);
                IF LocCode <> '' THEN BEGIN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                END ELSE BEGIN
                    RecLoc.SETRANGE(RecLoc."Used In Quarantine Report", TRUE);
                    RecLoc.SETFILTER(RecLoc.Code, LocCodeText);//NEW
                END;
                IF RecLoc.FINDFIRST THEN
                    REPEAT
                        LocTotalPCS := 0;
                        LocTotalKG := 0;
                        RecILE2.RESET;
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            RecILE2.SETRANGE("Posting Date", From_Date, To_Date)
                        ELSE
                            IF (AsOnDate <> 0D) THEN
                                RecILE2.SETRANGE("Posting Date", 99990101D, AsOnDate); //010199D
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                        IF VendorNo <> '' THEN
                            RecILE2.SETRANGE(RecILE2."Source No.", VendorNo);
                        IF RecILE2.FINDSET THEN
                            REPEAT
                                LocTotalPCS := LocTotalPCS + RecILE2."Remaining Quantity";

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                                            LocTotalKG := LocTotalKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                        END
                                    END
                                END;

                            UNTIL RecILE2.NEXT = 0;
                        TotalLocQtyPCS := TotalLocQtyPCS + LocTotalPCS;
                        TotalLocQtyKG := TotalLocQtyKG + LocTotalKG;
                        ExcelBuf.AddColumn(LocTotalPCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(LocTotalKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    // ExcelBuf.AddColumn(GrandLocQtyPCS,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                    //ExcelBuf.AddColumn(GrandLocQtyKG,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                    // ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                    // ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                    UNTIL RecLoc.NEXT = 0;
                //ExcelBuf.AddColumn(TotalLocQtyPCS,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn(TotalLocQtyKG,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('GrandTotalInPCS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('GrandTotalInKGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            end;

            trigger OnPreDataItem();
            begin

                //CCIT-PRI-280318
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode1 := LocCode1 + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                RecLocation1.RESET;
                RecLocation1.SETFILTER(RecLocation1.Code, DELCHR(LocCode1, '<', '|'));
                RecLocation1.SETRANGE(RecLocation1."Used In Quarantine Report", TRUE);
                IF RecLocation1.FINDFIRST THEN
                    REPEAT
                        LocationName := LocationName + '|' + RecLocation1.Code;
                    UNTIL RecLocation1.NEXT = 0;

                LocCodeText := DELCHR(LocationName, '<', '|');
                /*
                IF LocCode <> '' THEN BEGIN
                IF Recloc2.GET(LocCode) THEN BEGIN
                  IF Recloc2."Used In Quarantine Report" <> TRUE THEN
                    ERROR('Please Select the Block Location');
                    //CurrReport.SKIP;
                END;
                END;
                */
                //IF LocCodeText <> '' THEN
                IF LocCode = '' THEN
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCodeText)
                ELSE
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCode);


                //CCIT-PRI-280318

                //LocFilters := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 99990101D, AsOnDate);
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
                    field("Vendor No."; VendorNo)
                    {
                        TableRelation = Vendor."No.";
                        Visible = false;
                    }
                    field("Location Code"; LocCode)
                    {
                        TableRelation = Location.Code;
                        Visible = true;
                    }
                }
                group("From Date - To Date Filter")
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
                        Caption = 'To Date';

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
                    field("As On date"; AsOnDate)
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
        CurrItem := 'CRONUS BLANK';
        //CurrBatch := 'FORTUNE BLANK';
        //CurrLoc := 'FORTUNE1 BLANK';
        TotalLocQtyPCS := 0;
        TotalLocQtyKG := 0;
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        Recloc2.RESET;
        Recloc2.SETRANGE(Recloc2.Code, LocCode);
        Recloc2.SETRANGE(Recloc2."Used In Quarantine Report", FALSE);
        IF Recloc2.FINDFIRST THEN BEGIN
            IF (LocCode <> '') THEN
                ERROR('Please Select the Quarantine Location');
        END;

        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN BEGIN
            IF (RecUserBranch."Location Code" <> LocCode) THEN
                ERROR('This Location is not available for this user');
        END;
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
        CurrBatch: Code[20];
        VendorNo: Code[10];
        LocCode: Text[250];
        TotalLocQtyPCS: Decimal;
        TotalLocQtyKG: Decimal;
        CustomerNo: Code[10];
        RecCust: Record 18;
        Vertical: Code[10];
        TotalLocQtyPCSBLR: Decimal;
        TotalLocQtyKGBLR: Decimal;
        TotalLocQtyPCSCHE: Decimal;
        TotalLocQtyKGCHE: Decimal;
        TotalLocQtyPCSDEL: Decimal;
        TotalLocQtyKGDEL: Decimal;
        TotalLocQtyPCSGOA: Decimal;
        TotalLocQtyKGGOA: Decimal;
        TotalLocQtyPCSHYD: Decimal;
        TotalLocQtyKGHYD: Decimal;
        TotalLocQtyPCSJWL: Decimal;
        TotalLocQtyKGJWL: Decimal;
        TotalLocQtyPCSMAR: Decimal;
        TotalLocQtyKGMAR: Decimal;
        LocationFilters: Text[250];
        LocFilters: Text[250];
        RecUOM1: Record 5404;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode1: Code[1024];
        LocCodeText: Text[1024];
        RecLocation1: Record 14;
        LocationName: Code[1024];
        Recloc2: Record 14;
        VendNum: Code[20];
        SalesCategory: Code[20];

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Quarantine Report.xlsx', 'Quarantine Report', 'Quarantine Report', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Quarantine Report.xlsx', 'Quarantine Report', 'Quarantine Report', COMPANYNAME, USERID);
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('QUARANTINE REPORT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('Date :' + FORMAT(From_Date) + '  To  ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            IF (AsOnDate <> 0D) THEN
                ExcelBuf.AddColumn('Date :' + FORMAT(AsOnDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Fortune Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        RecLoc.RESET;
        //IF GlobLoc <> '' THEN
        //RecLoc.SETRANGE(RecLoc."Used In Inventory Planning HO",TRUE);
        IF LocCode <> '' THEN BEGIN
            RecLoc.SETRANGE(RecLoc.Code, LocCode);
        END ELSE BEGIN
            RecLoc.SETRANGE(RecLoc."Used In Quarantine Report", TRUE);
            RecLoc.SETFILTER(RecLoc.Code, LocCodeText);//NEW
        END;
        IF RecLoc.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn(RecLoc.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLoc.NEXT = 0;

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

        RecLocation.RESET;
        IF LocCode <> '' THEN BEGIN
            RecLocation.SETFILTER(RecLocation.Code, LocCode);
        END ELSE BEGIN
            RecLocation.SETRANGE(RecLocation."Used In Quarantine Report", TRUE);
            RecLocation.SETFILTER(RecLocation.Code, LocCodeText);//NEW
        END;
        IF RecLocation.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('IOH in KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('IOH in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecLocation.NEXT = 0;
        //ExcelBuf.AddColumn('IOH in KGS',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('IOH in PCS',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(ProductDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Item Ledger Entry"."Sales Category",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //GrandLocQtyPCS := 0;
        //GrandLocQtyKG := 0;

        TotalLocQtyPCS := 0;
        TotalLocQtyKG := 0;
        RecLoc.RESET;
        IF LocCode <> '' THEN BEGIN
            RecLoc.SETRANGE(RecLoc.Code, LocCode);
        END ELSE BEGIN
            RecLoc.SETRANGE(RecLoc."Used In Quarantine Report", TRUE);
            RecLoc.SETFILTER(RecLoc.Code, LocCodeText);//NEW
        END;
        IF RecLoc.FINDFIRST THEN
            REPEAT
                LocQtyPCS := 0;
                LocQtyKG := 0;
                RecILE2.RESET;
                RecILE2.SETRANGE(RecILE2."Item No.", "Item Ledger Entry"."Item No.");
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    RecILE2.SETRANGE("Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        RecILE2.SETRANGE("Posting Date", 99990101D, AsOnDate);
                RecILE2.SETFILTER(RecILE2."Entry Type", '%1|%2|%3|%4|%5', RecILE2."Entry Type"::Purchase, RecILE2."Entry Type"::Transfer, RecILE2."Entry Type"::"Positive Adjmt.", RecILE2."Entry Type"::"Negative Adjmt.", RecILE2."Entry Type"::Sale);
                RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                IF VendorNo <> '' THEN
                    RecILE2.SETRANGE(RecILE2."Source No.", VendorNo);
                IF RecILE2.FINDSET THEN
                    REPEAT
                        LocQtyPCS := LocQtyPCS + RecILE2."Remaining Quantity";
                        IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                            IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM1.Weight <> 0) THEN BEGIN
                                    LocQtyKG := LocQtyKG + ROUND((RecILE2."Remaining Quantity" / RecUOM1.Weight), 1, '=');
                                END
                            END
                        END;
                    UNTIL RecILE2.NEXT = 0;
                TotalLocQtyPCS := TotalLocQtyPCS + LocQtyPCS;
                TotalLocQtyKG := TotalLocQtyKG + LocQtyKG;
                ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(LocQtyKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

            //GrandTotalInPCS := GrandTotalInPCS + LocQtyPCS;
            //GrandTotalInKGS := GrandTotalInKGS + LocQtyKG;
            UNTIL RecLoc.NEXT = 0;
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(ItemNo: Code[20]): Integer;
    begin
        RecILE33.RESET;
        //RecILE33.SETRANGE("Entry Type",RecILE33."Entry Type"::Purchase);
        IF LocCode <> '' THEN
            RecILE33.SETRANGE(RecILE33."Location Code", LocCode)
        ELSE
            RecILE33.SETFILTER(RecILE33."Location Code", STRSUBSTNO('%1', LocCodeText));
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            RecILE33.SETRANGE(RecILE33."Posting Date", From_Date, To_Date)
        ELSE
            IF (AsOnDate <> 0D) THEN
                RecILE33.SETRANGE(RecILE33."Posting Date", 99990101D, AsOnDate);
        //RecILE33.SETFILTER(RecILE33."Entry Type",'%1|%2|%3|%4|%5',RecILE33."Entry Type"::Purchase,RecILE33."Entry Type"::Transfer,RecILE33."Entry Type"::"Positive Adjmt.",RecILE33."Entry Type"::"Negative Adjmt.",RecILE33."Entry Type"::Sale);
        RecILE33.SETRANGE("Item No.", ItemNo);
        //RecILE33.SETFILTER("Remainig Qty. In KG",'<>%1',0);
        //RecILE33.SETRANGE("Lot No.",BatchNo);
        //RecILE33.SETRANGE("Location Code",LocCode);
        //RecILE33.SETRANGE("Document No.",DocNo);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

