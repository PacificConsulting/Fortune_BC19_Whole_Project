codeunit 50007 "ItemTrackingManagementEvents"
{
    trigger OnRun()
    begin
        //****** Codunit Inculded in 6500,90,6501,7324 ************
    end;
    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-6500 Item Tracking Management  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeTempHandlingSpecificationInsert', '', false, false)]
    local procedure OnBeforeTempHandlingSpecificationInsert(var TempTrackingSpecification: Record "Tracking Specification" temporary; ReservationEntry: Record "Reservation Entry")
    var
        EntriesExist: Boolean;
    begin
        if TempTrackingSpecification."Expiration Date" <> 0D then
            EntriesExist := true;
        //>> CS
        MfgDate :=
          ExistingManufacturingDate(
            ReservationEntry."Item No.", ReservationEntry."Variant Code", ReservationEntry."Lot No.", ReservationEntry."Serial No.", FALSE, EntriesExist);
        //<< CS
        if EntriesExist then begin
            //>> CS
            IF MfgDate = 0D then  //PCPL/NSW/260322 New Code add for Manufacturing Date is going to blank
                TempTrackingSpecification."Manufacturing Date" := TempTrackingSpecification."Manufacturing Date" //PCPL/NSW/260322
            else //PCPL/NSW/260322
                TempTrackingSpecification."Manufacturing Date" := MfgDate;
            //<< CS
            //CITS-SD-21-12-2017 -
            TempTrackingSpecification."Qty. to Handle (Base) In KG" := ReservationEntry."Qty. to Handle (Base) In KG";
            TempTrackingSpecification."Remainig Qty. In KG" := ReservationEntry."Remainig Qty. In KG";
            TempTrackingSpecification."PO Lot No." := ReservationEntry."PO Lot No.";
            TempTrackingSpecification."Expiration Date" := ReservationEntry."Expiration Date";
            //TempHandlingSpecification."Manufacturing Date" := ReservEntry."Manufacturing Date";
            TempTrackingSpecification."PO Expiration Date" := ReservationEntry."PO Expiration Date"; //22122020
            TempTrackingSpecification."PO Manufacturing Date" := ReservationEntry."PO Manufacturing Date";
            //CITS-SD-21-12-2017 +
            //JAGA 09-05-18 >>
            TempTrackingSpecification."Actual Batch" := ReservationEntry."Actual Batch";
            TempTrackingSpecification."Actual Batch KGS" := ReservationEntry."Actual Batch KGS";
            TempTrackingSpecification."Actual Batch PCS" := ReservationEntry."Actual Batch PCS";
            TempTrackingSpecification."Actual EXP Date" := ReservationEntry."Actual EXP Date";
            TempTrackingSpecification."Actual MFG Date" := ReservationEntry."Actual MFG Date";
            //JAGA 09-05-18  <<
            //CCIT-SG-30012018
            TempTrackingSpecification."Actual Qty In KG" := ReservationEntry."Actual Qty In KG";
            TempTrackingSpecification."Quarantine Qty In KG" := ReservationEntry."Quarantine Qty In KG";
            //CCIT-SG-30012018
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnSplitWhseJnlLineOnAfterCopyTrackingByToTransfer', '', false, false)]
    local procedure OnSplitWhseJnlLineOnAfterCopyTrackingByToTransfer(var TempWhseSplitTrackingSpec: Record "Tracking Specification"; var TempWhseJnlLine2: Record "Warehouse Journal Line"; ToTransfer: Boolean)
    begin
        with TempWhseSplitTrackingSpec do begin
            if ToTransfer then begin
                //>> CS
                IF "New Expiration Date" <> 0D THEN
                    TempWhseJnlLine2."Manufacturing Date" := "New Manufacturing Date";
                //<< CS
                //CCIT-SG
                TempWhseJnlLine2."Qty. to Handle (Base) In KG" := "Qty. to Handle (Base) In KG";
                TempWhseJnlLine2."Remainig Qty. In KG" := "Remainig Qty. In KG";
                //CCIT-SG
                //CITS-SD-29-12-17 -
                TempWhseJnlLine2."PO Lot No." := "PO Lot No.";
                TempWhseJnlLine2."PO Expiration Date" := "PO Expiration Date";
                TempWhseJnlLine2."PO Manufacturing Date" := "PO Manufacturing Date";
                //CITS-SD-29-12-17 +
                //JAGA 09-05-18 >>
                TempWhseJnlLine2."Actual Batch" := "Actual Batch";
                TempWhseJnlLine2."Actual Batch KGS" := "Actual Batch KGS";
                TempWhseJnlLine2."Actual Batch PCS" := "Actual Batch PCS";
                TempWhseJnlLine2."Actual EXP Date" := "Actual EXP Date";
                TempWhseJnlLine2."Actual MFG Date" := "Actual MFG Date";
                //JAGA 09-05-18 <<
                //CCIT-SG-30012018
                TempWhseJnlLine2."Actual Qty In KG" := "Actual Qty In KG";
                TempWhseJnlLine2."Quarantine Qty In KG" := "Quarantine Qty In KG";
                //CCIT-SG-30012018
            end else begin
                //>> CS
                TempWhseJnlLine2."Manufacturing Date" := "Manufacturing Date";
                //<< CS
                //CITS-SD-29-12-17 -
                TempWhseJnlLine2."PO Lot No." := "PO Lot No.";
                TempWhseJnlLine2."PO Expiration Date" := "PO Expiration Date";
                TempWhseJnlLine2."PO Manufacturing Date" := "PO Manufacturing Date";
                //CITS-SD-29-12-17 +

                //JAGA 09-05-18 >>
                TempWhseJnlLine2."Actual Batch" := "Actual Batch";
                TempWhseJnlLine2."Actual Batch KGS" := "Actual Batch KGS";
                TempWhseJnlLine2."Actual Batch PCS" := "Actual Batch PCS";
                TempWhseJnlLine2."Actual EXP Date" := "Actual EXP Date";
                TempWhseJnlLine2."Actual MFG Date" := "Actual MFG Date";
                //JAGA 09-05-18 <<

                //CCIT-SG-30012018
                TempWhseJnlLine2."Actual Qty In KG" := "Actual Qty In KG";
                TempWhseJnlLine2."Quarantine Qty In KG" := "Quarantine Qty In KG";
                //CCIT-SG-30012018

            end;
            //>> CS
            TempWhseJnlLine2."New Manufacturing Date" := "New Manufacturing Date";
            //<< CS
            //CCIT-SG
            TempWhseJnlLine2."Qty. to Handle (Base) In KG" := "Qty. to Handle (Base) In KG";
            TempWhseJnlLine2."Remainig Qty. In KG" := "Remainig Qty. In KG";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeInsertSplitPostedWhseRcptLine', '', false, false)]
    local procedure OnBeforeInsertSplitPostedWhseRcptLine(var TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary; PostedWhseRcptLine: Record "Posted Whse. Receipt Line"; WhseItemEntryRelation: Record "Whse. Item Entry Relation"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //>> CS
        TempPostedWhseRcptLine."Manufacturing Date" := ItemLedgerEntry."Manufacturing Date";
        //<< CS
        //CITS-SD-29-12-17 -
        TempPostedWhseRcptLine."PO Lot No." := ItemLedgerEntry."PO Lot No.";
        TempPostedWhseRcptLine."PO Expiration Date" := ItemLedgerEntry."PO Expiration Date";
        TempPostedWhseRcptLine."PO Manufacturing Date" := ItemLedgerEntry."PO Manufacturing Date";
        //CITS-SD-29-12-17 +
        //JAGA 09-05-18 >>
        TempPostedWhseRcptLine."Actual Batch" := ItemLedgerEntry."Actual Batch";
        TempPostedWhseRcptLine."Actual Batch KGS" := ItemLedgerEntry."Actual Batch KGS";
        TempPostedWhseRcptLine."Actual Batch PCS" := ItemLedgerEntry."Actual Batch PCS";
        TempPostedWhseRcptLine."Actual EXP Date" := ItemLedgerEntry."Actual EXP Date";
        TempPostedWhseRcptLine."Actual MFG Date" := ItemLedgerEntry."Actual MFG Date";
        //JAGA 09-05-18 <<
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeInsertSplitInternalPutAwayLine', '', false, false)]
    local procedure OnBeforeInsertSplitInternalPutAwayLine(var TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary; PostedWhseRcptLine: Record "Posted Whse. Receipt Line"; WhseItemTrackingLine: Record "Whse. Item Tracking Line")
    begin
        //>> CS
        TempPostedWhseRcptLine."Manufacturing Date" := WhseItemTrackingLine."Manufacturing Date";
        //<< CS
        //CITS-SD-29-12-17 -
        TempPostedWhseRcptLine."PO Lot No." := WhseItemTrackingLine."PO Lot No.";
        TempPostedWhseRcptLine."PO Expiration Date" := WhseItemTrackingLine."PO Expiration Date";
        TempPostedWhseRcptLine."PO Manufacturing Date" := WhseItemTrackingLine."PO Manufacturing Date";
        //CITS-SD-29-12-17 +
        //JAGA 09-05-18 >>
        TempPostedWhseRcptLine."Actual Batch" := WhseItemTrackingLine."Actual Batch";
        TempPostedWhseRcptLine."Actual Batch KGS" := WhseItemTrackingLine."Actual Batch KGS";
        TempPostedWhseRcptLine."Actual Batch PCS" := WhseItemTrackingLine."Actual Batch PCS";
        TempPostedWhseRcptLine."Actual EXP Date" := WhseItemTrackingLine."Actual EXP Date";
        TempPostedWhseRcptLine."Actual MFG Date" := WhseItemTrackingLine."Actual MFG Date";
        //JAGA 09-05-18 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeCreateWhseItemTrkgForReceipt', '', false, false)]
    local procedure OnBeforeCreateWhseItemTrkgForReceipt(var WhseItemTrackingLine: Record "Whse. Item Tracking Line"; WhseWkshLine: Record "Whse. Worksheet Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //>> CS
        WhseItemTrackingLine."Manufacturing Date" := ItemLedgerEntry."Manufacturing Date";
        //<< CS
        //CCIT-SG
        WhseItemTrackingLine."License No." := ItemLedgerEntry."License No.";
        WhseItemTrackingLine.Weight := ItemLedgerEntry.Weight;
        WhseItemTrackingLine."Conversion Qty" := ItemLedgerEntry."Conversion Qty";
        WhseItemTrackingLine."Saleable Qty. In PCS" := ItemLedgerEntry."Saleable Qty. In PCS";
        WhseItemTrackingLine."Saleable Qty. In KG" := ItemLedgerEntry."Saleable Qty. In KG";
        WhseItemTrackingLine."Damage Qty. In PCS" := ItemLedgerEntry."Damage Qty. In PCS";
        WhseItemTrackingLine."Damage Qty. In KG" := ItemLedgerEntry."Damage Qty. In KG";
        WhseItemTrackingLine."Sales Category" := ItemLedgerEntry."Sales Category";
        //CCIT-SG
        //CITS-SD-29-12-17 -
        WhseItemTrackingLine."PO Lot No." := ItemLedgerEntry."PO Lot No.";
        WhseItemTrackingLine."PO Expiration Date" := ItemLedgerEntry."PO Expiration Date";
        WhseItemTrackingLine."PO Manufacturing Date" := ItemLedgerEntry."PO Manufacturing Date";
        //CITS-SD-29-12-17 +
        //JAGA
        WhseItemTrackingLine."Actual Batch" := ItemLedgerEntry."Actual Batch";
        WhseItemTrackingLine."Actual Batch KGS" := ItemLedgerEntry."Actual Batch KGS";
        WhseItemTrackingLine."Actual Batch PCS" := ItemLedgerEntry."Actual Batch PCS";
        WhseItemTrackingLine."Actual EXP Date" := ItemLedgerEntry."Actual EXP Date";
        WhseItemTrackingLine."Actual MFG Date" := ItemLedgerEntry."Actual MFG Date";
        //JAGA
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeCreateWhseItemTrkgForResEntry', '', false, false)]
    local procedure OnBeforeCreateWhseItemTrkgForResEntry(var WhseItemTrackingLine: Record "Whse. Item Tracking Line"; SourceReservEntry: Record "Reservation Entry"; WhseWkshLine: Record "Whse. Worksheet Line")
    begin
        //>> CS
        WhseItemTrackingLine."Manufacturing Date" := SourceReservEntry."Manufacturing Date";
        //<< CS
        //CCIT-SG
        WhseItemTrackingLine."Qty. to Handle (Base) In KG" := SourceReservEntry."Qty. to Handle (Base) In KG";
        WhseItemTrackingLine."Remainig Qty. In KG" := SourceReservEntry."Remainig Qty. In KG";
        //CCIT-SG
        //CITS-SD-29-12-17 -
        WhseItemTrackingLine."PO Lot No." := SourceReservEntry."PO Lot No.";
        WhseItemTrackingLine."PO Expiration Date" := SourceReservEntry."PO Expiration Date";
        WhseItemTrackingLine."PO Manufacturing Date" := SourceReservEntry."PO Manufacturing Date";
        //CITS-SD-29-12-17 +
        //JAGA 09-05-18 >>
        WhseItemTrackingLine."Actual Batch" := SourceReservEntry."Actual Batch";
        WhseItemTrackingLine."Actual Batch KGS" := SourceReservEntry."Actual Batch KGS";
        WhseItemTrackingLine."Actual Batch PCS" := SourceReservEntry."Actual Batch PCS";
        WhseItemTrackingLine."Actual EXP Date" := SourceReservEntry."Actual EXP Date";
        WhseItemTrackingLine."Actual MFG Date" := SourceReservEntry."Actual MFG Date";
        //JAGA 09-05-18 <<
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeInsertWhseItemTrkgLines', '', false, false)]
    local procedure OnBeforeInsertWhseItemTrkgLines(var WhseItemTrkgLine: Record "Whse. Item Tracking Line"; PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; WhseItemEntryRelation: Record "Whse. Item Entry Relation"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //>> CS
        WhseItemTrkgLine."Manufacturing Date" := ItemLedgerEntry."Manufacturing Date";
        //<< CS
        //CCIT-SG
        WhseItemTrkgLine."License No." := ItemLedgerEntry."License No.";
        WhseItemTrkgLine.Weight := ItemLedgerEntry.Weight;
        WhseItemTrkgLine."Conversion Qty" := ItemLedgerEntry."Conversion Qty";
        WhseItemTrkgLine."Saleable Qty. In PCS" := ItemLedgerEntry."Saleable Qty. In PCS";
        WhseItemTrkgLine."Saleable Qty. In KG" := ItemLedgerEntry."Saleable Qty. In KG";
        WhseItemTrkgLine."Damage Qty. In PCS" := ItemLedgerEntry."Damage Qty. In PCS";
        WhseItemTrkgLine."Damage Qty. In KG" := ItemLedgerEntry."Damage Qty. In KG";
        WhseItemTrkgLine."Sales Category" := ItemLedgerEntry."Sales Category";
        //CCIT-SG
        //CITS-SD-29-12-17 -
        WhseItemTrkgLine."PO Lot No." := ItemLedgerEntry."PO Lot No.";
        WhseItemTrkgLine."PO Expiration Date" := ItemLedgerEntry."PO Expiration Date";
        WhseItemTrkgLine."PO Manufacturing Date" := ItemLedgerEntry."PO Manufacturing Date";
        //CITS-SD-29-12-17 +
        //JAGA
        WhseItemTrkgLine."Actual Batch" := ItemLedgerEntry."Actual Batch";
        WhseItemTrkgLine."Actual Batch KGS" := ItemLedgerEntry."Actual Batch KGS";
        WhseItemTrkgLine."Actual Batch PCS" := ItemLedgerEntry."Actual Batch PCS";
        WhseItemTrkgLine."Actual EXP Date" := ItemLedgerEntry."Actual EXP Date";
        WhseItemTrkgLine."Actual MFG Date" := ItemLedgerEntry."Actual MFG Date";
        //JAGA
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeWhseItemTrackingLineInsert', '', false, false)]
    local procedure OnBeforeWhseItemTrackingLineInsert(var WhseItemTrackingLine: Record "Whse. Item Tracking Line"; SourceReservEntry: Record "Reservation Entry")
    begin
        //>> CS
        WhseItemTrackingLine."Manufacturing Date" := SourceReservEntry."Manufacturing Date";
        //<< CS
        //CITS-SD-29-12-17 -
        WhseItemTrackingLine."PO Lot No." := SourceReservEntry."PO Lot No.";
        WhseItemTrackingLine."PO Expiration Date" := SourceReservEntry."PO Expiration Date";
        WhseItemTrackingLine."PO Manufacturing Date" := SourceReservEntry."PO Manufacturing Date";
        //CITS-SD-29-12-17 +
        //JAGA
        WhseItemTrackingLine."Actual Batch" := SourceReservEntry."Actual Batch";
        WhseItemTrackingLine."Actual Batch KGS" := SourceReservEntry."Actual Batch KGS";
        WhseItemTrackingLine."Actual Batch PCS" := SourceReservEntry."Actual Batch PCS";
        WhseItemTrackingLine."Actual EXP Date" := SourceReservEntry."Actual EXP Date";
        WhseItemTrackingLine."Actual MFG Date" := SourceReservEntry."Actual MFG Date";
        //JAGA
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeExistingExpirationDate', '', false, false)]
    local procedure OnBeforeExistingExpirationDate(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; TestMultiple: Boolean; var EntriesExist: Boolean; var ExpDate: Date; var IsHandled: Boolean; var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnInitReservEntryOnBeforeCopyTrackingFromItemLedgEntry', '', false, false)]
    local procedure OnInitReservEntryOnBeforeCopyTrackingFromItemLedgEntry(var ReservEntry: Record "Reservation Entry"; var ItemLedgEntryBuf: Record "Item Ledger Entry"; var EntriesExist: Boolean)
    begin
        with ReservEntry do begin
            //>> CS
            ReservEntry."Manufacturing Date" :=
              ExistingManufacturingDate("Item No.", "Variant Code", "Lot No.", "Serial No.", FALSE, EntriesExist);
            //<< CS
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnSyncActivItemTrkgOnBeforeInsertTempReservEntry', '', false, false)]
    local procedure OnSyncActivItemTrkgOnBeforeInsertTempReservEntry(var TempReservEntry: Record "Reservation Entry" temporary; WhseActivLine: Record "Warehouse Activity Line")
    begin
        with WhseActivLine do begin
            //>> CS
            TempReservEntry."Manufacturing Date" := "Manufacturing Date";
            //<< CS
            //CITS-SD-29-12-17 -
            TempReservEntry."PO Lot No." := "PO Lot No.";
            TempReservEntry."PO Expiration Date" := "PO Expiration Date";
            TempReservEntry."PO Manufacturing Date" := "PO Manufacturing Date";
            //CITS-SD-29-12-17 +
            //JAGA
            TempReservEntry."Actual Batch" := "Actual Batch";
            TempReservEntry."Actual Batch KGS" := "Actual Batch KGS";
            TempReservEntry."Actual Batch PCS" := "Actual Batch PCS";
            TempReservEntry."Actual EXP Date" := "Actual EXP Date";
            TempReservEntry."Actual MFG Date" := "Actual MFG Date";
            //JAGA
            //CCIT-SG-30012018
            TempReservEntry."Actual Qty In KG" := "Actual Qty In KG";
            TempReservEntry."Quarantine Qty In KG" := "Quarantine Qty In KG";

            //CCIT-SG-30012018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnSynchronizeWhseActivItemTrkgOnAfterSetExpirationDate', '', false, false)]
    local procedure OnSynchronizeWhseActivItemTrkgOnAfterSetExpirationDate(var WarehouseActivityLine: Record "Warehouse Activity Line"; var ReservationEntry: Record "Reservation Entry")
    begin
        with WarehouseActivityLine do begin
            //>> CS
            ReservationEntry."Manufacturing Date" := "Manufacturing Date";
            //<< CS
            //CITS-SD-29-12-17 -
            ReservationEntry."PO Lot No." := "PO Lot No.";
            ReservationEntry."PO Expiration Date" := "PO Expiration Date";
            ReservationEntry."PO Manufacturing Date" := "PO Manufacturing Date";
            //CITS-SD-29-12-17 +
            //JAGA
            ReservationEntry."Actual Batch" := "Actual Batch";
            ReservationEntry."Actual Batch KGS" := "Actual Batch KGS";
            ReservationEntry."Actual Batch PCS" := "Actual Batch PCS";
            ReservationEntry."Actual EXP Date" := "Actual EXP Date";
            ReservationEntry."Actual MFG Date" := "Actual MFG Date";
            //JAGA
        end;
    end;
    //<<PCPL/NSW/220422
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnAfterInitReservEntry', '', false, false)]
    local procedure OnAfterInitReservEntry(var ReservEntry: Record "Reservation Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ReservEntry."Expiration Date" := ItemLedgerEntry."Expiration Date";
        ReservEntry."Warranty Date" := ItemLedgerEntry."Warranty Date";
    end;
    //>>PCPL/NSW/220422

    PROCEDURE ExistingManufacturingDate(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[20]; SerialNo: Code[20]; TestMultiple: Boolean; VAR EntriesExist: Boolean) MfgDate: Date;
    VAR
        ItemLedgEntry: Record 32;
        ItemTracingMgt: Codeunit 6520;
    BEGIN
        //>> CS
        IF NOT ItemTrackCU.GetLotSNDataSet(ItemNo, Variant, LotNo, SerialNo, ItemLedgEntry) THEN BEGIN
            EntriesExist := FALSE;
            EXIT;
        END;

        EntriesExist := TRUE;
        IF ItemLedgEntry."Manufacturing Date" <> 0D then //PCPL/NSW/260322 New condititon Add
            MfgDate := ItemLedgEntry."Manufacturing Date";
    END;

    PROCEDURE ExistingManufacturingDateAndQty(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[20]; SerialNo: Code[20]; VAR SumOfEntries: Decimal) MfgDate: Date;
    VAR
        ItemLedgEntry: Record 32;
    BEGIN
        //>> CS
        IF NOT ItemTrackCU.GetLotSNDataSet(ItemNo, Variant, LotNo, SerialNo, ItemLedgEntry) THEN
            EXIT;

        MfgDate := ItemLedgEntry."Manufacturing Date";
        //<< CS
    END;

    PROCEDURE WhseExistingManufacturingDate(ItemNo: Code[20]; VariantCode: Code[20]; Location: Record 14; LotNo: Code[20]; SerialNo: Code[20]; VAR EntriesExist: Boolean) MfgDate: Date;
    VAR
        WhseEntry: Record 7312;
        SumOfEntries: Decimal;
    BEGIN
        //>> CS
        IF Location."Adjustment Bin Code" = '' THEN
            EXIT;

        WITH WhseEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.");
            SETRANGE("Item No.", ItemNo);
            SETRANGE("Bin Code", Location."Adjustment Bin Code");
            SETRANGE("Location Code", Location.Code);
            SETRANGE("Variant Code", VariantCode);
            IF LotNo <> '' THEN
                SETRANGE("Lot No.", LotNo)
            ELSE
                IF SerialNo <> '' THEN
                    SETRANGE("Serial No.", SerialNo);
            IF ISEMPTY THEN
                EXIT;

            IF FINDSET THEN
                REPEAT
                    SumOfEntries += "Qty. (Base)";
                    IF ("Manufacturing Date" <> 0D) AND (("Manufacturing Date" < MfgDate) OR (MfgDate = 0D)) THEN
                        MfgDate := "Manufacturing Date";
                UNTIL NEXT = 0;
        END;

        EntriesExist := SumOfEntries < 0;
        //<< CS
    END;

    PROCEDURE GetWhseManufacturingDate(ItemNo: Code[20]; VariantCode: Code[20]; Location: Record 14; LotNo: Code[20]; SerialNo: Code[20]; VAR MfgDate: Date): Boolean;
    VAR
        EntriesExist: Boolean;
    BEGIN
        //>> CS
        MfgDate := ExistingManufacturingDate(ItemNo, VariantCode, LotNo, SerialNo, FALSE, EntriesExist);
        IF EntriesExist THEN
            EXIT(TRUE);

        MfgDate := WhseExistingManufacturingDate(ItemNo, VariantCode, Location, LotNo, SerialNo, EntriesExist);
        IF EntriesExist THEN
            EXIT(TRUE);

        MfgDate := 0D;
        EXIT(FALSE);
        //<< CS
    END;

    PROCEDURE RetrieveAppliedManufacturingDate(VAR TempItemLedgEntry: Record 32 TEMPORARY);
    VAR
        ItemLedgEntry: Record 32;
        ItemApplnEntry: Record 339;
    BEGIN
        //>> CS
        WITH TempItemLedgEntry DO BEGIN
            IF Positive THEN
                EXIT;

            ItemApplnEntry.RESET;
            ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
            ItemApplnEntry.SETRANGE("Outbound Item Entry No.", "Entry No.");
            ItemApplnEntry.SETRANGE("Item Ledger Entry No.", "Entry No.");
            IF ItemApplnEntry.FINDFIRST THEN BEGIN
                ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
                "Manufacturing Date" := ItemLedgEntry."Manufacturing Date";
            END;
        END;
        //<< CS
    END;


    var
        MfgDate: Date;
        ItemTrackCU: Codeunit "Item Tracking Management";
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-6500 Item Tracking Management  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-90 Purch.-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnInsertReceiptLineOnAfterInitPurchRcptLine', '', false, false)]
    local procedure OnInsertReceiptLineOnAfterInitPurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; xPurchLine: Record "Purchase Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var CostBaseAmount: Decimal; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header"; WhseRcptHeader: Record "Warehouse Receipt Header")
    begin
        PurchRcptLine."Bill Of Entry No." := xPurchLine."Bill Of Entry No."; //ccit vivek
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostUpdateOrderLineOnPurchHeaderReceive', '', false, false)]
    local procedure OnPostUpdateOrderLineOnPurchHeaderReceive(var TempPurchLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        //CCIT-SD-08-01-2017
        TempPurchLine."Quantity Received In KG" := TempPurchLine."Quantity Received In KG" + TempPurchLine."Qty. to Receive In KG";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostUpdateOrderLineOnBeforeUpdateBlanketOrderLine', '', false, false)]
    local procedure OnPostUpdateOrderLineOnBeforeUpdateBlanketOrderLine(var PurchaseHeader: Record "Purchase Header"; var TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        if PurchaseHeader.Invoice then begin
            if TempPurchaseLine."Document Type" = TempPurchaseLine."Document Type"::Order then
                //CCIT-SD-08-01-2017-
                TempPurchaseLine.VALIDATE("Qty. to Invoice In KG",
                              TempPurchaseLine."Quantity Received In KG" - TempPurchaseLine."Quantity Invoiced In KG");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    begin
        with PurchaseHeader do begin
            //CCIT-JAGA
            IF "Document Type" = "Document Type"::Invoice THEN
                MESSAGE('Purchase Invoice has Been Posted with Posted Purchase Inv No: %1', PurchInvHdrNo);
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
                MESSAGE('Purchase Credit Memo has Been Posted with Posted Purchase Credit Memo No: %1', PurchCrMemoHdrNo);
            IF "Document Type" = "Document Type"::"Return Order" THEN
                MESSAGE('Purchase Credit Memo has Been Posted with Posted Purchase Credit Memo No: %1', RetShptHdrNo);
            //CCIT-JAGA
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnBeforeCopyDocumentFields', '', false, false)]
    local procedure OnPostItemJnlLineOnBeforeCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; WhseReceive: Boolean; WhseShip: Boolean; InvtPickPutaway: Boolean)

    begin
        //>>CCIT-JAGA
        ItemJournalLine."Reason Code" := PurchaseHeader."Reason Code";
        //<<CCIT-JAGA
        //CCIT-SG
        ItemJournalLine."Conversion UOM" := PurchaseLine."Conversion UOM";
        ItemJournalLine."License No." := PurchaseLine."License No.";
        ItemJournalLine."HS Code" := PurchaseLine."HS Code";
        ItemJournalLine."Storage Categories" := PurchaseLine."Storage Categories";
        ItemJournalLine.Weight := PurchaseLine.Weight;
        ItemJournalLine."Conversion Qty" := PurchaseLine."Conversion Qty";
        ItemJournalLine."BL/AWB No." := PurchaseHeader."BL/AWB No.";
        ItemJournalLine."BL Date" := PurchaseHeader."BL Date";
        ItemJournalLine."In-Bond Bill of Entry No." := PurchaseHeader."In-Bond Bill of Entry No.";
        ItemJournalLine."In-Bond BOE Date" := PurchaseHeader."In-Bond BOE Date";
        ItemJournalLine."Bond Number" := PurchaseHeader."Bond Number";
        ItemJournalLine."Bond Sr.No." := PurchaseHeader."Bond Sr.No.";
        ItemJournalLine."Bond Date" := PurchaseHeader."Bond Date";
        ItemJournalLine."Saleable Qty. In PCS" := PurchaseLine."Saleable Qty. In PCS";
        ItemJournalLine."Saleable Qty. In KG" := PurchaseLine."Saleable Qty. In KG";
        ItemJournalLine."Damage Qty. In PCS" := PurchaseLine."Damage Qty. In PCS";
        ItemJournalLine."Damage Qty. In KG" := PurchaseLine."Damage Qty. In KG";
        //CCIT-SG
        //CCIT-SG-30012018
        ItemJournalLine."Actual Qty In KG" := PurchaseLine."Actual Qty In KG";
        ItemJournalLine."Actual Qty In PCS" := PurchaseLine."Actual Qty In PCS";
        ItemJournalLine."Quarantine Qty In KG" := PurchaseLine."Quarantine Qty In KG";
        ItemJournalLine."Quarantine Qty In PCS" := PurchaseLine."Quarantine Qty In PCS";
        //CCIT-SG-30012018
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnBeforeInitAmount', '', false, false)]
    local procedure OnPostItemJnlLineOnBeforeInitAmount(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    begin
        with ItemJnlLine do begin
            //CCIT-SD-12-01-2018 -
            IF RecItem2.GET("No.") THEN BEGIN
                IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                    IF (RecUOM1.Weight <> 0) THEN BEGIN
                        ItemJnlLine."Conversion Qty" := Quantity / RecUOM1.Weight;
                        ItemJnlLine."Quantity (Base) In KG" := Quantity / RecUOM1.Weight;
                    END
                END
            END;
            //CCIT-SD-12-01-2018 +
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJnlLine."Bill of Entry No" := PurchHeader."Bill of Entry No."; //CCIT_kj_BillOfEntNo_29042021
                                                                          //Vikas
        PurchCommentLine.RESET();
        PurchCommentLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchCommentLine.SETRANGE("No.", PurchHeader."No.");
        IF PurchCommentLine.FIND('-') THEN BEGIN
            GenJnlLine.Comment := PurchCommentLine.Comment;
        END;
        //Vikas
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //CCIT-SG
        PurchRcptHeader."BL/AWB No." := PurchaseHeader."BL/AWB No.";
        PurchRcptHeader."BL Date" := PurchaseHeader."BL Date";
        PurchRcptHeader."In-Bond Bill of Entry No." := PurchaseHeader."In-Bond Bill of Entry No.";
        PurchRcptHeader."In-Bond BOE Date" := PurchaseHeader."In-Bond BOE Date";
        PurchRcptHeader."Bond Number" := PurchaseHeader."Bond Number";
        PurchRcptHeader."Bond Sr.No." := PurchaseHeader."Bond Sr.No.";
        PurchRcptHeader."Bond Date" := PurchaseHeader."Bond Date";
        //PurchRcptHeader."Posting Date" := PurchHeader."Posting Date";  //Code commented //JAGA 08102018
        PurchRcptHeader."Posting Date" := TODAY;  //New Code added //JAGA 08102018
        PurchRcptHeader."JWL BOND GRN No." := PurchaseHeader."JWL BOND GRN No.";
        PurchRcptHeader."JWL BOND GRN Date" := PurchaseHeader."JWL BOND GRN Date";
        //CCIT-SG
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptHeaderInsert', '', false, false)]
    local procedure OnBeforeReturnShptHeaderInsert(var ReturnShptHeader: Record "Return Shipment Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //CCIT-SG
        ReturnShptHeader."BL/AWB No." := PurchHeader."BL/AWB No.";
        ReturnShptHeader."BL Date" := PurchHeader."BL Date";
        ReturnShptHeader."In-Bond Bill of Entry No." := PurchHeader."In-Bond Bill of Entry No.";
        ReturnShptHeader."In-Bond BOE Date" := PurchHeader."In-Bond BOE Date";
        ReturnShptHeader."Bond Number" := PurchHeader."Bond Number";
        ReturnShptHeader."Bond Sr.No." := PurchHeader."Bond Sr.No.";
        ReturnShptHeader."Bond Date" := PurchHeader."Bond Date";
        //CCIT-SG
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //CCIT-SG
        PurchInvHeader."BL/AWB No." := PurchHeader."BL/AWB No.";
        PurchInvHeader."BL Date" := PurchHeader."BL Date";
        PurchInvHeader."In-Bond Bill of Entry No." := PurchHeader."In-Bond Bill of Entry No.";
        PurchInvHeader."In-Bond BOE Date" := PurchHeader."In-Bond BOE Date";
        PurchInvHeader."Bond Number" := PurchHeader."Bond Number";
        PurchInvHeader."Bond Sr.No." := PurchHeader."Bond Sr.No.";
        PurchInvHeader."Bond Date" := PurchHeader."Bond Date";
        PurchInvHeader."JWL BOND GRN No." := PurchHeader."JWL BOND GRN No.";
        PurchInvHeader."JWL BOND GRN Date" := PurchHeader."JWL BOND GRN Date";
        //CCIT-SG
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchCrMemoHeaderInsert', '', false, false)]
    local procedure OnBeforePurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //CCIT-SG
        PurchCrMemoHdr."BL/AWB No." := PurchHeader."BL/AWB No.";
        PurchCrMemoHdr."BL Date" := PurchHeader."BL Date";
        PurchCrMemoHdr."In-Bond Bill of Entry No." := PurchHeader."In-Bond Bill of Entry No.";
        PurchCrMemoHdr."In-Bond BOE Date" := PurchHeader."In-Bond BOE Date";
        PurchCrMemoHdr."Bond Number" := PurchHeader."Bond Number";
        PurchCrMemoHdr."Bond Sr.No." := PurchHeader."Bond Sr.No.";
        PurchCrMemoHdr."Bond Date" := PurchHeader."Bond Date";
        //CCIT-SG
    end;



    var
        RecItem2: Record 27;
        RecUOM1: Record 5404;
        PurchCommentLine: Record "Purch. Comment Line";

    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-90 Purch.-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    // //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-6501 Item Tracking Data Collection  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnTransferItemLedgToTempRecOnBeforeInsert', '', false, false)]
    // local procedure OnTransferItemLedgToTempRecOnBeforeInsert(var TempGlobalReservEntry: Record "Reservation Entry" temporary; ItemLedgerEntry: Record "Item Ledger Entry"; TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    // begin
    //     IF TempGlobalReservEntry.Positive THEN BEGIN
    //         TempGlobalReservEntry."Warranty Date" := ItemLedgerEntry."Warranty Date";
    //         //    TempGlobalReservEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
    //         //>> CS
    //         TempGlobalReservEntry."Manufacturing Date" := ItemLedgerEntry."Manufacturing Date";
    //         //<< CS
    //         TempGlobalReservEntry."Expected Receipt Date" := 0D;
    //         //>> CS
    //         TempGlobalReservEntry."Manufacturing Date" := ItemLedgerEntry."Manufacturing Date";
    //         //<< CS
    //     END ELSE
    //         TempGlobalReservEntry."Shipment Date" := 99991231D;


    //     IF TempGlobalReservEntry.INSERT THEN
    //         CreateEntrySummaryNew(TrackingSpecification, TempGlobalReservEntry)
    //     ELSE
    //         IF ItemLedgerEntry.TrackingExists THEN BEGIN
    //             TempGlobalReservEntry.INIT;
    //             TempGlobalReservEntry."Entry No." := -ItemLedgerEntry."Entry No.";
    //             TempGlobalReservEntry."Reservation Status" := TempGlobalReservEntry."Reservation Status"::Surplus;
    //             TempGlobalReservEntry.Positive := ItemLedgerEntry.Positive;
    //             TempGlobalReservEntry."Item No." := ItemLedgerEntry."Item No.";
    //             TempGlobalReservEntry."Location Code" := ItemLedgerEntry."Location Code";
    //             TempGlobalReservEntry."Quantity (Base)" := ItemLedgerEntry."Remaining Quantity";
    //             TempGlobalReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
    //             TempGlobalReservEntry."Source Ref. No." := ItemLedgerEntry."Entry No.";
    //             TempGlobalReservEntry."Serial No." := ItemLedgerEntry."Serial No.";
    //             TempGlobalReservEntry."Lot No." := ItemLedgerEntry."Lot No.";
    //             TempGlobalReservEntry."Variant Code" := ItemLedgerEntry."Variant Code";
    //         end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterTransferReservEntryToTempRec', '', false, false)]
    // local procedure OnAfterTransferReservEntryToTempRec(var GlobalReservEntry: Record "Reservation Entry"; ReservEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    // begin

    //     //>> CS
    //     IF (ReservEntry."Expiration Date" <> 0D) AND (ReservEntry."Manufacturing Date" <> 0D) THEN
    //         IF (ReservEntry."Expiration Date" - WORKDATE) / (ReservEntry."Expiration Date" - ReservEntry."Manufacturing Date") * 100 < MinShelfLife THEN
    //             IsHandled := true;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterCreateEntrySummary2', '', false, false)]
    // local procedure OnAfterCreateEntrySummary2(var TempGlobalEntrySummary: Record "Entry Summary" temporary; var TempGlobalReservEntry: Record "Reservation Entry" temporary)
    // begin
    //     LocalTempGlobalReservEntry := TempGlobalReservEntry;
    //     IF TempGlobalReservEntry.Positive THEN
    //         //>> CS
    //         TempGlobalEntrySummary."Manufacturing Date" := TempGlobalReservEntry."Manufacturing Date";
    //     //<< CS
    // end;
    //PCPL/NSW/12June22 New below Code

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterCreateEntrySummary', '', false, false)]
    // local procedure OnAfterCreateEntrySummary(TrackingSpecification: Record "Tracking Specification"; var TempGlobalEntrySummary: Record "Entry Summary" temporary)
    // begin
    //     TrackingSpecification."Expiration Date" := TempGlobalEntrySummary."Expiration Date";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnBeforeCreateEntrySummary2', '', false, false)]
    // local procedure OnBeforeCreateEntrySummary2(var TempGlobalEntrySummary: Record "Entry Summary" temporary; var TempReservationEntry: Record "Reservation Entry" temporary; TrackingSpecification: Record "Tracking Specification")
    // Var
    //     ILE: record 32;
    // begin
    //     ILE.Reset();
    //     ILE.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking",
    //       "Lot No.", "Serial No.");
    //     ILE.SetRange("Item No.", TrackingSpecification."Item No.");
    //     ILE.SetRange("Variant Code", TrackingSpecification."Variant Code");
    //     ILE.SetRange(Open, true);
    //     ILE.SetRange("Location Code", TrackingSpecification."Location Code");
    //     ILE.SetRange("Lot No.", TrackingSpecification."Lot No.");
    //     IF ILE.FindLast() then begin
    //         TrackingSpecification."Expiration Date" := ILE."Expiration Date";
    //         TempReservationEntry."Expiration Date" := ILE."Expiration Date";
    //         // TempGlobalEntrySummary."Expiration Date" := ILE."Expiration Date";
    //     end
    //     //TrackingSpecification."Expiration Date" := TempGlobalEntrySummary."Expiration Date";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnRetrieveLookupDataOnBeforeTransferToTempRec', '', false, false)]
    // local procedure OnRetrieveLookupDataOnBeforeTransferToTempRec(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempReservationEntry: Record "Reservation Entry" temporary; var ItemLedgerEntry: Record "Item Ledger Entry"; var FullDataSet: Boolean)
    // begin
    //     ItemLedgerEntry.Reset();
    //     ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking",
    //       "Lot No.", "Serial No.");
    //     ItemLedgerEntry.SetRange("Item No.", TempTrackingSpecification."Item No.");
    //     ItemLedgerEntry.SetRange("Variant Code", TempTrackingSpecification."Variant Code");
    //     ItemLedgerEntry.SetRange(Open, true);
    //     ItemLedgerEntry.SetRange("Location Code", TempTrackingSpecification."Location Code");
    //     ItemLedgerEntry.SetRange("Lot No.", TempTrackingSpecification."Lot No.");
    //     IF ItemLedgerEntry.FindLast() then begin
    //         TempTrackingSpecification."Expiration Date" := ItemLedgerEntry."Expiration Date";
    //         TempReservationEntry."Expiration Date" := ItemLedgerEntry."Expiration Date";
    //     end
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterTransferExpDateFromSummary', '', false, false)]
    local procedure OnAfterTransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification"; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        if TempEntrySummary."Total Quantity" <> 0 then begin
            //>> CS
            TrackingSpecification."Warranty Date" := TempEntrySummary."Warranty Date";
            //<< CS
            //>> CS
            IF TrackingSpecification.IsReclass THEN
                TrackingSpecification."Warranty Date" := TrackingSpecification."Warranty Date"
            ELSE
                TrackingSpecification."New Manufacturing Date" := 0D;
            //<< CS
        end else begin
            //>> CS
            TrackingSpecification."Warranty Date" := 0D;
            TrackingSpecification."New Manufacturing Date" := 0D;
            //<< CS
        end;
    end;
    // //<<PCPL/MIG/NSW New Event Created for Find out the LastSummaryEntryNo for  CreateEntrySummary2New this function where LastSummaryEntryNo variable is used
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnAfterAssignTrackingFromReservEntry', '', false, false)]
    // local procedure OnCreateEntrySummary2OnAfterAssignTrackingFromReservEntry(var TempGlobalEntrySummary: Record "Entry Summary" temporary; TempReservEntry: Record "Reservation Entry" temporary);
    // begin
    //     LastSummaryEntryNo := TempGlobalEntrySummary."Entry No.";
    // end;
    // //>>PCPL/MIG/NSW
    // [EventSubscriber(ObjectType::Page, Page::"Item Tracking Summary", 'OnAfterSetCurrentBinAndItemTrkgCode', '', false, false)]
    // local procedure OnAfterSetCurrentBinAndItemTrkgCode(var CurrBinCode: Code[20]; var CurrItemTrackingCode: Record "Item Tracking Code"; var BinContentVisible: Boolean; var EntrySummary: Record "Entry Summary"; var ReservationEntry: Record "Reservation Entry")
    // begin
    //     LocalBinCode := CurrBinCode;
    //     LocalItemTrackingCode := CurrItemTrackingCode;
    // end;

    // PROCEDURE SetMinShelfLife(_MinShelfLife: Decimal);
    // BEGIN
    //     //>> CS
    //     MinShelfLife := _MinShelfLife;
    //     //<< CS
    // END;

    // LOCAL PROCEDURE "--------------------"();
    // BEGIN
    // END;

    // local procedure UpdateBinContent(var TempEntrySummary: Record "Entry Summary" temporary)
    // var
    //     WarehouseEntry: Record "Warehouse Entry";
    //     WhseItemTrackingSetup: Record "Item Tracking Setup";
    //     IsHandled: Boolean;
    // begin
    //     if LocalBinCode = '' then
    //         exit;

    //     LocalItemTrackingCode.TestField(Code);

    //     WarehouseEntry.Reset();
    //     WarehouseEntry.SetCurrentKey(
    //       "Item No.", "Bin Code", "Location Code", "Variant Code",
    //       "Unit of Measure Code", "Lot No.", "Serial No.", "Package No.");
    //     WarehouseEntry.SetRange("Item No.", LocalTempGlobalReservEntry."Item No.");
    //     WarehouseEntry.SetRange("Bin Code", LocalBinCode);
    //     WarehouseEntry.SetRange("Location Code", LocalTempGlobalReservEntry."Location Code");
    //     WarehouseEntry.SetRange("Variant Code", LocalTempGlobalReservEntry."Variant Code");
    //     WhseItemTrackingSetup.CopyTrackingFromItemTrackingCodeWarehouseTracking(LocalItemTrackingCode);
    //     WhseItemTrackingSetup.CopyTrackingFromEntrySummary(TempEntrySummary);
    //     WarehouseEntry.SetTrackingFilterFromItemTrackingSetupIfRequiredIfNotBlank(WhseItemTrackingSetup);

    //     IsHandled := false;
    //     // OnUpdateBinContentOnBeforeCalcSumsQtyBase(TempEntrySummary, WarehouseEntry, IsHandled);
    //     if IsHandled then
    //         exit;

    //     WarehouseEntry.CalcSums("Qty. (Base)");

    //     TempEntrySummary."Bin Content" := WarehouseEntry."Qty. (Base)";
    // end;

    // LOCAL PROCEDURE CreateEntrySummary2New(TrackingSpecification: Record 336 TEMPORARY; LookupMode: option "Serial No.","Lot No."; TempReservEntry: Record 337 TEMPORARY);
    // VAR
    //     DoInsert: Boolean;
    // BEGIN
    //     TempGlobalEntrySummary.RESET;
    //     TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");

    //     // Set filters
    //     CASE LookupMode OF
    //         LookupMode::"Serial No.":
    //             BEGIN
    //                 IF TempReservEntry."Serial No." = '' THEN
    //                     EXIT;
    //                 TempGlobalEntrySummary.SETRANGE("Serial No.", TempReservEntry."Serial No.");
    //                 TempGlobalEntrySummary.SETRANGE("Lot No.", TempReservEntry."Lot No.");
    //             END;
    //         LookupMode::"Lot No.":
    //             BEGIN
    //                 TempGlobalEntrySummary.SETRANGE("Serial No.", '');
    //                 TempGlobalEntrySummary.SETRANGE("Lot No.", TempReservEntry."Lot No.");
    //                 IF TempReservEntry."Serial No." <> '' THEN
    //                     TempGlobalEntrySummary.SETRANGE("Table ID", 0)
    //                 ELSE
    //                     TempGlobalEntrySummary.SETFILTER("Table ID", '<>%1', 0);
    //             END;
    //     END;

    //     // If no summary exists, create new record
    //     IF NOT TempGlobalEntrySummary.FINDFIRST THEN BEGIN
    //         TempGlobalEntrySummary.INIT;
    //         TempGlobalEntrySummary."Entry No." := LastSummaryEntryNo + 1;
    //         LastSummaryEntryNo := TempGlobalEntrySummary."Entry No.";
    //         IF (LookupMode = LookupMode::"Lot No.") AND (TempReservEntry."Serial No." <> '') THEN
    //             TempGlobalEntrySummary."Table ID" := 0 // Mark as summation
    //         ELSE
    //             TempGlobalEntrySummary."Table ID" := TempReservEntry."Source Type";
    //         IF LookupMode = LookupMode::"Serial No." THEN
    //             TempGlobalEntrySummary."Serial No." := TempReservEntry."Serial No."
    //         ELSE
    //             TempGlobalEntrySummary."Serial No." := '';
    //         TempGlobalEntrySummary."Lot No." := TempReservEntry."Lot No.";
    //         TempGlobalEntrySummary."Bin Active" := LocalBinCode <> '';
    //         UpdateBinContent(TempGlobalEntrySummary); //PCPL/MIG/NSW UpdateBinContent Function can not access its local function


    //         // If consumption/output fill in double entry value here:
    //         TempGlobalEntrySummary."Double-entry Adjustment" :=
    //           MaxDoubleEntryAdjustQty(TrackingSpecification, TempGlobalEntrySummary); //PCPL/MIG/NSW MaxDoubleEntryAdjustQty Function can not access its local function

    //         DoInsert := TRUE;
    //     END;

    //     // Sum up values
    //     IF TempReservEntry.Positive THEN BEGIN
    //         TempGlobalEntrySummary."Warranty Date" := TempReservEntry."Warranty Date";
    //         TempGlobalEntrySummary."Expiration Date" := TempReservEntry."Expiration Date";
    //         //>> CS
    //         TempGlobalEntrySummary."Manufacturing Date" := TempReservEntry."Manufacturing Date";
    //         //<< CS
    //         IF TempReservEntry."Entry No." < 0 THEN // The record represents an Item ledger entry
    //             TempGlobalEntrySummary."Total Quantity" += TempReservEntry."Quantity (Base)";
    //         IF TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation THEN
    //             TempGlobalEntrySummary."Total Reserved Quantity" += TempReservEntry."Quantity (Base)";
    //     END ELSE BEGIN
    //         TempGlobalEntrySummary."Total Requested Quantity" -= TempReservEntry."Quantity (Base)";
    //         IF HasSamePointer(TrackingSpecification, TempReservEntry) THEN BEGIN
    //             IF TempReservEntry."Reservation Status" = TempReservEntry."Reservation Status"::Reservation THEN
    //                 TempGlobalEntrySummary."Current Reserved Quantity" -= TempReservEntry."Quantity (Base)";
    //             IF TempReservEntry."Entry No." > 0 THEN // The record represents a reservation entry
    //                 TempGlobalEntrySummary."Current Requested Quantity" -= TempReservEntry."Quantity (Base)";
    //         END;
    //     END;


    //     // Update available quantity on the record
    //     TempGlobalEntrySummary.UpdateAvailable;
    //     IF DoInsert THEN
    //         TempGlobalEntrySummary.INSERT
    //     ELSE
    //         TempGlobalEntrySummary.MODIFY;
    // END;

    // local procedure HasSamePointer(TrackingSpecification: Record "Tracking Specification"; ReservEntry: Record "Reservation Entry"): Boolean
    // begin
    //     EXIT((ReservEntry."Source Type" = TrackingSpecification."Source Type") AND
    //       (ReservEntry."Source Subtype" = TrackingSpecification."Source Subtype") AND
    //       (ReservEntry."Source ID" = TrackingSpecification."Source ID") AND
    //       (ReservEntry."Source Batch Name" = TrackingSpecification."Source Batch Name") AND
    //       (ReservEntry."Source Prod. Order Line" = TrackingSpecification."Source Prod. Order Line") AND
    //       (ReservEntry."Source Ref. No." = TrackingSpecification."Source Ref. No."));
    // end;

    // local procedure MaxDoubleEntryAdjustQty(var TempItemTrackLineChanged: Record "Tracking Specification" temporary; var ChangedEntrySummary: Record "Entry Summary" temporary): Decimal
    // var
    //     ItemJnlLine: Record "Item Journal Line";
    //     ItemTrackingSetup: Record "Item Tracking Setup";
    // begin
    //     if not (TempItemTrackLineChanged."Source Type" = DATABASE::"Item Journal Line") then
    //         exit;

    //     if not (TempItemTrackLineChanged."Source Subtype" in [5, 6]) then
    //         exit;

    //     if not ItemJnlLine.Get(TempItemTrackLineChanged."Source ID",
    //          TempItemTrackLineChanged."Source Batch Name", TempItemTrackLineChanged."Source Ref. No.")
    //     then
    //         exit;

    //     TempGlobalTrackingSpec.Reset();
    //     ItemTrackingSetup.CopyTrackingFromEntrySummary(ChangedEntrySummary);
    //     if FindRelatedParentTrkgSpec(ItemJnlLine, TempGlobalTrackingSpec, ItemTrackingSetup) then
    //         exit(-TempGlobalTrackingSpec."Quantity (Base)" - TempGlobalTrackingSpec."Buffer Value2");
    // end;

    // local procedure FindRelatedParentTrkgSpec(ItemJnlLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; ItemTrackingSetup: Record "Item Tracking Setup"): Boolean
    // begin
    //     ItemJnlLine.TestField("Order Type", ItemJnlLine."Order Type"::Production);
    //     TempTrackingSpecification.Reset();
    //     case ItemJnlLine."Entry Type" of
    //         ItemJnlLine."Entry Type"::Consumption:
    //             begin
    //                 if ItemJnlLine."Prod. Order Comp. Line No." = 0 then
    //                     exit;
    //                 TempTrackingSpecification.SetSourceFilter(
    //                   DATABASE::"Prod. Order Component", 3, ItemJnlLine."Order No.", ItemJnlLine."Prod. Order Comp. Line No.", false);
    //                 TempTrackingSpecification.SetSourceFilter('', ItemJnlLine."Order Line No.");
    //             end;
    //         ItemJnlLine."Entry Type"::Output:
    //             begin
    //                 TempTrackingSpecification.SetSourceFilter(DATABASE::"Prod. Order Line", 3, ItemJnlLine."Order No.", -1, false);
    //                 TempTrackingSpecification.SetSourceFilter('', ItemJnlLine."Order Line No.");
    //             end;
    //     end;
    //     TempTrackingSpecification.SetTrackingFilterFromItemTrackingSetup(ItemTrackingSetup);
    //     //  OnFindRelatedParentTrkgSpecOnAfterSetFilters(TempTrackingSpecification, ItemJnlLine);
    //     exit(TempTrackingSpecification.FindFirst);
    // end;

    // LOCAL PROCEDURE CreateEntrySummaryNew(TrackingSpecification: Record 336 TEMPORARY; TempReservEntry: Record 337 TEMPORARY);
    // VAR
    //     LookupMode: option "Serial No.","Lot No.";
    // BEGIN
    //     // CreateEntrySummary2(TrackingSpecification, LookupMode::"Serial No.", TempReservEntry);
    //     CreateEntrySummary2New(TrackingSpecification, LookupMode::"Lot No.", TempReservEntry);
    // END;

    // var
    //     MinShelfLife: Decimal;
    //     IsLotSerialOK: Boolean;
    //     TextCaption: Text[100];
    //     PostingDate: Date;
    //     //ItemTrackCU: Codeunit "Item Tracking Data Collection";
    //     TempGlobalEntrySummary: Record "Entry Summary" temporary;
    //     LastSummaryEntryNo: Integer; //PCPL/MIG/NSW

    // var
    //     LocalBinCode: Code[20];
    //     LocalItemTrackingCode: Record "Item Tracking Code";
    //     LocalTempGlobalReservEntry: Record "Reservation Entry" temporary;
    //     TempGlobalTrackingSpec: Record "Tracking Specification" temporary;
    // //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-6501 Item Tracking Data Collection  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7324 Whse.-Activity-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforePostedInvtPutAwayLineInsert', '', false, false)]
    local procedure OnBeforePostedInvtPutAwayLineInsert(var PostedInvtPutAwayLine: Record "Posted Invt. Put-away Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WhseActivHeader.SetRange("No.", WarehouseActivityLine."No.");
        if WhseActivHeader.FindFirst() then begin
            //CCIT-SD-12-02-2018 -
            //IF (("Source Document" = "Source Document" :: "Purchase Order" ) OR ("Source Document" = "Source Document"::"Sales Return Order")) AND (WhseActivLine."Quarantine Qty In KG" <> 0) THEN
            IF ((WhseActivHeader."Source Document" IN [WhseActivHeader."Source Document"::"Purchase Order",
                                      WhseActivHeader."Source Document"::"Sales Return Order",
                                      WhseActivHeader."Source Document"::"Inbound Transfer"]) AND
                                      (WarehouseActivityLine."Quarantine Qty In KG" <> 0)) THEN
                UpdateQuarantineQtyinJnl(WarehouseActivityLine);
            //CCIT-SD-12-02-2018 +
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforePostedInvtPickLineInsert', '', false, false)]
    local procedure OnBeforePostedInvtPickLineInsert(var PostedInvtPickLine: Record "Posted Invt. Pick Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WhseActivHeader.SetRange("No.", WarehouseActivityLine."No.");
        if WhseActivHeader.FindFirst() then begin
            //CCIT-SD-12-02-2018 -
            //IF (("Source Document" = "Source Document" :: "Purchase Order" ) OR ("Source Document" = "Source Document"::"Sales Return Order")) AND (WhseActivLine."Quarantine Qty In KG" <> 0) THEN
            IF ((WhseActivHeader."Source Document" IN [WhseActivHeader."Source Document"::"Purchase Order",
                                      WhseActivHeader."Source Document"::"Sales Return Order",
                                      WhseActivHeader."Source Document"::"Inbound Transfer"]) AND
                                      (WarehouseActivityLine."Quarantine Qty In KG" <> 0)) THEN
                UpdateQuarantineQtyinJnl(WarehouseActivityLine);
            //CCIT-SD-12-02-2018 +
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterPostWhseActivityLine', '', false, false)]
    local procedure OnAfterPostWhseActivityLine(WhseActivHeader: Record "Warehouse Activity Header"; var WhseActivLine: Record "Warehouse Activity Line"; PostedSourceNo: Code[20]; PostedSourceType: Integer; PostedSourceSubType: Integer)
    begin
        with WhseActivHeader do begin
            //CCIT-SD-12-02-2018 -
            IF ("Source Document" IN ["Source Document"::"Purchase Order",
                                            "Source Document"::"Sales Return Order",
                                            "Source Document"::"Inbound Transfer"]) THEN BEGIN
                ItemJournalLine.RESET;
                ItemJournalLine.SETRANGE("Journal Template Name", 'TRANSFER');
                ItemJournalLine.SETRANGE("Journal Batch Name", 'DEFAULT');
                ItemJournalLine.SETRANGE("Document No.", PostedSourceNo);
                ItemJournalLine.SETFILTER(Quantity, '<>%1', 0);
                IF ItemJournalLine.FINDFIRST THEN
                    REPEAT
                        PostQuarantineQtytoILE(ItemJournalLine);
                    UNTIL ItemJournalLine.NEXT = 0;
            END;
            //CCIT-SD-12-02-2018 +
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterWhseActivLineModify', '', false, false)]
    local procedure OnAfterWhseActivLineModify(var WhseActivityLine: Record "Warehouse Activity Line")
    begin
        //CCIT-SD-I3-06-01-17-
        Commit();
        WhseActivityLine.VALIDATE(
          "Qty. Outstanding In KG", WhseActivityLine."Qty. Outstanding In KG" - WhseActivityLine."Conversion Qty To Handle");
        //CCIT-SD-I3-06-01-17+
        //CCIT-SD-I3-06-01-17 -
        WhseActivityLine.VALIDATE(
          "Conversion Qty To Handle", WhseActivityLine."Conversion Qty" - WhseActivityLine."Qty. Outstanding In KG");
        //CCIT-SD-I3-06-01-17 +
        //CCIT-SD-13-02-17 -
        WhseActivityLine.VALIDATE("Quarantine Qty In KG", 0);
        //CCIT-SD-13-02-17 +
        WhseActivityLine."Tolerance Qty" := 0; //CCIT-SD-15-05-2018 -
        WhseActivityLine.MODIFY;
        Commit();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeTempWhseActivLineModify', '', false, false)]
    local procedure OnBeforeTempWhseActivLineModify(var TempWarehouseActivityLine: Record "Warehouse Activity Line" temporary; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        TempWarehouseActivityLine."Conversion Qty To Handle" := TempWarehouseActivityLine."Conversion Qty To Handle" + WarehouseActivityLine."Conversion Qty To Handle";//CCIT-SD-I3-06-01-17                                                                                                                                                                //TempWhseActivLine."Quarantine Qty In KG" := TempWhseActivLine."Quarantine Qty In KG" + "Quarantine Qty In KG"; //CCIT-SD-26-04-2016//Block030218
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeModifyPurchaseLine', '', false, false)]
    local procedure OnBeforeModifyPurchaseLine(var PurchaseLine: Record "Purchase Line")
    begin
        // IF PurchaseLine."Source Document" = PurchaseLine."Source Document"::"Purchase Order" THEN
        PurchaseLine.VALIDATE("Qty. to Receive In KG", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnInitSourceDocumentOnBeforeSalesLineLoopIteration', '', false, false)]
    local procedure OnInitSourceDocumentOnBeforeSalesLineLoopIteration(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; WarehouseActivityHeader: Record "Warehouse Activity Header"; var IsHandled: Boolean)
    begin
        IF WarehouseActivityHeader."Source Document" = WarehouseActivityHeader."Source Document"::"Sales Order" THEN BEGIN
            SalesLine.VALIDATE("Qty. to Ship", 0);
            SalesLine.VALIDATE("Qty. to Ship In KG", 0); //CCIT-SD-09-01-2018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeModifySalesHeader', '', false, false)]
    local procedure OnBeforeModifySalesHeader(var SalesHeader: Record "Sales Header"; WarehouseActivityHeader: Record "Warehouse Activity Header"; var ModifyHeader: Boolean)
    begin
        with WarehouseActivityHeader do begin
            //CCIT-SG-21022018
            IF ("Seal No." <> '') OR ("E-Way Bill No." <> '') OR ("E-Way Bill Date" <> 0D) OR ("LR/RR No." <> '') OR ("LR/RR Date" <> 0D) OR ("Vehicle No." <> '') OR ("Transport Vendor" <> '') THEN BEGIN
                SalesHeader."Seal No." := "Seal No.";
                SalesHeader."E-Way Bill No." := "E-Way Bill No.";
                SalesHeader."E-Way Bill Date" := "E-Way Bill Date";
                SalesHeader."LR/RR No." := "LR/RR No.";
                SalesHeader."LR/RR Date" := "LR/RR Date";
                SalesHeader."Vehicle No." := "Vehicle No.";
                SalesHeader."Transport Vendor" := "Transport Vendor";
                ModifyHeader := TRUE;
            END;
            //CCIT-SG-21022018
            //CCIT-SG-20062018

            IF ("Posting Date" <> 0D) THEN BEGIN
                //"Posting Date" := CALCDATE('<2D>',TODAY);
                "Posting Date" := TODAY;//CCIT-04052020
                SalesHeader."Posting Date" := "Posting Date";//CCIT-04052020
                                                             // SalesHeader."Posting Date" := WhseActivHeader."Posting Date";//DINESH //MANISH-20032019
                ModifyHeader := TRUE;
            END;
            //CCIT-SG-20062018
            //SalesHeader."Posting Date" := TODAY;   //CCIT-JAGA  20/11/2018  In the place of Posting they need today's date
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeModifyTransferHeader', '', false, false)]
    local procedure OnBeforeModifyTransferHeader(var TransferHeader: Record "Transfer Header"; WarehouseActivityHeader: Record "Warehouse Activity Header"; var ModifyHeader: Boolean)
    begin
        with WarehouseActivityHeader do begin
            //CCIT-SG
            TransferHeader."Transport Method" := "Transport Method";
            TransferHeader."Vehicle No." := "Vehicle No.";
            TransferHeader."LR/RR No." := "LR/RR No.";
            TransferHeader."LR/RR Date" := "LR/RR Date";
            TransferHeader."E-Way Bill No." := "E-Way Bill No.";
            TransferHeader."E-Way Bill Date" := "E-Way Bill Date";
            TransferHeader."JWL Transfer No." := "JWL Transfer No.";
            TransferHeader."JWL Transfer Date" := "JWL Transfer Date";
            TransferHeader."JWL BOND GRN No." := "JWL BOND GRN No.";
            TransferHeader."JWL BOND GRN Date" := "JWL BOND GRN Date";
            TransferHeader."Seal No." := "Seal No.";
            TransferHeader."Load Type" := "Load Type";
            TransferHeader."Transport Vendor" := "Transport Vendor";
            //CCIT-SG
            //CCIT-SG-20062018
            IF ("Posting Date" <> 0D) THEN BEGIN
                "Posting Date" := TODAY;
                TransferHeader."Posting Date" := "Posting Date";
                ModifyHeader := TRUE;
            END;
            //CCIT-SG-20062018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnUpdateSourceDocumentOnAfterGetPurchLine', '', false, false)]
    local procedure OnUpdateSourceDocumentOnAfterGetPurchLine(var PurchaseLine: Record "Purchase Line"; TempWhseActivLine: Record "Warehouse Activity Line" temporary)
    begin
        with TempWhseActivLine do begin
            if "Activity Type" = "Activity Type"::"Invt. Pick" then
                "Conversion Qty To Handle" := -"Conversion Qty To Handle";
            if "Source Document" = "Source Document"::"Purchase Order" then begin
                PurchaseLine.VALIDATE("Qty. to Receive In KG", "Conversion Qty To Handle");
                if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Invoice then
                    PurchaseLine.VALIDATE("Qty. to Invoice In KG", "Conversion Qty To Handle");

                //CCIT-SG-15022018
                //IF RecPL.GET("Source Document","Source No.","Source Line No.") THEN
                RecWAL1.RESET;
                RecWAL1.SETRANGE(RecWAL1."Source No.", PurchaseLine."Document No.");
                RecWAL1.SETRANGE(RecWAL1."Source Line No.", PurchaseLine."Line No.");
                IF RecWAL1.FINDSET THEN
                    REPEAT
                        PurchaseLine."Saleable Qty. In PCS" += RecWAL1."Saleable Qty. In PCS";
                        PurchaseLine."Saleable Qty. In KG" += RecWAL1."Saleable Qty. In KG";
                    UNTIL RecWAL1.NEXT = 0;
                //CCIT-SG-15022018
                //>>CCIT-SG
                // PurchaseLine."Reason Code" := "Reason Code";
                PurchaseLine."Quarantine Qty In KG" += "Quarantine Qty In KG";
                PurchaseLine."Quarantine Qty In PCS" += "Quarantine Qty In PCS";
                PurchaseLine."Actual Qty In KG" += "Actual Qty In KG";
                PurchaseLine."Actual Qty In PCS" += "Actual Qty In PCS";
                IF "Reason Code" = '' THEN
                    ERROR('Reason Code not blank');
                //<<CCIT-SG
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnUpdateSourceDocumentOnAfterGetSalesLine', '', false, false)]
    local procedure OnUpdateSourceDocumentOnAfterGetSalesLine(var SalesLine: Record "Sales Line"; TempWhseActivLine: Record "Warehouse Activity Line" temporary)
    begin
        with TempWhseActivLine do begin
            IF "Activity Type" = "Activity Type"::"Invt. Pick" THEN BEGIN
                "Conversion Qty To Handle" := -"Conversion Qty To Handle";//CCIT-SD-09-01-2018
            END;
            IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                SalesLine.VALIDATE("Qty. to Ship In KG", -"Conversion Qty To Handle");//CCIT-SD-09-01-18
                if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                    SalesLine.VALIDATE("Qty. to Invoice In KG", -"Conversion Qty To Handle");//CCIT-SD-09-01-18
            end;
            //CCIT-SG-09032018
            RecWAL2.RESET;
            RecWAL2.SETRANGE(RecWAL2."Source No.", SalesLine."Document No.");
            RecWAL2.SETRANGE(RecWAL2."Source Line No.", SalesLine."Line No.");
            IF RecWAL2.FINDSET THEN
                REPEAT
                    SalesLine."Salable Qty. In PCS" += RecWAL2."Saleable Qty. In KG";
                    SalesLine."Salable Qty. In KG" += RecWAL2."Saleable Qty. In PCS";
                    WALQtyToHandle += RecWAL2."Qty. to Handle";
                //SalesLine."Fill Rate %" += RecWAL2."Fill Rate %";//CCIT-SG-31052018
                UNTIL RecWAL2.NEXT = 0;
            //CCIT-SG-09032018
            //CCIT-SG-31052018
            IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                RecSL.RESET;
                RecSL.SETRANGE(RecSL."Document No.", "Source No.");
                RecSL.SETRANGE(RecSL."Line No.", "Source Line No.");
                IF RecSL.FINDSET THEN
                    REPEAT
                        SLQty := RecSL.Quantity;
                        SalesLine."Fill Rate %" += (WALQtyToHandle / SLQty) * 100;
                    UNTIL RecWAL2.NEXT = 0;
            END;
            //CCIT-SG-31052018
            //CCIT-SG
            SalesLine."Quarantine Qty In KG" := "Quarantine Qty In KG";
            SalesLine."Quarantine Qty In PCS" := "Quarantine Qty In PCS";
            SalesLine."Actual Qty In KG" := "Actual Qty In KG";
            SalesLine."Actual Qty In PCS" := "Actual Qty In PCS";
            SalesLine."Reason Code" := "Reason Code";
            IF "Reason Code" = '' THEN
                ERROR('Reason Code not blank');
            //SalesLine."Fill Rate %" := "Fill Rate %";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnUpdateSourceDocumentOnAfterTransLineModify', '', false, false)]
    local procedure OnUpdateSourceDocumentOnAfterTransLineModify(var TransferLine: Record "Transfer Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        with WarehouseActivityLine do begin
            IF "Activity Type" = "Activity Type"::"Invt. Put-away" THEN BEGIN
                TransferLine."Transfer To Reason Code" := "Reason Code";//CCIT-SG-24042018
                IF "Reason Code" = '' THEN
                    ERROR('Reason Code not blank')
            end else begin
                //CCIT-SG
                TransferLine."Fill Rate %" := "Fill Rate %";
                TransferLine."Transfer From Reason Code" := "Reason Code";//CCIT-SG-24042018
                //CCIT-SG
                IF "Reason Code" = '' THEN
                    ERROR('Reason Code not blank');
            end;
            TransferLine."Quarantine Qty In KG" := WarehouseActivityLine."Quarantine Qty In KG"; //CCIT-SD-02-05-2018
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnPostSourceDocumentOnBeforePurchPostRun', '', false, false)]
    local procedure OnPostSourceDocumentOnBeforePurchPostRun(WarehouseActivityHeader: Record "Warehouse Activity Header"; var PurchaseHeader: Record "Purchase Header")
    begin

        // rdk23-09-2019 -
        IF PurchaseHeader."Vendor Posting Group" = 'IMPORT' THEN
            IF PurchaseHeader."In-Bond Bill of Entry No." = '' THEN
                ERROR('Bill of Entry no. missing. Kindly check with Clearing');
        // rdk 23-09-2019 +
    end;

    //<<PCPL/MIG/NSW  This Below Event Created for Get value of PostedSourceNo Variable.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterPostSourceDocument', '', false, false)]
    local procedure OnAfterPostSourceDocument(WarehouseActivityHeader: Record "Warehouse Activity Header"; var PurchaseHeader: Record "Purchase Header"; var SalesHeader: Record "Sales Header"; var TransferHeader: Record "Transfer Header"; PostingReference: Integer; HideDialog: Boolean)
    begin
        WITH WarehouseActivityHeader DO
            CASE "Source Type" OF
                DATABASE::"Purchase Line":
                    BEGIN
                        IF "Source Document" = "Source Document"::"Purchase Order" THEN BEGIN
                            PostedSourceNo := PurchaseHeader."Last Receiving No.";
                        END ELSE BEGIN
                            PostedSourceNo := PurchaseHeader."Last Return Shipment No.";
                        END;
                    END;
                DATABASE::"Sales Line":
                    BEGIN
                        IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                            PostedSourceNo := SalesHeader."Last Shipping No.";
                        END ELSE BEGIN
                            PostedSourceNo := SalesHeader."Last Return Receipt No.";
                        END;
                    END;
                DATABASE::"Transfer Line":
                    BEGIN
                        IF Type = Type::"Invt. Put-away" THEN BEGIN
                            PostedSourceNo := TransferHeader."Last Receipt No.";
                        END ELSE BEGIN
                            PostedSourceNo := TransferHeader."Last Shipment No.";
                        END;
                    END;
            END;

    end;
    //<<PCPL/MIG/NSW 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterCreateWhseJnlLine', '', false, false)]
    local procedure OnAfterCreateWhseJnlLine(var WarehouseJournalLine: Record "Warehouse Journal Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        with WarehouseActivityLine do begin
            //>> CS
            WarehouseJournalLine."Manufacturing Date" := "Manufacturing Date";
            //<< CS
            //CCIT-SG
            WarehouseJournalLine."PO Lot No." := "PO Lot No.";
            WarehouseJournalLine."PO Manufacturing Date" := "PO Manufacturing Date";
            WarehouseJournalLine."PO Expiration Date" := "PO Expiration Date";
            WarehouseJournalLine."License No." := WhseActivHeader."License No.";
            WarehouseJournalLine.Weight1 := WarehouseActivityLine.Weight1;
            //WhseJnlLine."Conversion Qty" := WhseActivLine."Conversion Qty";
            WarehouseJournalLine."Conversion Qty" := WarehouseActivityLine."Conversion Qty To Handle";//CCIT-SG-100118
                                                                                                      //MESSAGE('%1',WhseActivLine."Conversion Qty To Handle");
            WarehouseJournalLine."Reason Code" := WarehouseActivityLine."Reason Code";
            WarehouseJournalLine."Saleable Qty. In PCS" := WarehouseActivityLine."Saleable Qty. In PCS";
            WarehouseJournalLine."Saleable Qty. In KG" := WarehouseActivityLine."Saleable Qty. In KG";
            WarehouseJournalLine."Damage Qty. In PCS" := WarehouseActivityLine."Damage Qty. In PCS";
            WarehouseJournalLine."Damage Qty. In KG" := WarehouseActivityLine."Damage Qty. In KG";
            WarehouseJournalLine."Quarantine Qty In KG" := WarehouseActivityLine."Quarantine Qty In KG";//CCIT-26-04-2018
                                                                                                        //CCIT-SG
                                                                                                        //JAGA
            WarehouseJournalLine."Actual Batch" := "Actual Batch";
            WarehouseJournalLine."Actual Batch KGS" := "Actual Batch KGS";
            WarehouseJournalLine."Actual Batch PCS" := "Actual Batch PCS";
            WarehouseJournalLine."Actual EXP Date" := "Actual EXP Date";
            WarehouseJournalLine."Actual MFG Date" := "Actual MFG Date";
            //JAGA
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnPostConsumptionLineOnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnPostConsumptionLineOnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ProdOrderLine: Record "Prod. Order Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        with WarehouseActivityLine do begin
            //CCIT-SG
            ItemJournalLine."License No." := WhseActivHeader."License No.";
            ItemJournalLine.Weight := Weight1;
            //ItemJnlLine."Conversion Qty" := "Conversion Qty";
            ItemJournalLine."Conversion Qty" := "Conversion Qty To Handle"; //CCIT-SG-100118
                                                                            //MESSAGE('%1',"Conversion Qty To Handle");
            ItemJournalLine."Reason Code" := "Reason Code";
            ItemJournalLine."Saleable Qty. In PCS" := "Saleable Qty. In PCS";
            ItemJournalLine."Saleable Qty. In KG" := "Saleable Qty. In KG";
            ItemJournalLine."Damage Qty. In PCS" := "Damage Qty. In PCS";
            ItemJournalLine."Damage Qty. In KG" := "Damage Qty. In KG";
            //CCIT-SG

            //CCIT-SG-30012018
            ItemJournalLine."Actual Qty In KG" := "Actual Qty In KG";
            ItemJournalLine."Actual Qty In PCS" := "Actual Qty In PCS";
            ItemJournalLine."Quarantine Qty In KG" := "Quarantine Qty In KG";
            ItemJournalLine."Quarantine Qty In PCS" := "Quarantine Qty In PCS";
            //CCIT-SG-30012018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnPostOutputLineOnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnPostOutputLineOnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ProdOrderLine: Record "Prod. Order Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        with WarehouseActivityLine do begin
            //CCIT-SG

            ItemJournalLine."License No." := WhseActivHeader."License No.";
            ItemJournalLine.Weight := Weight1;
            //ItemJnlLine."Conversion Qty" := "Conversion Qty";
            ItemJournalLine."Conversion Qty" := "Conversion Qty To Handle";//CCIT-SG-100118
                                                                           //MESSAGE('%1',"Conversion Qty To Handle");
            ItemJournalLine."Reason Code" := "Reason Code";
            ItemJournalLine."Saleable Qty. In PCS" := "Saleable Qty. In PCS";
            ItemJournalLine."Saleable Qty. In KG" := "Saleable Qty. In KG";
            ItemJournalLine."Damage Qty. In PCS" := "Damage Qty. In PCS";
            ItemJournalLine."Damage Qty. In KG" := "Damage Qty. In KG";


            //CCIT-SG
        end;
    end;

    LOCAL PROCEDURE "-----------CCIT-SD---------------"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateItemJournalLineForQuaratineQty(lRecWAL: Record 5767; lQuan_Loc: Code[10]);
    VAR
        ItemJournalBatch: Record 233;
        NoSeriesManagement: Codeunit 396;
        DocNo: Code[20];
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        LineNo: Integer;
        CreateReservEntry: Codeunit 99000830;
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

        ItemJournalLine."Document No." := PostedSourceNo;//lRecWAL."No.";
        ItemJournalLine.VALIDATE("Posting Date", WORKDATE);
        ItemJournalLine.VALIDATE("Item No.", lRecWAL."Item No.");
        ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine.VALIDATE("Location Code", lRecWAL."Location Code");
        ItemJournalLine.VALIDATE("New Location Code", lQuan_Loc);

        //CCIT-JAGA 23/11/2018
        IF RecLoc.GET(ItemJournalLine."Location Code") THEN BEGIN
            BranchCode123 := RecLoc."Branch Code";
            ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", BranchCode123);
            ItemJournalLine.VALIDATE("New Shortcut Dimension 1 Code", BranchCode123);
        END;
        //CCIT-JAGA 23/11/2018

        ItemJournalLine.VALIDATE(Quantity, lRecWAL."Quarantine Qty In KG");//("Conversion Qty"/"Cutting In (Pc)"));
                                                                           //ItemJournalLine.VALIDATE("Lot No.",lRecWAL."Lot No.");
                                                                           //VALIDATE("New Lot No.",lRecWAL."Lot No.");
        ItemJournalLine.VALIDATE("Manufacturing Date", lRecWAL."Manufacturing Date");
        ItemJournalLine.VALIDATE("Expiration Date", lRecWAL."Expiration Date");
        ItemJournalLine.INSERT(TRUE);



        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Lot No.", lRecWAL."Lot No.");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.SETRANGE("Location Code", lQuan_Loc);
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                WhseEntry.RESET;
                WhseEntry.SETCURRENTKEY("Reference No.", "Registering Date");
                WhseEntry.SETFILTER("Reference No.", ItemLedgerEntry."Document No.");
                WhseEntry.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                WhseEntry.SETRANGE("Lot No.", lRecWAL."Lot No.");
                IF WhseEntry.FINDFIRST THEN BEGIN
                    ItemJournalLine.VALIDATE("Bin Code", WhseEntry."Bin Code");
                    ItemJournalLine.MODIFY;
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;
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
               lRecWAL."Serial No.",
               lRecWAL."Lot No.");
               */ //>>PCPL/MIG/NSW/040522

            //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
              ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
            //>>PCPL/MIG/NSW/040522



            CreateReservEntry.SetNewSerialLotNo(lRecWAL."Serial No.", lRecWAL."Lot No.");
            CreateReservEntry.SetDates(//PCPL/MIG/NSW Original Function 1 Extra Parameter Pass
            ItemJournalLine."Warranty Date", lRecWAL."Expiration Date"/*, lRecWAL."Manufacturing Date"*/);
            //CreateReservEntry.SetPOData( //PCPL/MIG/NSW Original code Commented 
            "Create Reserv. Entry Events".SetPOData( //PCPL/MIG/NSW New Code added with Global var Define
              lRecWAL."PO Expiration Date", lRecWAL."PO Lot No.", lRecWAL."PO Manufacturing Date");
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETRANGE("Document No.", PostedSourceNo);
            ItemLedgerEntry.SETRANGE("Item No.", lRecWAL."Item No.");
            ItemLedgerEntry.SETRANGE("Lot No.", lRecWAL."Lot No.");
            ItemLedgerEntry.SETRANGE(Open, TRUE);
            ItemLedgerEntry.SETRANGE("Location Code", lRecWAL."Location Code");
            IF ItemLedgerEntry.FINDFIRST THEN
                CreateReservEntry.SetApplyToEntryNo(ItemLedgerEntry."Entry No.");
            //CreateReservEntry.SetQtyToHandleBaseInKG(ItemJournalLine.Quantity); //PCPL/MIG/NSW Original code Commented 
            "Create Reserv. Entry Events".SetQtyToHandleBaseInKG(ItemJournalLine.Quantity); //PCPL/MIG/NSW New Code added with Global var Define
            //CreateReservEntry.SetRemainQtyInKG(ItemJournalLine.Quantity);
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
    END;

    LOCAL PROCEDURE UpdateQuarantineQtyinJnl(Rec_WAL: Record 5767);
    VAR
        ToItem: Record 27;
        i: Integer;
        IUOM: Record 5404;
        RecLoc1: Record 14;
        QuarentineQty: Decimal;
        QuarantineLoc: Code[20];
        RecLoc: Record 14;
    BEGIN
        IF RecLoc.GET(Rec_WAL."Location Code") THEN BEGIN
            RecLoc1.RESET;
            RecLoc1.SETRANGE(RecLoc1."State Code", RecLoc."State Code");
            RecLoc1.SETRANGE(RecLoc1.City, RecLoc.City);
            RecLoc1.SETRANGE(RecLoc1."Quarantine Location", TRUE);
            IF RecLoc1.FINDFIRST THEN
                QuarantineLoc := RecLoc1.Code;
        END;
        CreateItemJournalLineForQuaratineQty(Rec_WAL, QuarantineLoc);
    END;

    LOCAL PROCEDURE PostQuarantineQtytoILE(ItemJnlLine: Record 83);
    VAR
        ItemJnlTemplate: Record 82;
        ItemJnlPostBatch: Codeunit 23;
        TempJnlBatchName: Code[10];
    BEGIN
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

    LOCAL PROCEDURE UpdateRemainingQty(pPostedInvtPutAwayLine: Record 7341);
    VAR
        ILE: Record 32;
        lPostedInvtPutAwayLine: Record 7341;
    BEGIN
        lPostedInvtPutAwayLine.RESET;
        lPostedInvtPutAwayLine.SETRANGE("No.", pPostedInvtPutAwayLine."No.");
        lPostedInvtPutAwayLine.SETRANGE("Source Document", lPostedInvtPutAwayLine."Source Document"::"Inbound Transfer");
        IF lPostedInvtPutAwayLine.FINDFIRST THEN BEGIN
            REPEAT
                ILE.RESET;
                ILE.SETRANGE("Document No.", PostedSourceNo);
                ILE.SETRANGE("Document Type", ILE."Document Type"::"Transfer Receipt");
                ILE.SETRANGE("Order No.", lPostedInvtPutAwayLine."Source No.");
                ILE.SETRANGE("Item No.", lPostedInvtPutAwayLine."Item No.");
                ILE.SETRANGE("Lot No.", lPostedInvtPutAwayLine."Lot No.");
                ILE.SETRANGE("Location Code", lPostedInvtPutAwayLine."Location Code");
                IF ILE.FINDFIRST THEN BEGIN
                    ILE."Remaining Quantity" := ILE."Remaining Quantity" - lPostedInvtPutAwayLine."Quarantine Qty In KG";
                    ILE.MODIFY;
                END;
            UNTIL lPostedInvtPutAwayLine.NEXT = 0;
        END;
    END;

    var
        QuarantineTot: Decimal;
        WAL: Record 5767;
        ActualTot: Decimal;
        ItemJournalLine: Record 83;
        Text006: TextConst ENU = 'cannot be filtered when posting recurring journals;ENN=cannot be filtered when posting recurring journals';
        RecWAL1: Record 5767;
        TotalPOQty: Decimal;
        RecWAL2: Record 5767;
        QtyToHandle1: Decimal;
        RecSH: Record 36;
        RecSL: Record 37;
        SLQty: Decimal;
        WALQtyToHandle: Decimal;
        RecLoc: Record 14;
        BranchCode123: Code[10];
        WhseActivHeader: Record "Warehouse Activity Header";
        "Create Reserv. Entry Events": Codeunit 50006;
        WhseActivityPost: Codeunit 7324;
        PostedSourceNo: Code[20];
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7324 Whse.-Activity-Post  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END
}