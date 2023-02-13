codeunit 50006 "Sales Post Events"
{
    trigger OnRun()
    begin
        //***** Codunit Inculded in 8,80,82,370,900,5704,6620,7000,7301,7302,7307,7321,7323,99000830,99000831,99000831,************
    end;
    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-80 Sales-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertInvoiceHeader', '', false, false)]
    local procedure OnAfterInsertInvoiceHeader(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    begin
        SalesInvHeader."Invoice Time" := Time;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforeInsertShipmentLine', '', false, false)]
    local procedure OnPostSalesLineOnBeforeInsertShipmentLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var IsHandled: Boolean; SalesLineACY: Record "Sales Line"; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35])
    begin
        SalesLine."Quantity Shipped In KG" := SalesLine."Conversion Qty";//CCIT-SD-09-01-2018
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', false, false)]
    local procedure OnAfterPostSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var SalesInvLine: Record "Sales Invoice Line"; var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var xSalesLine: Record "Sales Line")
    begin
        //CCIT-SG-05032018
        IF (xSalesLine."Document Type" = xSalesLine."Document Type"::"Credit Memo") AND (xSalesLine."Quarantine Qty In KG" <> 0) THEN
            UpdateQuarantineQtyinJnl(xSalesLine);
        //CCIT-SG-05032018 -
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', false, false)]
    local procedure OnAfterPostSalesLines(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        with TempSalesLineGlobal do begin
            //JAGA
            //CCIT-JAGA -
            IF ("Document Type" = "Document Type"::"Credit Memo") THEN BEGIN //AND ("Quarantine Qty In KG" <> 0) THEN BEGIN
                ItemJournalLine.RESET;
                ItemJournalLine.SETRANGE("Journal Template Name", 'TRANSFER');
                ItemJournalLine.SETRANGE("Journal Batch Name", 'DEFAULT');
                ItemJournalLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                ItemJournalLine.SETFILTER(Quantity, '<>%1', 0);
                IF ItemJournalLine.FINDFIRST THEN
                    REPEAT
                        PostQuarantineQtytoILE(ItemJournalLine);
                    UNTIL ItemJournalLine.NEXT = 0;
            END;
        end;
        //CCIT-JAGA +
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostUpdateOrderLineModifyTempLine', '', false, false)]
    local procedure OnBeforePostUpdateOrderLineModifyTempLine(var TempSalesLine: Record "Sales Line" temporary; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    begin
        TempSalesLine."Quantity Shipped In KG" := TempSalesLine."Quantity Shipped In KG" + TempSalesLine."Qty. to Ship In KG";//CCIT-SD-09-01-2018
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostUpdateInvoiceLineOnBeforeInitQtyToInvoice', '', false, false)]
    local procedure OnPostUpdateInvoiceLineOnBeforeInitQtyToInvoice(var SalesOrderLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        TempSalesLine.VALIDATE("Qty. to Invoice In KG",
    TempSalesLine."Quantity Shipped In KG" - TempSalesLine."Quantity Invoiced In KG");//CCIT-SD-09-01-2017
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
        CompanyInfo: Record "Company Information";
        SalesInvHeader: Record "Sales Invoice Header";
    begin

        with SalesHeader do begin
            /* //PCPL/MIGNSW
            CompanyInfo.GET();
            if SalesInvHeader.get(SalesInvHdrNo) then;
            IF CompanyInfo."Auto IRN Generation" = TRUE THEN BEGIN
                //IF cu_GSTMgmt.IsGSTApplicable(SalesInvHeader.Structure) THEN BEGIN //PCPL/MIG/NSW
                IF SalesInvHeader."GST Customer Type" IN
                 [SalesInvHeader."GST Customer Type"::Unregistered,
                  SalesInvHeader."GST Customer Type"::" "] THEN
                    i := 0
                ELSE
                    ; //PCPL/MIG/NSW Semicolon add

                //cu_GSTInvoice.GenerateIRNPayload(SalesInvHeader, TRUE, recSalesCrMemoHeader);//CITS_RS 220121 //PCPL/MIG/NSW
                //END;//CCIT-06032021 vivek //PCPL/MIG/NSW
           
            END;
           */ //PCPL/MIGNSW  
            //CCIT-JAGA
            IF ("Document Type" = "Document Type"::Order) THEN
                MESSAGE('Sales Invoice has been posted with Posted Sales Invoice No. : %1 and Shipment No. : %2', SalesInvHeader."No.", SalesShptHdrNo);
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
                MESSAGE('Credit Memo has been posted with Posted Credit Memo Order No. : %1', SalesCrMemoHdrNo);
            IF "Document Type" = "Document Type"::Invoice THEN
                MESSAGE('Sales Invoice has been posted with Posted Sales Invoice No. : %1', SalesShptHdrNo);
            IF "Document Type" = "Document Type"::"Return Order" THEN
                MESSAGE('Return Order has been posted with Posted Return Order No. : %1 And Credit Memo No. : %2', RetRcpHdrNo, SalesCrMemoHdrNo);
            //CCIT-JAGA
            //   cu_GSTInvoice.GenerateIRNPayload(SalesInvHeader,TRUE,recSalesCrMemoHeader);//CITS_RS 220121
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemJnlLineOnAfterPrepareItemJnlLine', '', false, false)]
    local procedure OnPostItemJnlLineOnAfterPrepareItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    var
        RecItem2: Record 27;
        RecUOM1: Record 5404;
    //ItemJournalLine: Record 83;
    begin
        //CCIT-SG
        ItemJournalLine.FOC := SalesLine.FOC;
        ItemJournalLine."Fill Rate %" := SalesLine."Fill Rate %";
        ItemJournalLine."Sales Category" := SalesLine."Sales Category";
        ItemJournalLine."Conversion UOM" := SalesLine."Conversion UOM";
        ItemJournalLine.Weight := SalesLine.Weight;
        ItemJournalLine."Storage Categories" := SalesLine."Storage Categories";
        ItemJournalLine."Conversion Qty" := -SalesLine."Conversion Qty";
        ItemJournalLine."Quarantine Qty In KG" := SalesLine."Quarantine Qty In KG";//CCIT-SD
        ItemJournalLine."BL/AWB No." := SalesHeader."BL/AWB No.";
        ItemJournalLine."BL Date" := SalesHeader."BL Date";
        ItemJournalLine."In-Bond Bill of Entry No." := SalesHeader."In-Bond Bill of Entry No.";
        ItemJournalLine."In-Bond BOE Date" := SalesHeader."In-Bond BOE Date";
        ItemJournalLine."Bond Number" := SalesHeader."Bond Number";
        ItemJournalLine."Bond Sr.No." := SalesHeader."Bond Sr.No.";
        ItemJournalLine."Bond Date" := SalesHeader."Bond Date";
        ItemJournalLine."Ex-bond BOE No." := SalesHeader."Ex-bond BOE No.";
        ItemJournalLine."Ex-bond BOE Date" := SalesHeader."Ex-bond BOE Date";
        ItemJournalLine."Ex-bond BOE No.1" := SalesHeader."Ex-bond BOE No.1";
        ItemJournalLine."Ex-bond BOE Date 1" := SalesHeader."Ex-bond BOE Date 1";
        ItemJournalLine."Ex-bond BOE No.2" := SalesHeader."Ex-bond BOE No.2";
        ItemJournalLine."Ex-bond BOE Date 2" := SalesHeader."Ex-bond BOE Date 2";
        ItemJournalLine."Ex-bond BOE No.3" := SalesHeader."Ex-bond BOE No.3";
        ItemJournalLine."Ex-bond BOE Date 3" := SalesHeader."Ex-bond BOE Date 3";
        ItemJournalLine."Ex-bond BOE No.4" := SalesHeader."Ex-bond BOE No.4";
        ItemJournalLine."Ex-bond BOE Date 4" := SalesHeader."Ex-bond BOE Date 4";
        ItemJournalLine."Ex-bond BOE No.5" := SalesHeader."Ex-bond BOE No.5";
        ItemJournalLine."Ex-bond BOE Date 5" := SalesHeader."Ex-bond BOE Date 5";
        ItemJournalLine."Ex-bond BOE No.6" := SalesHeader."Ex-bond BOE No.6";
        ItemJournalLine."Ex-bond BOE Date 6" := SalesHeader."Ex-bond BOE Date 6";
        ItemJournalLine."Ex-bond BOE No.7" := SalesHeader."Ex-bond BOE No.7";
        ItemJournalLine."Ex-bond BOE Date 7" := SalesHeader."Ex-bond BOE Date 7";
        ItemJournalLine."Ex-bond BOE No.8" := SalesHeader."Ex-bond BOE No.8";
        ItemJournalLine."Ex-bond BOE Date 8" := SalesHeader."Ex-bond BOE Date 8";
        ItemJournalLine."Ex-bond BOE No.9" := SalesHeader."Ex-bond BOE No.9";
        ItemJournalLine."Ex-bond BOE Date 9" := SalesHeader."Ex-bond BOE Date 9";
        ItemJournalLine."Customer License No." := SalesLine."Customer License No.";
        ItemJournalLine."Customer License Name" := SalesLine."Customer License Name";
        ItemJournalLine."Customer License Date" := SalesLine."Customer License Date";
        //CCIT-SG

        //CCIT-SD-12-01-2018 -
        IF RecItem2.GET(SalesLine."No.") THEN BEGIN
            IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                IF (RecUOM1.Weight <> 0) THEN BEGIN
                    ItemJournalLine."Conversion Qty" := ItemJournalLine.Quantity / RecUOM1.Weight;
                    ItemJournalLine."Quantity (Base) In KG" := ItemJournalLine.Quantity / RecUOM1.Weight;
                END
            END
        END;
        //CCIT-SD-12-01-2018 +
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        with SalesHeader do begin
            GenJnlLine."Vertical Category" := "Vertical Category";  //CCIT-SG
            GenJnlLine."Vertical Sub Category" := "Vertical Sub Category";  //CCIT-SG
            GenJnlLine."Outlet Area" := "Outlet Area";  //CCIT-SG
            GenJnlLine."Business Format / Outlet Name" := "Business Format / Outlet Name";  //CCIT-SG
                                                                                            //GenJnlLine2."License No." := "License No.";  //CCIT-SG
        end;
    end;
    //<<PCPL/MIG/NSW New Below Event Craeted we need  SalesCrMemoHdr."No." for one  CreateItemJournalLineForQuaratineQty function
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertPostedHeaders', '', false, false)]
    local procedure OnAfterInsertPostedHeaders(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHdr: Record "Sales Cr.Memo Header"; var ReceiptHeader: Record "Return Receipt Header")
    begin
        Clear(SalesCrMemoHeaderNo);
        SalesCrMemoHeaderNo := SalesCrMemoHdr."No."
    end;
    //>>PCPL/MIG/NSW

    //<<PCPL/MIG/NSW New Event add for need TempTrackingSpecification Variable from 80 Codeunit Function 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemJnlLineOnBeforePostItemJnlLineWhseLine', '', false, false)]
    local procedure OnPostItemJnlLineOnBeforePostItemJnlLineWhseLine(var ItemJnlLine: Record "Item Journal Line"; var TempWhseJnlLine: Record "Warehouse Journal Line" temporary; var TempWhseTrackingSpecification: Record "Tracking Specification" temporary; var TempTrackingSpecification: Record "Tracking Specification" temporary; var IsHandled: Boolean; SalesLine: Record "Sales Line")
    begin
        TempTrackingSpecification := TempTrackingSpecification
    end;
    //>>PCPL/MIG/NSW


    LOCAL PROCEDURE "-----------CCIT-SG---------------"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateItemJournalLineForQuaratineQty(lRecSL: Record 37; lQuan_Loc: Code[10]);
    VAR
        ItemJournalBatch: Record 233;
        NoSeriesManagement: Codeunit 396;
        DocNo: Code[20];
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        LineNo: Integer;
        CreateReservEntry: Codeunit 99000830;
        ItemJournalLine: Record 83;
        RecTrakingSpecification: Record 337;
        ForReservEntry: record "Reservation Entry";
    BEGIN
        LineNo := 0;

        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", 'TRANSFER');
        ItemJournalLine.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF ItemJournalLine.FINDLAST THEN BEGIN
            DocNo := ItemJournalLine."Document No.";
            LineNo := ItemJournalLine."Line No.";
        END;


        ItemJournalLine.INIT;
        ItemJournalLine."Journal Template Name" := 'TRANSFER';
        ItemJournalLine."Journal Batch Name" := 'DEFAULT';
        ItemJournalLine."Line No." := LineNo + 10000;
        ItemJournalLine."Document No." := SalesCrMemoHeaderNo;// PCPL/MIG/NSW SalesCrMemoHeader."No."; //Original code comment and new Variable Assigned
        ItemJournalLine.VALIDATE("Posting Date", WORKDATE);
        ItemJournalLine.VALIDATE("Item No.", lRecSL."No.");
        ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine.VALIDATE("Document Type", ItemJournalLine."Document Type"::"Sales Credit Memo");
        ItemJournalLine.VALIDATE("Location Code", lRecSL."Location Code");
        ItemJournalLine.VALIDATE("New Location Code", lQuan_Loc);


        ItemJournalLine.VALIDATE(Quantity, lRecSL."Quarantine Qty In KG");//
                                                                          //ItemJournalLine.VALIDATE("Manufacturing Date",lRecSL."Manufacturing Date");
                                                                          //ItemJournalLine.VALIDATE("Expiration Date",lRecSL."Expiration Date");
        ItemJournalLine.INSERT(TRUE);


        /*   {
          ItemLedgerEntry.RESET;
          //ItemLedgerEntry.SETRANGE("Lot No.",lRecSL."Lot No.");
          ItemLedgerEntry.SETRANGE(Open,TRUE);
          ItemLedgerEntry.SETRANGE("Location Code",lQuan_Loc);
          IF ItemLedgerEntry.FINDSET THEN
            REPEAT
              WhseEntry.RESET;
              WhseEntry.SETCURRENTKEY("Reference No.","Registering Date");
              WhseEntry.SETFILTER("Reference No.",ItemLedgerEntry."Document No.");
              WhseEntry.SETRANGE("Line No.",ItemLedgerEntry."Document Line No.");
              //WhseEntry.SETRANGE("Lot No.",lRecSL."Lot No.");
              IF WhseEntry.FINDFIRST THEN BEGIN
                ItemJournalLine.VALIDATE("Bin Code",WhseEntry."Bin Code");
                ItemJournalLine.MODIFY;
              END;
            UNTIL ItemLedgerEntry.NEXT = 0;} */
        /*   {
          RecTrakingSpecification.RESET;
          RecTrakingSpecification.SETRANGE(RecTrakingSpecification."Item No.",lRecSL."No.");
          RecTrakingSpecification.SETRANGE(RecTrakingSpecification."Source ID",lRecSL."Document No.");
          RecTrakingSpecification.SETRANGE(RecTrakingSpecification."Source Ref. No.",lRecSL."Line No.");
          IF RecTrakingSpecification.FINDFIRST THEN BEGIN
           } */
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer THEN BEGIN
            /*  //<<PCPL/MIG/NSW/040522
           CreateReservEntry.CreateReservEntryFor(
             DATABASE::"Item Journal Line",
             ItemJournalLine."Entry Type",
             ItemJournalLine."Journal Template Name",
             ItemJournalLine."Journal Batch Name",
             0,
             ItemJournalLine."Line No.",
             ItemJournalLine."Qty. per Unit of Measure",
             ItemJournalLine.Quantity,
             ItemJournalLine.Quantity,

             TempTrackingSpecification."Lot No.");
            */  //>>PCPL/MIG/NSW/040522

            //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
              ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
            //>>PCPL/MIG/NSW/040522
            CreateReservEntry.SetNewSerialLotNo('', TempTrackingSpecification."Lot No.");
            CreateReservEntry.SetDates(
              ItemJournalLine."Warranty Date", TempTrackingSpecification."Expiration Date"/*, TempTrackingSpecification."Manufacturing Date"*/); //PCPL/MIG/NSW This base function New parameter add which not allowed in BC18
            //CreateReservEntry.SetPOData(  //PCPL/MIG/NSW Original Code comment
            "Create Reserv. Entry Events".SetPOData(  //PCPL/MIG/NSW New Code Add and Global Var Define
              TempTrackingSpecification."PO Expiration Date", TempTrackingSpecification."PO Lot No.", TempTrackingSpecification."PO Manufacturing Date");
            //CreateReservEntry.SetApplyToEntryNo(ItemLedgerEntry."Entry No.");

            //CreateReservEntry.SetQtyToHandleBaseInKG(ItemJournalLine.Quantity); //PCPL/MIG/NSW Original Code comment
            "Create Reserv. Entry Events".SetQtyToHandleBaseInKG(ItemJournalLine.Quantity); //PCPL/MIG/NSW New Code Add and Global Var Define
            //CreateReservEntry.SetRemainQtyInKG(ItemJournalLine.Quantity); //PCPL/MIG/NSW Original Code comment
            "Create Reserv. Entry Events".SetRemainQtyInKG(ItemJournalLine.Quantity); //PCPL/MIG/NSW New Code Add and Global Var Define
            CreateReservEntry.CreateEntry(
              ItemJournalLine."Item No.",
              ItemJournalLine."Variant Code",
              ItemJournalLine."Location Code",
              ItemJournalLine.Description,
              ItemJournalLine."Posting Date",
              ItemJournalLine."Document Date",
              0,
              3);
        END;
        //END;
    END;

    LOCAL PROCEDURE UpdateQuarantineQtyinJnl(Rec_SL: Record 37);
    VAR
        ToItem: Record 27;
        i: Integer;
        IUOM: Record 5404;
        RecLoc1: Record 14;
        QuarentineQty: Decimal;
        QuarantineLoc: Code[20];
        RecLoc: Record 14;
    BEGIN
        IF RecLoc.GET(Rec_SL."Location Code") THEN BEGIN
            RecLoc1.RESET;
            RecLoc1.SETRANGE(RecLoc1."State Code", RecLoc."State Code");
            RecLoc1.SETRANGE(RecLoc1."Quarantine Location", TRUE);
            IF RecLoc1.FINDFIRST THEN
                QuarantineLoc := RecLoc1.Code;
        END;
        CreateItemJournalLineForQuaratineQty(Rec_SL, QuarantineLoc);
    END;

    LOCAL PROCEDURE PostQuarantineQtytoILE(ItemJnlLine: Record 83);
    VAR
        ItemJnlTemplate: Record 82;
        ItemJnlPostBatch: Codeunit 23;
        TempJnlBatchName: Code[10];
    BEGIN
        //ERROR('Post Quarantine');
        WITH ItemJnlLine DO BEGIN
            ItemJnlTemplate.GET("Journal Template Name");
            ItemJnlTemplate.TESTFIELD("Force Posting Report", FALSE);
            IF ItemJnlTemplate.Recurring AND (GETFILTER("Posting Date") <> '') THEN
                FIELDERROR("Posting Date", Text006);

            TempJnlBatchName := "Journal Batch Name";

            ItemJnlPostBatch.RUN(ItemJnlLine);

            IF NOT FIND('=><') OR (TempJnlBatchName <> "Journal Batch Name") THEN BEGIN
                RESET;
                FILTERGROUP(2);
                SETRANGE("Journal Template Name", "Journal Template Name");
                SETRANGE("Journal Batch Name", "Journal Batch Name");
                FILTERGROUP(0);
                "Line No." := 1;
            END;
        END;
    END;

    var
        //cu_GSTMgmt: Codeunit 16401; //PCPL/MIG/NSW
        "Create Reserv. Entry Events": Codeunit 50006;
        i: Integer;
        CompInfo: Record 79;
        ItemJournalLine: Record 83;
        RecSalesLine: Record 37;
        //cu_GSTInvoice: Codeunit 50008; //PCPL/MIG/NSW
        recSalesCrMemoHeader: Record 114;
        Text006: TextConst ENU = 'Posting lines              #2######;ENN=Posting lines              #2######';
        SalesCrMemoHeaderNo: Code[20]; //PCPL/MIG/NSW
        TempTrackingSpecification: Record 336 temporary; //PCPL/MIG/NSW

    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-80 Sales-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-82 Sales-Post + Print  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforePrintShip', '', false, false)]
    local procedure OnBeforePrintShip(var SalesHeader: Record "Sales Header"; SendReportAsEmail: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-82 Sales-Post + Print  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-370 Bank Acc. Reconciliation Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", 'OnBeforeAppliedAmountCheck', '', false, false)]
    local procedure OnBeforeAppliedAmountCheck(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)
    begin
        // rdk 210819 -
        IF BankAccReconciliationLine."Document No." <> '' THEN BEGIN
            AppliedAmount := BankAccReconciliationLine."Applied Amount";
            BankAccReconciliationLine.TESTFIELD("Applied Amount", AppliedAmount);
        END
        // ELSE
        // rdk 210819 +
    end;

    var
        FGSPL_Difference: Decimal;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-370 Bank Acc. Reconciliation Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-900 Bank Assembly-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnAfterCreateItemJnlLineFromAssemblyHeader', '', false, false)]
    local procedure OnAfterCreateItemJnlLineFromAssemblyHeader(var ItemJournalLine: Record "Item Journal Line"; AssemblyHeader: Record "Assembly Header")
    begin
        ItemJournalLine."Overhead Rate" := AssemblyHeader."Overhead Rate" / AssemblyHeader."Qty. per Unit of Measure";
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-900 Bank Assembly-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnRunOnBeforeInsertShipmentLines', '', false, false)]
    local procedure OnRunOnBeforeInsertShipmentLines(var WhseShptHeader: Record "Warehouse Shipment Header"; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    begin
        //  Error('Hiiiii');
    end;

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-5704 TransferOrder-Post Shipment  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    begin
        with TransHeader do begin
            //CCIT-SG
            TransShptHeader."Load Type" := "Load Type";
            TransShptHeader."Seal No." := "Seal No.";
            TransShptHeader."E-Way Bill No." := "E-Way Bill No.";
            TransShptHeader."E-Way Bill Date" := "E-Way Bill Date";
            TransShptHeader."JWL Transfer No." := "JWL Transfer No.";
            TransShptHeader."JWL Transfer Date" := "JWL Transfer Date";
            TransShptHeader."Transport Vendor" := "Transport Vendor";
            TransShptHeader."Customer License No." := "Customer License No.";
            //CCIT-SG
            TransShptHeader."Order Time" := "Order Time";//CCIT-SG-15072019
            TransShptHeader."Inv Time" := TIME; //CCIT-SG-15072019

            // rdk230919 -
            TransShptHeader."In-Bond Bill of Entry No." := TransHeader."In-Bond Bill of Entry No.";
            TransShptHeader."In-Bond BOE Date" := TransHeader."In-Bond BOE Date";
            TransShptHeader."Bond Number" := TransHeader."Bond Number";
            TransShptHeader."Bond Sr.No." := TransHeader."Bond Sr.No.";
            TransShptHeader."Bond Date" := TransHeader."Bond Date";
            TransShptHeader."BL/AWB No." := TransHeader."BL/AWB No.";
            TransShptHeader."Ex-bond BOE No." := TransHeader."Ex Bond Order No.";
            TransShptHeader."Ex-bond BOE Date" := TransHeader."Ex-bond BOE Date";
            // rdk230919 +


            TransShptHeader."Calculate Custom Duty" := "Calculate Custom Duty";//CCIT-SD-28-02-2018-
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', false, false)]
    local procedure OnBeforeInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    begin
        //CCIT-SG
        TransShptLine."Customer No." := TransLine."Customer No.";
        TransShptLine."Customer Name" := TransLine."Customer Name";
        TransShptLine.Reserved := TransLine.Reserved;
        TransShptLine."License No." := TransLine."License No.";
        //TransShptLine."Conversion Qty" := TransLine."Conversion Qty";
        TransShptLine."Customer License No." := TransLine."Customer License No.";
        TransShptLine."Customer License Name" := TransLine."Customer License Name";
        TransShptLine."Customer License Date" := TransLine."Customer License Date";
        TransShptLine."Fill Rate %" := TransLine."Fill Rate %";
        TransShptLine."Transfer From Reason Code" := TransLine."Transfer From Reason Code";//CCIT-SG-24042018
                                                                                           //CCIT-SG
                                                                                           //CCIT-SG-19042018
        IF RecItem2.GET(TransShptLine."Item No.") THEN BEGIN
            IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                IF (RecUOM.Weight <> 0) THEN BEGIN
                    TransShptLine."Conversion Qty" := TransShptLine.Quantity / RecUOM.Weight;
                END
            END
        END;
        //CCIT-SG-19042018
        TransShptLine."TO Order QTY" := TransLine.Quantity; //CCIT-SG-15072019
        TransShptLine."TO Order Value" := (TransLine.Quantity * TransLine."Transfer Price"); //CCIT-SG-15072019
                                                                                             //CCIT-SD-28-02-2018 -
        TransShptLine."GST Assessable Value" := TransLine."GST Assessable Value1";
        TransShptLine."Custom Duty Amount" := TransLine."Custom Duty Amount1";
        TransShptLine.Duty := TransLine.Duty;
        TransShptLine.Cess := TransLine.Cess;
        TransShptLine.Surcharge := TransLine.Surcharge;
        //CCIT-SD-28-02-2018 +
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnRunOnBeforeCommit', '', false, false)]
    local procedure OnRunOnBeforeCommit(var TransferHeader: Record "Transfer Header"; TransferShipmentHeader: Record "Transfer Shipment Header"; PostedWhseShptHeader: Record "Posted Whse. Shipment Header")
    begin
        // CompInfo.GET();
        // IF CompInfo."Auto IRN Generation" = TRUE THEN
        //     CU_GST_Transfer.WriteIRNPayload_IRN(TransferShipmentHeader);//CCIT-06032021 vivek //PCPL/MIG/NSW
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line"; CommitIsSuppressed: Boolean)
    var
        TransHeader: Record "Transfer Header";
    begin
        if TransHeader.Get(TransferLine."Document No.") then;
        //CCIT-SG
        ItemJournalLine."JWL Transfer No." := TransHeader."JWL Transfer No.";
        ItemJournalLine."JWL Transfer Date" := TransHeader."JWL Transfer Date";
        ItemJournalLine."Customer No." := TransferLine."Customer No.";
        ItemJournalLine."Customer Name" := TransferLine."Customer Name";
        ItemJournalLine."ICA No." := TransHeader."ICA No.";
        //ItemJnlLine."Customer No." := TransLine."Customer No.";
        ItemJournalLine."Conversion Qty" := TransferLine."Conversion Qty";
        //MESSAGE('Ship %1',ItemJnlLine."Conversion Qty");
        ItemJournalLine."Storage Categories" := TransferLine."Storage Categories";
        ItemJournalLine.Reserved := TransferLine.Reserved;
        ItemJournalLine."Conversion UOM" := TransferLine."Conversion UOM";
        ItemJournalLine."License No." := TransferLine."License No.";
        ItemJournalLine.Weight := TransferLine.Weight;
        ItemJournalLine."BL/AWB No." := TransHeader."BL/AWB No.";
        ItemJournalLine."BL Date" := TransHeader."BL Date";
        ItemJournalLine."In-Bond Bill of Entry No." := TransHeader."In-Bond Bill of Entry No.";
        ItemJournalLine."In-Bond BOE Date" := TransHeader."In-Bond BOE Date";
        ItemJournalLine."Bond Number" := TransHeader."Bond Number";
        ItemJournalLine."Bond Sr.No." := TransHeader."Bond Sr.No.";
        ItemJournalLine."Bond Date" := TransHeader."Bond Date";
        ItemJournalLine."Ex-bond BOE No." := TransHeader."Ex-bond BOE No.";
        ItemJournalLine."Ex-bond BOE Date" := TransHeader."Ex-bond BOE Date";
        ItemJournalLine."Ex-bond BOE No.1" := TransHeader."Ex-bond BOE No.1";
        ItemJournalLine."Ex-bond BOE Date 1" := TransHeader."Ex-bond BOE Date 1";
        ItemJournalLine."Ex-bond BOE No.2" := TransHeader."Ex-bond BOE No.2";
        ItemJournalLine."Ex-bond BOE Date 2" := TransHeader."Ex-bond BOE Date 2";
        ItemJournalLine."Ex-bond BOE No.3" := TransHeader."Ex-bond BOE No.3";
        ItemJournalLine."Ex-bond BOE Date 3" := TransHeader."Ex-bond BOE Date 3";
        ItemJournalLine."Ex-bond BOE No.4" := TransHeader."Ex-bond BOE No.4";
        ItemJournalLine."Ex-bond BOE Date 4" := TransHeader."Ex-bond BOE Date 4";
        ItemJournalLine."Ex-bond BOE No.5" := TransHeader."Ex-bond BOE No.5";
        ItemJournalLine."Ex-bond BOE Date 5" := TransHeader."Ex-bond BOE Date 5";
        ItemJournalLine."Ex-bond BOE No.6" := TransHeader."Ex-bond BOE No.6";
        ItemJournalLine."Ex-bond BOE Date 6" := TransHeader."Ex-bond BOE Date 6";
        ItemJournalLine."Ex-bond BOE No.7" := TransHeader."Ex-bond BOE No.7";
        ItemJournalLine."Ex-bond BOE Date 7" := TransHeader."Ex-bond BOE Date 7";
        ItemJournalLine."Ex-bond BOE No.8" := TransHeader."Ex-bond BOE No.8";
        ItemJournalLine."Ex-bond BOE Date 8" := TransHeader."Ex-bond BOE Date 8";
        ItemJournalLine."Ex-bond BOE No.9" := TransHeader."Ex-bond BOE No.9";
        ItemJournalLine."Ex-bond BOE Date 9" := TransHeader."Ex-bond BOE Date 9";
        //ItemJnlLine."Gen. Prod. Posting Group" := TransLine."Gen. Prod. Posting Group";
        ItemJournalLine."Customer License No." := TransferLine."Customer License No.";
        ItemJournalLine."Customer License Date" := TransferLine."Customer License Date";
        ItemJournalLine."Customer License Name" := TransferLine."Customer License Name";
        ItemJournalLine."Sales Category" := TransferLine."Sales Category";
        ItemJournalLine."Supplier Invoice No." := TransferLine."Supplier Invoice No.";
        ItemJournalLine."Supplier Invoice No.1" := TransferLine."Supplier Invoice No.1";
        ItemJournalLine."Supplier Invoice No.2" := TransferLine."Supplier Invoice No.2";
        ItemJournalLine."Supplier Invoice No.3" := TransferLine."Supplier Invoice No.3";
        ItemJournalLine."Supplier Invoice No.4" := TransferLine."Supplier Invoice No.4";
        ItemJournalLine."Supplier Invoice Date" := TransferLine."Supplier Invoice Date";
        ItemJournalLine."Supplier Invoice Date 1" := TransferLine."Supplier Invoice Date 1";
        ItemJournalLine."Supplier Invoice Date 2" := TransferLine."Supplier Invoice Date 2";
        ItemJournalLine."Supplier Invoice Date 3" := TransferLine."Supplier Invoice Date 3";
        ItemJournalLine."Supplier Invoice Date 4" := TransferLine."Supplier Invoice Date 4";
        ItemJournalLine."Supplier Invoice Sr.No." := TransferLine."Supplier Invoice Sr.No.";
        ItemJournalLine."Supplier Invoice Sr.No.1" := TransferLine."Supplier Invoice Sr.No.1";
        ItemJournalLine."Supplier Invoice Sr.No.2" := TransferLine."Supplier Invoice Sr.No.2";
        ItemJournalLine."Supplier Invoice Sr.No.3" := TransferLine."Supplier Invoice Sr.No.3";
        ItemJournalLine."Supplier Invoice Sr.No.4" := TransferLine."Supplier Invoice Sr.No.4";
        ItemJournalLine."Custom Duty Amount1" := TransferLine."Custom Duty Amount1";//CCIT-SG-24052018
                                                                                    //CCIT-SG

    end;

    var
        RecItem2: Record 27;
        RecUOM: Record 5404;
        //GSTMGMT: Codeunit 16401;
        //CompInfo: Record 79;
        FromLoc: Record 14;
        ToLoc: Record 14;
    //CU_GST_Transfer: Codeunit 50010;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-5704 TransferOrder-Post Shipment  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-6620 Copy Document Mgt.  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesDocument', '', false, false)]
    local procedure OnBeforeCopySalesDocument(FromDocumentType: Option; FromDocumentNo: Code[20]; var ToSalesHeader: Record "Sales Header")
    var
        FromSalesHeader: Record "Sales Header";
    begin
        if FromSalesHeader.Get(FromDocumentNo) then;
        IF FromSalesHeader."Invoice Type" <> ToSalesHeader."Invoice Type" THEN
            ERROR(InvoiceTypeErr, FromDocumentNo, ToSalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnBeforeCopySalesDocShptLine', '', false, false)]
    local procedure OnCopySalesDocOnBeforeCopySalesDocShptLine(var FromSalesShipmentHeader: Record "Sales Shipment Header"; var ToSalesHeader: Record "Sales Header")
    begin
        IF FromSalesShipmentHeader."Invoice Type" <> ToSalesHeader."Invoice Type" THEN
            ERROR(InvoiceTypeErr, FromSalesShipmentHeader."No.", ToSalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnBeforeCopySalesDocInvLine', '', false, false)]
    local procedure OnCopySalesDocOnBeforeCopySalesDocInvLine(var FromSalesInvoiceHeader: Record "Sales Invoice Header"; var ToSalesHeader: Record "Sales Header")
    begin
        IF FromSalesInvoiceHeader."Invoice Type" <> ToSalesHeader."Invoice Type" THEN
            ERROR(InvoiceTypeErr, FromSalesInvoiceHeader."No.", ToSalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnBeforeCopySalesDocReturnRcptLine', '', false, false)]
    local procedure OnCopySalesDocOnBeforeCopySalesDocReturnRcptLine(var FromReturnReceiptHeader: Record "Return Receipt Header"; var ToSalesHeader: Record "Sales Header")
    begin
        // IF FromReturnReceiptHeader. <> ToSalesHeader."Invoice Type" THEN
        //  ERROR(InvoiceTypeErr, FromReturnReceiptHeader."No.", ToSalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnBeforeCopySalesDocCrMemoLine', '', false, false)]
    local procedure OnCopySalesDocOnBeforeCopySalesDocCrMemoLine(var FromSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ToSalesHeader: Record "Sales Header")
    begin
        IF FromSalesCrMemoHeader."Invoice Type" <> ToSalesHeader."Invoice Type" THEN
            ERROR(InvoiceTypeErr, FromSalesCrMemoHeader."No.", ToSalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopyPurchDocLineOnBeforeCopyThisLine', '', false, false)]
    local procedure OnCopyPurchDocLineOnBeforeCopyThisLine(var ToPurchLine: Record "Purchase Line"; var FromPurchLine: Record "Purchase Line"; MoveNegLines: Boolean; FromPurchDocType: Enum "Purchase Document Type From"; var LinesNotCopied: Integer; var CopyThisLine: Boolean; var Result: Boolean; var IsHandled: Boolean; ToPurchaseHeader: Record "Purchase Header")
    begin
        IsHandled := true;
        IF CopyThisLine THEN BEGIN
            IF ToPurchLine.INSERT THEN BEGIN
                ToPurchLine.VALIDATE(ToPurchLine.Quantity);
                ToPurchLine.MODIFY;
            END;
        END ELSE
            LinesNotCopied := LinesNotCopied + 1;
        //CCIT-SG-29052018 -
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesCombDocNoLine', '', false, false)]
    local procedure OnBeforeInsertOldSalesCombDocNoLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; CopyFromInvoice: Boolean; OldDocNo: Code[20]; OldDocNo2: Code[20])
    begin
        //CCIT-SG-08062018
        ToSalesHeader."Your Reference" := OldDocNo2;
        ToSalesHeader.MODIFY;
        //CCIT-SG-08062018
    end;

    var
        InvoiceTypeErr: TextConst ENU = '@@@="%1 = Sales Header No., %2 = Sales Shipement No.";ENU=Invoice Type must be same for %1 and %2';
        Text050: TextConst ENU = '%1:';
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-6620 Copy Document Mgt.  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7000 Sales Price Calc. Mgt.  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice', '', false, false)]
    local procedure OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary)
    var
        Item: Record Item;
    begin
        with SalesLine do begin
            if Item.Get("No.") then;
            // "Unit Price" := TempSalesPrice."Unit Price Per KG";
            //CCIT-SG-070318
            IF "Special Price" = "Special Price"::" " THEN BEGIN
                RecSPrice.RESET;
                RecSPrice.SETRANGE(RecSPrice."Item No.", Item."No.");
                RecSPrice.SETRANGE(RecSPrice."Sales Code", "Customer Price Group");
                RecSPrice.SETRANGE(RecSPrice."Customer Code", "Sell-to Customer No.");
                RecSPrice.SETFILTER(RecSPrice."Starting Date", '<=%1', SalesHeader."Order Date");
                RecSPrice.SETFILTER(RecSPrice."Ending Date", '>=%1', SalesHeader."Order Date");
                RecSPrice.SETFILTER(RecSPrice.Block, '=%1', FALSE);//CCIT-12-11-2021
                RecSPrice.SETRANGE(RecSPrice."Location Code", SalesHeader."Location Code");
                IF RecSPrice.FINDFIRST THEN
                    "Unit Price" := RecSPrice."Unit Price";
                "Rate In PCS" := RecSPrice."Conversion Price Per PCS";
            END ELSE BEGIN
                RecSPrice1.RESET;
                RecSPrice1.SETRANGE(RecSPrice1."Item No.", Item."No.");
                RecSPrice1.SETRANGE(RecSPrice1."Sales Code", "Customer Price Group");
                RecSPrice1.SETFILTER(RecSPrice1."Starting Date", '<=%1', SalesHeader."Order Date");
                RecSPrice1.SETFILTER(RecSPrice1."Ending Date", '>=%1', SalesHeader."Order Date");
                RecSPrice1.SETFILTER(RecSPrice1."Location Code", '=%1', '');
                RecSPrice1.SETFILTER(RecSPrice1.Block, '=%1', FALSE);//CCIT-12-11-2021
                IF RecSPrice1.FINDFIRST THEN BEGIN
                    "Unit Price" := RecSPrice1."Unit Price";
                    "Rate In PCS" := RecSPrice1."Conversion Price Per PCS";
                END;
                RecSPrice.RESET;
                RecSPrice.SETRANGE(RecSPrice."Item No.", Item."No.");
                RecSPrice.SETRANGE(RecSPrice."Sales Code", "Customer Price Group");
                RecSPrice.SETFILTER(RecSPrice."Starting Date", '<=%1', SalesHeader."Order Date");
                RecSPrice.SETFILTER(RecSPrice."Ending Date", '>=%1', SalesHeader."Order Date");
                RecSPrice.SETFILTER(RecSPrice.Block, '=%1', FALSE);//CCIT-12-11-2021
                RecSPrice.SETRANGE(RecSPrice."Location Code", SalesHeader."Location Code");
                IF RecSPrice.FINDFIRST THEN BEGIN
                    "Unit Price" := RecSPrice."Unit Price";
                    "Rate In PCS" := RecSPrice."Conversion Price Per PCS";
                END;

            END;

            //CCIT-SG-070318
            /*  {//CCIT-SG-04062018
             IF RecItem.GET(SalesLine."No.") THEN BEGIN
               IF RecItem."Base Unit of Measure" = 'PCS' THEN BEGIN
                 "Unit Price" := TempSalesPrice."Unit Price";
               END
               ELSE IF RecItem."Base Unit of Measure" = 'CASE' THEN BEGIN
                  "Unit Price" := TempSalesPrice."Conversion Price";
               END
             END;
             //CCIT-SG-04062018} */
            //CCIT-SG-04072018
            IF "Special Price" = "Special Price"::Free THEN
                "Line Discount %" := 100;
            //CCIT-SG-04072018
        end;
    end;

    var
        RecItem: Record 27;
        RecSPrice: Record 7002;
        RecSPrice1: Record 7002;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7000 Sales Price Calc. Mgt.  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7301 Whse. Jnl.-Register Line  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnInitWhseEntryCopyFromWhseJnlLine', '', false, false)]
    local procedure OnInitWhseEntryCopyFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line"; OnMovement: Boolean; Sign: Integer)
    begin
        with WarehouseJournalLine do begin
            //CCIT-SG
            WarehouseEntry."License No." := "License No.";
            WarehouseEntry.Weight1 := Weight1;
            WarehouseEntry."Conversion Qty" := "Conversion Qty";
            WarehouseEntry."Conversion Qty To Handle" := "Conversion Qty To Handle";
            WarehouseEntry."Saleable Qty. In PCS" := "Saleable Qty. In PCS";
            WarehouseEntry."Saleable Qty. In KG" := "Saleable Qty. In KG";
            WarehouseEntry."Damage Qty. In PCS" := "Damage Qty. In PCS";
            WarehouseEntry."Damage Qty. In KG" := "Damage Qty. In KG";
            //CCIT-SG
        end;
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7301 Whse. Jnl.-Register Line  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7302 WMS Management  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnAfterCreateWhseJnlLine', '', false, false)]
    local procedure OnAfterCreateWhseJnlLine(var WhseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line"; ToTransfer: Boolean)
    begin
        with ItemJournalLine do begin
            //CCIT-SG
            WhseJournalLine."License No." := "License No.";
            WhseJournalLine.Weight1 := Weight;
            WhseJournalLine."Conversion Qty" := "Conversion Qty";
            WhseJournalLine."Conversion Qty To Handle" := "Conversion Qty To Handle";
            WhseJournalLine."Saleable Qty. In PCS" := "Saleable Qty. In PCS";
            WhseJournalLine."Saleable Qty. In KG" := "Saleable Qty. In KG";
            WhseJournalLine."Damage Qty. In PCS" := "Damage Qty. In PCS";
            WhseJournalLine."Damage Qty. In KG" := "Damage Qty. In KG";
            WhseJournalLine."Sales Category" := "Sales Category";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnAfterTransferWhseItemTrkg', '', false, false)]
    local procedure OnAfterTransferWhseItemTrkg(var WarehouseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line")
    begin
        //>> CS
        WarehouseJournalLine."Manufacturing Date" := ItemJournalLine."Manufacturing Date";
        //<< CS
        //CCIT-SG
        WarehouseJournalLine."PO Lot No." := ItemJournalLine."PO Lot No.";
        WarehouseJournalLine."PO Manufacturing Date" := ItemJournalLine."PO Manufacturing Date";
        WarehouseJournalLine."PO Expiration Date" := ItemJournalLine."PO Expiration Date";
        WarehouseJournalLine."License No." := ItemJournalLine."License No.";
        WarehouseJournalLine.Weight1 := ItemJournalLine.Weight;
        WarehouseJournalLine."Conversion Qty" := ItemJournalLine."Conversion Qty";
        WarehouseJournalLine."Conversion Qty To Handle" := ItemJournalLine."Conversion Qty To Handle";
        WarehouseJournalLine."Saleable Qty. In PCS" := ItemJournalLine."Saleable Qty. In PCS";
        WarehouseJournalLine."Saleable Qty. In KG" := ItemJournalLine."Saleable Qty. In KG";
        WarehouseJournalLine."Damage Qty. In PCS" := ItemJournalLine."Damage Qty. In PCS";
        WarehouseJournalLine."Damage Qty. In KG" := ItemJournalLine."Damage Qty. In KG";
        WarehouseJournalLine."Sales Category" := ItemJournalLine."Sales Category";
        //CCIT-SG
        //CCIT-SG-25052018 <<
        WarehouseJournalLine."Actual Batch" := ItemJournalLine."Actual Batch";
        WarehouseJournalLine."Actual Batch KGS" := ItemJournalLine."Actual Batch KGS";
        WarehouseJournalLine."Actual Batch PCS" := ItemJournalLine."Actual Batch PCS";
        WarehouseJournalLine."Actual EXP Date" := ItemJournalLine."Actual EXP Date";
        WarehouseJournalLine."Actual MFG Date" := ItemJournalLine."Actual MFG Date";
        //CCIT-SG-25052018 >>
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7302 WMS Management  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7307 Whse.-Activity-Register  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnBeforeWhseJnlRegisterLine', '', false, false)]
    local procedure OnBeforeWhseJnlRegisterLine(var WarehouseJournalLine: Record "Warehouse Journal Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        with WarehouseActivityLine do begin
            //>> CS
            WarehouseJournalLine."Manufacturing Date" := "Manufacturing Date";
            //<< CS
            //CCIT-SG
            WarehouseJournalLine."PO Lot No." := "PO Lot No.";
            WarehouseJournalLine."PO Manufacturing Date" := "PO Manufacturing Date";
            WarehouseJournalLine."PO Expiration Date" := "PO Expiration Date";
            //CCIT-SG
            //CCIT-SG-25052018 <<
            WarehouseJournalLine."Actual Batch" := "Actual Batch";
            WarehouseJournalLine."Actual Batch KGS" := "Actual Batch KGS";
            WarehouseJournalLine."Actual Batch PCS" := "Actual Batch PCS";
            WarehouseJournalLine."Actual EXP Date" := "Actual EXP Date";
            WarehouseJournalLine."Actual MFG Date" := "Actual MFG Date";
            //CCIT-SG-25052018 <<
            WarehouseJournalLine."Quarantine Qty In KG" := "Quarantine Qty In KG";
            WarehouseJournalLine."Actual Qty In KG" := "Actual Qty In KG"; //CCIT-SD
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnBeforeRegWhseItemTrkgLine', '', false, false)]
    local procedure OnBeforeRegWhseItemTrkgLine(var WhseActivLine2: Record "Warehouse Activity Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        //>> CS
        TempTrackingSpecification."Manufacturing Date" := WhseActivLine2."Manufacturing Date";
        //<< CS
        //CCIT-SG
        TempTrackingSpecification."PO Lot No." := WhseActivLine2."PO Lot No.";
        TempTrackingSpecification."PO Manufacturing Date" := WhseActivLine2."PO Manufacturing Date";
        TempTrackingSpecification."PO Expiration Date" := WhseActivLine2."PO Expiration Date";
        //CCIT-SG
        //CCIT-SG-25052018 <<
        TempTrackingSpecification."Actual Batch" := WhseActivLine2."Actual Batch";
        TempTrackingSpecification."Actual Batch KGS" := WhseActivLine2."Actual Batch KGS";
        TempTrackingSpecification."Actual Batch PCS" := WhseActivLine2."Actual Batch PCS";
        TempTrackingSpecification."Actual EXP Date" := WhseActivLine2."Actual EXP Date";
        TempTrackingSpecification."Actual MFG Date" := WhseActivLine2."Actual MFG Date";
        //CCIT-SG-25052018 >>
        TempTrackingSpecification."Quarantine Qty In KG" := WhseActivLine2."Quarantine Qty In KG";
        TempTrackingSpecification."Actual Qty In KG" := WhseActivLine2."Actual Qty In KG";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnInsertRegWhseItemTrkgLineOnAfterCopyFields', '', false, false)]
    local procedure OnInsertRegWhseItemTrkgLineOnAfterCopyFields(var WhseItemTrackingLine: Record "Whse. Item Tracking Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        //>> CS
        WhseItemTrackingLine."Manufacturing Date" := WarehouseActivityLine."Manufacturing Date";
        //<< CS
        //CCIT-SG
        WhseItemTrackingLine."PO Lot No." := WarehouseActivityLine."PO Lot No.";
        WhseItemTrackingLine."PO Manufacturing Date" := WarehouseActivityLine."PO Manufacturing Date";
        WhseItemTrackingLine."PO Expiration Date" := WarehouseActivityLine."PO Expiration Date";
        //CCIT-SG
        //CCIT-SG-25052018 <<
        WhseItemTrackingLine."Actual Batch" := WarehouseActivityLine."Actual Batch";
        WhseItemTrackingLine."Actual Batch KGS" := WarehouseActivityLine."Actual Batch KGS";
        WhseItemTrackingLine."Actual Batch PCS" := WarehouseActivityLine."Actual Batch PCS";
        WhseItemTrackingLine."Actual EXP Date" := WarehouseActivityLine."Actual EXP Date";
        WhseItemTrackingLine."Actual MFG Date" := WarehouseActivityLine."Actual MFG Date";
        //CCIT-SG-25052018 >>
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnBeforeTempTrackingSpecificationInsert', '', false, false)]
    local procedure OnBeforeTempTrackingSpecificationInsert(var TempTrackingSpecification: Record "Tracking Specification" temporary; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        with WarehouseActivityLine do begin
            //>> CS
            TempTrackingSpecification."Manufacturing Date" := "Manufacturing Date";
            //<< CS
            //CCIT-SG
            TempTrackingSpecification."PO Lot No." := "PO Lot No.";
            TempTrackingSpecification."PO Manufacturing Date" := "PO Manufacturing Date";
            TempTrackingSpecification."PO Expiration Date" := "PO Expiration Date";
            //CCIT-SG
            //CCIT-SG-25052018 <<
            TempTrackingSpecification."Actual Batch" := "Actual Batch";
            TempTrackingSpecification."Actual Batch KGS" := "Actual Batch KGS";
            TempTrackingSpecification."Actual Batch PCS" := "Actual Batch PCS";
            TempTrackingSpecification."Actual EXP Date" := "Actual EXP Date";
            TempTrackingSpecification."Actual MFG Date" := "Actual MFG Date";
            //CCIT-SG-25052018 >>
            TempTrackingSpecification."Quarantine Qty In KG" := "Quarantine Qty In KG";
            TempTrackingSpecification."Actual Qty In KG" := "Quarantine Qty In KG";
        end;
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7307 Whse.-Activity-Register  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7321 Create Inventory Put-away  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnBeforeGetSourceDocHeader', '', false, false)]
    local procedure OnBeforeGetSourceDocHeader(var WarehouseRequest: Record "Warehouse Request"; var IsHandled: Boolean)
    begin
        case WarehouseRequest."Source Document" of
            WarehouseRequest."Source Document"::"Purchase Order":
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::Order, WarehouseRequest."Source No.");
                    ETDDescPort := PurchHeader."ETA - Destination Port";
                    ETDCFS := PurchHeader."ETA - Destination CFS";
                    ETDBond := PurchHeader."ETA - Bond";
                    //CCIT-SG
                    LicenseNo := PurchHeader."License No.";
                    OrderDate := PurchHeader."Order Date";
                    IF RecVend.GET(PurchHeader."Buy-from Vendor No.") THEN BEGIN
                        CountryCode := RecVend."Country/Region Code";
                        IF RecCountry.GET(CountryCode) THEN
                            CountryName := RecCountry.Name;
                    END;
                    //CCIT-SG
                end;
            WarehouseRequest."Source Document"::"Purchase Return Order":
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::"Return Order", WarehouseRequest."Source No.");
                    ETDDescPort := PurchHeader."ETA - Destination Port";
                    ETDCFS := PurchHeader."ETA - Destination CFS";
                    ETDBond := PurchHeader."ETA - Bond";
                    //CCIT-SG
                    LicenseNo := PurchHeader."License No.";
                    OrderDate := PurchHeader."Order Date";
                    IF RecVend.GET(PurchHeader."Buy-from Vendor No.") THEN BEGIN
                        CountryCode := RecVend."Country/Region Code";
                        IF RecCountry.GET(CountryCode) THEN
                            CountryName := RecCountry.Name;
                    END;
                    //CCIT-SG
                end;
            WarehouseRequest."Source Document"::"Sales Order":
                begin
                    SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseRequest."Source No.");
                    LicenseNo := SalesHeader."License No.";  //CCIT-SG
                    OrderDate := SalesHeader."Order Date"; //CCIT-SG
                end;
            WarehouseRequest."Source Document"::"Sales Return Order":
                begin
                    SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WarehouseRequest."Source No.");
                    LicenseNo := SalesHeader."License No.";  //CCIT-SG
                    OrderDate := SalesHeader."Order Date"; //CCIT-SG
                end;
            WarehouseRequest."Source Document"::"Inbound Transfer":
                begin
                    TransferHeader.Get(WarehouseRequest."Source No.");
                    //CCIT-SG
                    LicenseNo := TransferHeader."License No.";
                    JWLTransNo := TransferHeader."JWL Transfer No.";
                    JWLTransDate := TransferHeader."JWL Transfer Date";
                    //CCIT-SG
                end;
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnBeforeCreatePutAwayLinesFromTransferLoop', '', false, false)]
    // local procedure OnBeforeCreatePutAwayLinesFromTransferLoop(var WarehouseActivityHeader: Record "Warehouse Activity Header"; TransferHeader: Record "Transfer Header"; var IsHandled: Boolean; TransferLine: Record "Transfer Line")
    // begin
    //     Error('Hi');
    // end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnAfterUpdateWhseActivHeader', '', false, false)]
    local procedure OnAfterUpdateWhseActivHeader(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var WarehouseRequest: Record "Warehouse Request")
    begin
        //CCIT-SG
        WarehouseActivityHeader."License No." := LicenseNo;
        WarehouseActivityHeader."OrderDate WareActHed" := OrderDate;
        WarehouseActivityHeader."Country Code" := CountryCode;
        WarehouseActivityHeader."Country Name" := CountryName;
        WarehouseActivityHeader."ETA - Destination Port" := ETDDescPort;
        WarehouseActivityHeader."ETA - Destination CFS" := ETDCFS;
        WarehouseActivityHeader."ETA - Bond" := ETDBond;
        WarehouseActivityHeader."JWL Transfer No." := JWLTransNo;
        WarehouseActivityHeader."JWL Transfer Date" := JWLTransDate;
        //CCIT-SG
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnBeforeNewWhseActivLineInsertFromPurchase', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsertFromPurchase(var WarehouseActivityLine: Record "Warehouse Activity Line"; PurchaseLine: Record "Purchase Line")
    begin
        with PurchaseLine do begin
            //CCIT-SG
            WarehouseActivityLine.Weight1 := Weight;
            WarehouseActivityLine."Conversion Qty" := "Conversion Qty";
            WarehouseActivityLine."HS Code" := "HS Code";
            WarehouseActivityLine."Qty. Outstanding In KG" := "Conversion Qty";
            WarehouseActivityLine."Quarantine Qty In KG" := "Quarantine Qty In KG";
            WarehouseActivityLine."Quarantine Qty In PCS" := "Quarantine Qty In PCS";
            WarehouseActivityLine."Actual Qty In KG" := "Actual Qty In KG";
            WarehouseActivityLine."Actual Qty In PCS" := "Actual Qty In PCS";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnBeforeNewWhseActivLineInsertFromSales', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsertFromSales(var WarehouseActivityLine: Record "Warehouse Activity Line"; SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
            //CCIT-SG
            WarehouseActivityLine.Weight1 := Weight;
            WarehouseActivityLine."Conversion Qty" := "Conversion Qty";
            WarehouseActivityLine."Qty. to Invoice In KG" := "Qty. to Invoice In KG";
            WarehouseActivityLine."Qty. to Receive In KG" := "Qty. to Ship In KG";
            WarehouseActivityLine."Sales Category" := "Sales Category";
            WarehouseActivityLine."Quarantine Qty In KG" := "Quarantine Qty In KG";
            WarehouseActivityLine."Quarantine Qty In PCS" := "Quarantine Qty In PCS";
            WarehouseActivityLine."Actual Qty In KG" := "Actual Qty In KG";
            WarehouseActivityLine."Actual Qty In PCS" := "Actual Qty In PCS";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnBeforeNewWhseActivLineInsertFromTransfer', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsertFromTransfer(var WarehouseActivityLine: Record "Warehouse Activity Line"; TransferLine: Record "Transfer Line")
    begin
        with TransferLine do begin
            //CCIT-SG
            WarehouseActivityLine.Weight1 := Weight;
            WarehouseActivityLine."Conversion Qty" := "Conversion Qty";
            WarehouseActivityLine."Qty. to Invoice In KG" := "Qty. to Ship In KG";
            WarehouseActivityLine."Qty. to Receive In KG" := "Qty. to Receive In KG";
            WarehouseActivityLine."Gen.Prod.Post.Group" := "Gen. Prod. Posting Group";
            WarehouseActivityLine."Sales Category" := "Sales Category";
            WarehouseActivityLine."Quarantine Qty In KG" := "Quarantine Qty In KG";
            WarehouseActivityLine."Quarantine Qty In PCS" := "Quarantine Qty In PCS";
            WarehouseActivityLine."Actual Qty In KG" := "Actual Qty In KG";
            WarehouseActivityLine."Actual Qty In PCS" := "Actual Qty In PCS";
            RECReservatioEntry.RESET();//CCIT_TK
            RECReservatioEntry.SETRANGE(RECReservatioEntry."Source ID", "Document No.");
            RECReservatioEntry.SETRANGE(RECReservatioEntry."Source Ref. No.", TransferLine."Line No.");
            RECReservatioEntry.SETRANGE(RECReservatioEntry."Item No.", "Item No.");
            //RECReservatioEntry.SETRANGE(RECReservatioEntry."Location Code","Transfer-to Code");
            IF RECReservatioEntry.FIND('-') THEN BEGIN
                REPEAT
                    WarehouseActivityLine."Lot No." := RECReservatioEntry."Lot No.";
                    WarehouseActivityLine."Expiration Date" := RECReservatioEntry."Expiration Date";
                    WarehouseActivityLine."Manufacturing Date" := RECReservatioEntry."Manufacturing Date";
                    WarehouseActivityLine."Warranty Date" := RECReservatioEntry."Warranty Date";//PCPL/NSW/210422
                UNTIL RECReservatioEntry.NEXT = 0;
            end;//CCIT_TK
        end;

        //CCIT-SG
    end;
    //141222
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnInsertWhseActivLineOnBeforeAutoCreation', '', false, false)]
    local procedure OnInsertWhseActivLineOnBeforeAutoCreation(var WarehouseActivityLine: Record "Warehouse Activity Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; ReservationFound: Boolean; SNRequired: Boolean; LNRequired: Boolean)
    var
        ILE: record 32;
    begin
        with WarehouseActivityLine do begin
            /* 141222
            if ReservationFound then

                //MESSAGE("Lot No.");//vikas

                //>> CS
            "Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
            "Warranty Date" := TempTrackingSpecification."Warranty Date";//PCPL/NSW/210422
            //15June22
            //<< CS
            //CCIT-SD-29-12-17 -
            "PO Lot No." := TempTrackingSpecification."Lot No.";
            "PO Expiration Date" := TempTrackingSpecification."Expiration Date";
            //"PO Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
            "PO Manufacturing Date" := TempTrackingSpecification."Warranty Date";

            //CCIT-SD-29-12-17 +
            //CCIT-SG-25052018 <<
            "Actual Batch" := TempTrackingSpecification."Actual Batch";
            "Actual Batch KGS" := TempTrackingSpecification."Actual Batch KGS";
            "Actual Batch PCS" := TempTrackingSpecification."Actual Batch PCS";
            "Actual EXP Date" := TempTrackingSpecification."Actual EXP Date";
            "Actual MFG Date" := TempTrackingSpecification."Actual MFG Date";

            //<<PCPL/NSW/07 16June22
            ILE.reset;
            //ILE.setrange("Item No.",TempTrackingSpecification."Item No.");
            ILE.setrange("Lot No.", TempTrackingSpecification."Lot No.");
            IF ILE.FINDFIRST THEN BEGIN
                "Expiration Date" := ILE."Expiration Date";
                //  "Lot No." := TempTrackingSpecification."Lot No."; //141222
                IF "PO Expiration Date" = 0D Then begin
                    "PO Expiration Date" := TempTrackingSpecification."Expiration Date";
                end
            end;
            */ //141222
               //>>PCPL/NSW/07 16June22

            //CCIT-SG-25052018 >>
            // IF (SNRequired OR LNRequired) AND (TempTrackingSpecification.NEXT <> 0) THEN BEGIN  141222
            //MESSAGE("Lot No.");//vikas
            //>> CS
            /*     //PCPL/MIG/NSW 15June22 Below Code commented due to Same value Updated in Both Line                               
            "Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
            //<< CS
            //CCIT-SD-29-12-17 -
            "PO Lot No." := TempTrackingSpecification."Lot No.";
            "PO Expiration Date" := TempTrackingSpecification."Expiration Date";
            "PO Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
            //CCIT-SD-29-12-17 +
            //CCIT-SG-25052018 <<
            "Actual Batch" := TempTrackingSpecification."Actual Batch";
            "Actual Batch KGS" := TempTrackingSpecification."Actual Batch KGS";
            "Actual Batch PCS" := TempTrackingSpecification."Actual Batch PCS";
            "Actual EXP Date" := TempTrackingSpecification."Actual EXP Date";
            "Actual MFG Date" := TempTrackingSpecification."Actual MFG Date";
            //CCIT-SG-25052018 >>
            */

            // end; 141222
            //<<15June22
            // IF "Lot No." = '' then BEGIN
            //     "Lot No." := TempTrackingSpecification."Lot No.";
            //     "Expiration Date" := TempTrackingSpecification."Expiration Date";
            // END;
            //ReservationFound := true;
            //>>15June22
            //<<PCPL/NSW/141222
            RECReservatioEntry.RESET();//CCIT_TK
            RECReservatioEntry.SETRANGE(RECReservatioEntry."Source ID", WarehouseActivityLine."Source No.");
            RECReservatioEntry.SETRANGE(RECReservatioEntry."Lot No.", WarehouseActivityLine."Lot No.");
            IF RECReservatioEntry.FindFirst() THEN BEGIN
                WarehouseActivityLine."Warranty Date" := RECReservatioEntry."Warranty Date";
                WarehouseActivityLine."Manufacturing Date" := RECReservatioEntry."Warranty Date";
            END;//CCIT_TK


        end;
    end;
    //141222
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Put-away", 'OnAfterInsertWhseActivLine', '', false, false)]
    local procedure OnAfterInsertWhseActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line"; SNRequired: Boolean; LNRequired: Boolean)
    var
        ILE: Record 32;
    begin

        RECReservatioEntry.RESET();//CCIT_TK
        RECReservatioEntry.SETRANGE(RECReservatioEntry."Source ID", WarehouseActivityLine."No.");
        RECReservatioEntry.SETRANGE(RECReservatioEntry."Source Ref. No.", WarehouseActivityLine."Line No.");
        IF RECReservatioEntry.FIND('-') THEN BEGIN
            REPEAT
                WarehouseActivityLine."Manufacturing Date" := RECReservatioEntry."Manufacturing Date";
                WarehouseActivityLine."Warranty Date" := RECReservatioEntry."Warranty Date";//PCPL/NSW/210422
            UNTIL RECReservatioEntry.NEXT = 0;
        END;//CCIT_TK

        // //<<PCPL/NSW/141222
        // RECReservatioEntry.RESET();//CCIT_TK
        // RECReservatioEntry.SETRANGE(RECReservatioEntry."Source ID", WarehouseActivityLine."Source No.");
        // RECReservatioEntry.SETRANGE(RECReservatioEntry."Lot No.", WarehouseActivityLine."Lot No.");
        // IF RECReservatioEntry.FindFirst() THEN BEGIN
        //     WarehouseActivityLine."Warranty Date" := RECReservatioEntry."Warranty Date";
        //     WarehouseActivityLine."Manufacturing Date" := RECReservatioEntry."Warranty Date";
        // END;//CCIT_TK


        // ILE.RESET();//CCIT_TK
        // ILE.SETRANGE(ILE."Order No.", WarehouseActivityLine."Source No.");
        // ILE.SETRANGE(ILE.Positive, TRUE);
        // IF ILE.FINDSET THEN
        //     REPEAT
        //         WarehouseActivityLine."Manufacturing Date" := ILE."Manufacturing Date";
        //         WarehouseActivityLine."Warranty Date" := ILE."Warranty Date";
        //         WarehouseActivityLine."Lot No." := ILE."Lot No.";
        //     UNTIL RECReservatioEntry.NEXT = 0;
        //>>PCPL/NSW/141222
    end;


    //CCIT_TK
    var
        RECReservatioEntry: Record 337;

        LicenseNo: Code[20];
        OrderDate: Date;
        RecVend: Record 23;
        RecCountry: Record 9;
        CountryCode: Code[10];
        CountryName: Text[50];
        ETDDescPort: Date;
        ETDCFS: Date;
        ETDBond: Date;
        JWLTransNo: Code[20];
        JWLTransDate: Date;
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        ProdOrder: Record "Production Order";
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7321 Create Inventory Put-away  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7323 Whse.-Act.-Post (Yes/No)  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    //


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    //local procedure OnBeforeSelectForPutAway(var WhseActivLine: Record "Warehouse Activity Line"; var Result: Boolean; var IsHandled: Boolean)
    local procedure OnBeforeConfirmPost(var WhseActivLine: Record "Warehouse Activity Line"; var HideDialog: Boolean; var Selection: Integer; var DefaultOption: Integer; var IsHandled: Boolean; var PrintDoc: Boolean)
    begin
        // IsHandled := true;
        with WhseActivLine do
            if ("Source Document" = "Source Document"::"Prod. Output") or
               ("Source Document" = "Source Document"::"Inbound Transfer") or
               ("Source Document" = "Source Document"::"Prod. Consumption")
            then begin
                if not Confirm(Text002, false, "Activity Type", "Source Document") then
                    exit
            end else begin
                //CCIT-SG-16042018+
                /* //<<PCPL/NSW/07 30June22 Wrong code Thats why Block code
                IF ("Source Document" = "Source Document"::"Purchase Order") THEN
                    Selection := STRMENU(Text003, 2)
                ELSE
                    IF ("Source Document" = "Source Document"::"Sales Return Order") THEN
                        Selection := STRMENU(Text000, 2);
                */
                //<<PCPL/NSW/07 30June22
                //CCIT-SG-16042018-
                //Selection := STRMENU(Text000,2);
                if Selection = 0 then
                    exit;
            end;

        //Result := true;
    end;

    var
        Text003: TextConst ENU = '&Receive';
        Selection: Integer;
        Text001: Label '&Ship,Ship &and Invoice';
        Text002: Label 'Do you want to post the %1 and %2?';
        Text000: Label '&Receive,Receive &and Invoice';
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7323 Whse.-Act.-Post (Yes/No)  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-99000830 Create Reserv. Entry  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    //<<PCPL/NSW/260322
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeReservEntryInsert', '', false, false)]
    local procedure OnBeforeReservEntryInsert(var ReservationEntry: Record "Reservation Entry")
    begin
        // ReservationEntry."Manufacturing Date" := 20220101D;
    end;
    //>>PCPL/NSW/260322

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeCreateRemainingReservEntry', '', false, false)]
    local procedure OnBeforeCreateRemainingReservEntry(var ReservationEntry: Record "Reservation Entry"; FromReservationEntry: Record "Reservation Entry")
    begin
        //>> CS
        ReservationEntry."Manufacturing Date" := FromReservationEntry."Manufacturing Date";
        //<< CS
        //CCIT-SG
        ReservationEntry."Qty. to Handle (Base) In KG" := FromReservationEntry."Qty. to Handle (Base) In KG";
        ReservationEntry."Remainig Qty. In KG" := FromReservationEntry."Remainig Qty. In KG";
        //CCIT-SG
        //CCIT-SD-26-12-2017 -
        ReservationEntry."PO Expiration Date" := FromReservationEntry."PO Expiration Date";
        ReservationEntry."PO Lot No." := FromReservationEntry."PO Lot No.";
        ReservationEntry."PO Manufacturing Date" := FromReservationEntry."PO Manufacturing Date";
        //CCIT-SD-26-12-2017 +
        //CCIT-SG-30012018
        ReservationEntry."Actual Qty In KG" := FromReservationEntry."Actual Qty In KG";
        ReservationEntry."Quarantine Qty In KG" := FromReservationEntry."Quarantine Qty In KG";
        //CCIT-SG-30012018
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeCreateRemainingNonSurplusReservEntry', '', false, false)]
    local procedure OnBeforeCreateRemainingNonSurplusReservEntry(var ReservationEntry: Record "Reservation Entry"; FromReservationEntry: Record "Reservation Entry")
    begin
        //>> CS
        ReservationEntry."Manufacturing Date" := FromReservationEntry."Manufacturing Date";
        //<< CS
        //CCIT-SG
        ReservationEntry."Qty. to Handle (Base) In KG" := FromReservationEntry."Qty. to Handle (Base) In KG";
        ReservationEntry."Remainig Qty. In KG" := FromReservationEntry."Remainig Qty. In KG";
        //CCIT-SG
        //CCIT-SD-26-12-2017 -
        ReservationEntry."PO Expiration Date" := FromReservationEntry."PO Expiration Date";
        ReservationEntry."PO Lot No." := FromReservationEntry."PO Lot No.";
        ReservationEntry."PO Manufacturing Date" := FromReservationEntry."PO Manufacturing Date";
        //CCIT-SD-26-12-2017 +
        //CCIT-SG-30012018
        ReservationEntry."Actual Qty In KG" := FromReservationEntry."Actual Qty In KG";
        ReservationEntry."Quarantine Qty In KG" := FromReservationEntry."Quarantine Qty In KG";
        //CCIT-SG-30012018
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeSplitReservEntry', '', false, false)]
    local procedure OnBeforeSplitReservEntry(var TempTrackingSpecification: Record "Tracking Specification" temporary; var ReservationEntry: Record "Reservation Entry")
    begin
        //>> CS
        ReservationEntry."Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
        //<< CS
        //CCIT-SG
        ReservationEntry."Qty. to Handle (Base) In KG" := TempTrackingSpecification."Qty. to Handle (Base) In KG";
        ReservationEntry."Remainig Qty. In KG" := TempTrackingSpecification."Remainig Qty. In KG";
        //CCIT-SG
        //CCIT-SD-26-12-2017 -
        ReservationEntry."PO Expiration Date" := TempTrackingSpecification."PO Expiration Date";
        ReservationEntry."PO Lot No." := TempTrackingSpecification."PO Lot No.";
        ReservationEntry."PO Manufacturing Date" := TempTrackingSpecification."PO Manufacturing Date";
        //CCIT-SD-26-12-2017 +
        //CCIT-SG-30012018
        ReservationEntry."Actual Qty In KG" := TempTrackingSpecification."Actual Qty In KG";
        ReservationEntry."Quarantine Qty In KG" := TempTrackingSpecification."Quarantine Qty In KG";
        //CCIT-SG-30012018
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeSplitNonSurplusReservEntry', '', false, false)]
    local procedure OnBeforeSplitNonSurplusReservEntry(var TempTrackingSpecification: Record "Tracking Specification" temporary; var ReservationEntry: Record "Reservation Entry")
    begin
        //>> CS
        ReservationEntry."Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
        //<< CS
        //CCIT-SG
        ReservationEntry."Qty. to Handle (Base) In KG" := TempTrackingSpecification."Qty. to Handle (Base) In KG";
        ReservationEntry."Remainig Qty. In KG" := TempTrackingSpecification."Remainig Qty. In KG";
        //CCIT-SG
        //CCIT-SD-26-12-2017 -
        ReservationEntry."PO Expiration Date" := TempTrackingSpecification."PO Expiration Date";
        ReservationEntry."PO Lot No." := TempTrackingSpecification."PO Lot No.";
        ReservationEntry."PO Manufacturing Date" := TempTrackingSpecification."PO Manufacturing Date";
        //CCIT-SD-26-12-2017 +
        //CCIT-SG-30012018
        ReservationEntry."Actual Qty In KG" := TempTrackingSpecification."Actual Qty In KG";
        ReservationEntry."Quarantine Qty In KG" := TempTrackingSpecification."Quarantine Qty In KG";
        //CCIT-SG-30012018
    end;

    PROCEDURE SetNewManufacturingDate(NewManufacturingDate: Date);
    BEGIN
        //>> CS
        InsertReservEntry."New Manufacturing Date" := NewManufacturingDate;
        //<< CS
    END;

    PROCEDURE SetQtyToHandleBaseInKG(QtytoHandleBaseInKG: Decimal);
    BEGIN
        //CCIT-SG
        InsertReservEntry."Qty. to Handle (Base) In KG" := QtytoHandleBaseInKG;
        //CCIT-SG
    END;

    PROCEDURE SetRemainQtyInKG(RemainigQtyInKG: Decimal);
    BEGIN
        //CCIT-SG
        InsertReservEntry."Remainig Qty. In KG" := RemainigQtyInKG;
        //CCIT-SG
    END;

    PROCEDURE SetPOData(POExpDate: Date; POLotNo: Code[20]; POManfDate: Date);
    BEGIN
        //CITS-SD-26-12-2017 -
        InsertReservEntry."PO Expiration Date" := POExpDate;
        InsertReservEntry."PO Lot No." := POLotNo;
        InsertReservEntry."PO Manufacturing Date" := POManfDate;
        //CITS-SD-26-12-2017 +
    END;
    //PCPL/MIG/NSW New Code Add below 
    procedure SetDatesManuFacturing(Manufacturingdate: Date)
    begin

        InsertReservEntry."Manufacturing Date" := Manufacturingdate;
    end;

    var
        InsertReservEntry: Record 337;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-99000830 Create Reserv. Entry  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-99000831 Reservation Engine Mgt.  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Engine Mgt.", 'OnBeforeUpdateItemTracking', '', false, false)]
    local procedure OnBeforeUpdateItemTracking(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    begin
        //>> CS
        ReservEntry."Manufacturing Date" := TrackingSpecification."Manufacturing Date";
        //<< CS
        //CCIT-SG
        ReservEntry."Qty. to Handle (Base) In KG" := TrackingSpecification."Qty. to Handle (Base) In KG";
        ReservEntry."Remainig Qty. In KG" := TrackingSpecification."Remainig Qty. In KG";
        //CCIT-SG
        //CCIT-SD-28-12-2017 -
        ReservEntry."PO Expiration Date" := TrackingSpecification."PO Expiration Date";
        ReservEntry."PO Lot No." := TrackingSpecification."PO Lot No.";
        ReservEntry."PO Manufacturing Date" := TrackingSpecification."PO Manufacturing Date";
        //CCIT-SD-28-12-2017 +
        //CCIT-SG-30012018
        ReservEntry."Actual Qty In KG" := TrackingSpecification."Actual Qty In KG";
        ReservEntry."Quarantine Qty In KG" := TrackingSpecification."Quarantine Qty In KG";
        //CCIT-SG-30012018
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-99000831 Reservation Engine Mgt.  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-99000832 Sales Line-Reserve  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line-Reserve", 'OnCallItemTrackingOnBeforeItemTrackingLinesRunModal', '', false, false)]
    local procedure OnCallItemTrackingOnBeforeItemTrackingLinesRunModal(var SalesLine: Record "Sales Line"; var ItemTrackingLines: Page "Item Tracking Lines")
    begin
        //>> CS
        SalesLine.CALCFIELDS("Minimum Shelf Life %");
        ItemTrackingLines.SetMinShelfLife(SalesLine."Minimum Shelf Life %");
        //<< CS
    end;

    var
        Customer: Record 18;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-99000832 Sales Line-Reserve  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-8 AccSchedManagement  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, 'OnAfterSetGLAccGLEntryFilters', '', false, false)]
    local procedure OnAfterSetGLAccGLEntryFilters(var GLAccount: Record "G/L Account"; var GLEntry: Record "G/L Entry"; var AccSchedLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; UseBusUnitFilter: Boolean; UseDimFilter: Boolean)
    begin

        with GLEntry do begin
            IF ColumnLayout."Entry Type" <> ColumnLayout."Entry Type"::" " THEN // rdk 05-08-2019
                SETCURRENTKEY("G/L Account No.", "Posting Date", "Document Type");
            IF ColumnLayout."Entry Type" <> ColumnLayout."Entry Type"::" " THEN // rdk 05-08-2019
                SETRANGE(GLEntry."Document Type", ColumnLayout."Entry Type"); // rdk 05-08-2019

            IF AccSchedLine."Document No. filter" <> '' THEN  // rdk 14-08-2019
                SETFILTER(GLEntry."Document No.", '%1', AccSchedLine."Document No. filter"); // rdk 14-08-2019

            IF AccSchedLine."Vendor Type" <> '' THEN  // rdk 21-08-2019 -
                SETFILTER(GLEntry."CashFlow Vendor Type", '%1', AccSchedLine."Vendor Type"); // rdk 21-08-2019
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, 'OnBeforeDrillDownOnGLAccount', '', false, false)]
    local procedure OnBeforeDrillDownOnGLAccount(var TempColumnLayout: Record "Column Layout" temporary; var AccScheduleLine: Record "Acc. Schedule Line"; var IsHandled: Boolean)
    var
        GLAcc: Record "G/L Account";
        GLAccAnalysisView: Record "G/L Account (Analysis View)";
        CostType: Record "Cost Type";
        ChartOfAccsAnalysisView: Page "Chart of Accs. (Analysis View)";
        AccSchedManagement: Codeunit AccSchedManagement;
        AccSchedName: Record "Acc. Schedule Name";
    begin
        IsHandled := true;
        with AccScheduleLine do
            if "Totaling Type" in ["Totaling Type"::"Cost Type", "Totaling Type"::"Cost Type Total"] then begin
                AccSchedManagement.SetCostTypeRowFilters(CostType, AccScheduleLine, TempColumnLayout);
                AccSchedManagement.SetCostTypeColumnFilters(CostType, AccScheduleLine, TempColumnLayout);
                CopyFilter("Cost Center Filter", CostType."Cost Center Filter");
                CopyFilter("Cost Object Filter", CostType."Cost Object Filter");
                CopyFilter("Cost Budget Filter", CostType."Budget Filter");
                CostType.FilterGroup(2);
                CostType.SetFilter("Cost Center Filter", AccSchedManagement.GetDimTotalingFilter(1, "Cost Center Totaling"));
                CostType.SetFilter("Cost Object Filter", AccSchedManagement.GetDimTotalingFilter(1, "Cost Object Totaling"));
                CostType.FilterGroup(8);
                CostType.SetFilter("Cost Center Filter", AccSchedManagement.GetDimTotalingFilter(1, TempColumnLayout."Cost Center Totaling"));
                CostType.SetFilter("Cost Object Filter", AccSchedManagement.GetDimTotalingFilter(1, TempColumnLayout."Cost Object Totaling"));
                CostType.FilterGroup(0);
                PAGE.Run(PAGE::"Chart of Cost Types", CostType);
            end else begin
                CopyFilter("Business Unit Filter", GLAcc."Business Unit Filter");
                CopyFilter("G/L Budget Filter", GLAcc."Budget Filter");
                AccSchedManagement.SetGLAccRowFilters(GLAcc, AccScheduleLine);
                AccSchedManagement.SetGLAccColumnFilters(GLAcc, AccScheduleLine, TempColumnLayout);
                AccSchedName.Get("Schedule Name");
                if AccSchedName."Analysis View Name" = '' then begin
                    CopyFilter("Dimension 1 Filter", GLAcc."Global Dimension 1 Filter");
                    CopyFilter("Dimension 2 Filter", GLAcc."Global Dimension 2 Filter");
                    CopyFilter("Business Unit Filter", GLAcc."Business Unit Filter");
                    GLAcc.FilterGroup(2);
                    GLAcc.SetFilter("Global Dimension 1 Filter", AccSchedManagement.GetDimTotalingFilter(1, "Dimension 1 Totaling"));
                    GLAcc.SetFilter("Global Dimension 2 Filter", AccSchedManagement.GetDimTotalingFilter(2, "Dimension 2 Totaling"));
                    GLAcc.FilterGroup(8);
                    GLAcc.SetFilter("Business Unit Filter", TempColumnLayout."Business Unit Totaling");
                    GLAcc.SetFilter("Global Dimension 1 Filter", AccSchedManagement.GetDimTotalingFilter(1, TempColumnLayout."Dimension 1 Totaling"));
                    GLAcc.SetFilter("Global Dimension 2 Filter", AccSchedManagement.GetDimTotalingFilter(2, TempColumnLayout."Dimension 2 Totaling"));
                    GLAcc.FilterGroup(0);
                    GLAcc.FINDSET;
                    GLAcc.SETFILTER("CashFlow Vendor Type", "Vendor Type");// rdk 31-08-2019
                    GLAcc.FINDSET;
                    PAGE.Run(PAGE::"Chart of Accounts (G/L)", GLAcc)
                end else begin
                    GLAcc.CopyFilter("Date Filter", GLAccAnalysisView."Date Filter");
                    GLAcc.CopyFilter("Budget Filter", GLAccAnalysisView."Budget Filter");
                    GLAcc.CopyFilter("Business Unit Filter", GLAccAnalysisView."Business Unit Filter");
                    GLAccAnalysisView.SetRange("Analysis View Filter", AccSchedName."Analysis View Name");
                    GLAccAnalysisView.CopyDimFilters(AccScheduleLine);
                    GLAccAnalysisView.FilterGroup(2);
                    GLAccAnalysisView.SetDimFilters(
                      AccSchedManagement.GetDimTotalingFilter(1, "Dimension 1 Totaling"), AccSchedManagement.GetDimTotalingFilter(2, "Dimension 2 Totaling"),
                      AccSchedManagement.GetDimTotalingFilter(3, "Dimension 3 Totaling"), AccSchedManagement.GetDimTotalingFilter(4, "Dimension 4 Totaling"));
                    GLAccAnalysisView.FilterGroup(8);
                    GLAccAnalysisView.SetDimFilters(
                      AccSchedManagement.GetDimTotalingFilter(1, TempColumnLayout."Dimension 1 Totaling"),
                      AccSchedManagement.GetDimTotalingFilter(2, TempColumnLayout."Dimension 2 Totaling"),
                      AccSchedManagement.GetDimTotalingFilter(3, TempColumnLayout."Dimension 3 Totaling"),
                      AccSchedManagement.GetDimTotalingFilter(4, TempColumnLayout."Dimension 4 Totaling"));
                    GLAccAnalysisView.SetFilter("Business Unit Filter", TempColumnLayout."Business Unit Totaling");
                    GLAccAnalysisView.FilterGroup(0);
                    Clear(ChartOfAccsAnalysisView);
                    ChartOfAccsAnalysisView.InsertTempGLAccAnalysisViews(GLAcc);
                    ChartOfAccsAnalysisView.SetTableView(GLAccAnalysisView);
                    ChartOfAccsAnalysisView.Run;
                end;
            end;
    end;

    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-8 AccSchedManagement  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

}
// 