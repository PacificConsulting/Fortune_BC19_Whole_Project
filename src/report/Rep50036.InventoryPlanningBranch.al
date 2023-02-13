report 50036 "Inventory Planning - Branch"
{
    // version RDK in use

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Blocked = FILTER(false));
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Entry Type", "Posting Date", "Location Code");
                RequestFilterFields = "Item No.", "Location Code";

                trigger OnAfterGetRecord();
                begin
                    NoOfDays_InDaterange := To_Date - From_Date;

                    IF RecCust.GET("Item Ledger Entry"."Source No.") THEN BEGIN
                        SubCategory := RecCust."Vertical Sub Category";
                    END;

                    DASValueTotal := 0;
                    DASValue1 := 0;
                    RecILE.RESET;
                    RecILE.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                    RecILE.SETRANGE(RecILE."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE.SETFILTER(RecILE."Entry Type", '%1', RecILE."Entry Type"::Sale);
                    RecILE.SETRANGE(RecILE."Posting Date", From_Date, To_Date);
                    RecILE.SETFILTER(RecILE."Location Code", '%1', Location_Main);
                    RecILE.CALCSUMS(RecILE.Quantity);
                    DASValue1 += RecILE.Quantity;

                    DASValue2 := 0;
                    RecILE6.RESET;
                    RecILE6.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                    RecILE6.SETRANGE(RecILE6."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE6.SETFILTER(RecILE6."Entry Type", '%1', RecILE."Entry Type"::Sale);
                    RecILE6.SETRANGE(RecILE6."Posting Date", From_Date, To_Date);
                    RecILE6.SETFILTER(RecILE6."Location Code", '%1', Location_DF);
                    RecILE6.CALCSUMS(RecILE6.Quantity);
                    DASValue2 += RecILE6.Quantity;

                    DASValueTotal := -(DASValue1 + DASValue2);

                    StockMain := 0;   // Main Location stock
                    RecILE1.RESET;
                    RecILE1.SETCURRENTKEY("Item No.", "Location Code");
                    RecILE1.SETRANGE(RecILE1."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE1.SETRANGE(RecILE1."Location Code", Location_Main);
                    //RecILE1.SETRANGE(recile1."Posting Date",From_Date,To_Date); // CCIT AN
                    RecILE1.CALCSUMS(RecILE1.Quantity);
                    StockMain += RecILE1.Quantity;


                    StockIntra := 0;    // Intra Location stock
                    RecILE2.RESET;
                    RecILE2.SETCURRENTKEY("Item No.", "Location Code");
                    RecILE2.SETRANGE(RecILE2."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE2.SETRANGE(RecILE2."Location Code", Location_Intra);
                    //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);  // CCIT AN
                    RecILE2.CALCSUMS(RecILE2.Quantity);
                    StockIntra += RecILE2.Quantity;   // MESSAGE('%1--',StockIntra);


                    StockDF := 0;     // Duty Free Location stock
                    RecILE3.RESET;
                    RecILE3.SETCURRENTKEY("Item No.", "Location Code");
                    RecILE3.SETRANGE(RecILE3."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE3.SETRANGE(RecILE3."Location Code", Location_DF);
                    //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);  // CCIT AN
                    RecILE3.CALCSUMS(RecILE3.Quantity);
                    StockDF += RecILE3.Quantity;


                    TotalStock := StockIntra + StockMain + StockDF;
                    IF RecItem2.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                TotalStockInPCS := TotalStock / RecUOM.Weight;
                            END
                        END
                    END;
                    //CCIT-SG-18042019
                    NetSalesAmtTotal := 0;
                    NetSalesAmt1 := 0;
                    RecILE5.RESET;
                    RecILE5.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                    RecILE5.SETRANGE(RecILE5."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE5.SETFILTER(RecILE5."Entry Type", '%1', RecILE5."Entry Type"::Sale);
                    RecILE5.SETRANGE(RecILE5."Posting Date", From_Date, To_Date);
                    RecILE5.SETFILTER(RecILE5."Location Code", '%1', Location_Main);
                    RecILE5.CALCSUMS(RecILE5.Quantity);
                    NetSalesAmt1 += RecILE5.Quantity;

                    NetSalesAmt2 := 0;
                    RecILE7.RESET;
                    RecILE7.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
                    RecILE7.SETRANGE(RecILE7."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE7.SETFILTER(RecILE7."Entry Type", '%1', RecILE7."Entry Type"::Sale);
                    RecILE7.SETRANGE(RecILE7."Posting Date", From_Date, To_Date);
                    RecILE7.SETFILTER(RecILE7."Location Code", '%1', Location_DF);
                    RecILE7.CALCSUMS(RecILE7.Quantity);
                    NetSalesAmt2 += RecILE7.Quantity;

                    NetSalesAmtTotal := -(NetSalesAmt1 + NetSalesAmt2);
                    //CCIT-SG-18042019


                    //ERROR('%1,%2',NoOfDays_InDaterange,DASValue);
                    DAS_Branch_Total := DASValueTotal / NoOfDays_InDaterange;


                    CLEAR(Days_StocK_per_DAS);
                    CLEAR(Safety_Stock_Plus_Minus);
                    SafetyStock_value := DAS_Branch_Total * NoOfDays;
                    IF (DAS_Branch_Total <> 0) THEN
                        Days_StocK_per_DAS := TotalStock / DAS_Branch_Total;
                    IF (SafetyStock_value <> 0) THEN
                        Safety_Stock_Plus_Minus := TotalStock - SafetyStock_value;
                    /*
                    IF TotalSaleValue = 0 THEN
                      CurrReport.SKIP;
                    */

                    IF (CurrItem = 'CRONUS BLANK') THEN BEGIN
                        CurrItem := "Item Ledger Entry"."Item No.";
                        I := 0;
                        ItemCounter := EntryCount(CurrItem);
                    END;
                    I += 1;

                    IF I = ItemCounter THEN BEGIN
                        MakeExcelDataBody;
                        CurrItem := 'CRONUS BLANK';
                        ItemCounter := 0;
                    END;

                    //CCIT-HG-Start-19/02/2019
                    IUM.RESET;
                    IUM.SETRANGE(IUM."Item No.", "Item Ledger Entry"."Item No.");
                    IF IUM.FINDFIRST THEN
                        ItemWeight := IUM.Weight;
                    //CCIT-HG-End-19/02/2019

                    //MakeExcelDataBody;

                end;

                trigger OnPostDataItem();
                begin


                    //MakeExcelDataFooter;
                end;

                trigger OnPreDataItem();
                begin
                    //CCIT-PRI-280318
                    /*RecUserBranch.RESET ;
                    RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
                    IF RecUserBranch.FINDFIRST THEN
                      REPEAT
                        LocCode := LocCode+'|'+ RecUserBranch."Location Code" ;
                      UNTIL RecUserBranch.NEXT=0 ;
                    
                    LocCodeText := DELCHR(LocCode,'<','|');*/

                    //LocCodeText := ARRAYLEN(FORMAT(LocCode),'<','|');

                    IF LocCodeText <> '' THEN
                        "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCodeText);
                    //CCIT-PRI-280318
                    //"Item Ledger Entry".SETFILTER("Item Ledger Entry"."Posting Date",FORMAT(From_Date),To_Date);

                    //MakeExcelDataHeader;

                end;
            }

            trigger OnAfterGetRecord();
            begin

                IF RecVend.GET(Item."Vendor No.") THEN BEGIN
                    Supplier := RecVend.Name;
                END;
                IF RecItem.GET(Item."No.") THEN BEGIN
                    brand := RecItem."Brand Name";
                    SalesCategory := RecItem."Sales Category";
                    Itemname := RecItem.Description;


                    Category := RecItem."Sales Category";
                    vertical := RecItem."Gen. Prod. Posting Group";
                    UOM := RecItem."Conversion UOM";
                    ConversionUOM := RecItem."Base Unit of Measure";
                END;
                /*//CCIT-SS
                CLEAR(LocCode);
                CLEAR(LocCodeText);
                RecUserBranch.RESET ;
                RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
                IF RecUserBranch.FINDFIRST THEN
                  REPEAT
                    LocCode := LocCode+'|'+ RecUserBranch."Location Code" ;
                  UNTIL RecUserBranch.NEXT=0 ;
                
                LocCodeText := DELCHR(LocCode,'<','|');
                *//////////

            end;

            trigger OnPreDataItem();
            begin
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
                field("No Of Days"; NoOfDays)
                {
                }
                field("Location Main"; Location_Main)
                {
                    TableRelation = Location.Code;
                }
                field("Location Intra"; Location_Intra)
                {
                    TableRelation = Location.Code;
                }
                field("Location DF"; Location_DF)
                {
                    TableRelation = Location.Code;
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
                group("As On Date Filter ")
                {
                    Visible = false;
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
        CurrItem := 'CRONUS BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelbook;
    end;

    trigger OnPreReport();
    begin
        StockDFTot := 0;
        StockIntraTot := 0;
        StockMainTot := 0;


        IF NoOfDays = 0 THEN
            ERROR('No Of Days Should not blank...');

        IF (From_Date = 0D) OR (To_Date = 0D) THEN
            ERROR('From_Date OR TO_Date Should not blank...');

        IF (From_Date = To_Date) THEN
            ERROR('From_Date AND TO_Date Should not same...');

        IF RecUserSetup.GET(USERID) THEN
            User_Location := RecUserSetup.Location;
        IF (User_Location <> '') THEN BEGIN
            IF Loc1.GET(Location_Main) THEN
                Loc_Main_State := Loc1."State Code";

            IF Loc2.GET(Location_Intra) THEN
                Loc_Intra_State := Loc2."State Code";

            IF Loc3.GET(Location_DF) THEN
                Loc_DF_State := Loc3."State Code";

            IF (User_Location <> Loc_Main_State) AND (User_Location <> Loc_Intra_State) AND (User_Location <> Loc_DF_State) THEN
                ERROR('User Location Does Not Match....');
        END;
    end;

    var
        Document_Type: Option " ",Invoice,"Credit Note";
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        RecCust: Record 18;
        CustomerBusinessFormat: Text[100];
        CustName: Text[50];
        VerticalSubCategory: Code[50];
        CurrLoc: Code[20];
        CurrItem: Code[20];
        CurrCust: Code[20];
        CurrDocNo: Code[20];
        I: Integer;
        From_Date: Date;
        To_Date: Date;
        ItemCounter: Integer;
        RecItem: Record 27;
        Supplier: Text[100];
        brand: Code[20];
        RecVend: Record 23;
        VendorCode: Code[20];
        Category: Code[30];
        SubCategory: Code[30];
        vertical: Code[20];
        SalesCategory: Code[20];
        RecILE: Record 32;
        Itemname: Text[100];
        NoOfDays: Integer;
        NoOfDays_InDaterange: Integer;
        DASValueTotal: Decimal;
        DAS_Branch_Total: Decimal;
        SafetyStock_value: Decimal;
        Location_Main: Code[10];
        Location_Intra: Code[10];
        Location_DF: Code[10];
        StockIntra: Decimal;
        StockDF: Decimal;
        StockMain: Decimal;
        RecILE1: Record 32;
        RecILE2: Record 32;
        RecILE3: Record 32;
        TotalStock: Decimal;
        RecUserSetup: Record 91;
        User_Location: Code[10];
        Loc1: Record 14;
        Loc2: Record 14;
        Loc3: Record 14;
        Loc_Main_State: Code[10];
        Loc_Intra_State: Code[10];
        Loc_DF_State: Code[10];
        Days_StocK_per_DAS: Decimal;
        Safety_Stock_Plus_Minus: Decimal;
        UOM: Code[10];
        TotalStockInPCS: Decimal;
        RecItem2: Record 27;
        RecUOM: Record 5404;
        StockIntraTot: Decimal;
        StockDFTot: Decimal;
        StockMainTot: Decimal;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RecILE4: Record 32;
        RecLoc: Record 14;
        MainLoc: Code[20];
        IUM: Record 5404;
        ItemWeight: Decimal;
        ConversionUOM: Code[10];
        Time: Time;
        RecItem_New: Record 27;
        NetSalesAmtTotal: Decimal;
        RecILE5: Record 32;
        RecILE6: Record 32;
        DASValue1: Decimal;
        DASValue2: Decimal;
        NetSalesAmt1: Decimal;
        NetSalesAmt2: Decimal;
        RecILE7: Record 32;

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Inventory Planning - Branch.xlsx', 'Inventory Planning - Branch', 'Inventory Planning - Branch', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Inventory Planning - Branch.xlsx', 'Inventory Planning - Branch', 'Inventory Planning - Branch', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Inventory Planning - Branch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Location_Main, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT-HG-19/02/2019
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(TODAY) + ' Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT-HG-19/02/2019
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
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Perticular', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Categoty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Conversion UOM',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);// rdk 200919
        ExcelBuf.AddColumn('Weight', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT-HG-19/02/2019
        ExcelBuf.AddColumn('Safety Stock Planning in Days ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Net Sales-Kgs.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('DAS Branch ' + '(' + FORMAT(From_Date) + ' To ' + FORMAT(To_Date) + ')', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Safety Stocks-Kgs.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Intransit Stocks-Kgs.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IOH-Kgs.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('DF Stocks-Kgs.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total IOH-Kgs. ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total IOH-Case/PCS ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days Stocks wl last as per DAS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date Stocks wl last as per DAS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//230919
        ExcelBuf.AddColumn('+ / - Safety Stocks ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Itemname, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(UOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(ConversionUOM,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//CCIT-HG-19/02/2019 / commented // rdk 200919
        ExcelBuf.AddColumn(ItemWeight, FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);//CCIT-HG-19/02/2019
        ExcelBuf.AddColumn(NoOfDays, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(ROUND(NetSalesAmtTotal, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ABS(ROUND(DAS_Branch_Total,0.001,'=')),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(DAS_Branch_Total, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ABS(ROUND(SafetyStock_value, 0.001, '=')), FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StockIntra, FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StockMain, FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StockDF, FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalStock, FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(TotalStockInPCS, 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(ABS(Days_StocK_per_DAS), 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TODAY + ROUND(ABS(Days_StocK_per_DAS), 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date); // rdk 230919
        //ExcelBuf.AddColumn(ROUND(Safety_Stock_Plus_Minus,0.001,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(ABS(TotalStock) - ABS(SafetyStock_value), 0.001, '='), FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelDataFooter();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StockIntraTot, FALSE, '', TRUE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StockMainTot, FALSE, '', TRUE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StockDFTot, FALSE, '', TRUE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '0.000', ExcelBuf."Cell Type"::Number);
    end;

    procedure EntryCount(ItemNo: Code[20]): Integer;
    var
        ILE: Record 32;
    begin
        ILE.RESET;
        ILE.SETCURRENTKEY(ILE."Item No.", "Location Code");//
        ILE.SETRANGE(ILE."Item No.", ItemNo);
        //ILE.SETRANGE(ILE."Source No.",CustNo);
        //ILE.SETRANGE(ILE."Location Code",Loc);
        IF ILE.FINDSET THEN
            EXIT(ILE.COUNT);

    end;
}

