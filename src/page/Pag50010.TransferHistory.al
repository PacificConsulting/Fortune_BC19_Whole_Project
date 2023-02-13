page 50010 "Transfer History"
{
    PageType = List;
    SourceTable = "Transfer Shipment Line";
    SourceTableView = WHERE(Quantity = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Branch Code Out"; "Transfer-from Code")
                {
                    CaptionML = ENU = 'Branch Code Out',
                                ENN = 'Transfer-to Code';
                    ApplicationArea = all;
                }
                field("Branch Code Out - GST Number"; Location."GST Registration No.")
                {
                    ApplicationArea = all;
                }
                field("TO Order No."; "Transfer Order No.")
                {
                    CaptionML = ENU = 'TO Order No.',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("Inv Number"; "Document No.")
                {
                    CaptionML = ENU = 'Inv Number',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("Inv Date"; TransferShipmentHeader."Posting Date")
                {
                    CaptionML = ENU = 'Inv Date',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("Month - As per Posting Date"; FORMAT(DATE2DMY(TransferShipmentHeader."Posting Date", 2)) + '-' + FORMAT(DATE2DMY(TransferShipmentHeader."Posting Date", 3)))
                {
                    Caption = 'Month - As per Shipment Posting Date';
                    ApplicationArea = all;
                }
                field("Item Code"; "Item No.")
                {
                    CaptionML = ENU = 'Item Code',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("GST Group Code"; "GST Group Code")
                {
                    ApplicationArea = all;
                }
                field("HSN/SAC Code"; "HSN/SAC Code")
                {
                    ApplicationArea = all;
                }
                field("Item Name"; Description)
                {
                    CaptionML = ENU = 'Item Name',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("ERP TI QTY-KGS"; Quantity)
                {
                    CaptionML = ENU = 'ERP TI QTY-KGS',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field(Value; "Unit Price" * Quantity)
                {
                    CaptionML = ENU = 'Value',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field(CGST; CSGSTValue)
                {
                    CaptionML = ENU = 'CGST',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field(SGST; SGSTVALUE)
                {
                    CaptionML = ENU = 'SGST',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field(IGST; IGST)
                {
                    CaptionML = ENU = 'IGST',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("Total Value"; TotalValue)
                {
                    CaptionML = ENU = 'Total Value',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("Branch Code IN"; TransferReceiptLine."Transfer-to Code")
                {
                    Caption = 'Branch Code IN';
                    ApplicationArea = all;
                }
                field("Branch Code IN - GST Number"; Location1."GST Registration No.")
                {
                    Caption = 'Branch Code IN - GST Number';
                    ApplicationArea = all;
                }
                field("ERP GRN No"; TransferReceiptLine."Document No.")
                {
                    CaptionML = ENU = 'ERP GRN No',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("ERP GRN Date"; TransferRecDate)
                {
                    CaptionML = ENU = 'ERP GRN Date',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("Month - As per GRN Date"; transferRecDM)
                {
                    ApplicationArea = all;
                }
                field("GRN Qty-KG"; TransferReceiptLine.Quantity)
                {
                    CaptionML = ENU = 'GRN Qty-KG',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("GRN Value"; TransferReceiptLine.Quantity * TransferReceiptLine."Unit Price")
                {
                    CaptionML = ENU = 'GRN Value',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("GRN CGST"; CSGSTValue1)
                {
                    CaptionML = ENU = 'GRN CGST',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("GRN SGST"; SGSTVALUE)
                {
                    CaptionML = ENU = 'GRN SGST',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("GRN IGST"; IGST1)
                {
                    CaptionML = ENU = 'GRN IGST',
                                ENN = 'Document No.';
                    ApplicationArea = all;
                }
                field("GRN Total Value"; TotalValue1)
                {
                    Caption = 'GRN Total Value';
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        ClearData;
        Location.RESET;
        IF Location.GET("Transfer-to Code") THEN;
        TransferShipmentHeader.RESET;
        IF TransferShipmentHeader.GET("Document No.") THEN;
        FLocation.RESET;
        TLocation.RESET;
        IF FLocation.GET("Transfer-from Code") THEN
            IF TLocation.GET("Transfer-to Code") THEN
                IF FLocation."State Code" <> TLocation."State Code" THEN BEGIN
                    //IF "Total GST Amount" <> 0 THEN BEGIN Transfer Shipment Line
                    IGST := 0;//((Quantity * "Unit Price") * "GST %")/100; Transfer Shipment Line
                    TotalValue := ((Quantity * "Unit Price") + IGST)
                    //END; Transfer Shipment Line
                END;



        FLocation.RESET;
        TLocation.RESET;
        IF FLocation.GET("Transfer-from Code") THEN
            IF TLocation.GET("Transfer-to Code") THEN
                IF FLocation."State Code" = TLocation."State Code" THEN BEGIN
                    //IF "Total GST Amount" <> 0 THEN BEGIN  /* //PCPL/MIG/NSW Filed not Exist in BC18
                    CSGSTValue := ((Quantity * "Unit Price")) * 0;//("GST %"/2)/100; //PCPL/MIG/NSW Filed not Exist in BC18
                    SGSTVALUE := ((Quantity * "Unit Price")) * 0;//("GST %"/2)/100; //PCPL/MIG/NSW Filed not Exist in BC18
                                                                 //END; Transfer Shipment Line
                    TotalValue := ((Quantity * "Unit Price") + (CSGSTValue + SGSTVALUE));

                END;

        TransferReceiptHeader.RESET;
        TransferReceiptHeader.SETRANGE("Transfer Order No.", "Transfer Order No.");
        IF TransferReceiptHeader.FINDFIRST THEN BEGIN
            transferRecDM := FORMAT(DATE2DMY(TransferReceiptHeader."Posting Date", 2)) + '-' + FORMAT(DATE2DMY(TransferReceiptHeader."Posting Date", 3));
            TransferRecDate := FORMAT(TransferReceiptHeader."Posting Date");
            TransferReceiptLine.RESET;
            TransferReceiptLine.SETRANGE("Transfer Order No.", "Transfer Order No.");
            TransferReceiptLine.SETRANGE("Item No.", "Item No.");
            TransferReceiptLine.SETFILTER(Quantity, '<>%1', 0);
            IF TransferReceiptLine.FINDFIRST THEN BEGIN

                Location1.RESET;
                IF Location1.GET(TransferReceiptLine."Transfer-to Code") THEN;


                FLocation1.RESET;
                TLocation1.RESET;
                IF FLocation1.GET(TransferReceiptLine."Transfer-from Code") THEN
                    IF TLocation1.GET(TransferReceiptLine."Transfer-to Code") THEN
                        IF FLocation1."State Code" <> TLocation1."State Code" THEN BEGIN
                            //IF TransferReceiptLine."Total GST Amount" <> 0 THEN BEGIN //PCPL/MIG/NSW Filed not Exist in BC18
                            IGST1 := ((TransferReceiptLine.Quantity * TransferReceiptLine."Unit Price") * 0/*TransferReceiptLine."GST %"*/) / 100; //PCPL/MIG/NSW Filed not Exist in BC18
                                                                                                                                                   //END;
                            TotalValue1 := ((TransferReceiptLine.Quantity * TransferReceiptLine."Unit Price") + IGST1)
                        END;




                FLocation1.RESET;
                TLocation1.RESET;
                IF FLocation1.GET(TransferReceiptLine."Transfer-from Code") THEN
                    IF TLocation1.GET(TransferReceiptLine."Transfer-to Code") THEN
                        IF FLocation1."State Code" = TLocation1."State Code" THEN BEGIN
                            //IF TransferReceiptLine."Total GST Amount" <> 0 THEN BEGIN //PCPL/MIG/NSW Filed not Exist in BC18
                            /*
                          CSGSTValue1 := ((TransferReceiptLine.Quantity * TransferReceiptLine."Unit Price")) *
                           (TransferReceiptLine."GST %"/2)/100;
                          SGSTVALUE1 := ((TransferReceiptLine.Quantity * TransferReceiptLine."Unit Price")) *

                            (TransferReceiptLine."GST %"/2)/100;*/
                            // END; //PCPL/MIG/NSW Filed not Exist in BC18
                            TotalValue1 := ((TransferReceiptLine.Quantity * TransferReceiptLine."Unit Price") + (CSGSTValue1 + SGSTVALUE1));
                        END;
            END;
        END;


    end;

    var
        TransferReceiptHeader: Record 5746;
        TransferReceiptLine: Record 5747;
        Location: Record 14;
        Location1: Record 14;
        TransferShipmentHeader: Record 5744;
        FLocation: Record 14;
        TLocation: Record 14;
        FLocation1: Record 14;
        TLocation1: Record 14;
        IGST: Decimal;
        SGSTVALUE: Decimal;
        CSGSTValue: Decimal;
        TotalValue: Decimal;
        IGST1: Decimal;
        SGSTVALUE1: Decimal;
        CSGSTValue1: Decimal;
        TotalValue1: Decimal;
        TransferRecDate: Text;
        transferRecDM: Text;

    local procedure ClearData();
    begin
        CLEAR(transferRecDM);
        CLEAR(TransferRecDate);
        CLEAR(TransferReceiptLine);
        CLEAR(TransferReceiptHeader);
        CLEAR(Location);
        CLEAR(TransferShipmentHeader);
        CLEAR(FLocation);
        CLEAR(TLocation);
        CLEAR(IGST);
        CLEAR(TotalValue);
        CLEAR(SGSTVALUE);
        CLEAR(CSGSTValue);
        CLEAR(FLocation);
        CLEAR(TLocation);
        CLEAR(FLocation1);
        CLEAR(TLocation1);
        CLEAR(IGST1);
        CLEAR(TotalValue1);
        CLEAR(Location1);
        CLEAR(SGSTVALUE1);
        CLEAR(CSGSTValue1);
        CLEAR(FLocation1);
        CLEAR(TLocation1);
    end;
}

