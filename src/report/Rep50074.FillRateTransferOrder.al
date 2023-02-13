report 50074 "Fill Rate Transfer Order"
{
    // version CCIT-Fortune-SG

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0));

                trigger OnAfterGetRecord();
                begin
                    Reason_Desc := '';
                    RecPostInvPickHeader.RESET;
                    RecPostInvPickHeader.SETRANGE(RecPostInvPickHeader."Source No.", "Transfer Shipment Header"."No.");
                    IF RecPostInvPickHeader.FINDFIRST THEN BEGIN
                        RecPostInvPickLine.RESET;
                        RecPostInvPickLine.SETRANGE(RecPostInvPickLine."No.", RecPostInvPickHeader."No.");
                        RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Item No.", "Transfer Shipment Line"."Item No.");
                        IF RecPostInvPickLine.FINDSET THEN
                            REPEAT
                                IF RecResonCode.GET(RecPostInvPickLine."Reason Code") THEN
                                    Reason_Desc := RecResonCode.Description;
                            UNTIL RecPostInvPickLine.NEXT = 0;
                    END;
                    MakeExcelDataBody;
                end;
            }

            trigger OnPreDataItem();
            begin
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Transfer Shipment Header".SETRANGE("Transfer Shipment Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Transfer Shipment Header".SETRANGE("Transfer Shipment Header"."Posting Date", 99990101D, AsOnDate);

                MakeExcelDataHeader;
            end;
        }
        dataitem("Transfer Header"; "Transfer Header")
        {
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Qty. to Ship" = FILTER(<> 0),
                                          "Completely Shipped" = FILTER(false));

                trigger OnAfterGetRecord();
                begin
                    IF RecResonCode1.GET("Transfer Line"."Reason Code") THEN BEGIN
                        Reason_Desc1 := RecResonCode1.Description;
                    END;

                    //IF txtqty<>"Transfer Line".Quantity THEN BEGIN
                    MakeExcelDataBody1;
                    //txtqty := "Transfer Shipment Line".Quantity;
                    //END;
                end;
            }

            trigger OnPreDataItem();
            begin
                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Transfer Header".SETRANGE("Transfer Header"."Order Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Transfer Header".SETRANGE("Transfer Header"."Order Date", 99990101D, AsOnDate);

                MakeExcelDataHeader1;
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

    trigger OnPostReport();
    begin
        CreateExcelbook;
    end;

    var
        Document_Type: Option " ",Invoice,"Credit Note";
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        Reason_Desc: Text[1024];
        RecPostInvPickLine: Record 7343;
        RecResonCode: Record 231;
        RecPostInvPickHeader: Record 7342;
        RecResonCode1: Record 231;
        Reason_Desc1: Text[1024];
        MonthDateChr: Text[50];
        txtqty: Decimal;
        rectsl: Record 5745;

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Fill Rate Transfer.xlsx', 'Fill Rate Transfer', 'Fill Rate Transfer', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Fill Rate Transfer.xlsx', 'Fill Rate Transfer', 'Fill Rate Transfer', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Fill Rate Transfer', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code Out', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code IN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO Order No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO DATE ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO Time', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO ORDER QTY - KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO ORDER VALUE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Inv Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv Time', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP TI QTY-KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate - KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Fill Rate - Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Transfer-from Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Transfer-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Header"."Transfer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MonthDateChr := FORMAT("Transfer Shipment Header"."Posting Date", 0, '<Month Text>-<Year>');//10-04-2019
        ExcelBuf.AddColumn(MonthDateChr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10-04-2019
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Header"."Transfer Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Transfer Shipment Header"."Order Time", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        ExcelBuf.AddColumn("Transfer Shipment Line"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ROUND("Transfer Shipment Line"."TO Order QTY", 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Transfer Shipment Line"."TO Order Value", 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Transfer Shipment Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Transfer Shipment Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Transfer Shipment Header"."Inv Time", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.AddColumn("Transfer Shipment Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Transfer Shipment Line".Amount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        IF "Transfer Shipment Line"."TO Order QTY" <> 0 THEN
            ExcelBuf.AddColumn(FORMAT(ROUND(("Transfer Shipment Line".Quantity / "Transfer Shipment Line"."TO Order QTY") * 100, 0.01, '=')) + ' %', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF "Transfer Shipment Line"."TO Order Value" <> 0 THEN
            ExcelBuf.AddColumn(FORMAT(ROUND(("Transfer Shipment Line".Amount / "Transfer Shipment Line"."TO Order Value") * 100, 0.01, '=')) + ' %', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Reason_Desc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelInfo1();
    begin
    end;

    procedure CreateExcelbook1();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\Fill Rate Transfer.xlsx', 'Fill Rate Transfer', 'Fill Rate Transfer', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\Fill Rate Transfer.xlsx', 'Fill Rate Transfer', 'Fill Rate Transfer', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader1();
    begin
        /*ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Document Type',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code Out',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Branch Code IN',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO Order No.',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO DATE ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO Time',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        ExcelBuf.AddColumn('Item Code',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Name',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO ORDER QTY - KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TO ORDER VALUE',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv Number',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        ExcelBuf.AddColumn('Inv Date',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Inv Time',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ERP TI QTY-KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Value',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Fill Rate - KGS',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        
        ExcelBuf.AddColumn('Fill Rate - Value',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reason Code ',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        */

    end;

    procedure MakeExcelDataBody1();
    begin
        ExcelBuf.NewRow;
        IF "Transfer Line".Quantity <> "Transfer Line"."Quantity Shipped" THEN
            ExcelBuf.AddColumn('Order', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."Transfer-from Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."Transfer-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MonthDateChr := FORMAT("Transfer Header"."Order Date", 0, '<Month Text>-<Year>');//10-04-2019
        ExcelBuf.AddColumn(MonthDateChr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10-04-2019
                                                                                                         //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Transfer Header"."Order Time", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);

        ExcelBuf.AddColumn("Transfer Line"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(ROUND("Transfer Line".Quantity,0.01,'='),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND("Transfer Line"."Outstanding Quantity", 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(ROUND(("Transfer Line"."Outstanding Quantity" * "Transfer Line"."Transfer Price"), 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        IF "Transfer Shipment Line"."TO Order QTY" <> 0 THEN
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF "Transfer Shipment Line"."TO Order Value" <> 0 THEN
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Reason_Desc1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;
}

