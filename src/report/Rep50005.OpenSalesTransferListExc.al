report 50005 "Open Sales & Transfer List-Exc"
{
    // version CCIT-JAGA

    Caption = 'Open Sales & Transfer List-Exc';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;



    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = CONST(Order),
                                      "Short Closed" = FILTER(false));
            RequestFilterFields = "No.", "Location Code", "Salesperson Code";
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          Type = FILTER(<> "G/L Account"),
                                          "Outstanding Quantity" = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    CLEAR(ReasonDes); //CCIT-JAGA 07/12/2018

                    IF NOT (Document_Type = Document_Type::"Open Sales") THEN
                        CurrReport.SKIP;

                    Sr_No += 1;

                    CLEAR(SalesCategory);
                    CLEAR(StorageCategory);

                    RecItem.RESET;
                    IF RecItem.GET("Sales Line"."No.") THEN BEGIN
                        //BrandName := RecItem."Brand Name";
                        SalesCategory := RecItem."Sales Category";
                        StorageCategory := FORMAT(RecItem."Storage Categories");
                        //VendorNo := RecItem."Vendor No.";
                    END;

                    IF RecItem.GET("Sales Line"."No.") THEN BEGIN
                        IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                Pending_Qty_PC := ROUND(("Sales Line"."Outstanding Quantity" / RecUOM.Weight), 1, '=');
                            END
                        END
                    END;

                    MakeExcelDataBody;
                end;

                trigger OnPostDataItem();
                begin
                    //MakeExcelDataBody;
                    //MESSAGE('%1',Total);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF NOT (Document_Type = Document_Type::"Open Sales") THEN
                    CurrReport.SKIP;

                CLEAR(KAM);

                IF RecCust.GET("Sales Header"."Sell-to Customer No.") THEN BEGIN
                    CustomerBusinessFormat := RecCust."Business Format / Outlet Name";
                    //CustName := RecCust.Name;
                END;

                RecSalesPerson.RESET;
                IF RecSalesPerson.GET("Sales Header"."Salesperson Code") THEN
                    KAM := RecSalesPerson.Name;
            end;

            trigger OnPostDataItem();
            begin

                //IF Document_Type = Document_Type::"Open Sales" THEN

                //MakeExcelDataFooter;
            end;

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCode <> '' THEN
                    "Sales Header".SETFILTER("Sales Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Header".SETRANGE("Sales Header"."Document Date", From_Date, To_Date)
                ELSE
                    IF (ReqDate <> 0D) THEN
                        "Sales Header".SETRANGE("Sales Header"."Order Date", 99990101D, ReqDate);
            end;
        }
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("Short Closed" = FILTER(false));
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          "Outstanding Quantity" = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    CLEAR(ReasonDes1);  //CCIT-JAGA 07/12/2018

                    IF NOT (Document_Type = Document_Type::"Open Transfer") THEN
                        CurrReport.SKIP;

                    CLEAR(CustPriceGroup1);
                    CLEAR(CustOutletArea1);
                    CLEAR(KAM1);
                    CLEAR(SalesCategory1);
                    CLEAR(StorageCategory1);
                    CLEAR(KAMCode);

                    RecCust.RESET;
                    IF RecCust.GET("Transfer Line"."Customer No.") THEN BEGIN
                        CustPriceGroup1 := RecCust."Customer Price Group";
                        CustOutletArea1 := RecCust."Business Format / Outlet Name";
                        KAMCode := RecCust."Salesperson Code";
                    END;

                    RecSalesPerson.RESET;
                    IF RecSalesPerson.GET(KAMCode) THEN
                        KAM1 := RecSalesPerson.Name;

                    RecItem.RESET;
                    IF RecItem.GET("Transfer Line"."Item No.") THEN BEGIN
                        //BrandName := RecItem."Brand Name";
                        SalesCategory1 := RecItem."Sales Category";
                        StorageCategory1 := FORMAT(RecItem."Storage Categories");
                        //VendorNo := RecItem."Vendor No.";
                    END;

                    IF RecItem.GET("Transfer Line"."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                Pending_Qty_PC1 := ROUND(("Transfer Line"."Outstanding Quantity" / RecUOM.Weight), 1, '=');
                            END
                        END
                    END;

                    MakeExcelDataBody1;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF NOT (Document_Type = Document_Type::"Open Transfer") THEN
                    CurrReport.SKIP;
            end;

            trigger OnPostDataItem();
            begin
                IF NOT (Document_Type = Document_Type::"Open Transfer") THEN
                    CurrReport.SKIP;

                //MakeExcelDataFooter1;
            end;

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                "Transfer Header".SETFILTER("Transfer Header"."Transfer-from Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) AND (ReqDate = 0D) THEN
                    "Transfer Header".SETRANGE("Transfer Header"."Order Date", From_Date, To_Date)
                ELSE
                    IF (From_Date = 0D) AND (To_Date = 0D) AND (ReqDate <> 0D) THEN
                        "Transfer Header".SETRANGE("Transfer Header"."Order Date", 99990101D, ReqDate);
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
                }
                group("As On Date Filter")
                {
                    field("As On Date Date"; ReqDate)
                    {

                        trigger OnValidate();
                        begin
                            IF (From_Date <> 0D) AND (To_Date <> 0D) THEN BEGIN
                                ReqDate := 0D;
                                MESSAGE('From Date - To Date allready Entered...');
                            END;
                        end;
                    }
                }
                group("From Date - To Date Filter")
                {
                    field("From Date"; From_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (ReqDate <> 0D) THEN BEGIN
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
                            IF (ReqDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
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
        CompInfo.GET;
    end;

    trigger OnPostReport();
    begin
        IF Document_Type = Document_Type::"Open Sales" THEN
            CreateExcelbook
        ELSE
            IF Document_Type = Document_Type::"Open Transfer" THEN
                CreateExcelbook1;
    end;

    trigger OnPreReport();
    begin

        //MakeExcelInfo;
        IF Document_Type = Document_Type::"Open Sales" THEN
            MakeExcelDataHeader
        ELSE
            IF Document_Type = Document_Type::"Open Transfer" THEN
                MakeExcelDataHeader1;
    end;

    var
        Document_Type: Option " ","Open Sales","Open Transfer";
        ReqDate: Date;
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        RecCust: Record 18;
        CompInfo: Record 79;
        CustomerBusinessFormat: Text[100];
        RecSalesPerson: Record 13;
        KAM: Text[50];
        RecItem: Record 27;
        StorageCategory: Text[10];
        SalesCategory: Text[20];
        CustOutletArea1: Text[100];
        CustPriceGroup1: Text[10];
        KAM1: Text[50];
        StorageCategory1: Text[10];
        SalesCategory1: Text[20];
        KAMCode: Code[10];
        From_Date: Date;
        To_Date: Date;
        RecUOM: Record 5404;
        Pending_Qty_PC: Decimal;
        Pending_Qty_PC1: Decimal;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RecCust1: Record 18;
        RecSalesPerson1: Record 13;
        RecItem1: Record 27;
        RecUOM1: Record 5404;
        CustPriceGroup2: Text[50];
        CustOutletArea2: Text[100];
        KAM2: Text[50];
        SalesCategory2: Text[20];
        StorageCategory2: Text[10];
        KAMCode2: Code[10];
        Pending_Qty_PC2: Decimal;
        RecReasonCode: Record 231;
        ReasonDes: Text[50];
        ReasonDes1: Text[50];
        ReasonDes2: Text[50];

    procedure MakeExcelInfo();
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('SALES REGISTER',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */

    end;

    procedure CreateExcelbook();
    begin
        ExcelBuf.CreateBookAndOpenExcel('D:\Open Sales Tracking.xlsx', 'Open Sales Tracking', 'Open Sales Tracking', COMPANYNAME, USERID);
        //ExcelBuf.CreateBookAndOpenExcel('D:\Purchase Register Before POST.xlsx', 'Open PO Tracker', 'Open PO Tracker', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CompInfo.Name, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('From Date : ' + FORMAT(From_Date) + '  TO   ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            IF (ReqDate <> 0D) THEN
                ExcelBuf.AddColumn('As On Date : ' + FORMAT(ReqDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Pending Order - Line Wise', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Todays Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Bill To Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Price Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Outlet Area', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('KAM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Prod. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Categories', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer PO/SO Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer PO/SO Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Document No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CRDD Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);// 180919
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer PO/SO Qty-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer PO/SO Qty-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Pending Qty-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Pending Qty-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Pending Order Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days Pending For', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        /*
        //ExcelBuf.AddColumn('CRDD Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Document No',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Document Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Description',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        //ExcelBuf.AddColumn('Sales Category',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('UOM',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        {
        ExcelBuf.AddColumn('Pending Order-PCS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Pending Order-KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        ExcelBuf.AddColumn('Pending Order-Value',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days Pending For',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        }
        */

    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Header"."Bill-to Name" + ' - ' + "Sales Header"."Sell-to Customer Name 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Customer Price Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CustomerBusinessFormat, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(KAM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(StorageCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Sales Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Header"."Promised Delivery Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Sales Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//180919
        ExcelBuf.AddColumn("Sales Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ROUND("Sales Line"."Conversion Qty", 1, '='), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Sales Line".Quantity, 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(Pending_Qty_PC, 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ROUND("Sales Line"."Outstanding Quantity In KG",0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Sales Line"."Outstanding Quantity", 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(("Sales Line"."Outstanding Quantity" * "Sales Line"."Unit Price"), 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        IF "Sales Header"."Document Date" <> 0D THEN
            ExcelBuf.AddColumn(("Sales Header"."Document Date" - TODAY), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        //CCIT-JAGA 07/12/2018
        IF RecReasonCode.GET("Sales Line"."Reason Code") THEN
            ReasonDes := RecReasonCode.Description;
        ExcelBuf.AddColumn(ReasonDes, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //CCIT-JAGA 07/12/2018

        /*
        //ExcelBuf.AddColumn("Sales Header"."Promised Delivery Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);//CRRD Date
        //ExcelBuf.AddColumn("Sales Header"."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//Doc No
        //ExcelBuf.AddColumn("Sales Header"."Document Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);//Doc Date
        //ExcelBuf.AddColumn("Sales Line".Description,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(SalesCategory,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//sales CAt
        //ExcelBuf.AddColumn("Sales Line"."Unit of Measure Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Sales Line"."Reason Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);  //CCIT-JAGA 07/12/2018
        //CCIT-JAGA 07/12/2018
        IF RecReasonCode.GET("Sales Line"."Reason Code") THEN
          ReasonDes := RecReasonCode.Description;
        ExcelBuf.AddColumn(ReasonDes,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //CCIT-JAGA 07/12/2018
        */

    end;

    procedure MakeExcelDataFooter();
    begin
    end;

    procedure CreateExcelbook1();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Open Transfer Tracking.xlsx', 'Open Transfer Tracking', 'Open Transfer Tracking', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Open Transfer Tracking.xlsx', 'Open Transfer Tracking', 'Open Transfer Tracking', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CompInfo.Name, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('From Date : ' + FORMAT(From_Date) + '  TO   ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            IF (ReqDate <> 0D) THEN
                ExcelBuf.AddColumn('As On Date : ' + FORMAT(ReqDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Transfer Order - Line Wise', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Todays Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('From Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('To Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Bill To Customer Name',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer Price Group',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn('Customer Outlet Area',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('KAM',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);// 130919
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//

        ExcelBuf.AddColumn('Gen. Prod. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Categories', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Customer PO/SO Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        //ExcelBuf.AddColumn('Customer PO/SO Number',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Customer PO/SO Qty-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Customer PO/SO Qty-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Days Pending For', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Pending Qty-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Pending Qty-PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Pending Order Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//
        ExcelBuf.AddColumn('Reason Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//

        //ExcelBuf.AddColumn('Customer PO/SO Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer PO/SO Qty-KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Customer PO/SO Qty-PCS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Pending Order Value',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Days Pending For',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn('Pending Qty-KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Pending Qty-PCS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Planned Delivery Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Document No',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Document Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Description',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Sales Category',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn('UOM',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Reason Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        /*
        ExcelBuf.AddColumn('Pending Order-PCS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Pending Order-KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        ExcelBuf.AddColumn('Pending Order-Value',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Days Pending For',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */

    end;

    procedure MakeExcelDataBody1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Transfer Header"."Transfer-from Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."Transfer-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn("Transfer Line"."Customer Name",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(CustPriceGroup1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn(CustOutletArea1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(KAM1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Transfer Line"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//130919
        ExcelBuf.AddColumn("Transfer Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StorageCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Transfer Header"."External Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Transfer Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ROUND("Transfer Line".Quantity, 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Transfer Line"."Conversion Qty", 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        IF ReqDate <> 0D THEN
            ExcelBuf.AddColumn(ReqDate - "Transfer Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
        ELSE
            ExcelBuf.AddColumn(To_Date - "Transfer Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(ROUND("Transfer Line"."Outstanding Quantity", 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Transfer Line"."Outstanding Quantity In KG", 0.01), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Transfer Line"."Outstanding Quantity" * "Transfer Line"."Transfer Price", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        IF RecReasonCode.GET("Transfer Line"."Reason Code") THEN
            ReasonDes1 := RecReasonCode.Description;
        ExcelBuf.AddColumn(ReasonDes1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        /*
        IF ReqDate <> 0D THEN
          ExcelBuf.AddColumn(ReqDate - "Transfer Header"."Order Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
        ELSE
          ExcelBuf.AddColumn(To_Date - "Transfer Header"."Order Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
          */
        //ExcelBuf.AddColumn("Transfer Line"."Outstanding Quantity"*"Transfer Line"."Transfer Price",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ROUND("Transfer Line".Quantity,0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);


        //ExcelBuf.AddColumn(ROUND("Transfer Line"."Conversion Qty",1,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ROUND("Transfer Line".Quantity,0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ROUND("Transfer Line"."Conversion Qty",0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn("Transfer Line"."Outstanding Quantity"*"Transfer Line"."Transfer Price",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(Pending_Qty_PC1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//comment ccit san
        /*IF ReqDate <> 0D THEN
          ExcelBuf.AddColumn(ReqDate - "Transfer Header"."Order Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
        ELSE
          ExcelBuf.AddColumn(To_Date - "Transfer Header"."Order Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        */

        //ExcelBuf.AddColumn(ROUND("Transfer Line"."Outstanding Quantity",0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(ROUND("Transfer Line"."Outstanding Quantity In KG",0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn("Transfer Header"."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('"Sales Header"."Document Date"',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn("Transfer Line".Description,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(SalesCategory1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn("Transfer Line"."Unit of Measure Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Transfer Line"."Reason Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);  //CCIT-JAGA 07/12/2018
        /*//CCIT-JAGA 07/12/2018
        IF RecReasonCode.GET("Transfer Line"."Reason Code") THEN
          ReasonDes1 := RecReasonCode.Description;
        ExcelBuf.AddColumn(ReasonDes1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //CCIT-JAGA 07/12/2018
        */

    end;

    procedure MakeExcelDataFooter1();
    begin
    end;
}

