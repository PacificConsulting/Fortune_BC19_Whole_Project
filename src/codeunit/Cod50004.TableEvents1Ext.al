codeunit 50004 "Table_Events1_Ext"
{
    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure OnAfterInitOutstandingQty(var PurchaseLine: Record "Purchase Line")
    begin
        IF PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::"Return Order", PurchaseLine."Document Type"::"Credit Memo"] THEN BEGIN

            //CCIT-SG-15012018
            PurchaseLine."Damage Qty. In KG" := PurchaseLine."Outstanding Quantity";
            IF RecItem2.GET(PurchaseLine."No.") THEN BEGIN
                IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                    IF (RecUOM.Weight <> 0) THEN BEGIN
                        PurchaseLine."Damage Qty. In PCS" := PurchaseLine."Outstanding Quantity" / RecUOM.Weight;
                        PurchaseLine."Outstanding Quantity In KG" := PurchaseLine."Outstanding Quantity" / RecUOM.Weight;
                    END
                END
            END;
            //CCIT-SG-15012018
        END ELSE BEGIN
            //CCIT-SG-15012018
            PurchaseLine."Damage Qty. In KG" := PurchaseLine."Outstanding Quantity";
            IF RecItem2.GET(PurchaseLine."No.") THEN BEGIN
                IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                    IF (RecUOM.Weight <> 0) THEN BEGIN
                        PurchaseLine."Damage Qty. In PCS" := PurchaseLine."Outstanding Quantity" / RecUOM.Weight;
                        PurchaseLine."Outstanding Quantity In KG" := PurchaseLine."Outstanding Quantity" / RecUOM.Weight;
                    END
                END
            END;
            //CCIT-SG-15012018            
        END;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterInitQtyToReceive', '', false, false)]
    local procedure OnAfterInitQtyToReceive(var PurchLine: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        GetPurchSetup;
        IF (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) OR
           (PurchLine."Document Type" = PurchLine."Document Type"::Invoice)
        THEN BEGIN
            PurchLine."Qty. to Receive In KG" := PurchLine."Outstanding Quantity In KG"; //CCIT-SD-08-01-2017
                                                                                         //"Qty. Received (Base) In KG" := "Outstanding Qty. (Base) In KG" //CCIT-SG-17012018
        END
    end;

    local procedure GetPurchSetup()
    begin
        if not PurchSetupRead then
            PurchSetup.Get();
        PurchSetupRead := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnBeforeCalcInvDiscToInvoice', '', false, false)]
    local procedure OnBeforeCalcInvDiscToInvoice(var PurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer)
    begin
        PurchaseLine."Qty. to Invoice In KG" := PurchaseLine.MaxQtyToInvoiceKG;//CCIT-SD-08-01-2017
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterUpdateWithWarehouseReceive', '', false, false)]
    local procedure OnAfterUpdateWithWarehouseReceive(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    begin
        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN
            CASE TRUE OF
                (PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Quote, PurchaseLine."Document Type"::Order]) AND (PurchaseLine.Quantity >= 0):
                    BEGIN

                        //CCIT-SD-08-01-18 -
                        IF Location.RequireReceive(PurchaseLine."Location Code") THEN
                            PurchaseLine.VALIDATE("Qty. to Receive In KG", 0)
                        ELSE
                            PurchaseLine.VALIDATE(PurchaseLine."Qty. to Receive In KG", PurchaseLine."Outstanding Quantity In KG");
                        IF PurchaseLine.Subcontracting THEN
                            PurchaseLine.VALIDATE("Qty. to Receive In KG", 0);
                        //CCIT-SD-08-01-18 +
                    END;
                (PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Quote, PurchaseLine."Document Type"::Order]) AND (PurchaseLine.Quantity < 0):
                    IF Location.RequireShipment(PurchaseLine."Location Code") THEN BEGIN

                        PurchaseLine.VALIDATE("Qty. to Receive In KG", 0);//CCIT-SD-08-01-18 +
                    END ELSE BEGIN

                        PurchaseLine.VALIDATE("Qty. to Receive In KG", PurchaseLine."Outstanding Quantity In KG");//CCIT-SD-08-01-18 +
                    END;

            END;

    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterInitQtyToReceive2', '', false, false)]
    local procedure OnAfterInitQtyToReceive2(var PurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer)
    begin
        PurchaseLine."Qty. to Receive In KG" := PurchaseLine."Outstanding Quantity In KG"; //CCIT-SD-08-01-2017

    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnInitQtyToReceive2OnBeforeCalcInvDiscToInvoice', '', false, false)]
    local procedure OnInitQtyToReceive2OnBeforeCalcInvDiscToInvoice(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine."Qty. to Invoice In KG" := PurchaseLine.MaxQtyToInvoiceKG;//CCIT-SD-08-01-2017
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterSetDefaultQuantity', '', false, false)]
    local procedure OnAfterSetDefaultQuantity(var PurchLine: Record "Purchase Line"; var xPurchLine: Record "Purchase Line")
    begin
        IF (PurchLine."Document Type" = PurchLine."Document Type"::Order) OR (PurchLine."Document Type" = PurchLine."Document Type"::Quote) THEN BEGIN
            //CCIT-SD-09-01-18 -
            PurchLine."Qty. to Receive In KG" := 0;
            PurchLine."Qty. to Invoice In KG" := 0;
            //CCIT-SD-09-01-18 +
        END;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLine(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        // SalesInvLine."GST Base Amount" := SalesInvLine."Line Amount";//CCIT-SG
        //---- CCIT-SG
        IF RecItem2.GET(SalesInvLine."No.") THEN BEGIN
            IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                IF (RecUOM.Weight <> 0) THEN BEGIN
                    SalesInvLine."Conversion Qty" := SalesInvLine.Quantity / RecUOM.Weight;
                END
            END
        END;
        //CCIT-SG

    end;

    [EventSubscriber(ObjectType::Table, database::"Purch. Rcpt. Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure OnAfterInitFromPurchLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        //CCIT-SG-12042018
        //"Damage Qty. In KG" := PurchLine."Outstanding Quantity";
        IF RecItem2.GET(PurchRcptLine."No.") THEN BEGIN
            IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                IF (RecUOM1.Weight <> 0) THEN BEGIN
                    PurchRcptLine."Conversion Qty" := PurchRcptLine.Quantity / RecUOM1.Weight;
                    //"Damage Qty. In PCS" := PurchLine."Outstanding Quantity" / RecUOM1.Weight;
                END
            END
        END;
        //CCIT-SG-12042018

    end;

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnBeforeAutofillQtyToHandle', '', false, false)]
    local procedure OnBeforeAutofillQtyToHandle(var WarehouseActivityLine: Record "Warehouse Activity Line"; var IsHandled: Boolean)
    begin
        //WarehouseActivityLine.VALIDATE("Tolerance Qty", WarehouseActivityLine."Qty. Outstanding"); //CCIT-SD-23-05-2018 -
    end;

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnBeforeDeleteQtyToHandle', '', false, false)]
    local procedure OnBeforeDeleteQtyToHandle(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        //WarehouseActivityLine.VALIDATE("Tolerance Qty", 0); //CCIT-SD-23-05-2018 -
    end;

    //PCPL/MIG/NSW New event added coz above event not working.
    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnAfterAutofillQtyToHandle', '', false, false)]
    local procedure OnAfterAutofillQtyToHandle(var WarehouseActivityLine: Record "Warehouse Activity Line")
    //begin
    //end;
    //local procedure OnAfterAutofillQtyToHandleLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WarehouseActivityLine.VALIDATE("Tolerance Qty", WarehouseActivityLine."Qty. Outstanding"); //CCIT-SD-23-05-2018 -
        //Message(Format(WarehouseActivityLine."Tolerance Qty"));
    end;

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnAfterUpdateQtyToHandleWhseActivLine', '', false, false)]
    local procedure OnAfterUpdateQtyToHandleWhseActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WarehouseActivityLine.VALIDATE("Tolerance Qty", 0); //CCIT-SD-23-05-2018 -
    end;
    //<<PCPL/NSW/210422
    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromSpec(var WarehouseActivityLine: Record "Warehouse Activity Line"; TrackingSpecification: Record "Tracking Specification")
    var
        ILE: Record 32;
    begin
        ILE.Reset();
        ILE.SetRange("Lot No.", TrackingSpecification."Lot No.");
        IF ILE.FindFirst() then begin
            WarehouseActivityLine.Validate("Expiration Date", ILE."Expiration Date");
        end;
    end;

    //>>PCPL/NSW/210422

    //<<PCPL/NSW/210422
    // [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    // local procedure OnAfterCopyTrackingFromSpec(var WarehouseActivityLine: Record "Warehouse Activity Line"; TrackingSpecification: Record "Tracking Specification")
    // begin
    //     WarehouseActivityLine."Warranty Date" := TrackingSpecification."Warranty Date";//PCPL/NSW/210422
    // end;
    //>>PCPL/NSW/210422




    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnBeforeInsertNewWhseActivLine', '', false, false)]
    local procedure OnBeforeInsertNewWhseActivLine(var NewWarehouseActivityLine: Record "Warehouse Activity Line"; var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        NewWarehouseActivityLine."Tolerance Qty" := NewWarehouseActivityLine.Quantity; //CCIT-SD-19-04-2018 -
        NewWarehouseActivityLine."Main Quantity in KG" := NewWarehouseActivityLine."Tolerance Qty"; //CCIT-SD-15-05-2018 -

        //CCIT-JAGA 22/11/2018
        IF (NewWarehouseActivityLine."Source Document" = NewWarehouseActivityLine."Source Document"::"Sales Order") OR (NewWarehouseActivityLine."Source Document" = NewWarehouseActivityLine."Source Document"::"Outbound Transfer") THEN BEGIN
            IF NewWarehouseActivityLine."TO Qty. In PCS" <> 0 THEN
                NewWarehouseActivityLine."Fill Rate %" := (NewWarehouseActivityLine."Qty. to Handle" / NewWarehouseActivityLine."TO Qty. In PCS") * 100
            ELSE
                NewWarehouseActivityLine."Fill Rate %" := (NewWarehouseActivityLine."Qty. to Handle" / NewWarehouseActivityLine.Quantity) * 100;

            NewWarehouseActivityLine."Qty. Handled In KG" := 0;  //CCIT-SG  

            //IF NewWarehouseActivityLine.INSERT THEN BEGIN

            //END;
            //CCIT-SG

        END;
        //CCIT-JAGA 22/11/2018
    end;

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnBeforeModifyOldWhseActivLine', '', false, false)]
    local procedure OnBeforeModifyOldWhseActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        //CCIT-SG
        WarehouseActivityLine.VALIDATE(Quantity);
        WarehouseActivityLine.VALIDATE("Qty. to Handle");
        WarehouseActivityLine."Main Quantity in KG" := WarehouseActivityLine."Qty. to Handle"; //ccit-sd-16-05-2018 -
        WarehouseActivityLine.VALIDATE(Quantity);
        WarehouseActivityLine.VALIDATE("Qty. to Handle");
        //CCIT-SG
    end;
    /*//Code Commented for Below new trigger Code added
    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnLookUpTrackingSummaryOnAfterAssignSerialNoTracking', '', false, false)]
    local procedure OnLookUpTrackingSummaryOnAfterAssignSerialNoTracking(var WarehouseActivityLine: Record "Warehouse Activity Line"; TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        //>> CS
        WarehouseActivityLine.VALIDATE("Manufacturing Date", TempTrackingSpecification."Manufacturing Date");
        //<< CS
    end;

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnLookUpTrackingSummaryOnAfterAssignLotNoTracking', '', false, false)]
    local procedure OnLookUpTrackingSummaryOnAfterAssignLotNoTracking(var WarehouseActivityLine: Record "Warehouse Activity Line"; TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        //>> CS
        WarehouseActivityLine.VALIDATE("Manufacturing Date", TempTrackingSpecification."Manufacturing Date");
        //<< CS
    end;
    */ //Code Commented for Above  coz new trigger Code added below

    //<<PCPL/MIG/NSW New Below Code add agian replacement of Above code for Event Trigger chnages
    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnAfterLookupTrackingSummary', '', false, false)]
    local procedure OnAfterLookupTrackingSummary(var WarehouseActivityLine: Record "Warehouse Activity Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; TrackingType: Enum "Item Tracking Type")
    begin
        case TrackingType of
            TrackingType::"Serial No.":
                if TempTrackingSpecification."Serial No." <> '' then begin
                    WarehouseActivityLine.VALIDATE("Manufacturing Date", TempTrackingSpecification."Manufacturing Date");
                    //WarehouseActivityLine.Validate("Warranty Date", TempTrackingSpecification."Warranty Date");
                END;
            TrackingType::"Lot No.":
                if TempTrackingSpecification."Lot No." <> '' then begin
                    WarehouseActivityLine.VALIDATE("Manufacturing Date", TempTrackingSpecification."Manufacturing Date");
                    //WarehouseActivityLine.Validate("Warranty Date", TempTrackingSpecification."Warranty Date");
                end;
        end;
    end;
    //>>PCPL/MIG/NSW

    [EventSubscriber(ObjectType::Table, database::"Warehouse Activity Line", 'OnAfterInitTrackingSpecFromWhseActivLine', '', false, false)]
    local procedure OnAfterInitTrackingSpecFromWhseActivLine(var TrackingSpecification: Record "Tracking Specification"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        //>> CS
        TrackingSpecification."Manufacturing Date" := WarehouseActivityLine."Manufacturing Date";
        //<< CS
        TrackingSpecification."Manufacturing Date" := WarehouseActivityLine."Manufacturing Date";//CCIT-SD
        //TrackingSpecification."Warranty Date" := WarehouseActivityLine."Warranty Date";//PCPL/MIG/NSW 050422
    end;


    /* //PCPL/MIG/NSW TEMp Comment
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterSetControls', '', false, false)]
    local procedure OnAfterSetControls(ItemTrackingCode: Record "Item Tracking Code"; var Controls: Option Handle,Invoice,Quantity,Reclass,Tracking; var SetAccess: Boolean)
    begin
        CASE Controls OF
            Controls::Reclass:
                BEGIN

                    //>> CS
                    "New Manufacturing DateVisible" := SetAccess;
                    "New Manufacturing DateEditable" := SetAccess;
                    //<< CS
                    //CCIT-SG
                    "QtytoHandleBaseInKG DateVisible" := SetAccess;
                    "RemainigQtyInKGE DateVisible" := SetAccess;
                    //CCIT-SG
                    ButtonLineReclassVisible := SetAccess;
                    ButtonLineVisible := NOT SetAccess;
                END;

            Controls::Tracking:
                BEGIN
                    //>> CS
                    "Manufacturing DateEditable" := SetAccess;
                    //<< CS
                    //CITS-SD-29-12-17 -
                    POLotNoEditable := SetAccess;
                    POExpdateEditable := SetAccess;
                    POManufacEditable := SetAccess;
                    //CITS-SD-29-12-17 +
                END;
        END;

    end;
    */ //PCPL/MIG/NSW TEMp Comment

    //PCPL/MIG/NSW TEMp Comment
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        //>> CS
        IdenticalArray[2] := (
                      (ReservEntry1."Manufacturing Date" = ReservEntry2."Manufacturing Date") AND
                      //<< CS
                      //>> CS
                      (ReservEntry1."New Manufacturing Date" = ReservEntry2."New Manufacturing Date") AND
                      //<< CS
                      //CCIT-SG
                      (ReservEntry1."Qty. to Handle (Base) In KG" = ReservEntry2."Qty. to Handle (Base) In KG") AND
                      (ReservEntry1."Remainig Qty. In KG" = ReservEntry2."Remainig Qty. In KG") AND
                      //CCIT-SG
                      //CITS-SD-26-12-2017 -
                      (ReservEntry1."PO Expiration Date" = ReservEntry2."PO Expiration Date") AND
                      (ReservEntry1."PO Lot No." = ReservEntry2."PO Lot No.") AND
                      (ReservEntry1."PO Manufacturing Date" = ReservEntry2."PO Manufacturing Date"));
        //CITS-SD-26-12-2017 +
    end;
    //PCPL/MIG/NSW TEMp Comment
    //OnAfterCreateReservEntryFor
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry', '', false, false)]
    //[EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCreateReservEntryFor', '', false, false)]
    local procedure OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry(var TrackingSpecification: Record "Tracking Specification"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer) //PCPL/MIG/NSW Add Option in parameter
    //local procedure OnAfterCreateReservEntryFor(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; var CreateReservEntry: Codeunit "Create Reserv. Entry")
    var
        WAL: Record "Warehouse Activity Line";
    begin
        IF FormRunMode = FormRunMode::Reclass THEN BEGIN
            //>> CS
            CreateReservEntry.SetNewManufacturingDate(OldTrackingSpecification."New Manufacturing Date");

            //<< CS

            //ADDED BY - CITS-SD-22-12-17 - 
            CreateReservEntry.SetQtyToHandleBaseInKG(NewTrackingSpecification."Qty. to Handle (Base) In KG");//SD
            CreateReservEntry.SetRemainQtyInKG(NewTrackingSpecification."Remainig Qty. In KG");
            //ADDED BY - CITS-SD-22-12-17 +

            //CITS-SD-26-12-2017 -
            CreateReservEntry.SetPOData(NewTrackingSpecification."PO Expiration Date", NewTrackingSpecification."PO Lot No.",
                               NewTrackingSpecification."PO Manufacturing Date");
            //CITS-SD-26-12-2017 +
            //PCPL/MIG/NSW Temp Block
            //PCPL/MIG/NSW New Function created for Below Code Replacment
            CreateReservEntry.SetDatesManuFacturing(NewTrackingSpecification."Manufacturing Date");
            /*
           CreateReservEntry.SetDates(
             //>> CS
             //NewTrackingSpecification."Warranty Date",NewTrackingSpecification."Expiration Date");
             NewTrackingSpecification."Warranty Date", NewTrackingSpecification."Expiration Date", NewTrackingSpecification."Manufacturing Date");
             //PCPL/MIG/NSW Temp Block
             */
            //<< CS
        end;
        //<<PCPL/MIG/NSW 110422
        IF FormRunMode = FormRunMode::Transfer then begin
            WAL.Reset();
            WAL.SetRange(WAL."Source No.", OldTrackingSpecification."Source ID");
            WAL.SetRange(WAL."Source Line No.", OldTrackingSpecification."Source Ref. No.");
            IF WAL.FindFirst() then begin
                OldTrackingSpecification."Expiration Date" := WAL."Expiration Date";
                NewTrackingSpecification."Expiration Date" := WAL."Expiration Date";
            end;
        end
        else begin
            WAL.Reset();
            WAL.SetRange(WAL."Source No.", OldTrackingSpecification."Source ID");
            WAL.SetRange(WAL."Source Line No.", OldTrackingSpecification."Source Ref. No.");
            IF WAL.FindFirst() then begin
                OldTrackingSpecification."Expiration Date" := WAL."Expiration Date";
                NewTrackingSpecification."Expiration Date" := WAL."Expiration Date";
            end;
        end;


        //>>PCPL/MIG/NSW 110422
    ENd;

    //PCPL/MIG/NSW TEMp Comment
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        //>> CS
        SourceTrackingSpec."Manufacturing Date" := DestTrkgSpec."Manufacturing Date";
        //<< CS
        //CCIT-SG
        SourceTrackingSpec."Qty. to Handle (Base) In KG" := DestTrkgSpec."Qty. to Handle (Base) In KG";
        SourceTrackingSpec."Remainig Qty. In KG" := DestTrkgSpec."Remainig Qty. In KG";
        //CCIT-SG
        //CITS-SD-26-12-2017 -
        SourceTrackingSpec."PO Expiration Date" := DestTrkgSpec."PO Expiration Date";
        SourceTrackingSpec."PO Lot No." := DestTrkgSpec."PO Lot No.";
        SourceTrackingSpec."PO Manufacturing Date" := DestTrkgSpec."PO Manufacturing Date";
        //CITS-SD-26-12-2017 -   
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterModify', '', false, false)]
    local procedure OnRegisterChangeOnAfterModify(var NewTrackingSpecification: Record "Tracking Specification"; var OldTrackingSpecification: Record "Tracking Specification")
    begin
        //ChangeType::FullDelete,ChangeType::PartDelete:
        //>> CS
        NewTrackingSpecification."Manufacturing Date" := 0D;
        //<< CS
        //CITS-SD-29-12-17 -
        NewTrackingSpecification."PO Lot No." := '';
        NewTrackingSpecification."PO Expiration Date" := 0D;
        NewTrackingSpecification."PO Manufacturing Date" := 0D;
        //CITS-SD-29-12-17 +
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterClearTrackingSpec', '', false, false)]
    local procedure OnAfterClearTrackingSpec(var OldTrkgSpec: Record "Tracking Specification")
    begin
        //>> CS
        OldTrkgSpec."Manufacturing Date" := 0D;
        //<< CS
        //CITS-SD-29-12-17 -
        OldTrkgSpec."PO Lot No." := '';
        OldTrkgSpec."PO Expiration Date" := 0D;
        OldTrkgSpec."PO Manufacturing Date" := 0D;
        //CITS-SD-29-12-17 +
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        //>> CS
        ReservEntry."Manufacturing Date" := TrkgSpec."Manufacturing Date";
        //<< CS
        //>> CS
        ReservEntry."New Manufacturing Date" := TrkgSpec."New Manufacturing Date";
        //<< CS
        //CCIT-SG
        ReservEntry."Qty. to Handle (Base) In KG" := TrkgSpec."Qty. to Handle (Base) In KG";
        ReservEntry."Remainig Qty. In KG" := TrkgSpec."Remainig Qty. In KG";
        //CCIT-SG
        //CITS-SD-26-12-2017 -
        ReservEntry."PO Expiration Date" := TrkgSpec."PO Expiration Date";
        ReservEntry."PO Lot No." := TrkgSpec."PO Lot No.";
        ReservEntry."PO Manufacturing Date" := TrkgSpec."PO Manufacturing Date";
        //CITS-SD-26-12-2017 +
    end;
    //PCPL/MIG/NSW TEMp Comment

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterAssignNewTrackingNo', '', false, false)]
    local procedure OnAfterAssignNewTrackingNo(var TrkgSpec: Record "Tracking Specification"; xTrkgSpec: Record "Tracking Specification"; FieldID: Integer)
    begin
        //CCIT-SG
        IF RecItem.GET(TrkgSpec."Item No.") THEN BEGIN
            IF (RecItem."Base Unit of Measure" = 'PCS') THEN BEGIN
                IF RecUOM1.GET(RecItem."No.", 'PCS') THEN BEGIN
                    IF (RecUOM1.Weight <> 0) THEN
                        TrkgSpec."Remainig Qty. In KG" := TrkgSpec."Quantity (Base)" * RecUOM1.Weight;
                    TrkgSpec."Qty. to Handle (Base) In KG" := TrkgSpec."Quantity (Base)" * RecUOM1.Weight; //CITS-SD-26-12-2017
                END;
            END;
        END;
        //CCIT-SG

    end;
    //<<PCPL/NSW/260322
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure OnRegisterChangeOnAfterCreateReservEntry(var ReservEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification"; OldTrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry."Manufacturing Date" := TrackingSpecification."Manufacturing Date";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeRegisterChange', '', false, false)]
    local procedure OnBeforeRegisterChange(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; CurrentSignFactor: Integer; FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer; var IsHandled: Boolean)
    var

    begin
        // "Old & New TrackingSpecification".Init();
        // "Old & New TrackingSpecification".TransferFields(NewTrackingSpecification);
        // "Old & New TrackingSpecification".Insert();
        // ExpireDateTemp := NewTrackingSpecification."Expiration Date";

    end;

    //>>PCPL/NSW/260322

    [EventSubscriber(ObjectType::Page, Page::"Whse. Item Tracking Lines", 'OnBeforeItemTrackingLineInsert', '', false, false)]
    local procedure OnBeforeItemTrackingLineInsert(var WhseItemTrackingLine: Record "Whse. Item Tracking Line"; WhseWorksheetLine: Record "Whse. Worksheet Line"; WarehouseEntry: Record "Warehouse Entry")
    begin
        //>> CS
        IF (WhseItemTrackingLine."Manufacturing Date" <> 0D) AND (FormSourceType = DATABASE::"Internal Movement Line") THEN
            WhseItemTrackingLine.InitManufacturingDate;
        //<< CS

    end;





    [EventSubscriber(ObjectType::Table, database::"Reservation Entry", 'OnAfterCopyTrackingFromTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromTrackingSpec(var ReservationEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        ReservationEntry."Manufacturing Date" := TrackingSpecification."Manufacturing Date";
    end;

    [EventSubscriber(ObjectType::Table, database::"Reservation Entry", 'OnAfterCopyTrackingFromWhseActivLine', '', false, false)]
    local procedure OnAfterCopyTrackingFromWhseActivLine(var ReservationEntry: Record "Reservation Entry"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        ReservationEntry."Warranty Date" := WarehouseActivityLine."Warranty Date";//PCPL/NSW/08042022
                                                                                  // ReservationEntry."Expiration Date" := WarehouseActivityLine."Expiration Date"; //PCPL/NSW/11042022
    end;







    var
        RecItem: Record 27;
        FormSourceType: Integer;
        RecItem2: Record 27;
        RecUOM: Record 5404;
        PurchSetupRead: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
        Location: Record 14;
        RecUOM1: Record 5404;
        "New Manufacturing DateVisible": Boolean;
        "New Manufacturing DateEditable": Boolean;
        "QtytoHandleBaseInKG DateVisible": Boolean;
        "RemainigQtyInKGE DateVisible": Boolean;
        ButtonLineReclassVisible: Boolean;
        ButtonLineVisible: Boolean;
        "Manufacturing DateEditable": Boolean;
        POLotNoEditable: Boolean;
        POExpdateEditable: Boolean;
        POManufacEditable: Boolean;
        CreateReservEntry: Codeunit 50006;

        "Old & New TrackingSpecification": Record "Tracking Specification" temporary;//PCPL/MIG/NSW
        ExpireDateTemp: Date;//PCPL/MIG/NSW



}

