report 50017 "Open PO Tracker"
{
    // version CCIT-JAGA

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(<> 'Invoice'));//, PutAwayCreated = filter(true)
            //, Receive = filter(true));
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE("Outstanding Quantity" = FILTER(<> 0));
                /*
                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    DataItemLink = "Source ID" = FIELD("Document No."),
                                   "Item No." = FIELD("No."),
                                   "Source Ref. No." = FIELD("Line No.");

                    trigger OnAfterGetRecord();
                    begin
                        Sr_No += 1;

                        IF RecItem.GET("Reservation Entry"."Item No.") THEN BEGIN
                            IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM1.Weight <> 0) THEN BEGIN
                                    ConQty := ROUND(("Reservation Entry"."Quantity (Base)" / RecUOM1.Weight), 1, '=');
                                END;
                            END;
                        END;

                        TotalQtyPCS += "Reservation Entry"."Quantity (Base)";
                        IF RecItem.GET("Reservation Entry"."Item No.") THEN BEGIN
                            IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM1.Weight <> 0) THEN BEGIN
                                    TotalQtyKG += ROUND(("Reservation Entry"."Quantity (Base)" / RecUOM1.Weight), 1, '=');
                                END;
                            END;
                        END;

                        MakeExcelDataBody;
                    end;
                }
                */

                trigger OnAfterGetRecord();
                begin
                    RecSalesPrice.RESET;
                    IF RecSalesPrice.GET("Purchase Header"."No.") THEN
                        PricePerKG := RecSalesPrice."Conversion Price Per PCS";

                    RecItem.RESET;
                    IF RecItem.GET("Purchase Line"."No.") THEN BEGIN
                        SalesCategory := RecItem."Sales Category";
                        BrandName := RecItem."Brand Name";
                        Vertical := RecItem."Gen. Prod. Posting Group";
                    END;

                    RecItem.RESET;
                    IF RecItem.GET("Purchase Line"."No.") THEN BEGIN
                        //IF RecItem.FINDFIRST THEN BEGIN
                        Desc1 := RecItem.Description;
                        Desc2 := RecItem."Description 2";
                        ProdType := RecItem."Product Type";
                    END;
                    //>>PCPL-064 10022023
                    Clear(ProductGroup);
                    if RecitemCat.Get("Purchase Line"."Item Category Code") then begin
                        ProductGroup := RecitemCat."Parent Category";
                    end;
                    //>>PCPL-064 10022023
                    // QtyInPCS := "Outstanding Quantity" / Weight; //PCPL-0070 20Jan23
                    Sr_No += 1;
                    MakeExcelDataBody

                end;

            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(VendName);
                CLEAR(CountryCode);
                IF RecVend.GET("Purchase Header"."Buy-from Vendor No.") THEN BEGIN
                    VendName := RecVend.Name;
                    CountryCode := RecVend."Country/Region Code";
                END;

                IF RecPaymentTerms.GET("Purchase Header"."Payment Terms Code") THEN
                    PaymentDesc := RecPaymentTerms.Description;




            end;



            trigger OnPostDataItem();
            begin
                //IF Document_Type = Document_Type :: Invoice THEN
                MakeExcelTotal;
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

                IF LocCodeText <> '' THEN
                    "Purchase Header".SETFILTER("Purchase Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF DocNo <> '' THEN
                    "Purchase Header".SETRANGE("Purchase Header"."No.", DocNo);
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    //"Purchase Header".SETRANGE("Purchase Header"."Posting Date",From_Date,To_Date)
                    "Purchase Header".SETRANGE("Purchase Header"."Order Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        //"Purchase Header".SETRANGE("Purchase Header"."Posting Date",010199D,AsOnDate);
                        "Purchase Header".SETRANGE("Purchase Header"."Order Date", 20200101D, AsOnDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Document No."; DocNo)
                {
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecPH.RESET;
                        RecPH.SETRANGE(RecPH."No.", "Purchase Header"."No.");
                        IF RecPH.FINDSET THEN
                            REPEAT
                                "Purchase Header"."No." := RecPH."No.";
                            UNTIL RecPH.NEXT = 0;
                        IF PAGE.RUNMODAL(9307, RecPH) = ACTION::LookupOK THEN BEGIN
                            Text := FORMAT(RecPH."No.");
                            EXIT(TRUE);
                        END;
                    end;
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
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin

        //IF Document_Type = Document_Type :: Invoice THEN
        MakeExcelDataHeader;


        Sr_No := 0;


        TotalQtyPCS := 0;
        TotalQtyKG := 0;
        TotalDiscount := 0;
        TotalAmount := 0;
    end;

    var
        ExcelBuf: Record 370 temporary;
        Document_Type: Option " ",Invoice,"Credit Note";
        Sr_No: Integer;
        Sr_No1: Integer;
        RecVend: Record 23;
        VendName: Text[50];
        TotalQtyPCS: Decimal;
        TotalDiscount: Decimal;
        TotalAmount: Decimal;
        TotalQty1: Decimal;
        TotalDiscount1: Decimal;
        TotalAmount1: Decimal;
        VendName1: Text[50];
        RecItem: Record 27;
        RecitemCat: Record "Item Category";
        ProductGroup: Code[20];
        BrandName: Code[20];
        BrandName1: Code[20];
        RecSalesPrice: Record 7002;
        PricePerKG: Decimal;
        PricePerKG1: Decimal;
        DocNo: Code[50];
        RecPH: Record 38;
        RecILE: Record 32;
        Batch: Code[20];
        MFGDate: Date;
        EXPDate: Date;
        CountryCode: Code[20];
        TotalQtyKG: Decimal;
        Desc1: Text[50];
        Desc2: Text[50];
        ProdType: Code[20];
        RecRE: Record 337;
        SalesCategory: Code[20];
        Vertical: Code[10];
        RecVendItem: Record 99;
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Code[1024];
        RecUOM1: Record 5404;
        ConQty: Decimal;
        PaymentDesc: Text[200];
        RecPaymentTerms: Record 3;
        QtyInPCS: Decimal;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Purchase Register Before POST.xlsx', 'Open PO Tracker', 'Open PO Tracker', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Purchase Register Before POST.xlsx', 'Open PO Tracker', 'Open PO Tracker', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
        /*
         ExcelBuf.CreateBook('Purchase Register Before POST');
         ExcelBuf.WriteSheet('Purchase Register Before POST',CompanyName,UserId);
         ExcelBuf.CloseBook();
         ExcelBuf.SetFriendlyFilename('Purchase Export');
         ExcelBuf.OpenExcel();;
     */

    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Purchase Register Before POST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Open PO Tracker', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('SR No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country/Region Of Origin Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Import/Local', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mode of Shipment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Transport Mode', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Container Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Terms', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Terms Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Vendor PO No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('P.O.No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.O.Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('In Location', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Supplier Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fortune Product Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Vertical', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty. In KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty. In PCS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO Batch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('PO MFG Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('PO Exp. Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETD-Suppier Warehouse', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETD-Origin Port', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Port Of Loading-Air', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Port Of Loading-Ocean', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Destination Port-Air', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Destination Port-Ocean', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETA-Destination Port', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETA-Destination CFS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ETA-Bond', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('ETA-Availability For Sale', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Sr_No, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(VendName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CountryCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Shipment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purchase Header"."Transport Method", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Container Filter", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Payment Terms Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(PaymentDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purchase Header"."Vendor Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purchase Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Purchase Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Desc2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Desc1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Vertical, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Line"."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Purchase Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL-064
        ExcelBuf.AddColumn(ProductGroup, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCL-064
        ExcelBuf.AddColumn("Purchase Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ProdType, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(BrandName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Line"."Outstanding Quantity" /*"Reservation Entry"."Quantity (Base)"*/, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //PCPL-0070 << 20Jan23
        If ("Purchase Line".Weight = 0) then
            ExcelBuf.AddColumn('', False, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
        Else
            ExcelBuf.AddColumn("Purchase Line"."Outstanding Quantity" / "Purchase Line".Weight, False, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //PCPL-0070 >> 20Jan23
        ExcelBuf.AddColumn(''/*"Reservation Entry"."PO Lot No."*/, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(''/*"Reservation Entry"."PO Manufacturing Date"*/, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn(''/*"Reservation Entry"."PO Expiration Date"*/, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purchase Header"."ETD - Supplier Warehouse", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purchase Header"."ETD - Origin Port", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purchase Header"."Port of Loading-Air", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Port of Loading-Ocean", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Purchase Header"."Port of Destination-Air", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."Port of Destination-Ocean", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purchase Header"."ETA - Destination Port", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purchase Header"."ETA - Destination CFS", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purchase Header"."ETA - Bond", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Purchase Header"."ETA - Availability for Sale", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
    end;

    procedure MakeExcelTotal();
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(TotalQtyPCS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//
        ExcelBuf.AddColumn(TotalQtyKG, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;
}

