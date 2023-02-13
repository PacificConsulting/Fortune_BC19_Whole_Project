report 50057 "Purchase Register Invioce"
{
    // version CCIT-Fortune-Using

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.", "Location Code";
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    Sr_No += 1;

                    /*RecSalesPrice.RESET;
                     IF RecSalesPrice.GET("Purch. Inv. Line"."No.") THEN
                      PricePerKG := RecSalesPrice."Conversion Price";
                      */

                    // rdk 130819 -
                    CLEAR(BrandName);
                    CLEAR(SalesCategory);
                    CLEAR(PricePerKG);
                    // rdk 130819 +

                    /*RecSalesPrice.RESET;
                    RecSalesPrice.SETRANGE(RecSalesPrice."Item No.","Purch. Inv. Line"."No.");
                    IF RecSalesPrice.FINDFIRST THEN
                       PricePerKG := RecSalesPrice."Conversion Price Per PCS";*/



                    RecItem.RESET;
                    IF RecItem.GET("Purch. Inv. Line"."No.") THEN BEGIN
                        BrandName := RecItem."Brand Name";
                        SalesCategory := RecItem."Sales Category";
                    END;

                    //CCIT-SG-05072021
                    /*
                    IF RecTDSNatureDe.GET("Purch. Inv. Line"."TDS Nature of Deduction") THEN //PCPL/MIG/NSW Filed not Exist in BC18
                    //BEGIN //PCPL/MIG/NSW Filed not Exist in BC18
                    TDSSection := '';
                    RecTDSGr.RESET;
                    RecTDSGr.SETRANGE(RecTDSGr."TDS Group", RecTDSNatureDe."TDS Group");
                    //RecTDSGr.SETFILTER(RecTDSGr."Effective Date",'<=%1',"Purch. Inv. Line"."Posting Date");
                    //RecTDSGr.SETFILTER(RecTDSGr."Effective Date",'>=%1',"Purch. Inv. Line"."Posting Date");
                    IF RecTDSGr.FINDFIRST THEN
                        TDSSection := FORMAT(RecTDSGr."TDS Section");
                    END; 
                    //CCIT-SG-05072021
                    */ //PCPL/MIG/NSW Filed not Exist in BC18

                    //IF RecItem.GET("Purch. Inv. Line"."No.") THEN
                    TotalQty += "Purch. Inv. Line".Quantity;
                    TotalDiscount += "Purch. Inv. Line"."Line Discount Amount";

                    IF "Purch. Inv. Header"."Currency Factor" <> 0 THEN
                        TotalAmount += "Purch. Inv. Line".Amount * (1 / "Purch. Inv. Header"."Currency Factor")
                    ELSE
                        TotalAmount += "Purch. Inv. Line".Amount;
                    //RL ++
                    CLEAR(GSTCompAmount);
                    CLEAR(GSTPerc);
                    CLEAR(RCharge);
                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
                    DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
                    DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    IF DetailedGSTLedgerEntry.FINDSET THEN
                        REPEAT

                            GSTCompAmount[2] += ABS(DetailedGSTLedgerEntry."GST Amount");
                            GSTPerc[2] := DetailedGSTLedgerEntry."GST %";
                            RCharge := DetailedGSTLedgerEntry."Reverse Charge";
                        UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
                    DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
                    DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    IF DetailedGSTLedgerEntry.FINDSET THEN
                        REPEAT
                            GSTCompAmount[1] += ABS(DetailedGSTLedgerEntry."GST Amount");
                            GSTPerc[1] := DetailedGSTLedgerEntry."GST %";
                            RCharge := DetailedGSTLedgerEntry."Reverse Charge";
                        UNTIL DetailedGSTLedgerEntry.NEXT = 0;

                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
                    DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
                    DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    IF DetailedGSTLedgerEntry.FINDSET THEN
                        REPEAT
                            GSTCompAmount[3] += ABS(DetailedGSTLedgerEntry."GST Amount");
                            GSTPerc[3] := DetailedGSTLedgerEntry."GST %";
                            RCharge := DetailedGSTLedgerEntry."Reverse Charge";
                        UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                    //RL --

                    //24112021 CCIT AN
                    CLEAR(GRNNO);
                    CLEAR(Position);

                    CLEAR(GRNString);
                    CLEAR(GRNDate);

                    PIN.RESET;
                    PIN.SETRANGE("Document No.", "Purch. Inv. Header"."No.");
                    PIN.SETRANGE("Buy-from Vendor No.", '');
                    PIN.SETRANGE("No.", '');
                    IF PIN.FINDFIRST THEN BEGIN //REPEAT
                        GRNString := PIN.Description;
                    END;//UNTIL PIN.NEXT = 0 ;
                    Position := STRPOS(GRNString, '.');
                    GRNNO := COPYSTR(GRNString, Position + 1);
                    GRNNO2 := DELCHR(GRNNO, '>', ':');
                    ;

                    PRH.RESET;
                    PRH.SETRANGE("No.", GRNNO2);
                    IF PRH.FINDFIRST THEN BEGIN
                        GRNDate := PRH."Posting Date";
                    END;
                    //24112021 CCIT AN

                    //<<PCPL/NSW/MIG 18July22
                    Clear(ItemParent);
                    IF ParentItem.Get("Purch. Inv. Line"."Item Category Code") then begin
                        ItemParent := ParentItem."Parent Category";
                    end;
                    //>>PCPL/NSW/MIG 18July22


                    MakeExcelDataBody;

                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecVend.GET("Purch. Inv. Header"."Buy-from Vendor No.") THEN BEGIN
                    VendName := RecVend.Name;
                    VendCountry := RecVend."Country/Region Code";
                END;
            end;

            trigger OnPostDataItem();
            begin
                IF Document_Type = Document_Type::Invoice THEN
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
                    "Purch. Inv. Header".SETFILTER("Purch. Inv. Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF Document_Type <> Document_Type::Invoice THEN
                    "Purch. Inv. Header".SETRANGE("No.", '', '');

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Purch. Inv. Header".SETRANGE("Purch. Inv. Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Purch. Inv. Header".SETRANGE("Purch. Inv. Header"."Posting Date", 99990101D, AsOnDate); //010199D
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            RequestFilterFields = "No.", "Location Code";
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    Sr_No1 += 1;

                    // rdk 130819 -
                    CLEAR(BrandName1);
                    CLEAR(SalesCategory1);
                    CLEAR(PricePerKG1);
                    // rdk 130819 +


                    RecItem.RESET;
                    IF RecItem.GET("Purch. Cr. Memo Line"."No.") THEN
                        SalesCategory1 := RecItem."Sales Category";

                    /*RecSalesPrice.RESET;
                    IF RecSalesPrice.GET("Purch. Cr. Memo Line"."No.") THEN
                      PricePerKG1 := RecSalesPrice."Conversion Price Per PCS";*/

                    RecItem.RESET;
                    IF RecItem.GET("Purch. Cr. Memo Line"."No.") THEN BEGIN
                        BrandName1 := RecItem."Brand Name";
                    END;

                    TotalQty1 += "Purch. Cr. Memo Line".Quantity;
                    TotalDiscount1 += "Purch. Cr. Memo Line"."Line Discount Amount";

                    IF "Purch. Cr. Memo Hdr."."Currency Factor" <> 0 THEN
                        TotalAmount1 += "Purch. Cr. Memo Line".Amount * (1 / "Purch. Cr. Memo Hdr."."Currency Factor")
                    ELSE
                        TotalAmount1 += "Purch. Cr. Memo Line".Amount;
                    //RL ++
                    CLEAR(GSTCompAmount);
                    CLEAR(GSTPerc);
                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
                    DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
                    DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
                        GSTCompAmount[2] := ABS(DetailedGSTLedgerEntry."GST Amount");
                        GSTPerc[2] := DetailedGSTLedgerEntry."GST %";
                    END;
                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
                    DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
                    DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
                        GSTCompAmount[1] := ABS(DetailedGSTLedgerEntry."GST Amount");
                        GSTPerc[1] := DetailedGSTLedgerEntry."GST %";
                    END;
                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
                    DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
                    DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
                        GSTCompAmount[3] := ABS(DetailedGSTLedgerEntry."GST Amount");
                        GSTPerc[3] := DetailedGSTLedgerEntry."GST %";
                    END;
                    //RL --

                    //<<PCPL/NSW/MIG 18July22
                    Clear(ItemParent1);
                    IF ParentItem.Get("Purch. Cr. Memo Line"."Item Category Code") then begin
                        ItemParent1 := ParentItem."Parent Category";
                    end;
                    //>>PCPL/NSW/MIG 18July22
                    MakeExcelDataBody1;

                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecVend.GET("Purch. Cr. Memo Hdr."."Buy-from Vendor No.") THEN BEGIN
                    VendName1 := RecVend.Name;
                    VendCountry1 := RecVend."Country/Region Code";
                END;
            end;

            trigger OnPostDataItem();
            begin
                IF Document_Type = Document_Type::"Credit Note" THEN
                    MakeExcelTotal1;
            end;

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                "Purch. Cr. Memo Hdr.".SETFILTER("Purch. Cr. Memo Hdr."."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF Document_Type <> Document_Type::"Credit Note" THEN
                    "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."No.", '', '');

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."Posting Date", 99990101D, AsOnDate); //010199D
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

        IF Document_Type = Document_Type::Invoice THEN
            CreateExcelBook
        ELSE
            IF Document_Type = Document_Type::"Credit Note" THEN
                CreateExcelBook1;
    end;

    trigger OnPreReport();
    begin

        IF Document_Type = Document_Type::Invoice THEN
            MakeExcelDataHeader
        ELSE
            IF Document_Type = Document_Type::"Credit Note" THEN
                MakeExcelDataHeader1;


        Sr_No := 0;
        Sr_No1 := 0;
        Sr_No2 := 0;

        TotalQty := 0;
        TotalDiscount := 0;
        TotalAmount := 0;
    end;

    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        ExcelBuf: Record 370 temporary;
        Document_Type: Option " ",Invoice,"Credit Note";
        Sr_No: Integer;
        Sr_No1: Integer;
        RecVend: Record 23;
        VendName: Text[50];
        TotalQty: Decimal;
        TotalDiscount: Decimal;
        TotalAmount: Decimal;
        TotalQty1: Decimal;
        TotalDiscount1: Decimal;
        TotalAmount1: Decimal;
        VendName1: Text[50];
        RecItem: Record 27;
        BrandName: Code[20];
        BrandName1: Code[20];
        RecSalesPrice: Record 7002;
        PricePerKG: Decimal;
        PricePerKG1: Decimal;
        Sr_No2: Integer;
        PricePerKG2: Decimal;
        TotalQty2: Decimal;
        TotalDiscount2: Decimal;
        TotalAmount2: Decimal;
        VendCountry: Code[20];
        VendCountry1: Code[20];
        VendCountry2: Code[20];
        VendName2: Text[50];
        SalesCategory: Code[20];
        SalesCategory1: Code[20];
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        //RecTDSNatureDe : Record 13726;
        //RecTDSGr : Record 13731;
        TDSSection: Code[20];
        GSTCompAmount: array[3] of Decimal;
        GSTPerc: array[3] of Decimal;
        GSTCompAmount1: array[3] of Decimal;
        GSTPerc1: array[3] of Decimal;
        RCharge: Boolean;
        PurchHeader: Record 38;
        GRNNO: Code[50];
        GRNDate: Date;
        PIN: Record 123;
        GRNString: Code[50];
        Position: Integer;
        GRNNO2: Code[50];
        PRH: Record 120;
        ParentItem: Record 5722;
        ItemParent: text;
        ItemParent1: text;
        Decimal1: Decimal;
        Decimal2: Decimal;
        Decimal3: Decimal;
        Decimal4: Decimal;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Purchase Register Invoice.xlsx','Purchase Register Invoice','Purchase Register Invoice',COMPANYNAME,USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Purchase Register Invoice.xlsx', 'Purchase Register Invoice', 'Purchase Register Invoice', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Register Invoice', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Document Number(Fortune)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Service/Product', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Import/Local', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('P.O.No(Fortune)',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.O.Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('GRN No',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('GRN Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mode Of Shipment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Order No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Date(Booking)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Branch',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Prod. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country/Region Of Origin Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Parent Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('BOE No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('LOT No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn('Quantity(GRN)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Price Per KG',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Base Value In Foreign Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Discount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Value in Foreign Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Invoice Exchange Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Value In INR', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //RL ++
        ExcelBuf.AddColumn('SGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gross Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL --
        ExcelBuf.AddColumn('TDS Section', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT-SG-05072021
        ExcelBuf.AddColumn('TDS Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT-SG-05072021
                                                                                                        //RL ++

        /*
        ExcelBuf.AddColumn('GST %',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text); //CCIT_kj_06082021
        ExcelBuf.AddColumn('GST Amount',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text); //CCIT_kj_06082021
        ExcelBuf.AddColumn('HSN Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text); //CCIT_kj_06082021
        */
        ExcelBuf.AddColumn('Net Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('RCM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Custome Duty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //24112021 CCIT AN
        ExcelBuf.AddColumn('BE No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //17112021
        ExcelBuf.AddColumn('GRN No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //24112021 CCIT AN

    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Sr_No, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Purch. Inv. Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Purch. Inv. Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VendName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Purch. Inv. Header"."Vendor Order No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//RL
        ExcelBuf.AddColumn("Purch. Inv. Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn("Purch. Inv. Line"."Receipt No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('GRN Date',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Shipment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Vendor Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Vendor Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(Document_Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn("Purch. Inv. Header"."Shortcut Dimension 1 Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemParent, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BrandName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn("Purch. Inv. Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Bill of Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL

        ExcelBuf.AddColumn("Purch. Inv. Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(PricePerKG,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Header"."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF "Purch. Inv. Header"."Currency Factor" <> 0 THEN BEGIN
            ExcelBuf.AddColumn("Purch. Inv. Line"."Direct Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(1 / "Purch. Inv. Header"."Currency Factor", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount" * (1 / "Purch. Inv. Header"."Currency Factor"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            //RL ++
            ExcelBuf.AddColumn(GSTPerc[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN
              ExcelBuf.AddColumn(GSTPerc[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
            ELSE
              ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
              */
            ExcelBuf.AddColumn(GSTCompAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(("Purch. Inv. Line"."Line Amount" * (1 / "Purch. Inv. Header"."Currency Factor")) + GSTCompAmount[1] +
            GSTCompAmount[2] + GSTCompAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN BEGIN
            ExcelBuf.AddColumn(GSTCompAmount[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(("Purch. Inv. Line"."Line Amount"*(1/"Purch. Inv. Header"."Currency Factor")) + GSTCompAmount[1]+
            GSTCompAmount[2]+GSTCompAmount[3],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            END ELSE BEGIN
            ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(("Purch. Inv. Line"."Line Amount"*(1/"Purch. Inv. Header"."Currency Factor")) + GSTCompAmount[1]+
            GSTCompAmount[3],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            //RL --
            END;
            */
            // ExcelBuf.AddColumn(TDSSection, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-SG-05072021 //PCPL-064
            ExcelBuf.AddColumn("Purch. Inv. Line"."TDS Section Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            // ExcelBuf.AddColumn("Purch. Inv. Header"."TDS Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL-064
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-SG-05072021
            ExcelBuf.AddColumn((100 * (1 / "Purch. Inv. Header"."Currency Factor")), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//RL ////PCPL/MIG/NSW 100 Amount add field missing in BC Amount to vendor
            ExcelBuf.AddColumn(RCharge, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            IF "Purch. Inv. Line"."Custom Duty Amount" <> 0 THEN
                ExcelBuf.AddColumn(("Purch. Inv. Line"."Custom Duty Amount" * (1 / "Purch. Inv. Header"."Currency Factor")), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)
        END ELSE BEGIN //for inr
            ExcelBuf.AddColumn("Purch. Inv. Line"."Direct Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '0.01', ExcelBuf."Cell Type"::Number);
            //RL ++
            ExcelBuf.AddColumn(GSTPerc[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN
              ExcelBuf.AddColumn(GSTPerc[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
            ELSE
              ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            */
            ExcelBuf.AddColumn(GSTCompAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount" + GSTCompAmount[1] +
            GSTCompAmount[2] + GSTCompAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN BEGIN
            ExcelBuf.AddColumn(GSTCompAmount[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount" + GSTCompAmount[1]+
            GSTCompAmount[2]+GSTCompAmount[3],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            END ELSE BEGIN
            ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount" + GSTCompAmount[1]+
            GSTCompAmount[3],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            END;
            */

            //RL -
            // ExcelBuf.AddColumn(TDSSection, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-SG-05072021 PCPL-064
            ExcelBuf.AddColumn("Purch. Inv. Line"."TDS Section Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL-064
                                                                                                                                         //  ExcelBuf.AddColumn("Purch. Inv. Header"."TDS Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);                                                                                                                           // ExcelBuf.AddColumn("Purch. Inv. Header"."TDS Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL-064
            ExcelBuf.AddColumn("Purch. Inv. Header"."TDS Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-SG-05072021
            IF "Purch. Inv. Header"."Currency Factor" <> 0 THEN
                ExcelBuf.AddColumn((100 * (1 / "Purch. Inv. Header"."Currency Factor")), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number) ////PCPL/MIG/NSW 100 Add amount to vemdor missing in BC18
            ELSE
                ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(RCharge, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            IF "Purch. Inv. Line"."Custom Duty Amount" <> 0 THEN BEGIN
                ExcelBuf.AddColumn(("Purch. Inv. Line"."Custom Duty Amount" * (1 / "Purch. Inv. Header"."Currency Factor")), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END ELSE
                ExcelBuf.AddColumn(0, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        END;

        //24112021 CCIT AN
        ExcelBuf.AddColumn("Purch. Inv. Header"."In-Bond Bill of Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GRNNO2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GRNDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //24112021 CCIT AN


    end;

    procedure MakeExcelTotal();
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Invoice Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
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
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        /*
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(TotalQty,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(TotalDiscount,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-SG-05072021
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-SG-05072021
        ExcelBuf.AddColumn(TotalAmount, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)

    end;

    procedure CreateExcelBook1();
    begin

        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Purchase Register Credit Note.xlsx', 'Purchase Register Credit Note', 'Purchase Register Credit Note', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader1();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Register Credit Note', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Document Number(Fortune)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Service/Product', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Import/Local', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('P.O.No(Fortune)',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.O.Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('GRN No',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('GRN Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Mode Of Shipment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Daye(Booking)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Branch',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Prod. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country/Region Of Origin Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Parent Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('BOE No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('LOT No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn('Quantity(GRN)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Price Per KG',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Base Value In Foreign Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Discount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Value in Foreign Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Purchase Invoice Exchange Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice Value In INR', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL ++
        ExcelBuf.AddColumn('SGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IGST Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gross Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //RL --
    end;

    procedure MakeExcelDataBody1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Sr_No1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Gen. Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VendName1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('PO No',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('PO Date', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('GRN No',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('GRN Date',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Shipment Method Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Mode Of Shipment',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(Document_Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Shortcut Dimension 1 Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VendCountry1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ItemParent1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //PCPL/NSW/MIG 18July22
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesCategory1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BrandName1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Bill of Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //RL

        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(PricePerKG1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Cr. Memo Hdr."."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF "Purch. Cr. Memo Hdr."."Currency Factor" <> 0 THEN BEGIN
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Direct Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(1 / "Purch. Cr. Memo Hdr."."Currency Factor", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Line Amount" * (1 / "Purch. Cr. Memo Hdr."."Currency Factor"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            //RL ++
            ExcelBuf.AddColumn(GSTPerc[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN
              ExcelBuf.AddColumn(GSTPerc[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
            ELSE
              ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);*/

            ExcelBuf.AddColumn(GSTCompAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN
              ExcelBuf.AddColumn(GSTCompAmount[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
            ELSE
              ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        */
            // ExcelBuf.AddColumn(("Purch. Cr. Memo Line"."Line Amount" * (1 / "Purch. Cr. Memo Hdr."."Currency Factor")), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL/MIG/NSW 100 add Amount to vendor field missing                                                                                                                                                          //RL --
            ExcelBuf.AddColumn(("Purch. Cr. Memo Line"."Line Amount" + GSTCompAmount[3] + GSTCompAmount[2] + GSTCompAmount[1]), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL-0070
        END ELSE BEGIN
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            //RL ++
            ExcelBuf.AddColumn(GSTPerc[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTPerc[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN
              ExcelBuf.AddColumn(GSTPerc[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
            ELSE
              ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        */
            ExcelBuf.AddColumn(GSTCompAmount[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(GSTCompAmount[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            /*
            IF "Purch. Inv. Header"."Gen. Bus. Posting Group" <> 'INTERNATIO' THEN
              ExcelBuf.AddColumn(GSTCompAmount[2],FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
            ELSE
              ExcelBuf.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
              */
            ExcelBuf.AddColumn(("Purch. Cr. Memo Line"."Line Amount" + GSTCompAmount[3] + GSTCompAmount[2] + GSTCompAmount[1]), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL-0070
                                                                                                                                                                                                   //ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number); //PCPL/MIG/NSW
                                                                                                                                                                                                   //RL --
        END;

    end;

    procedure MakeExcelTotal1();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Total for CRs.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
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
        //ExcelBuf.AddColumn(TotalQty1,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(TotalDiscount1,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalAmount1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;
}

