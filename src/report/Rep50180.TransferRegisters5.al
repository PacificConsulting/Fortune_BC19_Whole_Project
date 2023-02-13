report 50180 "Transfer Registers5"
{
    // version CCIT-Fortune-SG-tk

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ILE_Shipment; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry Type" = FILTER(Transfer),
                                      "Document Type" = FILTER("Transfer Shipment"));
            dataitem(ILE_Receipt; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("Item No."),
                               "Order No." = FIELD("Order No."),
                               "Lot No." = FIELD("Lot No."),
                               "Order Line No." = FIELD("Order Line No.");
                DataItemTableView = SORTING("Document No.", "Posting Date", "Item No.")
                                    ORDER(Ascending)
                                    WHERE("Entry Type" = FILTER(Transfer),
                                          "Document Type" = FILTER("Transfer Receipt"));

                trigger OnAfterGetRecord();
                begin

                    IF RecLoc.GET(ILE_Receipt."Location Code") THEN BEGIN
                        IF RecLoc."Use As In-Transit" = TRUE THEN
                            CurrReport.SKIP;
                    END;

                    //GRNQtyPCS :=0;
                    VarianceQtyPCS := 0;
                    IF RecItem2.GET(ILE_Receipt."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                //GRNQtyPCS := ILE_Receipt.Quantity / RecUOM.Weight;
                                GRNQtyPCS := RecUOM.Weight;//Tk New
                                                           //VarianceQtyPCS := (ABS(ILE_Shipment.Quantity) - ILE_Receipt.Quantity) / RecUOM.Weight;
                            END
                        END
                    END;
                    //tk Start
                    GRNQUantityPcs1 := 0;
                    GrnQuantityKg := 0;
                    RecILESort.RESET;
                    RecILESort.SETRANGE(RecILESort."Entry Type", ILE_Receipt."Entry Type"::Transfer);
                    RecILESort.SETRANGE(RecILESort."Document Type", ILE_Receipt."Document Type"::"Transfer Receipt");
                    RecILESort.SETRANGE(RecILESort.Positive, TRUE);
                    RecILESort.SETRANGE(RecILESort."Document No.", ILE_Receipt."Document No.");
                    RecILESort.SETRANGE(RecILESort."Item No.", ILE_Receipt."Item No.");
                    //RecILESort.SETRANGE(RecILESort."Location Code",ILE_Receipt."Location Code");
                    RecILESort.SETRANGE(RecILESort."Lot No.", ILE_Receipt."Lot No.");
                    IF RecILESort.FINDSET THEN BEGIN
                        REPEAT
                            // RecILESort.CALCSUMS(RecILESort.Quantity);
                            GRNQUantityPcs1 += RecILESort.Quantity;
                            //GrnQuantityKg +=ILE_Receipt.Quantity;
                            GrnQuantityKg += RecILESort.Quantity;//CCIT-15092021
                            ILEReceiptQty := GRNQUantityPcs1 / GRNQtyPCS;
                            VarianceQtyPCS := ILEReceiptQty - ERP_TI_Qty_PCS;
                        //GRNQUantityPcs1-ILE_Shipment.Quantity;
                        UNTIL RecILESort.NEXT = 0;
                    END; //tk End


                    IF VehReportDate = 0D THEN // 121019
                      BEGIN
                        RecTransShipHeader.RESET;
                        RecTransRcpt.RESET;
                        RecTransRcpt.SETRANGE("No.", ILE_Receipt."Document No.");
                        IF RecTransRcpt.FINDFIRST THEN BEGIN

                            VehReportDate := RecTransRcpt."Vehicle Reporting Date";
                            VehReportTime := RecTransRcpt."Vehicle Reporting Time";
                            VehReleaseTime := RecTransRcpt."Vehicle Release Time";
                        END;
                    END;
                    valuercpt := 0;
                    IGSTRcpt := 0;
                    TotalValueRcpt := 0;
                    IF FromLocation.GET(RecTransRcpt."Transfer-from Code") THEN BEGIN
                        IF ToLocation.GET(RecTransRcpt."Transfer-to Code") THEN BEGIN
                            IF FromLocation."State Code" <> ToLocation."State Code" THEN BEGIN
                                RecTransRcptLine.RESET;
                                RecTransRcptLine.SETRANGE("Document No.", ILE_Receipt."Document No.");
                                RecTransRcptLine.SETRANGE("Item No.", ILE_Receipt."Item No.");
                                IF RecTransRcptLine.FINDFIRST THEN BEGIN
                                    valuercpt := RecTransRcptLine."Unit Price" * ABS(ILE_Receipt.Quantity);
                                    IGSTRcpt := 0;//(valuercpt * RecTransRcptLine."GST %")/100; //PCPL/MIG/NSW Filed not Exist in BC18
                                    TotalValueRcpt := valuercpt + IGSTRcpt;
                                END;
                            END;
                        END;
                    END;
                    RecTransRcptLine.RESET;
                    RecTransRcptLine.SETRANGE("Document No.", ILE_Receipt."Document No.");
                    RecTransRcptLine.SETRANGE("Item No.", ILE_Receipt."Item No.");
                    IF RecTransRcptLine.FINDFIRST THEN BEGIN
                        valuercpt := RecTransRcptLine."Unit Price" * ABS(ILE_Receipt.Quantity);
                        IGST2rcpt := 0;//(valuercpt * RecTransRcptLine."GST %")/100; //PCPL/MIG/NSW Filed not Exist in BC18
                        TotalValueRcpt := valuercpt + IGST2rcpt;
                    END;

                    IF TxtShorting <> ILE_Receipt."Document No." + ILE_Receipt."Order No." + ILE_Receipt."Item No." + ILE_Receipt."Lot No." + FORMAT(ILE_Receipt."Order Line No.") THEN BEGIN /* (ItemNo<> ILE_Receipt."Item No.") AND (DoceNo<>ILE_Receipt."Document No.") THEN*/

                        //IF TxtShorting<>ILE_Receipt."Document No."+ ILE_Receipt."Item No."+ ILE_Receipt."Lot No."THEN BEGIN { (ItemNo<> ILE_Receipt."Item No.") AND (DoceNo<>ILE_Receipt."Document No.") THEN}
                        MakeExcelDataBody_Receipt;
                        //TxtShorting := ILE_Receipt."Document No."+ILE_Receipt."Item No."+ ILE_Receipt."Lot No.";
                        TxtShorting := ILE_Receipt."Document No." + ILE_Receipt."Order No." + ILE_Receipt."Item No." + ILE_Receipt."Lot No." + FORMAT(ILE_Receipt."Order Line No.");
                        /*ItemNo := ILE_Receipt."Item No.";
                        DoceNo :=ILE_Receipt."Document No.";*/
                    END;//Tk End


                    cnt += 1;

                end;

                trigger OnPreDataItem();
                begin
                    /*//CCIT-PRI-280318
                    RecUserBranch.RESET ;
                    RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
                    IF RecUserBranch.FINDFIRST THEN
                      REPEAT
                        LocCode1 := LocCode1 +'|'+ RecUserBranch."Location Code" ;
                      UNTIL RecUserBranch.NEXT=0 ;
                    
                    LocCodeText := DELCHR(LocCode1,'<','|');
                    
                    //IF LocCodeText <> '' THEN
                    IF LocFilter = '' THEN
                      ILE_Receipt.SETFILTER(ILE_Receipt."Location Code",LocCodeText)
                    ELSE
                      ILE_Receipt.SETFILTER(ILE_Receipt."Location Code",LocFilter);
                    //CCIT-PRI-280318
                    
                    
                    LocCode := ILE_Receipt.GETFILTER(ILE_Receipt."Location Code");
                    
                    //ItemNoFilter := ILE_Receipt".GETFILTER(ILE_Receipt."Item No.");
                    
                    MakeExcelDataHeader;*/

                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecLoc.GET(ILE_Shipment."Location Code") THEN BEGIN
                    IF RecLoc."Use As In-Transit" = TRUE THEN
                        CurrReport.SKIP;
                END;

                ERP_TI_Qty_PCS := 0;
                IF RecItem2.GET(ILE_Shipment."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            ERP_TI_Qty_PCS := ABS(ILE_Shipment.Quantity) / RecUOM.Weight;
                        END
                    END
                END;

                TransportVendor := '';
                LRNumber := '';
                EWayBillNO := '';
                LRDate := 0D;
                TransportMode := '';
                VehicleNo := '';
                TypeOfVehicle := '';
                RecTransShipHeader.RESET;
                RecTransShipHeader.SETRANGE(RecTransShipHeader."No.", ILE_Shipment."Document No.");
                IF RecTransShipHeader.FINDFIRST THEN BEGIN
                    TransportVendor := RecTransShipHeader."Transport Vendor";
                    EWayBillNO := RecTransShipHeader."E-Way Bill No.";
                    EWayBillDate := RecTransShipHeader."E-Way Bill Date";
                    TransportMode := RecTransShipHeader."Mode of Transport";
                    LRNumber := RecTransShipHeader."LR/RR No.";
                    LRDate := RecTransShipHeader."LR/RR Date";
                    VehicleNo := RecTransShipHeader."Vehicle No.";

                    VehReportDate := RecTransShipHeader."Vehicle Reporting Date";
                    VehReportTime := RecTransShipHeader."Vehicle Reporting Time";
                    VehReleaseTime := RecTransShipHeader."Vehicle Release Time";

                    // MESSAGE('%1',TransportMode);
                END;

                value := 0;
                IGST := 0;
                TotalValue := 0;
                RecTransShipLine.RESET;
                RecTransShipLine.SETRANGE(RecTransShipLine."Document No.", ILE_Shipment."Document No.");
                RecTransShipLine.SETRANGE(RecTransShipLine."Item No.", ILE_Shipment."Item No.");
                IF RecTransShipLine.FINDFIRST THEN BEGIN
                    value := RecTransShipLine."Unit Price" * ABS(ILE_Shipment.Quantity);
                    IGST := 0;//(value * RecTransShipLine."GST %")/100; //PCPL/MIG/NSW Filed not Exist in BC18
                    TotalValue := value + IGST;
                END;

                cnt := 1;

                MakeExcelDataBody_Shipment;

                AllInTransit := TRUE;
                RecILE.RESET;
                RecILE.SETRANGE(RecILE."Document Type", RecILE."Document Type"::"Transfer Receipt");
                //RecILE.SETRANGE(RecILE."Posting Date",ILE_Shipment."Posting Date");
                RecILE.SETRANGE(RecILE."Item No.", ILE_Shipment."Item No.");
                RecILE.SETRANGE(RecILE."Order No.", ILE_Shipment."Order No.");
                //RecILE.SETRANGE(RecILE."Lot No.",ILE_Shipment."Lot No.");//tk
                IF RecILE.FINDFIRST THEN BEGIN
                    REPEAT
                        IF RecLoc.GET(RecILE."Location Code") THEN
                            IF NOT RecLoc."Use As In-Transit" THEN
                                AllInTransit := FALSE;
                    UNTIL RecILE.NEXT = 0;
                    IF AllInTransit THEN
                        ExcelBuf.NewRow;
                END ELSE
                    ExcelBuf.NewRow;

            end;

            trigger OnPreDataItem();
            begin
                //"Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date",Fromdate,ToDate);
                IF (Fromdate <> 0D) AND (ToDate <> 0D) THEN
                    ILE_Shipment.SETRANGE(ILE_Shipment."Posting Date", Fromdate, ToDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; Fromdate)
                {
                }
                field("To Date"; ToDate)
                {
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
        MakeExcelDataHeader;
    end;

    var
        InLoc: Record 14;
        OutLoc: Record 14;
        ExcelBuf: Record 370;
        Fromdate: Date;
        ToDate: Date;
        RecLoc: Record 14;
        RecILE: Record 32;
        RecILE1: Record 32;
        cnt: Integer;
        VarianceInKG: Decimal;
        RecTransShipLine: Record 5745;
        value: Decimal;
        IGST: Decimal;
        TotalValue: Decimal;
        RecTransShipHeader: Record 5744;
        TransportVendor: Text[200];
        LRNumber: Code[20];
        LRDate: Date;
        VehicleNo: Code[20];
        TypeOfVehicle: Text[50];
        TransportMode: Code[20];
        AllInTransit: Boolean;
        GRNQtyPCS: Decimal;
        VarianceQtyPCS: Decimal;
        RecItem2: Record 27;
        RecUOM: Record 5404;
        ERP_TI_Qty_PCS: Decimal;
        ItemNo: Code[20];
        DoceNo: Code[20];
        TxtShorting: Text;
        RecILESort: Record 32;
        GrnQuantityKg: Decimal;
        GRNQUantityPcs1: Decimal;
        ILEReceiptQty: Decimal;
        EWayBillNO: Code[20];
        EWayBillDate: Date;
        RecUserBranch: Record 50029;
        LocCode1: Code[1024];
        LocCodeText: Text[1024];
        LocFilter: Code[50];
        LocCode: Text[250];
        VehReportDate: Date;
        VehReportTime: Time;
        VehReleaseTime: Time;
        PrvRcpt: Code[20];
        PrvShpt: Code[20];
        RecTransRcpt: Record 5746;
        RecILE123: Record 32;
        FromLocation: Record 14;
        ToLocation: Record 14;
        IGST2: Decimal;
        RecTransRcptLine: Record 5747;
        valuercpt: Decimal;
        IGSTRcpt: Decimal;
        TotalValueRcpt: Decimal;
        IGST2rcpt: Decimal;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Transfer GRN Register', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date :' + FORMAT(Fromdate) + '  To  ' + FORMAT(ToDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //Header For Shipment
        ExcelBuf.NewRow;
        //ExcelBuf.AddColumn('Entry No.',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code Out', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code Out - GST Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//ccit-tk
        ExcelBuf.AddColumn('TO Order No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Month - As per Shipment Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//CCIT-TK
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('E-way Bill Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('E-way Bill Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('TI Batch', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TI Mfg Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TI Exp. Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP TI QTY-PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP TI QTY-KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Transport Mode', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Transport Vendor', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('LR Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('LR Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vehicle Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vehicle Reporting Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vehicle Reporting Time', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vehicle Release Time', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn('Type of Vehicle',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CGST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('SGST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('IGST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Total Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('Fill Rate In Kg',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);

        // Header for receipt
        //ExcelBuf.AddColumn('Receipt Entry No',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code IN', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code IN - GST Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn('ERP GRN No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP GRN Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Month - As per GRN Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn('GRN Qty-PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Qty-KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn('GRN CGST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN SGST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN IGST', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN Total Value', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn('Variance in PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Variance in KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Actual Batch', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Actual MFG Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Actual EXP Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //121019 -
        ExcelBuf.AddColumn('Vehicle Reporting Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vehicle Reporting Time', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vehicle Release Time', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //121019 +
        ExcelBuf.NewRow;
    end;

    procedure MakeExcelDataBody_Shipment();
    begin

        //For Shipment
        //ExcelBuf.NewRow;
        //ExcelBuf.AddColumn(ILE_Shipment."Entry No.",FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Shipment."Location Code", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF OutLoc.GET(ILE_Shipment."Location Code") THEN;//CCIT_TK
        ExcelBuf.AddColumn(OutLoc."GST Registration No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn(ILE_Shipment."Order No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Shipment."Document No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Shipment."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(FORMAT(DATE2DMY(ILE_Shipment."Posting Date", 2)) + '-' + FORMAT(DATE2DMY(ILE_Shipment."Posting Date", 3)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn(ILE_Shipment."Item No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Shipment."Item Description", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(EWayBillNO, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(EWayBillDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);

        ExcelBuf.AddColumn(ILE_Shipment."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Shipment."Manufacturing Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(ILE_Shipment."Expiration Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(ROUND(ERP_TI_Qty_PCS, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ABS(ILE_Shipment.Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(TransportMode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TransportVendor, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LRNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(LRDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(VehicleNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(VehReportDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(VehReportTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.AddColumn(VehReleaseTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(value, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(IGST, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(ROUND(TotalValue, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);

    end;

    procedure CreateExcelBook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('Daily Sales Report','',COMPANYNAME,USERID);
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Transfer GRN Register.xlsx', 'Transfer GRN Register', 'Transfer GRN Register', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Transfer GRN Register.xlsx', 'Transfer GRN Register', 'Transfer GRN Register', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
        ERROR('');
    end;

    procedure MakeExcelDataBody_Receipt();
    begin

        //For Shipment
        IF cnt <> 1 THEN BEGIN

            MakeExcelDataBody_Shipment; // rdk 091019
                                        /*
                                        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);

                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);

                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);

                                        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                        */
        END;
        // For Receipt
        //ExcelBuf.AddColumn(ILE_Receipt."Entry No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Receipt."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF InLoc.GET(ILE_Receipt."Location Code") THEN;
        ExcelBuf.AddColumn(InLoc."GST Registration No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Receipt."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Receipt."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(FORMAT(DATE2DMY(ILE_Receipt."Posting Date", 2)) + '-' + FORMAT(DATE2DMY(ILE_Receipt."Posting Date", 3)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//CCIT_TK
        ExcelBuf.AddColumn(ROUND(ILEReceiptQty, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

        IF ABS(GrnQuantityKg) = 0 THEN
            ExcelBuf.AddColumn(ABS(ILE_Shipment.Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number)//CCIT-15092021
        ELSE
            ExcelBuf.AddColumn((ABS(GrnQuantityKg)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-15092021
        ExcelBuf.AddColumn(ROUND(valuercpt, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(IGSTRcpt, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(TotalValueRcpt, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-TK

        //ExcelBuf.AddColumn((ABS(ILE_Receipt.Quantity)),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//CCIT-15092021
        ExcelBuf.AddColumn(ROUND(VarianceQtyPCS, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//CCIT-15092021
                                                                                                                          //ExcelBuf.AddColumn(GRNQUantityPcs1,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                                                                                                          //CCIT-15092021
                                                                                                                          /*
                                                                                                                          IF cnt = 1 THEN//CCIT_TK
                                                                                                                            //ExcelBuf.AddColumn((ABS(ILE_Shipment.Quantity) - ILE_Receipt.Quantity),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
                                                                                                                        //vikas   ExcelBuf.AddColumn((ABS(ILE_Shipment.Quantity) - GRNQUantityPcs1),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)//tk
                                                                                                                       //     ExcelBuf.AddColumn(50,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)//tk

                                                                                                                         ExcelBuf.AddColumn((ABS(ILE_Receipt.Quantity)),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)//tk
                                                                                                                          ELSE
                                                                                                                            ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);//CCIT_TK
                                                                                                                          IF cnt = 1 THEN
                                                                                                                             //ExcelBuf.AddColumn(ROUND(VarianceQtyPCS,0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
                                                                                                                             ExcelBuf.AddColumn(ROUND(VarianceQtyPCS,0.01),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)//tk
                                                                                                                          ELSE
                                                                                                                             ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                                                                                                                             */ //CCIT-15092021
        ExcelBuf.AddColumn(GRNQUantityPcs1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        //     ExcelBuf.AddColumn(25,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        /* IF cnt = 1 THEN
           //ExcelBuf.AddColumn((ABS(ILE_Shipment.Quantity) - ILE_Receipt.Quantity),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)
           ExcelBuf.AddColumn((ABS(ILE_Shipment.Quantity) - GRNQUantityPcs1),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number)//tk
         ELSE
           ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);*/
        //ExcelBuf.AddColumn(VarianceInKG,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ILE_Shipment."Actual Batch", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ILE_Shipment."Actual MFG Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(ILE_Shipment."Actual EXP Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        // 121019 -
        ExcelBuf.AddColumn(VehReportDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(VehReportTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.AddColumn(VehReleaseTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        // 121019 +
        ExcelBuf.NewRow;


    end;
}

