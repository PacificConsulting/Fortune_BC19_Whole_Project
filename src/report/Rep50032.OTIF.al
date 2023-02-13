report 50032 "OTIF"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/OTIF.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Location Code";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");

                trigger OnAfterGetRecord();
                begin
                    //SrNo := SrNo + 1;
                    MakeExcelBodyData;
                end;

                trigger OnPostDataItem();
                begin
                    //MakeExcelTotal;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(ReasonDes); //CCIT-JAGA 07/12/2018
            end;

            trigger OnPostDataItem();
            begin
                MakeExcelTotal;
            end;

            trigger OnPreDataItem();
            begin
                /*RecSIH.RESET;
                RecSIH.SETFILTER(RecSIH."Location Code", LocCode);
                RecSIH.SETFILTER(RecSIH."Sell-to Customer No.", CustNo);
                RecSIH.SETFILTER(RecSIH."Customer Posting Group", CustPostingGrpFilter);
                
                IF LocCode <> '' THEN
                  SETFILTER("Sales Invoice Header"."Location Code", '%1', LocCode);
                  */
                SrNo := 1;
                IF CustNo <> '' THEN
                    SETFILTER("Sales Invoice Header"."Sell-to Customer No.", '%1', CustNo);

                IF CustPostingGrpFilter <> '' THEN
                    SETFILTER("Sales Invoice Header"."Customer Posting Group", '%1', CustPostingGrpFilter);

                MakeExcelHeaderData;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Filter';
                group("Filter Group")
                {
                }
                field("Location Code"; LocCode)
                {
                    Caption = 'Location Code';
                    TableRelation = Location.Code;
                    Visible = false;
                }
                field("Customer No."; CustNo)
                {
                    Caption = 'Customer No.';
                    TableRelation = Customer."No.";
                }
                field("Customer Group"; CustGrpFilter)
                {
                    Visible = false;
                }
                field("Customer Posting Group"; CustPostingGrpFilter)
                {
                    TableRelation = "Customer Posting Group".Code;
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

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        ExcelBuf.DELETEALL;
    end;

    var
        ExcelBuf: Record 370;
        RecCust: Record 18;
        RecSIL: Record 113;
        CustName: Text[100];
        CustGroup: Code[10];
        CustOutletName: Text[50];
        CustPostGrp: Code[10];
        SrNo: Integer;
        RecItem: Record 27;
        ItemCode: Code[15];
        VendorName: Text[100];
        ItemDesc: Text[250];
        SalesCat: Code[20];
        BrandName: Text[100];
        recVend: Record 23;
        ItemCat: Code[20];
        StorageCat: Option;
        PrdGrp: Code[20];
        CustGrpFilter: Code[50];
        CustPostingGrpFilter: Code[50];
        CustNo: Code[25];
        LocCode: Code[10];
        RecSalesPerson: Record 13;
        SalesName: Text[75];
        RecSIH: Record 112;
        RecSalesShipHdr: Record 110;
        Deliverydate: Date;
        target: Integer;
        diffDate: Integer;
        TotalSalesPcs: Decimal;
        TotalSalesKgs: Decimal;
        TotalSalesVal: Decimal;
        RecInvLine: Record 113;
        RecSL: Record 37;
        OrderQtyPcs: Decimal;
        OrderQtyKgs: Decimal;
        OrderValue: Decimal;
        FillRateKgs: Decimal;
        FillRatePcs: Decimal;
        FillRateRs: Decimal;
        TotalOrderPcs: Decimal;
        TotalOrderKgs: Decimal;
        TotalOrderValue: Decimal;
        FRTotPcs: Decimal;
        FRTotKgs: Decimal;
        FRTotRs: Decimal;
        FillRateKgsRnd: Decimal;
        FillRatePcsRnd: Decimal;
        FillRateRsRnd: Decimal;
        FRTotPcsRnd: Decimal;
        FRTotKgsRnd: Decimal;
        FRTotRsRnd: Decimal;
        RecReasonCode: Record 231;
        ReasonDes: Text[50];
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;

    local procedure CreateExcelBook();
    begin
        ExcelBuf.CreateBookAndOpenExcel('F:\Reports\OTIF.xlsx', 'OTIF', 'OTIF', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    local procedure MakeExcelHeaderData();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('OTIF', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Serial Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Business format / Outlet Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Sales person', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vertical Sub Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Customer Price Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CRDD', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Order Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Order Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP Inv Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ERP Inv Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Targeted Delivery Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Actual Delivery Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('OTD W/h', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase vendor name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Order Qty - Pcs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Order Qty - Kgs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Order Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales in Pcs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales in Kgs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate in %  - PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate in %  - KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate in %  - IN Rs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyData();
    begin

        //RecSIL.RESET;
        //RecSIL.SETRANGE(RecSIL."Document No.", "Sales Invoice Header"."No.");
        //IF RecSIL.FINDSET THEN REPEAT

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(SrNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        RecCust.RESET;
        RecSalesPerson.RESET;
        RecCust.SETRANGE(RecCust."No.", "Sales Invoice Header"."Sell-to Customer No.");

        IF RecCust.FINDFIRST THEN BEGIN
            CustName := RecCust.Name;
            CustGroup := RecCust."Gen. Bus. Posting Group";
            CustOutletName := RecCust."Outlet Area";

            RecSalesPerson.SETRANGE(RecSalesPerson.Code, RecCust."Salesperson Code");
            IF RecSalesPerson.FINDFIRST THEN
                SalesName := RecSalesPerson.Name;

            ExcelBuf.AddColumn(CustName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(CustGroup, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(CustOutletName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(SalesName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(RecCust."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(RecCust."Vertical Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(RecCust."Vertical Sub Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('IN - Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        END;

        ExcelBuf.AddColumn("Sales Invoice Line"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        RecSalesShipHdr.RESET;
        RecSalesShipHdr.SETRANGE(RecSalesShipHdr."Order No.", RecSIH."Order No.");
        IF RecSalesShipHdr.FINDFIRST THEN BEGIN
            Deliverydate := RecSalesShipHdr."Requested Delivery Date";
        END;

        ExcelBuf.AddColumn(Deliverydate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF "Sales Invoice Header"."External Document No." <> '' THEN
            ExcelBuf.AddColumn("Sales Invoice Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn(' ', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Sales Invoice Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        IF Deliverydate <> 0D THEN
            target := Deliverydate - "Sales Invoice Header"."Document Date"
        ELSE
            target := 0;

        ExcelBuf.AddColumn(target, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(("Sales Invoice Header"."Posting Date" - "Sales Invoice Header"."Document Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn((target - ("Sales Invoice Header"."Posting Date" - "Sales Invoice Header"."Document Date")), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        RecItem.RESET;
        recVend.RESET;
        RecItem.SETRANGE(RecItem."No.", "Sales Invoice Line"."No.");
        IF RecItem.FINDFIRST THEN BEGIN
            IF recVend.GET(RecItem."Vendor No.") THEN BEGIN
                VendorName := recVend.Name;
            END;
            ItemCode := RecItem."No.";
            ItemDesc := RecItem.Description;
            SalesCat := RecItem."Sales Category";
            BrandName := RecItem."Brand Name";
            ItemCat := RecItem."Item Category Code";
            PrdGrp := '';// RecItem."Product Group Code"; //PCPL/MIG/NSW
            StorageCat := RecItem."Storage Categories";

        END;

        ExcelBuf.AddColumn(VendorName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BrandName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemCat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(PrdGrp, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StorageCat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //MESSAGE('%1', StorageCat);
        //MESSAGE('%1', RecSIL."Unit of Measure");

        //IF RecSIL."Unit of Measure" <> ' ' THEN
        ExcelBuf.AddColumn("Sales Invoice Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ELSE
        // ExcelBuf.AddColumn('uumm ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        RecSL.RESET;
        RecSL.SETRANGE(RecSL."No.", "Sales Invoice Line"."No.");
        IF RecSL.FINDSET THEN
            REPEAT
                OrderQtyPcs := OrderQtyPcs + ROUND(RecSL."Conversion Qty", 1, '=');
            UNTIL RecSL.NEXT = 0;

        OrderQtyKgs := ABS(OrderQtyPcs) * 0.2;
        OrderValue := ABS(OrderQtyKgs) * 410;

        TotalOrderPcs := TotalOrderPcs + OrderQtyPcs;
        TotalOrderKgs := TotalOrderKgs + OrderQtyKgs;
        TotalOrderValue := TotalOrderValue + OrderValue;

        ExcelBuf.AddColumn(OrderQtyPcs, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(OrderQtyKgs, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(OrderValue, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        TotalSalesPcs := TotalSalesPcs + ROUND("Sales Invoice Line"."Conversion Qty", 1, '=');
        TotalSalesKgs := TotalSalesKgs + "Sales Invoice Line".Quantity;
        TotalSalesVal := TotalSalesVal + ("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price");

        ExcelBuf.AddColumn(ROUND("Sales Invoice Line"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        FillRatePcs := (ROUND("Sales Invoice Line"."Conversion Qty", 1, '=')) / OrderQtyPcs;
        FillRatePcsRnd := ROUND(FillRatePcs);

        FRTotPcs := FRTotPcs + FillRatePcs;
        FRTotPcsRnd := ROUND(FRTotPcs);

        FillRateKgs := ("Sales Invoice Line".Quantity) / OrderQtyKgs;
        FillRateKgsRnd := ROUND(FillRateKgs);

        FRTotKgs := FRTotKgs + FillRateKgs;
        FRTotKgsRnd := ROUND(FRTotKgs);

        FillRateRs := ("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price") / OrderValue;
        FillRateRsRnd := ROUND(FillRateRs);

        FRTotRs := FRTotRs + FillRateRs;
        FRTotRsRnd := ROUND(FRTotRs);

        ExcelBuf.AddColumn(FillRatePcsRnd, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FillRateKgsRnd, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FillRateRsRnd, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn("Sales Invoice Header"."Reason Code", FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);  CCIT-JAGA 07/12/2018
        //CCIT-JAGA 07/12/2018
        IF RecReasonCode.GET("Sales Invoice Header"."Reason Code") THEN
            ReasonDes := RecReasonCode.Description;

        ExcelBuf.AddColumn(ReasonDes, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        //CCIT-JAGA 07/12/2018

        SrNo := SrNo + 1;
        // UNTIL RecSIL.NEXT = 0;


        //MakeExcelTotal;
    end;

    local procedure MakeExcelTotal();
    begin
        //CLEAR(TotalSalesPcs);
        //CLEAR(TotalSalesKgs);
        //CLEAR(TotalSalesVal);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TotalOrderPcs, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalOrderKgs, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalOrderValue, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(TotalSalesPcs, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalSalesKgs, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalSalesVal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FRTotPcsRnd, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FRTotKgsRnd, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FRTotRsRnd, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;
}

