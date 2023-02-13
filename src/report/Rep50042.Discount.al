report 50042 "Discount"
{
    // version CCIT-Fortune-SG

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Source No.", "Item No.", "Posting Date")
                                ORDER(Ascending)
                                WHERE("Entry Type" = FILTER(Sale),
                                      "Document Type" = FILTER('Sales Shipment'));
            RequestFilterFields = "Item No.", "Source No.";

            trigger OnAfterGetRecord();
            begin
                CLEAR(Supplier);
                CLEAR(brand);
                CLEAR(SalesCategory);
                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    IF RecVend.GET(RecItem."Vendor No.") THEN
                        Supplier := RecVend.Name;
                    brand := RecItem."Brand Name";
                    SalesCategory := RecItem."Sales Category";
                END;

                CLEAR(ItemDesc);
                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    Itemcode := RecItem."No.";
                    ItemDesc := RecItem.Description;
                END;

                //IF RecSalesPersonCode.GET("Item Ledger Entry".) THEN
                //SalesPersonName := RecSalesPersonCode.Name;

                IF RecCust.GET("Item Ledger Entry"."Source No.") THEN BEGIN
                    OutletArea := RecCust."Delivery Outlet";
                    Category := RecCust."Vertical Category";
                    SalesReporting := RecCust."Sales Reporting Field";
                    SubCategory := RecCust."Vertical Sub Category";
                    vertical := RecCust."Customer Posting Group";
                    PartyName := RecCust.Name;
                    SalesPersonCode := RecCust."Salesperson Code";
                END;

                IF RecSalesPersonCode.GET(SalesPersonCode) THEN
                    SalesPersonName := RecSalesPersonCode.Name;

                CLEAR(PriceListPrice);
                RecSalesPrice.RESET;
                RecSalesPrice.SETRANGE(RecSalesPrice."Item No.", "Item Ledger Entry"."Item No.");
                IF RecSalesPrice.FINDSET THEN
                    REPEAT
                        IF vertical = 'OTHERS'/*And 'OTHERS' AND 'TRADER' AND 'DISTRIBUT')*/ THEN BEGIN
                            IF RecSalesPrice."Sales Code" = 'HPL 19-20' THEN BEGIN
                                PriceListPrice := 0;// RecSalesPrice."Unit Price Per KG";
                            END
                        END
                        ELSE
                            IF vertical = 'HORECA' THEN BEGIN
                                IF RecSalesPrice."Sales Code" = 'HPL 19-20' THEN BEGIN
                                    PriceListPrice := 0;// RecSalesPrice."Unit Price Per KG";
                                END
                            END
                            ELSE
                                IF vertical = 'TRADER' THEN BEGIN
                                    IF RecSalesPrice."Sales Code" = 'HPL 19-20' THEN BEGIN
                                        PriceListPrice := 0;//RecSalesPrice."Unit Price Per KG";
                                    END
                                END
                                ELSE
                                    IF vertical = 'DISTRIBUT' THEN BEGIN
                                        IF RecSalesPrice."Sales Code" = 'HPL 19-20' THEN BEGIN
                                            PriceListPrice := 0;// RecSalesPrice."Unit Price Per KG";
                                        END
                                    END
                                    ELSE
                                        IF vertical = 'RETAIL' THEN BEGIN
                                            IF RecSalesPrice."Sales Code" = 'RPL 19-20' THEN BEGIN
                                                PriceListPrice := 0;//RecSalesPrice."Unit Price Per KG";
                                            END;
                                        END;



                    UNTIL RecSalesPrice.NEXT = 0;


                CLEAR(salesPriceGroup);
                RecSalesShipLine.RESET;
                RecSalesShipLine.SETRANGE(RecSalesShipLine."Document No.", "Item Ledger Entry"."Document No.");
                IF RecSalesShipLine.FINDFIRST THEN
                    salesPriceGroup := RecSalesShipLine."Customer Price Group";

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN BEGIN
                    TotalKGs := 0;
                    Amount := 0;
                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Document Type", "Item Ledger Entry"."Document Type"::"Sales Shipment");
                    RecILE.SETRANGE(RecILE."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE.SETRANGE(RecILE."Source No.", "Item Ledger Entry"."Source No.");
                    RecILE.SETRANGE(RecILE."Location Code", "Item Ledger Entry"."Location Code");

                    //IF (From_Date <> 0D) AND (To_Date <> 0D) AND (AsOnDate = 0D)THEN//tk
                    /*IF (From_Date <> 0D) AND (To_Date <> 0D) THEN//tk
                      RecILE.SETRANGE(RecILE."Posting Date",From_Date,To_Date);
                    ///ELSE IF (AsOnDate <> 0D) AND (From_Date <> 0D) AND (To_Date <> 0D) THEN
                     // RecILE.SETRANGE(RecILE."Posting Date",010199D,AsOnDate);*/
                    IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                        RecILE.SETRANGE(RecILE."Posting Date", From_Date, To_Date)
                    ELSE
                        IF (AsOnDate <> 0D) THEN
                            RecILE.SETRANGE(RecILE."Posting Date", 99990101D, AsOnDate);  //010199D
                    IF RecILE.FINDSET THEN
                        REPEAT
                            TotalKGs += RecILE.Quantity;
                            IF RecValueRntry."Item Charge No." = '' THEN BEGIN
                                RecValueRntry.RESET;
                                RecValueRntry.SETRANGE(RecValueRntry."Posting Date", From_Date, To_Date);
                                //RecValueRntry.SETRANGE(RecValueRntry."Item Ledger Entry Type",RecILE."Entry Type");
                                RecValueRntry.SETRANGE(RecValueRntry."Item Ledger Entry No.", RecILE."Entry No.");
                                RecValueRntry.SETRANGE(RecValueRntry."Source No.", RecILE."Source No.");
                                RecValueRntry.SETRANGE(RecValueRntry."Item No.", RecILE."Item No.");
                                //RecValueRntry.SETRANGE(RecValueRntry."Item Charge No.",RecValueRntry."Item Charge No."='');
                                IF RecValueRntry.FINDFIRST THEN
                                    REPEAT
                                        Amount += RecValueRntry."Sales Amount (Actual)";
                                    UNTIL RecValueRntry.NEXT = 0;

                            END;
                        //RecILE."Cost Amount (Actual)"
                        UNTIL RecILE.NEXT = 0;
                    CLEAR(AgreedRate);
                    IF TotalKGs <> 0 THEN
                        AgreedRate := -Amount / TotalKGs
                    ELSE
                        AgreedRate := 0;
                    CLEAR(DiscountKg);
                    DiscountKg := PriceListPrice - AgreedRate;
                    IF AgreedRate <> 0 THEN
                        "Discount%" := (DiscountKg / AgreedRate) * 100
                    ELSE
                        "Discount%" := 0;
                    TotalSaleValue := (AgreedRate * TotalKGs);
                    TotalDisValue := -(DiscountKg * TotalKGs);
                    IF TotalSaleValue <> 0 THEN
                        MonthWiseSale := -(TotalDisValue / TotalSaleValue) * 100
                    ELSE
                        MonthWiseSale := 0;
                    /*
                   IF (CurrItem = 'CRONUS BLANK') AND (CurrCust = 'FORTUNE BLANK') AND (CurrLoc = 'FORTUNE1 BLANK') THEN BEGIN
                      I := 0;
                      CurrItem := "Item Ledger Entry"."Item No.";
                      CurrCust := "Item Ledger Entry"."Source No.";
                      CurrLoc := "Item Ledger Entry"."Location Code";
                      ItemCounter := EntryCount(CurrItem,CurrCust,CurrLoc);
                   END;
                   I += 1;

                   IF I = ItemCounter THEN BEGIN
                     MakeExcelDataBody;
                     CurrCust := 'FORTUNE BLANK';
                     CurrItem := 'CRONUS BLANK';
                     CurrLoc := 'FORTUNE1 BLANK';
                     ItemCounter :=0;
                   END;*/
                    /*IF CustShort <> "Item Ledger Entry"."Source No." THEN BEGIN
                    IF ItemCodeshort <> "Item Ledger Entry"."Item No." THEN
                     MakeExcelDataBody;

                    END;
                    CustShort :="Item Ledger Entry"."Source No.";
                    ItemCodeshort := "Item Ledger Entry"."Item No.";*/
                    IF TxtCustomerItemShort <> "Item Ledger Entry"."Source No." + "Item Ledger Entry"."Item No." THEN BEGIN
                        MakeExcelDataBody;
                        TxtCustomerItemShort := "Item Ledger Entry"."Source No." + "Item Ledger Entry"."Item No.";
                    END;
                END;

            end;

            trigger OnPostDataItem();
            begin


                MakeExcelDataFooter;
            end;

            trigger OnPreDataItem();
            begin
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 99990101D, AsOnDate); //010199D


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
        CurrItem := 'CRONUS BLANK';
        CurrCust := 'FORTUNE BLANK';
        CurrLoc := 'FORTUNE1 BLANK';
        //CurrDocNo := 'FORTUNE2 BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelbook;
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
        RecSalesPersonCode: Record 13;
        SalesPersonName: Text[50];
        TotalValue: Decimal;
        TotalQty: Decimal;
        LandedCost: Decimal;
        OutletArea: Text[100];
        vertical: Code[20];
        SalesCategory: Code[20];
        PriceListPrice: Decimal;
        RecSalesPrice: Record 7002;
        AgreedRate: Decimal;
        RecSalesPrice1: Record 7002;
        TotalSaleValue: Decimal;
        RecILE: Record 32;
        TotalDisValue: Decimal;
        TotalKGs: Decimal;
        MonthWiseSale: Decimal;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode1: Code[1024];
        LocCodeText: Text[1024];
        ItemDesc: Text[200];
        PartyName: Text[200];
        RecSalesShipLine: Record 111;
        salesPriceGroup: Code[30];
        SalesPersonCode: Code[20];
        Itemcode: Text[30];
        Amount: Decimal;
        RecValueRntry: Record 5802;
        "Discount%": Decimal;
        DiscountKg: Decimal;
        ItemCodeshort: Text;
        CustShort: Text;
        TxtCustomerItemShort: Text;
        SalesReporting: Text;

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Discount.xlsx', 'Discount', 'Discount', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Discount.xlsx', 'Discount', 'Discount', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Discount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Branch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn('Party Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn('Party Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn('Sales Reporting', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3 New
        ExcelBuf.AddColumn('Sales Person Name ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//12
        ExcelBuf.AddColumn('Delivery Outlet', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn('Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6

        ExcelBuf.AddColumn('Sub Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//7
        //ExcelBuf.AddColumn('Key Accounts Manager',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//8
        ExcelBuf.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//11
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//8 new
        ExcelBuf.AddColumn('Item Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//9
        ExcelBuf.AddColumn('Unit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn('Sales Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//14
        ExcelBuf.AddColumn('Brand ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10

        //ExcelBuf.AddColumn('Sales Price Group ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//13
        //ExcelBuf.AddColumn('DP/DF',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn('Price List Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
        //ExcelBuf.AddColumn('Price Level',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//17
        ExcelBuf.AddColumn('Agreed Rate/KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18new
        ExcelBuf.AddColumn('Discount/KG ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18new
        ExcelBuf.AddColumn('Discount in %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18

        //ExcelBuf.AddColumn('Agreed Rate',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn('Total KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//23
        ExcelBuf.AddColumn('Total Discount Value ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//21
        ExcelBuf.AddColumn('Total Sales Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//22
        ExcelBuf.AddColumn('Discount as a % Sales', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//24
        //ExcelBuf.NewRow;//tk
        //ExcelBuf.AddColumn('Total',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn("Item Ledger Entry"."Source No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn(PartyName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn(SalesReporting, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//12
        ExcelBuf.AddColumn(OutletArea, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn(vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn(Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6

        ExcelBuf.AddColumn(SubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//7
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//8
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//11
        ExcelBuf.AddColumn(Itemcode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//8new
        ExcelBuf.AddColumn(ItemDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//9
        ExcelBuf.AddColumn("Item Ledger Entry"."Conversion UOM", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//14
        ExcelBuf.AddColumn(brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10


        //ExcelBuf.AddColumn(salesPriceGroup,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//13
        //ExcelBuf.AddColumn(SalesCategory,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//14
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn(ROUND(ABS(PriceListPrice), 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//16
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//17
        ExcelBuf.AddColumn(ROUND(AgreedRate, 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//19
        ExcelBuf.AddColumn(ROUND(DiscountKg, 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//19
        //ExcelBuf.AddColumn(ROUND(DiscountKg,0.001))FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//18
        ExcelBuf.AddColumn(ROUND("Discount%", 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18

        //ExcelBuf.AddColumn(ROUND(AgreedRate,0.001),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//19
        //ExcelBuf.AddColumn("Item Ledger Entry"."Conversion UOM",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn(ABS(TotalKGs), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
        ExcelBuf.AddColumn(ROUND(TotalDisValue, 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//21
        ExcelBuf.AddColumn(ROUND(ABS(TotalSaleValue), 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//22
        ExcelBuf.AddColumn(ROUND(MonthWiseSale, 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//24
        //ExcelBuf.AddColumn(ROUND(Amount,0.001),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//24
    end;

    procedure MakeExcelDataFooter();
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        */

    end;

    procedure EntryCount(ItemNo: Code[20]; CustNo: Code[10]; Loc: Code[20]): Integer;
    var
        ILE: Record 32;
    begin
        ILE.RESET;
        ILE.SETRANGE(ILE."Item No.", ItemNo);
        ILE.SETRANGE(ILE."Source No.", CustNo);
        ILE.SETRANGE(ILE."Location Code", Loc);
        IF ILE.FINDSET THEN
            EXIT(ILE.COUNT);

    end;
}

