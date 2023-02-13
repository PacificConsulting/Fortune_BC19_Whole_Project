report 50033 "MA-Customer(Profitability-DP)"
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

                    CLEAR(Supplier);
                    CLEAR(brand);
                    CLEAR(LandedCost);
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
                        OutletName := RecCust."Delivery Outlet";
                    END;

                    CLEAR(SalesPersonName);
                    IF RecSalesPersonCode.GET("Sales Invoice Header"."Salesperson Code") THEN
                        SalesPersonName := RecSalesPersonCode.Name;

                    TotalValue += "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                    TotalQty += "Sales Invoice Line".Quantity;

                    CLEAR(AvgCostKG);
                    IF "Sales Invoice Line".Quantity <> 0 THEN
                        AvgCostKG := (("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price") / "Sales Invoice Line".Quantity); //tk *100 Change

                    CLEAR(MarkupValue);
                    TextPer := '%';
                    IF LandedCost <> 0 THEN
                        MarkupValue := ((AvgCostKG - LandedCost) / LandedCost) * 100;

                    /*CLEAR(Qty);
                    IF "Sales Invoice Line".Quantity <> 0 THEN
                      Qty := "Sales Invoice Line".Quantity;*/
                    //CCIT-PRI-100119-Commented Code
                    //CCIT-JAGA
                    /*CLEAR(UnitePrice);
                    RecSaleInvoiceHead.RESET;
                    IF RecSaleInvoiceHead.GET("Sales Invoice Line"."Document No.")THEN BEGIN
                      IF (RecSaleInvoiceHead."Customer Posting Group"='HORECA') OR
                         (RecSaleInvoiceHead."Customer Posting Group"='TRADER') OR
                         (RecSaleInvoiceHead."Customer Posting Group"='DISTRIBUT') THEN BEGIN
                        RecSalesPrice.RESET;
                        RecSalesPrice.SETRANGE(RecSalesPrice."Item No.","Sales Invoice Line"."No.");
                        IF RecSalesPrice.FINDSET THEN REPEAT
                          IF RecSalesPrice."Sales Type"=RecSalesPrice."Sales Type"::"Customer Price Group" THEN BEGIN
                            RecSalesPrice.SETFILTER("Sales Code",'%1','HPL 18-19');
                            IF RecSalesPrice.FINDFIRST THEN BEGIN
                              UnitePrice := RecSalesPrice."Unit Price Per KG";
                            END;
                          END;
                        UNTIL RecSalesPrice.NEXT=0;
                      END ELSE IF RecSaleInvoiceHead."Customer Posting Group"='RETAIL' THEN BEGIN
                        RecSalesPrice.RESET;
                        RecSalesPrice.SETRANGE(RecSalesPrice."Item No.","Sales Invoice Line"."No.");
                        IF RecSalesPrice.FINDSET THEN REPEAT
                          IF RecSalesPrice."Sales Type"=RecSalesPrice."Sales Type"::"Customer Price Group" THEN BEGIN
                            RecSalesPrice.SETFILTER("Sales Code",'%1','RPL 18-19');
                            IF RecSalesPrice.FINDFIRST THEN BEGIN
                              UnitePrice := RecSalesPrice."Unit Price Per KG";
                            END;
                          END;
                        UNTIL RecSalesPrice.NEXT=0;
                      END;
                    END;*/
                    //CCIT-JAGA
                    //CCIT-PRI-100119-Commented Code

                    //CCIT-PRI-100119
                    CLEAR(UnitePrice);
                    RecSaleInvoiceHead.RESET;
                    IF RecSaleInvoiceHead.GET("Sales Invoice Line"."Document No.") THEN BEGIN

                        IF (RecSaleInvoiceHead."Customer Posting Group" = 'HORECA') OR
                           (RecSaleInvoiceHead."Customer Posting Group" = 'TRADER') OR
                           (RecSaleInvoiceHead."Customer Posting Group" = 'OTHERS') OR
                           (RecSaleInvoiceHead."Customer Posting Group" = 'DISTRIBUT') THEN BEGIN

                            RecSalesPrice.RESET;
                            RecSalesPrice.SETRANGE(RecSalesPrice."Item No.", "Sales Invoice Line"."No.");
                            RecSalesPrice.SETRANGE(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                            RecSalesPrice.SETFILTER(RecSalesPrice."Sales Code", '%1', 'HPL 19-20');
                            IF RecSalesPrice.FINDSET THEN
                                REPEAT
                                    UnitePrice := 0;//RecSalesPrice."Unit Price Per KG";
                                UNTIL RecSalesPrice.NEXT = 0;

                        END ELSE
                            IF RecSaleInvoiceHead."Customer Posting Group" = 'RETAIL' THEN BEGIN

                                RecSalesPrice.RESET;
                                RecSalesPrice.SETRANGE(RecSalesPrice."Item No.", "Sales Invoice Line"."No.");
                                RecSalesPrice.SETRANGE(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                                RecSalesPrice.SETFILTER(RecSalesPrice."Sales Code", '%1', 'RPL 19-20');
                                IF RecSalesPrice.FINDSET THEN
                                    REPEAT
                                        UnitePrice := 0;//RecSalesPrice."Unit Price Per KG";
                                    UNTIL RecSalesPrice.NEXT = 0;

                            END;

                    END;
                    //CCIT-PRI-100119

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
                        "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", 99990101D, AsOnDate);

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
                        OutletName := RecCust."Delivery Outlet";
                    END;

                    CLEAR(SalesPersonName);
                    IF RecSalesPersonCode.GET("Sales Cr.Memo Header"."Salesperson Code") THEN
                        SalesPersonName := RecSalesPersonCode.Name;


                    TotalValueCr += "Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price";
                    TotalQtyCr += "Sales Cr.Memo Line".Quantity;

                    CLEAR(AvgCostKG);
                    IF "Sales Cr.Memo Line".Quantity <> 0 THEN
                        AvgCostKG := (("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price") / "Sales Cr.Memo Line".Quantity); //tk chane *100

                    CLEAR(MarkupValue);
                    IF LandedCost <> 0 THEN
                        MarkupValue := ((AvgCostKG - LandedCost) / LandedCost) * 100;


                    //CCIT-PRI-100119
                    CLEAR(UnitePrice);
                    RecSalesCrHdr.RESET;
                    IF RecSalesCrHdr.GET("Sales Cr.Memo Line"."Document No.") THEN BEGIN

                        IF (RecSalesCrHdr."Customer Posting Group" = 'HORECA') OR
                           (RecSalesCrHdr."Customer Posting Group" = 'TRADER') OR
                           (RecSalesCrHdr."Customer Posting Group" = 'Others') OR
                           (RecSalesCrHdr."Customer Posting Group" = 'DISTRIBUT') THEN BEGIN

                            RecSalesPrice.RESET;
                            RecSalesPrice.SETRANGE(RecSalesPrice."Item No.", "Sales Cr.Memo Line"."No.");
                            RecSalesPrice.SETRANGE(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                            RecSalesPrice.SETFILTER(RecSalesPrice."Sales Code", '%1', 'HPL 19-20');
                            IF RecSalesPrice.FINDSET THEN
                                REPEAT
                                    UnitePrice := 0;//RecSalesPrice."Unit Price Per KG";
                                UNTIL RecSalesPrice.NEXT = 0;

                        END ELSE
                            IF RecSalesCrHdr."Customer Posting Group" = 'RETAIL' THEN BEGIN

                                RecSalesPrice.RESET;
                                RecSalesPrice.SETRANGE(RecSalesPrice."Item No.", "Sales Invoice Line"."No.");
                                RecSalesPrice.SETRANGE(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                                RecSalesPrice.SETFILTER(RecSalesPrice."Sales Code", '%1', 'RPL 19-20');
                                IF RecSalesPrice.FINDSET THEN
                                    REPEAT
                                        UnitePrice := 0;// RecSalesPrice."Unit Price Per KG"; 
                                    UNTIL RecSalesPrice.NEXT = 0;

                            END;

                    END;
                    //CCIT-PRI-100119


                    MakeExcelDataBody1;
                end;
            }

            trigger OnPostDataItem();
            begin
                //MakeExcelDataFooter1;
            end;

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

                //MakeExcelDataHeader1;
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
        TotAvgCostKG := 0;
        TotalValueCr := 0;
        TotalQtyCr := 0;
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
        TotAvgCostKG: Decimal;
        MarkupValue: Decimal;
        AsOnDate: Date;
        RecSalesPrice: Record 7002;
        UnitePrice: Decimal;
        RecSaleInvoiceHead: Record 112;
        RecSalesCrHdr: Record 114;
        TotalValueCr: Decimal;
        TotalQtyCr: Decimal;
        j: Integer;
        Qty: Decimal;
        OutletName: Text;
        TextPer: Text;

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin
        // ExcelBuf.CreateBookAndOpenExcel('E:\Reports\MA-Customer(Profitability-DP).xlsx', 'MA-Customer(Profitability-DP)', 'MA-Customer(Profitability-DP)', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\MA-Customer(Profitability-DP).xlsx', 'MA-Customer(Profitability-DP)', 'MA-Customer(Profitability-DP)', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('MA-Customer(Profitability-DP)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Billing Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Delivery Outlet', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Price Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Gen. Prod. Posting Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sub Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('KAM ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Products ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Sales Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Price Group ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Posting Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Landed Cost per KG ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price List Price per KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total QTY IN KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total VALUE ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Total ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Avg Price per KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('% Mark Up over LC', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mark Up / Down to PLP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Invoice Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //CCIT-Harshal
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(OutletName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //CCIT-Harshal
        ExcelBuf.AddColumn(Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //CCIT-Harshal
        ExcelBuf.AddColumn("Sales Invoice Line"."Conversion UOM", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Line"."Sales Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Invoice Line"."Customer Price Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ROUND(LandedCost, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(UnitePrice, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //CCIT-JAGA
        //ExcelBuf.AddColumn(Qty,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Sales Invoice Line".Quantity, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price"), 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(AvgCostKG, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(ROUND(MarkupValue, 0.01)) + '%', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF UnitePrice <> 0 THEN
            ExcelBuf.AddColumn(FORMAT(ROUND(((ROUND(AvgCostKG, 0.01) - ROUND(UnitePrice, 0.01)) / ((ROUND(UnitePrice, 0.01)) / 100)), 0.01)) + '%', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelDataFooter();
    begin
        ExcelBuf.NewRow;
        j := 1;
        FOR j := 1 TO 25 DO
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalQty, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalValue, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
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
                SIL.SETRANGE(SIL."Posting Date", 99990101D, AsOnDate);  //010199D
        //SIL.SETFILTER(RecILE33."Entry Type",'%1|%2|%3|%4|%5',RecILE33."Entry Type"::Purchase,RecILE33."Entry Type"::Transfer,RecILE33."Entry Type"::"Positive Adjmt.",RecILE33."Entry Type"::"Negative Adjmt.",RecILE33."Entry Type"::Sale);
        SIL.SETRANGE(SIL."Sell-to Customer No.", CustNo);
        IF SIL.FINDSET THEN
            EXIT(SIL.COUNT);
    end;

    procedure MakeExcelDataHeader1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Credit Memos', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('MA-Customer(Profitability-DP)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Billing Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Price Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Gen. Prod. Posting Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sub Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('KAM ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Products ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Sales Category ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Price Group ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Posting Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Landed Cost ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Price List Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total QTY IN KGS ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total VALUE ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Total ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Avg Price per KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('% Mark Up over LC', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mark Up / Down to PLP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //CCIT-Harshal
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(OutletName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //CCIT-Harshal
        //ExcelBuf.AddColumn("Sales Invoice Header"."Customer Price Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Customer Posting Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SubCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesPersonName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //CCIT-Harshal
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Conversion UOM", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Sales Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(Supplier,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(brand, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Cr.Memo Line"."Customer Price Group",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ROUND(LandedCost, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(UnitePrice, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //CCIT-JAGA
        ExcelBuf.AddColumn(-ROUND(("Sales Cr.Memo Line".Quantity), 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn((ROUND(-(("Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price")), 0.01)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn((ROUND(AvgCostKG, 0.01)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(ROUND(MarkupValue, 0.01)) + '%', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF UnitePrice <> 0 THEN
            ExcelBuf.AddColumn(FORMAT(ROUND(((ROUND(AvgCostKG, 0.01) - ROUND(UnitePrice, 0.01)) / ((ROUND(UnitePrice, 0.01)) / 100)), 0.01)) + '%', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelDataFooter1();
    begin
        ExcelBuf.NewRow;
        j := 1;
        FOR j := 1 TO 25 DO
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
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
        ExcelBuf.AddColumn(TotalQtyCr, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalValueCr, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;
}

