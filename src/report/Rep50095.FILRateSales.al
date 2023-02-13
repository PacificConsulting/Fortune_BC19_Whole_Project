report 50095 "FIL Rate Sales"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    //RDLCLayout = 'src/reportlayout/FIL Rate Sales.rdl';
    ProcessingOnly = true;
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
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          Type = FILTER(Item),
                                          "Customer Price Group" = FILTER(<> 'SAM 19-20'));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord();
                begin
                    ERP_SO_No := '';
                    SO_Order_Qty_In_KG := 0;
                    SO_Order_Value := 0;
                    RecSalesHeaderArchive.RESET;
                    RecSalesHeaderArchive.SETRANGE(RecSalesHeaderArchive."No.", "Sales Invoice Header"."Order No.");
                    IF RecSalesHeaderArchive.FINDFIRST THEN BEGIN
                        SO_Time := RecSalesHeaderArchive."SO Creation Time";
                        ERP_SO_No := "Sales Invoice Header"."Order No.";
                        RecSalesLineArchive.RESET;
                        RecSalesLineArchive.SETCURRENTKEY(RecSalesLineArchive."Document No.", RecSalesLineArchive."Line No.", RecSalesLineArchive."No.");
                        RecSalesLineArchive.SETRANGE(RecSalesLineArchive."Document No.", RecSalesHeaderArchive."No.");
                        RecSalesLineArchive.SETRANGE(RecSalesLineArchive."Line No.", "Sales Invoice Line"."Line No.");
                        RecSalesLineArchive.SETRANGE(RecSalesLineArchive."No.", "Sales Invoice Line"."No.");
                        IF RecSalesLineArchive.FINDSET THEN
                            REPEAT
                                SO_Order_Qty_In_KG := RecSalesLineArchive.Quantity;
                                SO_Order_Value := RecSalesLineArchive."Line Amount";
                            UNTIL RecSalesLineArchive.NEXT = 0;
                    END;


                    RecSalesHeaderArchive1.RESET;
                    RecSalesHeaderArchive1.SETRANGE(RecSalesHeaderArchive1."No.", "Sales Invoice Header"."Order No.");
                    IF NOT RecSalesHeaderArchive1.FINDFIRST THEN BEGIN
                        RecSalesShipmentHeader.RESET;
                        RecSalesShipmentHeader.SETRANGE(RecSalesShipmentHeader."No.", "Sales Invoice Line"."Shipment No.");
                        IF RecSalesShipmentHeader.FINDFIRST THEN BEGIN
                            ERP_SO_No := RecSalesShipmentHeader."Order No.";
                            RecSalesHeader.RESET;
                            RecSalesHeader.SETRANGE(RecSalesHeader."No.", RecSalesShipmentHeader."Order No.");
                            IF RecSalesHeader.FINDFIRST THEN BEGIN
                                SO_Time := RecSalesHeader."SO Creation Time";
                            END;
                            RecSalesLine.RESET;
                            RecSalesLine.SETRANGE(RecSalesLine."Document No.", RecSalesShipmentHeader."Order No.");
                            RecSalesLine.SETRANGE(RecSalesLine."No.", "Sales Invoice Line"."No.");
                            RecSalesLine.SETRANGE(RecSalesLine."Line No.", "Sales Invoice Line"."Shipment Line No.");
                            IF RecSalesLine.FINDSET THEN
                                REPEAT
                                    SO_Order_Qty_In_KG := RecSalesLine.Quantity;
                                    SO_Order_Value := RecSalesLine."Line Amount";
                                UNTIL RecSalesLine.NEXT = 0;
                        END;
                    END;
                    //
                    ReasonDesc1 := '';
                    RecPostedPickList.RESET;
                    RecPostedPickList.SETRANGE(RecPostedPickList."Source No.", "Sales Invoice Header"."Order No.");
                    RecPostedPickList.SETRANGE(RecPostedPickList."Item No.", "Sales Invoice Line"."No.");
                    IF RecPostedPickList.FINDSET THEN
                        REPEAT
                            IF RecReasonCOde1.GET(RecPostedPickList."Reason Code") THEN
                                ReasonDesc1 := RecReasonCOde1.Description;
                        UNTIL RecPostedPickList.NEXT = 0;
                    //


                    IF RecItem.GET("Sales Invoice Line"."No.") THEN
                        SalesCategory1 := RecItem."Sales Category";

                    ShortCloseSI := FORMAT("Sales Invoice Header"."ShortClose Reason Code");

                    MakeExcelDataBody;
                end;
            }

            trigger OnAfterGetRecord();
            begin

                IF RecCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                    CustomerBusinessFormat := RecCust."Business Format / Outlet Name";
                    CustName := RecCust.Name;
                    //CustName2 := RecCust."Name 2";
                    SalesReporting := RecCust."Sales Reporting Field";
                END;

                OTDInDays := "Sales Invoice Header"."Document Date" - "Sales Invoice Header"."Posting Date"
            end;

            trigger OnPostDataItem();
            begin

                //IF Document_Type = Document_Type :: Invoice THEN
                //MakeExcelDataFooter;
            end;

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                CLEAR(LocCode);
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCodeText <> '' THEN
                    "Sales Invoice Header".SETFILTER("Sales Invoice Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", 99990101D, AsOnDate);
            end;
        }
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order));
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("No." = FILTER(<> ''),
                                          "Quantity" = FILTER(<> 0),
                                          "Document Type" = FILTER(Order),
                                          "Customer Price Group" = FILTER(<> 'SAM 19-20'));

                trigger OnAfterGetRecord();
                begin
                    IF RecItem.GET("Sales Line"."No.") THEN
                        SalesCategory := RecItem."Sales Category";


                    MakeExcelDataBody_SalesHeader;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF "Sales Header"."Document Type" = "Sales Header"."Document Type"::Order THEN BEGIN
                    IF RecCust.GET("Sales Header"."Sell-to Customer No.") THEN BEGIN
                        CustomerBusinessFormat := RecCust."Business Format / Outlet Name";
                        CustName := RecCust.Name;
                        //CustName2 := RecCust."Name 2";
                        SalesReporting := RecCust."Sales Reporting Field";
                    END;

                    OTDInDays := "Sales Header"."Posting Date" - "Sales Header"."Document Date"
                END;
                ShortClose := FORMAT("Sales Header"."ShortClose Reason Code");
            end;

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                CLEAR(LocCode);
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCodeText <> '' THEN
                    "Sales Header".SETFILTER("Sales Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Header".SETRANGE("Sales Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Header".SETRANGE("Sales Header"."Posting Date", 99990101D, AsOnDate);

                //MakeNewRow;
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
                field("Document Type"; Document_Type)
                {
                    Visible = false;
                }
                group("From Date - To Date Filters")
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

    trigger OnPostReport();
    begin
        //IF Document_Type = Document_Type :: Invoice THEN
        CreateExcelbook;
    end;

    trigger OnPreReport();
    begin
        //MakeExcelInfo;
        //IF Document_Type = Document_Type :: Invoice THEN
        MakeExcelDataHeader;
    end;

    var
        Document_Type: Option " ",Invoice,"Credit Note";
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        RecCust: Record 18;
        CustomerBusinessFormat: Text[100];
        CustName: Text[100];
        RecItem: Record 27;
        BrandName: Code[20];
        RecSalesPrice: Record 7002;
        PriceperKG: Decimal;
        RecSalesPerson: Record 13;
        SalesPersonName: Text[50];
        StorageCategory: Text[20];
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RecSIL: Record 113;
        RecSCML: Record 115;
        SalesReporting: Text[200];
        SalesReporting1: Text[200];
        MonthDateChr: Text[50];
        OTDInDays: Integer;
        RecSalesHeaderArchive: Record 5107;
        RecSalesLineArchive: Record 5108;
        SO_Order_Qty_In_KG: Decimal;
        SO_Order_Value: Decimal;
        SO_Time: Time;
        RecSH: Record 36;
        RecSalesHeaderArchive1: Record 5107;
        RecSalesInvHeader: Record 112;
        RecSalesLine: Record 37;
        RecSalesShipmentHeader: Record 110;
        ERP_SO_No: Code[20];
        RecSalesHeader: Record 36;
        RecReasonCOde: Record 231;
        ReasonDesc: Text[1024];
        SaleLineReasonDesc: Text[1024];
        SalesCategory: Code[20];
        SalesCategory1: Code[20];
        RecPostedPickList: Record 7343;
        ReasonDesc1: Text[1024];
        RecReasonCOde1: Record 231;
        ShortClose: Code[50];
        ShortCloseSI: Code[50];

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\FIL Rate Sales.xlsx', 'FIL Rate Sales', 'FIL Rate Sales', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\FIL Rate Sales.xlsx', 'FIL Rate Sales', 'FIL Rate Sales', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        //ExcelBuf.AddColumn('Sales Register Invoice ',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('FIL Rate Sales', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('From Date : ' + FORMAT(From_Date) + '  TO   ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            IF (AsOnDate <> 0D) THEN
                ExcelBuf.AddColumn('As On Date : ' + FORMAT(AsOnDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //1
        ExcelBuf.AddColumn('Branch Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer posting group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Reporting Filed', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Customer Order No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //2
        ExcelBuf.AddColumn('Customer Order Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP SO No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP SO Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP SO Time', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('SO Order Qty.KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //3
        ExcelBuf.AddColumn('SO Order Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP INV No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP INV DATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP INV TIME', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('OTD IN DAYS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //4
        ExcelBuf.AddColumn('ERP INV Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Sales In KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //5
        ExcelBuf.AddColumn('Base Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Loss KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Loss Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate in % - KG', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate in % - Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        // 18112021 CCIT AN
        ExcelBuf.AddColumn('ShortClose Reason', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        // 18112021 CCIT AN
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //1
        ExcelBuf.AddColumn("Sales Invoice Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Sell-to Customer Name" + "Sales Invoice Header"."Sell-to Customer Name 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesReporting, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //2
        ExcelBuf.AddColumn("Sales Invoice Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(ERP_SO_No, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(SO_Time, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        ExcelBuf.AddColumn(SO_Order_Qty_In_KG, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);  //3
        ExcelBuf.AddColumn(ROUND(SO_Order_Value, 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Invoice Header"."Invoice Time", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        ExcelBuf.AddColumn(OTDInDays, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //4
        MonthDateChr := FORMAT("Sales Invoice Header"."Posting Date", 0, '<Month Text>-<Year>');
        ExcelBuf.AddColumn(MonthDateChr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);  //5
        ExcelBuf.AddColumn("Sales Invoice Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(SO_Order_Qty_In_KG - "Sales Invoice Line".Quantity, 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND((SO_Order_Value - "Sales Invoice Line"."Line Amount"), 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        IF (SO_Order_Qty_In_KG <> 0) THEN
            ExcelBuf.AddColumn(FORMAT(ROUND(("Sales Invoice Line".Quantity / SO_Order_Qty_In_KG) * 100, 0.01, '=')) + ' %', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        IF (SO_Order_Value <> 0) THEN
            ExcelBuf.AddColumn(FORMAT(ROUND(("Sales Invoice Line"."Line Amount" / ROUND(SO_Order_Value, 0.01, '=')) * 100, 0.01, '=')) + ' %', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //CCIT AN
        /*ReasonDesc :='';
        IF RecReasonCOde.GET("Sales Invoice Header"."Reason Code") THEN
           ReasonDesc := RecReasonCOde.Description;*/
        ExcelBuf.AddColumn(ReasonDesc1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //18112021 CCIT AN
        ExcelBuf.AddColumn(ShortCloseSI, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //18112021 CCIT AN

    end;

    procedure MakeExcelDataFooter();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //1
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //2
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //3
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //4
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //5
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelDataBody_SalesHeader();
    begin
        //-----

        //-----
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Header"."Document Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //1
        ExcelBuf.AddColumn("Sales Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."Sell-to Customer Name" + "Sales Header"."Sell-to Customer Name 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesReporting, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Sales Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //2
        ExcelBuf.AddColumn("Sales Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Header"."SO Creation Time", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        ExcelBuf.AddColumn("Sales Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);  //3
        ExcelBuf.AddColumn(ROUND("Sales Line"."Line Amount", 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        ExcelBuf.AddColumn(OTDInDays, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //4
        MonthDateChr := FORMAT("Sales Header"."Posting Date", 0, '<Month Text>-<Year>');
        ExcelBuf.AddColumn(MonthDateChr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //5
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Line".Quantity - 0, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Line"."Line Amount" - 0, FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('0', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('0', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //18112021 CCIT AN
        SaleLineReasonDesc := '';
        IF RecReasonCOde.GET("Sales Line"."Reason Code") THEN
            SaleLineReasonDesc := RecReasonCOde.Description;
        //ELSE
        // SaleLineReasonDesc := FORMAT("Sales Header"."ShortClose Reason Code");
        ExcelBuf.AddColumn(SaleLineReasonDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ShortClose, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //18112021 CCIT AN
    end;

    local procedure MakeNewRow();
    begin
        //ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Order', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  //1
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //2
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //3
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //4
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);  //5
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;
}

