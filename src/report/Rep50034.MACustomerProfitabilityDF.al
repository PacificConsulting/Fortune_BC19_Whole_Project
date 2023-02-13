report 50034 "MA-Customer(Profitability-DF)"
{
    // version CCIT-Fortune-SG

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Location Code", "Customer Posting Group";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Type = FILTER(Item),
                                          Quantity = FILTER(<> 0));
                RequestFilterFields = "No.", "Gen. Prod. Posting Group";

                trigger OnAfterGetRecord();
                begin
                    Sr_No += 1;

                    IF RecItem.GET("Sales Invoice Line"."No.") THEN BEGIN
                        IF RecVend.GET(RecItem."Vendor No.") THEN
                            Supplier := RecVend.Name;
                        brand := RecItem."Brand Name";
                        LandedCost := RecItem."Unit Cost";
                    END;

                    CLEAR(Category);
                    CLEAR(SubCategory);
                    IF RecCust.GET("Sales Invoice Line"."Sell-to Customer No.") THEN BEGIN
                        Category := RecCust."Vertical Category";
                        SubCategory := RecCust."Vertical Sub Category";
                    END;

                    CLEAR(SalesPersonName);
                    IF RecSalesPersonCode.GET("Sales Invoice Header"."Salesperson Code") THEN
                        SalesPersonName := RecSalesPersonCode.Name;

                    TotalValue += "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                    TotalQty += "Sales Invoice Line".Quantity;

                    CLEAR(AvgCostKG);
                    IF "Sales Invoice Line".Quantity <> 0 THEN
                        AvgCostKG := (("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price") / "Sales Invoice Line".Quantity);

                    CLEAR(MarkupValue);
                    IF LandedCost <> 0 THEN
                        MarkupValue := ((AvgCostKG - LandedCost) / LandedCost) * 100;

                    MakeExcelDataBody;
                end;
            }

            trigger OnPostDataItem();
            begin

                //MakeExcelDataFooter;
            end;

            trigger OnPreDataItem();
            begin

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", 99990101D, AsOnDate);//010199D

                MakeExcelDataHeader;
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Type = CONST(Item),
                                          Quantity = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    Sr_No += 1;

                    CLEAR(Supplier);
                    CLEAR(brand);
                    CLEAR(LandedCost);
                    IF RecItem.GET("Sales Cr.Memo Line"."No.") THEN BEGIN
                        IF RecVend.GET(RecItem."Vendor No.") THEN
                            Supplier := RecVend.Name;
                        brand := RecItem."Brand Name";
                        LandedCost := RecItem."Unit Cost";
                    END;

                    CLEAR(Category);
                    CLEAR(SubCategory);
                    IF RecCust.GET("Sales Cr.Memo Line"."Sell-to Customer No.") THEN BEGIN
                        Category := RecCust."Vertical Category";
                        SubCategory := RecCust."Vertical Sub Category";
                    END;

                    CLEAR(SalesPersonName);
                    IF RecSalesPersonCode.GET("Sales Cr.Memo Header"."Salesperson Code") THEN
                        SalesPersonName := RecSalesPersonCode.Name;


                    TotalValueCr += "Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price";
                    TotalQtyCr += "Sales Cr.Memo Line".Quantity;

                    CLEAR(AvgCostKG);
                    IF "Sales Cr.Memo Line".Quantity <> 0 THEN
                        AvgCostKG := (("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price") / "Sales Cr.Memo Line".Quantity);

                    CLEAR(MarkupValue);
                    IF LandedCost <> 0 THEN
                        MarkupValue := ((AvgCostKG - LandedCost) / LandedCost) * 100;

                    MakeExcelDataBody1;
                end;
            }

            trigger OnPreDataItem();
            var
                RecUserBranch: Record 91;
                LocCode: Code[1024];
                LocCodeText: Text[1024];
            begin
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", 99990101D, AsOnDate);
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
                group("As On date Filter")
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
        //CurrLoc := 'FORTUNE1 BLANK';
        //CurrDocNo := 'FORTUNE2 BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelbook;
    end;

    trigger OnPreReport();
    begin
        Sr_No := 0;
        TotalValue := 0;
        TotalQty := 0;
        TotalQtyCr := 0;
        TotalValueCr := 0;
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
        AvgCostKG: Decimal;
        MarkupValue: Decimal;
        AsOnDate: Date;
        TotalValueCr: Decimal;
        TotalQtyCr: Decimal;

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\MA-Customer(Profitability-DF).xlsx', 'MA-Customer(Profitability-DF)', 'MA-Customer(Profitability-DF)', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\MA-Customer(Profitability-DF).xlsx', 'MA-Customer(Profitability-DF)', 'MA-Customer(Profitability-DF)', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('MA-Customer(Profitability-DF)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Branch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Billing Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Price Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Gen. Prod. Posting Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sub Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('KAM ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Products ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Sales Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Posting Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Landed Cost ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total QTY ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total VALUE ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Total ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Avg Cost/KG ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('% Mark Up ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Invoice Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Outlet Area", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Customer Price Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Customer Posting Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Line"."Sales Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LandedCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(AvgCostKG, 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(MarkupValue, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelDataFooter();
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

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
        ExcelBuf.AddColumn(TotalQty, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalValue, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure EntryCount(CustNo: Code[20]; ItemNo: Code[20]): Integer;
    var
        SIL: Record 113;
    begin
        SIL.RESET;
        SIL.SETRANGE(SIL."Document No.", "Sales Invoice Line"."Document No.");
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            SIL.SETRANGE(SIL."Posting Date", From_Date, To_Date)
        ELSE
            IF (AsOnDate <> 0D) THEN
                SIL.SETRANGE(SIL."Posting Date", 99990101D, AsOnDate);//010199D
        //SIL.SETFILTER(RecILE33."Entry Type",'%1|%2|%3|%4|%5',RecILE33."Entry Type"::Purchase,RecILE33."Entry Type"::Transfer,RecILE33."Entry Type"::"Positive Adjmt.",RecILE33."Entry Type"::"Negative Adjmt.",RecILE33."Entry Type"::Sale);
        SIL.SETRANGE(SIL."Sell-to Customer No.", CustNo);
        IF SIL.FINDSET THEN
            EXIT(SIL.COUNT);
    end;

    procedure MakeExcelDataBody1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Outlet Area", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Customer Price Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Customer Posting Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Sales Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LandedCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(-("Sales Cr.Memo Line".Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-(("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price")), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(AvgCostKG, 0.001), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(MarkupValue, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;
}

