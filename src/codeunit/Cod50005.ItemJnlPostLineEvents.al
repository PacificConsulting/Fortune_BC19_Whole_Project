codeunit 50005 "Item_Jnl_Post_Line_Events"
{
    trigger OnRun()
    begin
        //********* Codunit Inculded in 22,12,74,375,5705,7322,1252,396************
    end;
    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-22 Item Jnl.-Post Line  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterCalcCapQty', '', false, false)]
    local procedure OnAfterCalcCapQty(var ItemJnlLine: Record "Item Journal Line"; var CapQty: Decimal)
    var
        MfgSetup: Record "Manufacturing Setup";
    begin
        MfgSetup.Get();

        with ItemJnlLine do begin
            if "Unit Cost Calculation" = "Unit Cost Calculation"::Time then begin
                if MfgSetup."Cost Incl. Setup" then
                    CapQty := "Setup Time" + "Run Time"
                else
                    CapQty := "Run Time";
            end else
                CapQty := "Conversion Qty" + "Scrap Quantity"; //CCIT-SG-17012018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertCapValueEntry', '', false, false)]
    local procedure OnBeforeInsertCapValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        //CCIT-SG-17012018
        ValueEntry."Invoiced Quantity In KG" := ValueEntry."Invoiced Quantity";
        ValueEntry."Valued Quantity In KG" := ValueEntry."Valued Quantity";
        //CCIT-SG-17012018
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertTransferEntryOnTransferValues', '', false, false)]
    local procedure OnInsertTransferEntryOnTransferValues(var NewItemLedgerEntry: Record "Item Ledger Entry"; OldItemLedgerEntry: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var TempItemEntryRelation: Record "Item Entry Relation")
    begin
        //>> CS
        NewItemLedgerEntry."Manufacturing Date" := ItemJournalLine."New Item Manufacturing Date";
        //<< CS
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        with ItemJournalLine do begin
            //CCIT-SG
            IF RecItem1.GET(NewItemLedgEntry."Item No.") THEN BEGIN
                NewItemLedgEntry."Item Description" := RecItem1.Description;
                NewItemLedgEntry."Vendor Description" := RecItem1."Description 2";
            END;

            NewItemLedgEntry.FOC := ItemJournalLine.FOC;
            NewItemLedgEntry."Fill Rate %" := ItemJournalLine."Fill Rate %";
            NewItemLedgEntry.Weight := ItemJournalLine.Weight;
            NewItemLedgEntry."License No." := ItemJournalLine."License No.";
            NewItemLedgEntry."HS Code" := ItemJournalLine."HS Code";
            NewItemLedgEntry."OrderDate WareActHed" := ItemJournalLine."OrderDate WareActHed";
            NewItemLedgEntry."Storage Categories" := ItemJournalLine."Storage Categories";
            NewItemLedgEntry."JWL Transfer No." := ItemJournalLine."JWL Transfer No.";
            NewItemLedgEntry."JWL Transfer Date" := ItemJournalLine."JWL Transfer Date";
            //ItemLedgEntry."Reason Code" := ItemJnlLine."Reason Code";
            /*IF ("Entry Type" = "Entry Type"::Purchase) OR ("Entry Type" = "Entry Type"::"Positive Adjmt.") THEN
                NewItemLedgEntry."Conversion Qty" := ItemJnlLine."Conversion Qty"
             ELSE IF ("Entry Type" = "Entry Type"::Sale) OR ("Entry Type" = "Entry Type"::"Negative Adjmt.") THEN
                NewItemLedgEntry."Conversion Qty" := -ItemJnlLine."Conversion Qty";*/

            NewItemLedgEntry."Customer No." := ItemJournalLine."Customer No.";
            NewItemLedgEntry."Sales Category" := ItemJournalLine."Sales Category";
            NewItemLedgEntry."Conversion Qty To Handle" := ItemJournalLine."Conversion Qty To Handle";
            NewItemLedgEntry."Customer Name" := ItemJournalLine."Customer Name";
            NewItemLedgEntry."ICA No." := ItemJournalLine."ICA No.";
            NewItemLedgEntry."Conversion UOM" := ItemJournalLine."Conversion UOM";
            NewItemLedgEntry.Reserved := ItemJournalLine.Reserved;
            NewItemLedgEntry."BL/AWB No." := ItemJournalLine."BL/AWB No.";
            NewItemLedgEntry."BL Date" := ItemJournalLine."BL Date";
            NewItemLedgEntry."In-Bond Bill of Entry No." := ItemJournalLine."In-Bond Bill of Entry No.";
            NewItemLedgEntry."In-Bond BOE Date" := ItemJournalLine."In-Bond BOE Date";
            NewItemLedgEntry."Bond Number" := ItemJournalLine."Bond Number";
            NewItemLedgEntry."Bond Sr.No." := ItemJournalLine."Bond Sr.No.";
            NewItemLedgEntry."Bond Date" := ItemJournalLine."Bond Date";
            NewItemLedgEntry."Ex-bond BOE No." := ItemJournalLine."Ex-bond BOE No.";
            NewItemLedgEntry."Ex-bond BOE Date" := ItemJournalLine."Ex-bond BOE Date";
            NewItemLedgEntry."Ex-bond BOE No.1" := ItemJournalLine."Ex-bond BOE No.1";
            NewItemLedgEntry."Ex-bond BOE Date 1" := ItemJournalLine."Ex-bond BOE Date 1";
            NewItemLedgEntry."Ex-bond BOE No.2" := ItemJournalLine."Ex-bond BOE No.2";
            NewItemLedgEntry."Ex-bond BOE Date 2" := ItemJournalLine."Ex-bond BOE Date 2";
            NewItemLedgEntry."Ex-bond BOE No.3" := ItemJournalLine."Ex-bond BOE No.3";
            NewItemLedgEntry."Ex-bond BOE Date 3" := ItemJournalLine."Ex-bond BOE Date 3";
            NewItemLedgEntry."Ex-bond BOE No.4" := ItemJournalLine."Ex-bond BOE No.4";
            NewItemLedgEntry."Ex-bond BOE Date 4" := ItemJournalLine."Ex-bond BOE Date 4";
            NewItemLedgEntry."Ex-bond BOE No.5" := ItemJournalLine."Ex-bond BOE No.5";
            NewItemLedgEntry."Ex-bond BOE Date 5" := ItemJournalLine."Ex-bond BOE Date 5";
            NewItemLedgEntry."Ex-bond BOE No.6" := ItemJournalLine."Ex-bond BOE No.6";
            NewItemLedgEntry."Ex-bond BOE Date 6" := ItemJournalLine."Ex-bond BOE Date 6";
            NewItemLedgEntry."Ex-bond BOE No.7" := ItemJournalLine."Ex-bond BOE No.7";
            NewItemLedgEntry."Ex-bond BOE Date 7" := ItemJournalLine."Ex-bond BOE Date 7";
            NewItemLedgEntry."Ex-bond BOE No.8" := ItemJournalLine."Ex-bond BOE No.8";
            NewItemLedgEntry."Ex-bond BOE Date 8" := ItemJournalLine."Ex-bond BOE Date 8";
            NewItemLedgEntry."Ex-bond BOE No.9" := ItemJournalLine."Ex-bond BOE No.9";
            NewItemLedgEntry."Ex-bond BOE Date 9" := ItemJournalLine."Ex-bond BOE Date 9";
            NewItemLedgEntry."Customer License No." := ItemJournalLine."Customer License No.";
            NewItemLedgEntry."Customer License Date" := ItemJournalLine."Customer License Date";
            NewItemLedgEntry."Customer License Name" := ItemJournalLine."Customer License Name";
            NewItemLedgEntry."Sales Category" := ItemJournalLine."Sales Category";
            NewItemLedgEntry."Supplier Invoice No." := ItemJournalLine."Supplier Invoice No.";
            NewItemLedgEntry."Supplier Invoice No.1" := ItemJournalLine."Supplier Invoice No.1";
            NewItemLedgEntry."Supplier Invoice No.2" := ItemJournalLine."Supplier Invoice No.2";
            NewItemLedgEntry."Supplier Invoice No.3" := ItemJournalLine."Supplier Invoice No.3";
            NewItemLedgEntry."Supplier Invoice No.4" := ItemJournalLine."Supplier Invoice No.4";
            NewItemLedgEntry."Supplier Invoice Date" := ItemJournalLine."Supplier Invoice Date";
            NewItemLedgEntry."Supplier Invoice Date 1" := ItemJournalLine."Supplier Invoice Date 1";
            NewItemLedgEntry."Supplier Invoice Date 2" := ItemJournalLine."Supplier Invoice Date 2";
            NewItemLedgEntry."Supplier Invoice Date 3" := ItemJournalLine."Supplier Invoice Date 3";
            NewItemLedgEntry."Supplier Invoice Date 4" := ItemJournalLine."Supplier Invoice Date 4";
            NewItemLedgEntry."Supplier Invoice Sr.No." := ItemJournalLine."Supplier Invoice Sr.No.";
            NewItemLedgEntry."Supplier Invoice Sr.No.1" := ItemJournalLine."Supplier Invoice Sr.No.1";
            NewItemLedgEntry."Supplier Invoice Sr.No.2" := ItemJournalLine."Supplier Invoice Sr.No.2";
            NewItemLedgEntry."Supplier Invoice Sr.No.3" := ItemJournalLine."Supplier Invoice Sr.No.3";
            NewItemLedgEntry."Supplier Invoice Sr.No.4" := ItemJournalLine."Supplier Invoice Sr.No.4";
            //CCIT-SG

            //>> CS
            NewItemLedgEntry."Manufacturing Date" := "Manufacturing Date";
            //<< CS
            NewItemLedgEntry."Custom Duty Amount1" := ItemJournalLine."Custom Duty Amount1";//CCIT-SG-24052018
                                                                                            //CCIT-SG
            NewItemLedgEntry."PO Lot No." := ItemJournalLine."PO Lot No.";
            NewItemLedgEntry."PO Manufacturing Date" := ItemJournalLine."PO Manufacturing Date";
            NewItemLedgEntry."PO Expiration Date" := ItemJournalLine."PO Expiration Date";
            NewItemLedgEntry."Saleable Qty. In PCS" := ItemJournalLine."Saleable Qty. In PCS";
            NewItemLedgEntry."Saleable Qty. In KG" := ItemJournalLine."Saleable Qty. In KG";
            NewItemLedgEntry."Damage Qty. In PCS" := ItemJournalLine."Damage Qty. In PCS";
            NewItemLedgEntry."Damage Qty. In KG" := ItemJournalLine."Damage Qty. In KG";
            //>>JAGA
            NewItemLedgEntry."Actual Batch" := ItemJournalLine."Actual Batch";
            NewItemLedgEntry."Actual MFG Date" := ItemJournalLine."Actual MFG Date";
            NewItemLedgEntry."Actual EXP Date" := ItemJournalLine."Actual EXP Date";
            NewItemLedgEntry."Actual Batch PCS" := ItemJournalLine."Actual Batch PCS";
            NewItemLedgEntry."Actual Batch KGS" := ItemJournalLine."Actual Batch KGS";
            //<<JAGA
            //ItemLedgEntry."MFG Date"   := ItemJnlLine."MFG Date"; //CCIT-JAGA
            //CCIT-SG
            //CCIT-SG-30012018
            NewItemLedgEntry."Actual Qty In KG" := "Actual Qty In KG";
            NewItemLedgEntry."Actual Qty In PCS" := "Actual Qty In PCS";
            NewItemLedgEntry."Quarantine Qty In KG" := "Quarantine Qty In KG";
            NewItemLedgEntry."Quarantine Qty In PCS" := "Quarantine Qty In PCS";
            //CCIT-SG-30012018
            IF "Entry Type" IN
                      ["Entry Type"::Sale,
                       "Entry Type"::"Negative Adjmt.",
                       "Entry Type"::Transfer,
                       "Entry Type"::Consumption,
                       "Entry Type"::"Assembly Consumption"]
                   THEN BEGIN
                //ItemLedgEntry."Conversion Qty" := -"Conversion Qty"; //CCIT-SG
                //CCIT-SG-29012018
                IF RecItem2.GET(NewItemLedgEntry."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            NewItemLedgEntry."Conversion Qty" := NewItemLedgEntry.Quantity / RecUOM.Weight;
                            NewItemLedgEntry."Invoiced Quantity In KG" := NewItemLedgEntry."Invoiced Quantity" / RecUOM.Weight;
                            //ItemLedgEntry."Remainig Qty. In KG"  := ItemLedgEntry."Remaining Quantity" / RecUOM.Weight;
                        END
                    END
                END;
                //CCIT-SG-29012018
            end else begin
                //ItemLedgEntry."Conversion Qty" := "Conversion Qty"; //CCIT-SG

                //CCIT-SG-29012018
                IF RecItem2.GET(NewItemLedgEntry."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            NewItemLedgEntry."Conversion Qty" := NewItemLedgEntry.Quantity / RecUOM.Weight;
                            NewItemLedgEntry."Invoiced Quantity In KG" := NewItemLedgEntry."Invoiced Quantity" / RecUOM.Weight;
                            //ItemLedgEntry."Remainig Qty. In KG"  := ItemLedgEntry."Remaining Quantity" / RecUOM.Weight;

                        END
                    END
                END;
                //CCIT-SG-29012018
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertItemLedgEntryOnCheckItemTracking', '', false, false)]
    local procedure OnInsertItemLedgEntryOnCheckItemTracking(ItemJnlLine: Record "Item Journal Line"; ItemLedgEntry: Record "Item Ledger Entry"; ItemTrackingCode: Record "Item Tracking Code"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry")
    begin
        //CCIT-SD-25-04-2018 -
        DocNo := '';
        LocCode := '';
        // IF (ItemLedgEntry."Quarantine Qty In KG" <> 0) AND
        IF (ItemLedgerEntry."Document Type" IN [ItemLedgerEntry."Document Type"::"Sales Credit Memo"]) THEN BEGIN//,
                                                                                                                 // ItemLedgEntry."Document Type"::"Sales Return Receipt"])THEN BEGIN
                                                                                                                 //ItemLedgEntry."Document Type"::"Transfer Receipt"]) THEN BEGIN
            IF (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Receipt") THEN BEGIN
                PostedTransReceipt.RESET;
                PostedTransReceipt.SETRANGE("No.", ItemLedgerEntry."Document No.");
                IF PostedTransReceipt.FINDFIRST THEN BEGIN
                    DocNo := PostedTransReceipt."Transfer Order No.";
                    LocCode := PostedTransReceipt."Transfer-to Code";
                END;
            END ELSE
                IF (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Return Receipt") THEN BEGIN
                    PostedRetReceipt.RESET;
                    PostedRetReceipt.SETRANGE("No.", ItemLedgerEntry."Document No.");
                    IF PostedRetReceipt.FINDFIRST THEN
                        DocNo := PostedRetReceipt."Return Order No.";
                END;
            PostInvPutway.RESET;
            PostInvPutway.SETRANGE("Source No.", DocNo);
            PostInvPutway.SETRANGE("Item No.", ItemLedgerEntry."Item No.");
            PostInvPutway.SETRANGE("Lot No.", ItemLedgerEntry."Lot No.");
            IF PostInvPutway.FINDLAST THEN BEGIN
                IF (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Receipt") THEN BEGIN
                    IF ItemLedgerEntry."Location Code" = LocCode THEN BEGIN
                        IF (ItemLedgerEntry."Remaining Quantity" = ItemLedgerEntry.Quantity) AND (PostInvPutway."Quarantine Qty In KG" <> 0) THEN
                            ItemLedgerEntry."Remaining Quantity" := ItemLedgerEntry.Quantity - PostInvPutway."Quarantine Qty In KG";//ItemLedgEntry."Quarantine Qty In KG";//CCIT-SD-25-04-2018
                                                                                                                                    /* { RecItemLedgEntry.RESET;
                                                                                                                                        RecItemLedgEntry.SETRANGE("Entry Type", "Entry Type"::Purchase);
                                                                                                                                        RecItemLedgEntry.SETRANGE("Item No.", ItemLedgEntry."Item No.");
                                                                                                                                        RecItemLedgEntry.SETRANGE("Lot No.", ItemLedgEntry."Lot No.");
                                                                                                                                        RecItemLedgEntry.SETRANGE("Manufacturing Date", ItemLedgEntry."Manufacturing Date");
                                                                                                                                        IF RecItemLedgEntry.FINDFIRST THEN BEGIN
                                                                                                                                            RecItemLedgEntry."Remaining Quantity" := RecItemLedgEntry."Remaining Quantity" + PostInvPutway."Quarantine Qty In KG";
                                                                                                                                            RecItemLedgEntry.MODIFY;
                                                                                                                                        END;}*/
                    END;
                END ELSE BEGIN
                    ItemLedgerEntry."Remaining Quantity" := ItemLedgerEntry.Quantity - PostInvPutway."Quarantine Qty In KG";//ItemLedgEntry."Quarantine Qty In KG";//CCIT-SD-25-04-2018
                    RecItemLedgEntry.RESET;
                    RecItemLedgEntry.SETFILTER("Entry Type", '%1|%2', RecItemLedgEntry."Entry Type"::Purchase, RecItemLedgEntry."Entry Type"::"Positive Adjmt.");
                    RecItemLedgEntry.SETRANGE("Item No.", ItemLedgerEntry."Item No.");
                    RecItemLedgEntry.SETRANGE("Lot No.", ItemLedgerEntry."Lot No.");
                    RecItemLedgEntry.SETRANGE("Manufacturing Date", ItemLedgerEntry."Manufacturing Date");
                    RecItemLedgEntry.SETRANGE("Location Code", ItemLedgerEntry."Location Code");
                    IF RecItemLedgEntry.FINDFIRST THEN BEGIN
                        RecItemLedgEntry."Remaining Quantity" := RecItemLedgEntry."Remaining Quantity" + PostInvPutway."Quarantine Qty In KG";
                        RecItemLedgEntry.MODIFY;
                    END;
                END;
            END;
        END;
        //CCIT-SG-24012018
        IF RecItem2.GET(ItemLedgerEntry."Item No.") THEN BEGIN
            IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                IF (RecUOM.Weight <> 0) THEN BEGIN
                    ItemLedgerEntry."Remainig Qty. In KG" := ItemLedgerEntry."Remaining Quantity" / RecUOM.Weight;
                    //ItemLedgEntry."Conversion Qty"  := ItemLedgEntry.Quantity / RecUOM.Weight; //CCIT-SG-25012018
                END
            END
        END;
        //CCIT-SG-24012018

        ItemLedgerEntry."Expiration Date" := ItemJournalLine."Expiration Date"; //PCPL/NSW/200422

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnAfterAssignFields', '', false, false)]
    local procedure OnInitValueEntryOnAfterAssignFields(var ValueEntry: Record "Value Entry"; ItemLedgEntry: Record "Item Ledger Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        ValueEntry."Valued Quantity In KG" := ItemJnlLine."Invoiced Quantity In KG"; //CCIT-SG-17012018
        ValueEntry."Invoiced Quantity In KG" := ItemJnlLine."Invoiced Quantity In KG";//CCIT-SG-17012018
        ValueEntry."Valued Quantity In KG" := ItemJnlLine."Conversion Qty"; //CCIT-SG-17012018
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeCheckItemTrackingInformation', '', false, false)]
    local procedure OnBeforeCheckItemTrackingInformation(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; var ItemTrackingSetup: Record "Item Tracking Setup"; var SignFactor: Decimal; var ItemTrackingCode: Record "Item Tracking Code"; var IsHandled: Boolean)
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterSetupTempSplitItemJnlLineSetQty', '', false, false)]
    //local procedure OnAfterSetupTempSplitItemJnlLineSetQty(var TempSplitItemJnlLine: Record "Item Journal Line" temporary; ItemJournalLine: Record "Item Journal Line"; SignFactor: Integer; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        //>> CS
        CheckManufacturingDate(ItemJnlLine2, SignFactor, CalcManufacturingDate, ManufacturingDateChecked, TrackingSpecification);
        //<< CS
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnSplitItemJnlLineOnBeforeInsertTempTrkgSpecification', '', false, false)]
    local procedure OnSplitItemJnlLineOnBeforeInsertTempTrkgSpecification(var TempTrackingSpecification: Record "Tracking Specification" temporary; ItemJnlLine2: Record "Item Journal Line"; SignFactor: Integer)
    begin
        TempTrackingSpecification."Quarantine Qty In KG" := SignFactor * ItemJnlLine2."Quarantine Qty In KG";//CCIT-SD-26-04-2018
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertCorrItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertCorrItemLedgEntry(var NewItemLedgerEntry: Record "Item Ledger Entry"; var OldItemLedgerEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        //>> CS
        //ItemTrackingMgt.RetrieveAppliedManufacturingDate(NewItemLedgerEntry);//Original Code Comment PCPL/MIG/NSW
        ItemTrackingManagementEvents.RetrieveAppliedManufacturingDate(NewItemLedgerEntry); //PCPL/MIG/NSW New Code added with new global var define

        //NewItemLedgEntry."Remainig Qty. In KG" := -OldItemLedgEntry."Conversion Qty"; //CCIT-SG-13012018
        //<< CS
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempItemJournalLine: Record "Item Journal Line" temporary; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line"; SignFactor: Integer)
    begin
        WITH TempItemJournalLine DO BEGIN
            //CCIT-SG
            "PO Lot No." := TempTrackingSpecification."PO Lot No.";
            "PO Manufacturing Date" := TempTrackingSpecification."PO Manufacturing Date";
            "PO Expiration Date" := TempTrackingSpecification."PO Expiration Date";
            //CCIT-SG
            //CCIT-SG-25052018
            "Actual Batch" := TempTrackingSpecification."Actual Batch";
            "Actual Batch KGS" := TempTrackingSpecification."Actual Batch KGS";
            "Actual Batch PCS" := TempTrackingSpecification."Actual Batch PCS";
            "Actual EXP Date" := TempTrackingSpecification."Actual EXP Date";
            "Actual MFG Date" := TempTrackingSpecification."Actual MFG Date";
            //CCIT-SG-25052018
            //>> CS
            "Manufacturing Date" := TempTrackingSpecification."Manufacturing Date";
            "New Item Manufacturing Date" := TempTrackingSpecification."New Manufacturing Date";
            "Expiration Date" := TempTrackingSpecification."Expiration Date";//PCPL/NSW/200422
            //<< CS

            PostItemJnlLine := not HasSameNewTracking() or ("Manufacturing Date" <> "New Item Manufacturing Date") OR ("Item Expiration Date" <> "New Item Expiration Date");
        end;
    end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    // local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry")
    // begin

    // end;

    LOCAL PROCEDURE CheckManufacturingDate(VAR ItemJnlLine2: Record 83; SignFactor: Integer; CalcManufacturingDate: Date; VAR ManufacturingDateChecked: Boolean; var TempTrackingSpecification: Record "Tracking Specification" temporary);
    VAR
        ExistingManufacturingDate: Date;
        EntriesExist: Boolean;
        SumOfEntries: Decimal;
        SumLot: Decimal;
    // TempTrackingSpecification: Record "Tracking Specification" temporary;
    BEGIN
        //>> CS
        ExistingManufacturingDate :=
            //ItemTrackingMgt.ExistingManufacturingDate(   //Original Code Comment PCPL/MIG/NSW
            ItemTrackingManagementEvents.ExistingManufacturingDate(   //Original New Code Add with new global var define PCPL/MIG/NSW
            TempTrackingSpecification."Item No.",
            TempTrackingSpecification."Variant Code",
            TempTrackingSpecification."Lot No.",
            TempTrackingSpecification."Serial No.",
            TRUE,
            EntriesExist);

        IF NOT (EntriesExist OR ManufacturingDateChecked) THEN BEGIN
            ItemTrackingMgt.TestExpDateOnTrackingSpec(TempTrackingSpecification);
            ManufacturingDateChecked := TRUE;
        END;
        IF ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer THEN
            IF TempTrackingSpecification."Manufacturing Date" = 0D THEN
                TempTrackingSpecification."Manufacturing Date" := ExistingManufacturingDate;

        // Supply
        IF SignFactor * ItemJnlLine2.Quantity > 0 THEN BEGIN        // Only Manufacturing dates on supply.
            IF CalcManufacturingDate <> 0D THEN
                IF ExistingManufacturingDate <> 0D THEN
                    CalcManufacturingDate := ExistingManufacturingDate;

            IF ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer THEN
                IF TempTrackingSpecification."New Manufacturing Date" = 0D THEN
                    TempTrackingSpecification."New Manufacturing Date" := ExistingManufacturingDate;

            IF TempTrackingSpecification."Manufacturing Date" = 0D THEN
                TempTrackingSpecification."Manufacturing Date" := CalcManufacturingDate;
            //TempTrackingSpecification."Manufacturing Date":=ItemJnlLine2."Manufacturing Date"

            /* { IF EntriesExist THEN
                TempTrackingSpecification.TESTFIELD("Manufacturing Date",ExistingManufacturingDate);}*///CCIT-SG-03062018
        END ELSE BEGIN  // Demand
            IF ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer THEN BEGIN
                ExistingManufacturingDate :=
                  //ItemTrackingMgt.ExistingManufacturingDateAndQty(//Original Code Comment PCPL/MIG/NSW
                  ItemTrackingManagementEvents.ExistingManufacturingDateAndQty( ////PCPL/MIG/NSW New Code added with new global var define
                    TempTrackingSpecification."Item No.",
                    TempTrackingSpecification."Variant Code",
                    TempTrackingSpecification."New Lot No.",
                    TempTrackingSpecification."New Serial No.",
                    SumOfEntries);

                //Original Code Comment PCPL/MIG/NSW
                // //PCPL/MIG/NSW New Code added with new global var define

                IF TempTrackingSpecification."New Manufacturing Date" = 0D THEN
                    TempTrackingSpecification."New Manufacturing Date" := ExistingManufacturingDate;
                TempTrackingSpecification.MODIFY;
                IF TempTrackingSpecification."New Lot No." <> '' THEN BEGIN
                    IF TempTrackingSpecification."New Serial No." <> '' THEN
                        SumLot := SignFactor * ItemTrackingMgt.SumNewLotOnTrackingSpec(TempTrackingSpecification)
                    ELSE
                        SumLot := SignFactor * TempTrackingSpecification."Quantity (Base)";
                    IF (SumOfEntries > 0) AND
                       ((SumOfEntries <> SumLot) OR (TempTrackingSpecification."New Lot No." <> TempTrackingSpecification."Lot No."))
                    THEN
                        TempTrackingSpecification.TESTFIELD("New Manufacturing Date", ExistingManufacturingDate);
                    ItemTrackingMgt.TestExpDateOnTrackingSpecNew(TempTrackingSpecification);
                END;
            END;
        END;
        //>> CS
    END;

    PROCEDURE InsertILEForQuarantineLocation(ILE: Record 32);
    VAR
        ILE1: Record 32;
    BEGIN
        //CCIT-SG

        ILE1.RESET;
        ILE1.SETRANGE(ILE1."Document No.", ILE."Document No.");
        IF ILE1.FINDLAST THEN;
        ILE1.INIT;
        ILE1."Entry No." += 10000;
        ILE1.TRANSFERFIELDS(ILE);
        ILE1.INSERT(TRUE);

        //CCIT-SG
    END;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-22 Item Jnl.-Post Line  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START  >>>>>>>>>>>>>>>>>>>>>>  Codeunit-12 Gen. Jnl.-Post Line  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        VendorLedgerEntry.Comment := GenJournalLine.Comment;//ccit-tk-211220
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', false, false)]
    local procedure OnBeforeInsertGlobalGLEntry(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        //Single Instance Codeunit
        // SingleCU.InsertGL(GlobalGLEntry); //PCPL/MIG/NSW
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."RTGS/NEFT" := GenJournalLine."RTGS/NEFT";    //CCIT
        GLEntry.Comment := GenJournalLine.Comment;  //CCIT-Harshal
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."RTGS/NEFT" := GenJournalLine."RTGS/NEFT";  //CCIT
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."Vertical Category" := GenJournalLine."Vertical Category";  //CCIT-SG
        CustLedgerEntry."Vertical Sub Category" := GenJournalLine."Vertical Sub Category";  //CCIT-SG
        CustLedgerEntry."Outlet Name" := GenJournalLine."Outlet Area";  //CCIT-SG
        CustLedgerEntry."Business Format / Outlet Name" := GenJournalLine."Business Format / Outlet Name";  //CCIT-SG
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure OnAfterInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Bill of Entry No" := GenJournalLine."Bill of Entry No"; //ccit_kj_Billofentryno_29042021
                                                                                   //CCIT-SG
        IF RecVend.GET(VendorLedgerEntry."Vendor No.") THEN
            VendorLedgerEntry."Vendor Name" := RecVend.Name;

        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN BEGIN
            VendorLedgerEntry."Advanced Payment" := GenJournalLine."Advanced Payment";
            VendorLedgerEntry.Shipment := GenJournalLine.Shipment;
            VendorLedgerEntry."Purchase Order Reference No." := GenJournalLine."Purchase Order Reference No.";
        END;
        //CCIT-SG
    end;


    /*PROCEDURE InsertCLECustom(GenJnlLine: Record 81);
    VAR
        Vend: Record 23;
        VendPostingGr: Record 93;
        VendLedgEntry: Record 25;
        CVLedgEntryBuf: Record 382;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        DtldVendLedgEntry: Record 380;
        PayablesAccount: Code[20];
        OriginalGenJnlLine: Record 81;
        SourceCurrWorkTaxAmt: Decimal;
        SourceCurrTDSAmt: Decimal;
        ServiceTaxPoTAmount: Decimal;
        DtldLedgEntryInserted: Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            Vend.GET("Account No.");
            Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);
            IF "Posting Group" = '' THEN BEGIN
                Vend.TESTFIELD("Vendor Posting Group");
                "Posting Group" := Vend."Vendor Posting Group";
            END;
            //PostVend
            VendPostingGr.GET("Posting Group");
            PayablesAccount := VendPostingGr.GetPayablesAccount;
            IF "Service Tax Entry" OR "Serv. Tax on Advance Payment" THEN BEGIN
                ServiceTaxPoTAmount := PostServiceTax(GenJnlLine, Vend."No.", VendPostingGr.Code);
                IF "System-Created Entry" THEN
                    EXIT;
                OriginalGenJnlLine := GenJnlLine;
                AddServiceTaxToJnlLineAmount(GenJnlLine, ServiceTaxPoTAmount);
            END;
            DtldVendLedgEntry.LOCKTABLE;
            VendLedgEntry.LOCKTABLE;
            InitVendLedgEntry(GenJnlLine, VendLedgEntry);
            IF "GST on Advance Payment" AND "GST Reverse Charge" THEN BEGIN
                PostVendorGSTPayment(GenJnlLine, VendLedgEntry, Vend);
                IF "System-Created Entry" THEN
                    EXIT;
            END;
            IF ("Document Type" = "Document Type"::Refund) AND (NOT "GST on Advance Payment") THEN BEGIN
                PostVendorGSTRefund(GenJnlLine);
                IF "System-Created Entry" THEN
                    EXIT;
            END;
            IF NOT Vend."Block Payment Tolerance" THEN
                CalcPmtTolerancePossible(
                  GenJnlLine, VendLedgEntry."Pmt. Discount Date", VendLedgEntry."Pmt. Disc. Tolerance Date",
                  VendLedgEntry."Max. Payment Tolerance");
            TempDtldCVLedgEntryBuf.DELETEALL;
            TempDtldCVLedgEntryBuf.INIT;
            TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
            TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";
            IF ("Document Type" = "Document Type"::Invoice) AND (NOT "TDS From Orders") AND
               (("TDS Nature of Deduction" <> '') OR ("Work Tax Nature Of Deduction" <> ''))
            THEN BEGIN
                TempDtldCVLedgEntryBuf.Amount := Amount - "Bal. TDS/TCS Including SHECESS" - "Balance Work Tax Amount";
                TempDtldCVLedgEntryBuf."Amount (LCY)" := "Amount (LCY)" - TotalITAmountLCY - WorkTaxAmountLCY;
                TempDtldCVLedgEntryBuf."Additional-Currency Amount" := Amount - CalcLCYToAddCurr(TotalITAmountLCY) -
                  CalcLCYToAddCurr(WorkTaxAmountLCY);
            END ELSE
                IF ABS(Amount) < ABS("Bal. TDS/TCS Including SHECESS") THEN BEGIN
                    TempDtldCVLedgEntryBuf.Amount := Amount + "Bal. TDS/TCS Including SHECESS" + "Balance Work Tax Amount";
                    IF "Currency Code" <> '' THEN
                        TempDtldCVLedgEntryBuf."Amount (LCY)" := "Amount (LCY)" + TotalITAmountLCY + WorkTaxAmountLCY
                    ELSE
                        TempDtldCVLedgEntryBuf."Amount (LCY)" := "Amount (LCY)" + "Bal. TDS/TCS Including SHECESS" + "Balance Work Tax Amount";
                    TempDtldCVLedgEntryBuf."Additional-Currency Amount" := Amount + CalcLCYToAddCurr(TotalITAmountLCY) +
                      CalcLCYToAddCurr(WorkTaxAmountLCY);
                END ELSE BEGIN
                    TempDtldCVLedgEntryBuf.Amount := Amount;
                    TempDtldCVLedgEntryBuf."Amount (LCY)" := "Amount (LCY)";
                    TempDtldCVLedgEntryBuf."Additional-Currency Amount" := Amount;
                END;
            TempDtldCVLedgEntryBuf."TDS Nature of Deduction" := "TDS Nature of Deduction";
            TempDtldCVLedgEntryBuf."TDS Group" := "TDS Group";
            TempDtldCVLedgEntryBuf."Total TDS/TCS Incl. SHECESS" := "Total TDS/TCS Incl. SHE CESS";

            CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
            TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
            CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
            CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;
            CalcPmtDiscPossible(GenJnlLine, CVLedgEntryBuf);
            IF "Currency Code" <> '' THEN BEGIN
                TESTFIELD("Currency Factor");
                CVLedgEntryBuf."Adjusted Currency Factor" := "Currency Factor"
            END ELSE
                CVLedgEntryBuf."Adjusted Currency Factor" := 1;
            CVLedgEntryBuf."Original Currency Factor" := CVLedgEntryBuf."Adjusted Currency Factor";

            // Check the document no.
            IF "Recurring Method" = 0 THEN
                IF IsNotPayment("Document Type") THEN BEGIN
                    GenJnlCheckLine.CheckPurchDocNoIsNotUsed("Document Type", "Document No.");
                    CheckPurchExtDocNo(GenJnlLine);
                END;
            GenJnlLineTmp.RESET;
            GenJnlLineTmp.DELETEALL;

            TotalAmtToApply := 0;
            OnlineVendorLedgerEntry := VendLedgEntry;
            // Post application
            IF NOT "GST on Advance Payment" THEN
                ApplyVendLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Vend);
            // Post vendor entry
            VendLedgEntry."GST on Advance Payment" := "GST on Advance Payment";
            IF ("Document Type" = "Document Type"::Payment) AND (NOT "GST on Advance Payment") THEN BEGIN
                VendLedgEntry."GST Vendor Type" := "GST Vendor Type"::" ";
                VendLedgEntry."GST Reverse Charge" := FALSE;
            END;
            CVLedgEntryBuf.CopyToVendLedgEntry(VendLedgEntry);
            VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Applies-to Doc. No." := '';
            VendLedgEntry."Serv. Tax on Advance Payment" := "Serv. Tax on Advance Payment";
            VendLedgEntry."Input Service Distribution" := "Input Service Distribution";
            VendLedgEntry.PoT := PoT;
            VendLedgEntry.Comment := Comment;//ccit-tk-211220
            VendLedgEntry.INSERT(TRUE);

            // Post detailed vendor entries
            DtldLedgEntryInserted := PostDtldVendLedgEntries2(GenJnlLine, TempDtldCVLedgEntryBuf, VendPostingGr, TRUE);
            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
            PostAppSTGenJnlLineTmp(GenJnlLine);
            IF "Service Tax Entry" THEN
                RestoreJnlLineAmounts(GenJnlLine, OriginalGenJnlLine);
            IF ("Bal. TDS/TCS Including SHECESS" <> 0) AND ("Amount (LCY)" < 0) AND
               (NOT "TDS From Orders") AND (("TDS Nature of Deduction" <> '') OR ("Work Tax Nature Of Deduction" <> ''))
            THEN BEGIN
                TDSGroup.FindOnDate("TDS Group", "Posting Date");
                TDSGroup.TESTFIELD("TDS Account");
                IF AddCurrencyCode <> '' THEN
                    SourceCurrTDSAmt := CalcLCYToAddCurr(TotalITAmountLCY);
                //   CreateGLEntry(GenJnlLine,
                //   TDSGroup."TDS Account",TotalITAmountLCY,SourceCurrTDSAmt,TRUE,"System-Created Entry");
            END;
            IF ("Total TDS/TCS Incl. SHE CESS" <> 0) AND ("Amount (LCY)" < 0) AND
               (NOT "TCS From Orders") AND ("TCS Nature of Collection" <> '')
            THEN BEGIN
                FilterTCSSetup(GenJnlLine);
                IF AddCurrencyCode <> '' THEN
                    SourceCurrTDSAmt := CalcLCYToAddCurr(-TotalITAmountLCY);
                //  CreateGLEntry(GenJnlLine,
                //  TDSGroup."TDS Account",-TotalITAmountLCY,SourceCurrTDSAmt,TRUE,"System-Created Entry");
            END;
            IF ("Balance Work Tax Amount" <> 0) AND ("Amount (LCY)" < 0) AND NOT "TDS From Orders" THEN BEGIN
                IF TDSGroup.FindOnDate("Work Tax Group", "Posting Date") THEN BEGIN
                    GetGLSetup;
                    IF AddCurrencyCode <> '' THEN
                        SourceCurrWorkTaxAmt := CalcLCYToAddCurr(WorkTaxAmountLCY);
                    TDSGroup.TESTFIELD("TDS Account");
                    //  CreateGLEntry(GenJnlLine,
                    //   TDSGroup."TDS Account",WorkTaxAmountLCY,SourceCurrWorkTaxAmt,TRUE,"System-Created Entry");
                END;
            END;
            // DeferralPosting("Deferral Code","Source Code",PayablesAccount,GenJnlLine,Balancing);
            // OnMoveGenJournalLine(VendLedgEntry.RECORDID);
        END;
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntries2(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VendPostingGr: Record 93; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean;
    VAR
        TempInvPostBuf: Record 49 TEMPORARY;
        DtldVendLedgEntry: Record 380;
        STaxApplBuffer: ARRAY[2] OF Record 16529 TEMPORARY;
        TempApplnDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        AdjAmount: ARRAY[4] OF Decimal;
        DtldVendLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    BEGIN
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor THEN
            EXIT;

        IF DtldVendLedgEntry.FINDLAST THEN
            DtldVendLedgEntryNoOffset := DtldVendLedgEntry."Entry No."
        ELSE
            DtldVendLedgEntryNoOffset := 0;

        CopyApplicationEntries(DtldCVLedgEntryBuf, TempApplnDtldCVLedgEntryBuf);
        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            END;
            REPEAT
                InsertDtldVendLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldVendLedgEntry, DtldVendLedgEntryNoOffset);

                UpdateTotalAmounts(
                  TempInvPostBuf, GenJnlLine."Dimension Set ID",
                  DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount");

                // Post automatic entries.
                IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
                    (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
                   ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
                THEN BEGIN
                    PostDtldVendLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, AdjAmount);

                    IF DtldCVLedgEntryBuf."Entry Type" IN
                        [DtldCVLedgEntryBuf."Entry Type"::Application,
                         DtldCVLedgEntryBuf."Entry Type"::"Realized Loss",
                         DtldCVLedgEntryBuf."Entry Type"::"Realized Gain"]
                    THEN
                        PostServiceTaxApplication(GenJnlLine, DtldVendLedgEntry, TempApplnDtldCVLedgEntryBuf, STaxApplBuffer);
                END;
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;

            PostInvoiceServTaxApplnBuf(GenJnlLine, STaxApplBuffer);
        END;
     /*  {
      CreateGLEntriesForTotalAmounts(
        GenJnlLine, TempInvPostBuf, AdjAmount, SaveEntryNo, VendPostingGr.GetPayablesAccount, LedgEntryInserted);
        } 
      DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
      DtldCVLedgEntryBuf.DELETEALL;
    END;
    */

    var
        RecVend: Record Vendor;
        SingleCU: Codeunit 50009;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-12 Gen. Jnl.-Post Line  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END


    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-74 Purch.-Get Receipt  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterPurchRcptLineSetFilters', '', false, false)]
    local procedure OnAfterPurchRcptLineSetFilters(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchaseHeader: Record "Purchase Header")
    begin
        PurchRcptLine.SETRANGE("Bill Of Entry No.", PurchaseHeader."Bill of Entry No.");//CCIT-27042021
    end;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-74 Purch.-Get Receipt  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-5705 TransferOrder-Post Receipt  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeTransRcptHeaderInsert(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        with TransferHeader do begin
            //CCIT-SG
            TransferReceiptHeader."Vehicle No." := "Vehicle No.";
            TransferReceiptHeader."LR/RR No." := "LR/RR No.";
            TransferReceiptHeader."LR/RR Date" := "LR/RR Date";
            TransferReceiptHeader."Mode of Transport" := "Mode of Transport";
            TransferReceiptHeader."Load Type" := "Load Type";
            TransferReceiptHeader."Seal No." := "Seal No.";
            TransferReceiptHeader."E-Way Bill No." := "E-Way Bill No.";
            TransferReceiptHeader."E-Way Bill Date" := "E-Way Bill Date";
            TransferReceiptHeader."JWL Transfer No." := "JWL Transfer No.";
            TransferReceiptHeader."JWL Transfer Date" := "JWL Transfer Date";
            TransferReceiptHeader."Transport Vendor" := "Transport Vendor";
            TransferReceiptHeader."Customer License No." := "Customer License No.";
            //CCIT-SG

            // rdk160919 -
            TransferReceiptHeader."In-Bond Bill of Entry No." := TransferHeader."In-Bond Bill of Entry No.";
            TransferReceiptHeader."In-Bond BOE Date" := TransferHeader."In-Bond BOE Date";
            TransferReceiptHeader."Bond Number" := TransferHeader."Bond Number";
            TransferReceiptHeader."Bond Sr.No." := TransferHeader."Bond Sr.No.";
            TransferReceiptHeader."Bond Date" := TransferHeader."Bond Date";
            TransferReceiptHeader."BL/AWB No." := TransferHeader."BL/AWB No.";
            TransferReceiptHeader."Ex-bond BOE No." := TransferHeader."Ex Bond Order No.";
            TransferReceiptHeader."Ex-bond BOE Date" := TransferHeader."Ex-bond BOE Date";
            // rdk160919 +

            TransferReceiptHeader."Calculate Custom Duty" := "Calculate Custom Duty";//CCIT-SD-28-02-2018-
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', false, false)]
    local procedure OnBeforeInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    begin
        //CCIT-SG
        TransRcptLine."Customer No." := TransLine."Customer No.";
        TransRcptLine."Customer Name" := TransLine."Customer Name";
        TransRcptLine.Reserved := TransLine.Reserved;
        TransRcptLine."License No." := TransLine."License No.";
        //TransRcptLine."Conversion Qty" := TransLine."Conversion Qty";
        TransRcptLine."Customer License No." := TransLine."Customer License No.";
        TransRcptLine."Customer License Name" := TransLine."Customer License Name";
        TransRcptLine."Customer License Date" := TransLine."Customer License Date";
        TransRcptLine."Fill Rate %" := TransLine."Fill Rate %";
        TransRcptLine."Transfer To Reason Code" := TransLine."Transfer To Reason Code";//CCIT-SG-24042018
                                                                                       //CCIT-SG
                                                                                       /* {//JAGA
                                                                                       TransRcptLine."Actual Batch" := TransLine."Actual Batch";
                                                                             TransRcptLine."Actual Batch KGS" := TransLine."Actual Batch KGS";
                                                                             TransRcptLine."Actual Batch PCS" := TransLine."Actual Batch PCS";
                                                                             TransRcptLine."Actual EXP Date" := TransLine."Actual EXP Date";
                                                                             TransRcptLine."Actual MFG Date" := TransLine."Actual MFG Date";
                                                                             //JAGA} */
                                                                                       //CCIT-SG-19042018
        IF RecItem2.GET(TransRcptLine."Item No.") THEN BEGIN
            IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                IF (RecUOM.Weight <> 0) THEN BEGIN
                    TransRcptLine."Conversion Qty" := TransRcptLine.Quantity / RecUOM.Weight;
                END
            END
        END;
        //CCIT-SG-19042018
        //CCIT-SD-28-02-2018 -
        TransRcptLine."GST Assessable Value" := TransLine."GST Assessable Value1";
        TransRcptLine."Custom Duty Amount" := TransLine."Custom Duty Amount1";
        TransRcptLine.Duty := TransLine.Duty;
        TransRcptLine.Cess := TransLine.Cess;
        TransRcptLine.Surcharge := TransLine.Surcharge;
        //CCIT-SD-28-02-2018 +

        /*//PCPL/MIG/NSW
        //Vikas 14-09-2021
        IF TransRcptLine.Quantity > 0 THEN BEGIN
            IF FromLoc.GET(TransLine."Transfer-from Code") THEN BEGIN
                IF ToLoc.GET(TransLine."Transfer-to Code") THEN BEGIN
                    IF FromLoc."State Code" <> ToLoc."State Code" THEN
                        //TransRcptLine.TESTFIELD(TransLine."Total GST Amount"); //PCPL/MIG/NSW
                        Message('HI.');  
                END;
            END;
        END;
        //Vikas 14-09-2021
        */ //PCPL/MIG/NSW

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line")
    var
        TransHeader: Record "Transfer Header";
    begin
        if TransHeader.Get(TransLine."Document No.") then;
        //JAGA
        ItemJournalLine."Actual Batch" := TransLine."Actual Batch";
        ItemJournalLine."Actual Batch KGS" := TransLine."Actual Batch KGS";
        ItemJournalLine."Actual Batch PCS" := TransLine."Actual Batch PCS";
        ItemJournalLine."Actual EXP Date" := TransLine."Actual EXP Date";
        ItemJournalLine."Actual MFG Date" := TransLine."Actual MFG Date";
        //JAGA
        //CCIT-SG
        ItemJournalLine."JWL Transfer No." := TransHeader."JWL Transfer No.";
        ItemJournalLine."JWL Transfer Date" := TransHeader."JWL Transfer Date";
        ItemJournalLine."Customer No." := TransLine."Customer No.";
        ItemJournalLine."Customer Name" := TransLine."Customer Name";
        ItemJournalLine."ICA No." := TransHeader."ICA No.";
        ItemJournalLine.Reserved := TransLine.Reserved;
        ItemJournalLine."Storage Categories" := TransLine."Storage Categories";
        ItemJournalLine."Conversion UOM" := TransLine."Conversion UOM";
        ItemJournalLine."License No." := TransLine."License No.";
        ItemJournalLine.Weight := TransLine.Weight;
        ItemJournalLine."Conversion Qty" := TransLine."Conversion Qty";
        ItemJournalLine."Quarantine Qty In KG" := TransLine."Quarantine Qty In KG";//CCIT-SD-02-05-2018
        //MESSAGE('Receipt %1',ItemJnlLine."Conversion Qty" );
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
        ItemJournalLine."Customer License No." := TransLine."Customer License No.";
        ItemJournalLine."Customer License Date" := TransLine."Customer License Date";
        ItemJournalLine."Customer License Name" := TransLine."Customer License Name";
        ItemJournalLine."Sales Category" := TransLine."Sales Category";
        ItemJournalLine."Supplier Invoice No." := TransLine."Supplier Invoice No.";
        ItemJournalLine."Supplier Invoice No.1" := TransLine."Supplier Invoice No.1";
        ItemJournalLine."Supplier Invoice No.2" := TransLine."Supplier Invoice No.2";
        ItemJournalLine."Supplier Invoice No.3" := TransLine."Supplier Invoice No.3";
        ItemJournalLine."Supplier Invoice No.4" := TransLine."Supplier Invoice No.4";
        ItemJournalLine."Supplier Invoice Date" := TransLine."Supplier Invoice Date";
        ItemJournalLine."Supplier Invoice Date 1" := TransLine."Supplier Invoice Date 1";
        ItemJournalLine."Supplier Invoice Date 2" := TransLine."Supplier Invoice Date 2";
        ItemJournalLine."Supplier Invoice Date 3" := TransLine."Supplier Invoice Date 3";
        ItemJournalLine."Supplier Invoice Date 4" := TransLine."Supplier Invoice Date 4";
        ItemJournalLine."Supplier Invoice Sr.No." := TransLine."Supplier Invoice Sr.No.";
        ItemJournalLine."Supplier Invoice Sr.No.1" := TransLine."Supplier Invoice Sr.No.1";
        ItemJournalLine."Supplier Invoice Sr.No.2" := TransLine."Supplier Invoice Sr.No.2";
        ItemJournalLine."Supplier Invoice Sr.No.3" := TransLine."Supplier Invoice Sr.No.3";
        ItemJournalLine."Supplier Invoice Sr.No.4" := TransLine."Supplier Invoice Sr.No.4";
        ItemJournalLine."Custom Duty Amount1" := TransLine."Custom Duty Amount1";//CCIT-SG-24052018
                                                                                 //CCIT-SG
                                                                                 //
    end;

    var
        // RecItem2: Record 27;
        //RecUOM: Record 5404;
        FromLoc: Record 14;
        ToLoc: Record 14;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-5705 TransferOrder-Post Receipt  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7322 Create Inventory Pick/Movement  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeAutoCreatePickOrMove', '', false, false)]
    local procedure OnBeforeAutoCreatePickOrMove(WarehouseRequest: Record "Warehouse Request"; var WarehouseActivityHeader: Record "Warehouse Activity Header"; var LineCreated: Boolean; var IsHandled: Boolean; var HideDialog: Boolean)
    begin
        //   Error('Hiii');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeGetSourceDocHeader', '', false, false)]
    local procedure OnBeforeGetSourceDocHeader(var WhseRequest: Record "Warehouse Request"; var IsHandled: Boolean)
    begin
        case WhseRequest."Source Document" of
            WhseRequest."Source Document"::"Purchase Order":
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::Order, WhseRequest."Source No.");
                    LicenseNo := PurchHeader."License No.";  //CCIT-SG
                    OrderDate := PurchHeader."Order Date"; //CCIT-SG
                end;
            WhseRequest."Source Document"::"Purchase Return Order":
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::"Return Order", WhseRequest."Source No.");
                    LicenseNo := PurchHeader."License No.";  //CCIT-SG
                    OrderDate := PurchHeader."Order Date"; //CCIT-SG
                end;
            WhseRequest."Source Document"::"Sales Order":
                begin
                    SalesHeader.Get(SalesHeader."Document Type"::Order, WhseRequest."Source No.");
                    //CCIT-SG
                    LicenseNo := SalesHeader."License No.";
                    OrderDate := SalesHeader."Order Date";
                    ExternalDocNo := SalesHeader."External Document No.";
                    //CCIT-SG
                end;
            WhseRequest."Source Document"::"Sales Return Order":
                begin
                    SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WhseRequest."Source No.");
                    //CCIT-SG
                    LicenseNo := SalesHeader."License No.";
                    OrderDate := SalesHeader."Order Date";
                    ExternalDocNo := SalesHeader."External Document No.";
                    //CCIT-SG
                end;
            WhseRequest."Source Document"::"Outbound Transfer":
                begin
                    TransferHeader.Get(WhseRequest."Source No.");
                    //CCIT-SG
                    LicenseNo := TransferHeader."License No.";
                    LRNO := TransferHeader."LR/RR No.";
                    LRDate := TransferHeader."LR/RR Date";
                    VehicleNo := TransferHeader."Vehicle No.";
                    TransportMode := TransferHeader."Transport Method";
                    EWayBillNo := TransferHeader."E-Way Bill No.";
                    EWayDate := TransferHeader."E-Way Bill Date";
                    SealNo := TransferHeader."Seal No.";
                    LoadType := TransferHeader."Load Type";
                    JWLTransNo := TransferHeader."JWL Transfer No.";
                    JWLTransDate := TransferHeader."JWL Transfer Date";
                    TransportVendor := TransferHeader."Transport Vendor";
                    ExternalDocNo := TransferHeader."External Document No."; //CCIT-PRI-100119
                                                                             //CCIT-SG
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnAfterUpdateWhseActivHeader', '', false, false)]
    local procedure OnAfterUpdateWhseActivHeader(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var WarehouseRequest: Record "Warehouse Request")
    begin
        with WarehouseRequest do begin
            //CCIT-SG
            WarehouseActivityHeader."License No." := LicenseNo;
            WarehouseActivityHeader."OrderDate WareActHed" := OrderDate;
            WarehouseActivityHeader."LR/RR No." := LRNO;
            WarehouseActivityHeader."LR/RR Date" := LRDate;
            WarehouseActivityHeader."Transport Method" := TransportMode;
            WarehouseActivityHeader."E-Way Bill No." := EWayBillNo;
            WarehouseActivityHeader."E-Way Bill Date" := EWayDate;
            WarehouseActivityHeader."Vehicle No." := VehicleNo;
            WarehouseActivityHeader."Seal No." := SealNo;
            WarehouseActivityHeader."Load Type" := LoadType;
            WarehouseActivityHeader."External Document No." := ExternalDocNo;
            WarehouseActivityHeader."JWL Transfer No." := JWLTransNo;
            WarehouseActivityHeader."JWL Transfer Date" := JWLTransDate;
            WarehouseActivityHeader."Transport Vendor" := TransportVendor;
            //CCIT-SG
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeNewWhseActivLineInsertFromPurchase', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsertFromPurchase(var WarehouseActivityLine: Record "Warehouse Activity Line"; var PurchaseLine: Record "Purchase Line"; var WarehouseActivityHeader: Record "Warehouse Activity Header"; var RemQtyToPickBase: Decimal)
    begin
        with PurchaseLine do begin
            //CCIT-SG
            WarehouseActivityLine.Weight1 := Weight;
            WarehouseActivityLine."Conversion Qty" := "Conversion Qty";
            //NewWhseActivLine."Qty. to Invoice In KG" := "Qty. to Invoice In KG";
            //NewWhseActivLine."Qty. to Receive In KG" := "Qty. to Receive In KG";
            WarehouseActivityLine."Qty. Outstanding In KG" := "Conversion Qty";
            WarehouseActivityLine."Saleable Qty. In PCS" := "Saleable Qty. In PCS";
            WarehouseActivityLine."Damage Qty. In PCS" := "Damage Qty. In PCS";
            WarehouseActivityLine."Saleable Qty. In KG" := "Saleable Qty. In KG";
            WarehouseActivityLine."Damage Qty. In KG" := "Damage Qty. In KG";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeNewWhseActivLineInsertFromSales', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsertFromSales(var WarehouseActivityLine: Record "Warehouse Activity Line"; var SalesLine: Record "Sales Line"; var WarehouseActivityHeader: Record "Warehouse Activity Header"; var RemQtyToPickBase: Decimal)
    begin
        with SalesLine do begin
            //CCIT-SG
            WarehouseActivityLine.Weight1 := Weight;
            WarehouseActivityLine."Conversion Qty" := "Qty. to Ship In KG";
            WarehouseActivityLine."Qty. to Invoice In KG" := "Qty. to Invoice In KG";
            WarehouseActivityLine."Qty. to Receive In KG" := "Qty. to Ship In KG";
            WarehouseActivityLine."Sales Category" := "Sales Category";
            //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeNewWhseActivLineInsertFromTransfer', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsertFromTransfer(var WarehouseActivityLine: Record "Warehouse Activity Line"; var TransferLine: Record "Transfer Line"; var WarehouseActivityHeader: Record "Warehouse Activity Header"; var RemQtyToPickBase: Decimal)
    begin
        with TransferLine do begin
            //CCIT-SG
            WarehouseActivityLine.Weight1 := Weight;
            WarehouseActivityLine."Conversion Qty" := "Qty. to Ship In KG";
            WarehouseActivityLine."Qty. to Invoice In KG" := "Qty. to Ship In KG";
            WarehouseActivityLine."Qty. to Receive In KG" := "Qty. to Receive In KG";
            WarehouseActivityLine."Gen.Prod.Post.Group" := "Gen. Prod. Posting Group";
            WarehouseActivityLine."Qty. Outstanding In KG" := "Conversion Qty";
            WarehouseActivityLine."Sales Category" := "Sales Category";
            WarehouseActivityLine."TO Qty. In PCS" := TransferLine.Quantity;
            WarehouseActivityLine."TO Qty. In KG" := TransferLine."Conversion Qty";
            WarehouseActivityLine."Reason Code" := TransferLine."Reason Code"; //CCIT-PRI-100119
                                                                               /* {IF RecItem2.GET("Item No.") THEN BEGIN
                                                                                IF RecUOM.GET(RecItem2."No.",RecItem2."Base Unit of Measure") THEN BEGIN
                                                                                   IF (RecUOM.Weight <> 0) THEN BEGIN
                                                                                     //MESSAGE('%1',NewWhseActivLine.Quantity);
                                                                                     NewWhseActivLine."Conversion Qty" := NewWhseActivLine.Quantity * RecUOM.Weight;
                                                                                     NewWhseActivLine."Qty. Outstanding In KG" := NewWhseActivLine.Quantity * RecUOM.Weight;
                                                                                   END
                                                                                END
                                                                              END; } */
                                                                               //CCIT-SG
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnCreatePickOrMoveLineFromHandlingSpec', '', false, false)]
    local procedure OnCreatePickOrMoveLineFromHandlingSpec(var WarehouseActivityLine: Record "Warehouse Activity Line"; TrackingSpecification: Record "Tracking Specification"; EntriesExist: Boolean)
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        //>> CS
        WarehouseActivityLine."Manufacturing Date" :=
                      //ItemTrackingMgt.ExistingManufacturingDate(WarehouseActivityLine."Item No.", //PCPL/MIG/NSW Original Code Commented
                      ItemTrackingManagementEvents.ExistingManufacturingDate(WarehouseActivityLine."Item No.", //PCPL/MIG/NSW New Code add with Global var define to accesss this function
                        WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.", WarehouseActivityLine."Serial No.",
                        FALSE, EntriesExist);
        //<< CS
        WarehouseActivityLine."Warranty Date" := TrackingSpecification."Warranty Date";//PCPL/NSW270422
        WarehouseActivityLine."Expiration Date" := TrackingSpecification."Expiration Date";//PCPL/NSW270422
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnInsertTempHandlingSpecOnBeforeValidateQtyBase', '', false, false)]
    local procedure OnInsertTempHandlingSpecOnBeforeValidateQtyBase(var TempTrackingSpecification: Record "Tracking Specification" temporary; EntrySummary: Record "Entry Summary")
    begin
        with TempTrackingSpecification do begin
            //>> CS
            "Manufacturing Date" := EntrySummary."Manufacturing Date";
            //<< CS
            //CCIT-SG
            "PO Lot No." := EntrySummary."PO Lot No.";
            "PO Manufacturing Date" := EntrySummary."PO Manufacturing Date";
            "PO Expiration Date" := EntrySummary."PO Expiration Date";
            //CCIT-SG
            //CCIT-SG-25052018 <<
            "Actual Batch" := EntrySummary."Actual Batch";
            "Actual Batch KGS" := EntrySummary."Actual Batch KGS";
            "Actual Batch PCS" := EntrySummary."Actual Batch PCS";
            "Actual EXP Date" := EntrySummary."Actual EXP Date";
            "Actual MFG Date" := EntrySummary."Actual MFG Date";
            //CCIT-SG-25052018 >>
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeNewWhseActivLineInsert', '', false, false)]
    local procedure OnBeforeNewWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseActivityHeader: Record "Warehouse Activity Header")
    begin
        WarehouseActivityLine."Remaining Quantity" := WarehouseActivityLine.Quantity; //CCIT-SD-19-05-2018 -
        WarehouseActivityLine."Main Quantity in KG" := WarehouseActivityLine.CalcQty(WarehouseActivityLine."Qty. (Base)"); //CCIT-SD-15-05-2018 -
    end;

    var
        LicenseNo: Code[20];
        OrderDate: Date;
        LRNO: Code[20];
        LRDate: Date;
        VehicleNo: Code[20];
        TransportMode: Code[20];
        EWayBillNo: Code[20];
        EWayDate: Date;
        SealNo: Code[20];
        LoadType: Option;
        ExternalDocNo: Code[40];
        JWLTransNo: Code[20];
        JWLTransDate: Date;
        //RecItem2: Record 27;
        //RecUOM: Record 5404;
        TransportVendor: Text[50];
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        ItemTrackingManagementEvents: Codeunit 50007;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-7322 Create Inventory Pick/Movement  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    var
        RecItem1: Record 27;
        RecItem2: Record 27;
        RecUOM: Record 5404;
        TempItemLedgEntry: Record 32 TEMPORARY;
        PostInvPutway: Record 5767;
        PostedRetReceipt: Record 6660;
        PostedTransReceipt: Record 5746;
        RecItemLedgEntry: Record 32;
        DocNo: Code[20];
        LocCode: Code[20];
        CalcManufacturingDate: Date;
        ManufacturingDateChecked: Boolean;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    //ItemTrackingManagementEvents: Codeunit 50025;
    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-375 Bank Acc. Entry Set Recon.-No.  Only Function>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    PROCEDURE RemoveApplication_MultiBnkLines(VAR BankAccLedgEntry: Record 271);
    VAR
        BankAccReconLine: Record 274;
    BEGIN
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;

        IF NOT BankAccReconLine.GET(
             BankAccReconLine."Statement Type"::"Bank Reconciliation",
             BankAccLedgEntry."Bank Account No.",
             BankAccLedgEntry."Statement No.", BankAccLedgEntry."Statement Line No.")
        THEN
            EXIT;

        BankAccReconLine.TESTFIELD("Statement Type", BankAccReconLine."Statement Type"::"Bank Reconciliation");
        BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        BankAccReconLine.TESTFIELD("Bank Acc.Led Entry No."); // rdk 250719

        BankAccReconLine.SETRANGE("Bank Acc.Led Entry No.", BankAccLedgEntry."Entry No.");
        IF BankAccReconLine.FINDSET THEN
            REPEAT
                RemoveReconNo_MultiBnkLines(BankAccLedgEntry, BankAccReconLine, FALSE);

                IF BankAccLedgEntry.Amount > 0 THEN BEGIN
                    IF BankAccLedgEntry.Amount > BankAccReconLine."Applied Amount" THEN
                        BankAccReconLine."Applied Amount" := 0
                    ELSE
                        BankAccReconLine."Applied Amount" -= BankAccLedgEntry.Amount;
                END ELSE BEGIN
                    IF BankAccLedgEntry.Amount < BankAccReconLine."Applied Amount" THEN
                        BankAccReconLine."Applied Amount" := 0
                    ELSE
                        BankAccReconLine."Applied Amount" -= BankAccLedgEntry.Amount;
                END;

                BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
                BankAccReconLine.VALIDATE("Statement Amount");

                BankAccReconLine."Bank Acc.Led Entry No." := 0;
                BankAccReconLine."Document No." := '';

                BankAccReconLine.MODIFY;

            UNTIL BankAccReconLine.NEXT = 0;
    END;

    PROCEDURE RemoveReconNo_MultiBnkLines(VAR BankAccLedgEntry: Record 271; VAR BankAccReconLine: Record 274; Test: Boolean);
    BEGIN
        BankAccLedgEntry.TESTFIELD(Open, TRUE);
        IF Test THEN BEGIN
            BankAccLedgEntry.TESTFIELD(
              "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
            BankAccLedgEntry.TESTFIELD("Statement No.", BankAccReconLine."Statement No.");
            BankAccLedgEntry.TESTFIELD("Statement Line No.", BankAccReconLine."Statement Line No.");
        END;
        BankAccLedgEntry.TESTFIELD("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
        BankAccLedgEntry."Statement No." := '';
        BankAccLedgEntry."Statement Line No." := 0;
        BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
        BankAccLedgEntry.MODIFY;

        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                IF Test THEN BEGIN
                    CheckLedgEntry.TESTFIELD(
                      "Statement Status", CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                    CheckLedgEntry.TESTFIELD("Statement No.", '');
                    CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                END;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Open;
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    END;

    PROCEDURE ApplyEntries_MultiBnkLines(VAR BankAccReconLine: Record 274; VAR BankAccLedgEntry: Record 271; Relation: option "One-to-One","One-to-Many"): Boolean;
    BEGIN
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;
        BankAccReconLine.FIND;

        //IF BankAccLedgEntry.IsApplied THEN
        //  EXIT(FALSE);

        IF (Relation = Relation::"One-to-One") AND (BankAccReconLine."Applied Entries" > 0) THEN
            EXIT(FALSE);

        BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        BankAccReconLine."Ready for Application" := TRUE;
        //SetReconNo_MultiBnkLines(BankAccLedgEntry,BankAccReconLine);

        IF (BankAccReconLine."Applied Amount" < BankAccLedgEntry."Remaining Amount") OR (BankAccReconLine."Applied Amount" = 0) THEN
            BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount"
        ELSE
            BankAccReconLine."Applied Amount" += BankAccLedgEntry."Remaining Amount";

        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
        BankAccReconLine.VALIDATE("Statement Amount");

        BankAccReconLine."Bank Acc.Led Entry No." := BankAccLedgEntry."Entry No."; //rdk 25-07-2019
        BankAccReconLine."Document No." := BankAccLedgEntry."Document No.";//rdk 17-08-2019

        BankAccReconLine.MODIFY;
        //BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry."Remaining Amount" - BankAccReconLine."Statement Amount";
        //BankAccLedgEntry.MODIFY;
        EXIT(TRUE);
    END;

    PROCEDURE SetReconNo_MultiBnkLines(VAR BankAccLedgEntry: Record 271; VAR BankAccReconLine: Record 274);
    BEGIN
        BankAccLedgEntry.TESTFIELD(Open, TRUE);
        BankAccLedgEntry.TESTFIELD("Statement Status", BankAccLedgEntry."Statement Status"::Open);
        BankAccLedgEntry.TESTFIELD("Statement No.", '');
        BankAccLedgEntry.TESTFIELD("Statement Line No.", 0);
        BankAccLedgEntry.TESTFIELD("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" :=
          BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
        BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
        BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        BankAccLedgEntry.MODIFY;

        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                CheckLedgEntry.TESTFIELD("Statement Status", CheckLedgEntry."Statement Status"::Open);
                CheckLedgEntry.TESTFIELD("Statement No.", '');
                CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                CheckLedgEntry."Statement Status" :=
                  CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    END;

    VAR
        CheckLedgEntry: Record 272;
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-375 Bank Acc. Entry Set Recon.-No.  Only Function>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-396 NoSeriesManagement  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    LOCAL PROCEDURE FilterSeries1();
    VAR
        NoSeriesRelationship: Record 310;
        recUserBranch: Record 50029;
        recLoc: Record 14;
    BEGIN
        CLEAR(PostCodeCode);
        CLEAR(PostCodeText);
        NoSeries.RESET;
        //CCIT
        recUserBranch.RESET;
        recUserBranch.SETRANGE("User ID", USERID);
        IF recUserBranch.FINDSET THEN
            REPEAT
                recLoc.RESET;
                recLoc.SETRANGE(recLoc.Code, recUserBranch."Location Code");
                IF recLoc.FINDFIRST THEN
                    REPEAT
                        PostCodeCode := PostCodeCode + '|' + recLoc."Post Code";
                    UNTIL recLoc.NEXT = 0;
                PostCodeText := DELCHR(PostCodeCode, '<', '|');
            UNTIL recUserBranch.NEXT = 0;
        IF recUserBranch."Location Code" <> '' THEN
            NoSeries.SETFILTER(PostCode, PostCodeText)
        ELSE
            NoSeries.RESET;
        //CCIT
        NoSeriesRelationship.SETRANGE(Code, NoSeriesCode);
        IF NoSeriesRelationship.FINDSET THEN
            REPEAT
                NoSeries.Code := NoSeriesRelationship."Series Code";
                NoSeries.MARK := TRUE;
            UNTIL NoSeriesRelationship.NEXT = 0;
        NoSeries.GET(NoSeriesCode);
        NoSeries.MARK := TRUE;
        NoSeries.MARKEDONLY := TRUE;
    END;

    var
        RecUserBranch: Record 50029;
        PostCodeCode: Code[1024];
        PostCodeText: Text[1024];
        NoSeries: Record 308;
        NoSeriesCode: Code[10];
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-396 NoSeriesManagement  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END

    //START >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-1252 Match Bank Rec. Lines  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>START
    PROCEDURE MatchManually_MultiBankLines(VAR SelectedBankAccReconciliationLine: Record 274; VAR SelectedBankAccountLedgerEntry: Record 271);
    VAR
        BankAccReconciliationLine: Record 274;
        BankAccountLedgerEntry: Record 271;
        BankAccEntrySetReconNo: Codeunit 375;
        BnkLedEntryNo: Integer;
        TmpBnkAccReconLine: Record 274 TEMPORARY;
        Reco_amt: Decimal;
        Diff_amt: Decimal;
    BEGIN
        IF SelectedBankAccReconciliationLine.FINDSET THEN BEGIN
            Reco_amt := 0;// rdk 20-08-19
            REPEAT
                BankAccReconciliationLine.GET(
                  SelectedBankAccReconciliationLine."Statement Type",
                  SelectedBankAccReconciliationLine."Bank Account No.",
                  SelectedBankAccReconciliationLine."Statement No.",
                  SelectedBankAccReconciliationLine."Statement Line No.");
                IF BankAccReconciliationLine.Type <> BankAccReconciliationLine.Type::"Bank Account Ledger Entry" THEN
                    EXIT;

                IF SelectedBankAccountLedgerEntry.FINDSET THEN BEGIN
                    BnkLedEntryNo := SelectedBankAccountLedgerEntry."Entry No.";
                    BankAccountLedgerEntry.GET(SelectedBankAccountLedgerEntry."Entry No.");
                    //BankAccEntrySetReconNo.RemoveApplication(BankAccountLedgerEntry);
                    BankAccEntrySetReconNoEvents.ApplyEntries_MultiBnkLines(BankAccReconciliationLine, BankAccountLedgerEntry, Relation::"One-to-Many");
                END;
                TmpBnkAccReconLine := SelectedBankAccReconciliationLine;
                Reco_amt += TmpBnkAccReconLine."Statement Amount";
            UNTIL SelectedBankAccReconciliationLine.NEXT = 0;
            // rdk 20-08-19 -
            IF SelectedBankAccReconciliationLine.FINDLAST THEN BEGIN
                Diff_amt := Reco_amt - SelectedBankAccountLedgerEntry.Amount;
                SelectedBankAccReconciliationLine.VALIDATE("Applied Amount", SelectedBankAccReconciliationLine."Statement Amount" - Diff_amt);
                SelectedBankAccReconciliationLine.VALIDATE(Difference, Diff_amt);
                SelectedBankAccReconciliationLine.MODIFY;
            END;
            // rdk 20-08-19 +
            IF BnkLedEntryNo <> 0 THEN BEGIN
                BankAccountLedgerEntry.GET(BnkLedEntryNo);
                BankAccEntrySetReconNoEvents.SetReconNo_MultiBnkLines(BankAccountLedgerEntry, TmpBnkAccReconLine);
            END;

        END;
    END;

    PROCEDURE RemoveMatch_MultiBankLines(VAR SelectedBankAccReconciliationLine: Record 274; VAR SelectedBankAccountLedgerEntry: Record 271);
    VAR
        BankAccReconciliationLine: Record 274;
        BankAccountLedgerEntry: Record 271;
        BankAccEntrySetReconNo: Codeunit 375;
    BEGIN
        IF SelectedBankAccReconciliationLine."Bank Acc.Led Entry No." = 0 THEN
            ERROR('This is Single Line Application Record, use Remove Match option');
        IF SelectedBankAccReconciliationLine.FINDSET THEN
            //  REPEAT
            BankAccReconciliationLine.SETRANGE("Bank Acc.Led Entry No.", SelectedBankAccReconciliationLine."Bank Acc.Led Entry No.");
        /* {
            GET(
              SelectedBankAccReconciliationLine."Statement Type",
              SelectedBankAccReconciliationLine."Bank Account No.",
              SelectedBankAccReconciliationLine."Statement No.",
              SelectedBankAccReconciliationLine."Statement Line No.");
        } */
        IF BankAccReconciliationLine.FINDFIRST THEN BEGIN
            BankAccountLedgerEntry.SETRANGE("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
            BankAccountLedgerEntry.SETRANGE("Statement No.", BankAccReconciliationLine."Statement No.");
            BankAccountLedgerEntry.SETRANGE("Entry No.", BankAccReconciliationLine."Bank Acc.Led Entry No.");
            //BankAccountLedgerEntry.SETRANGE("Statement Line No.",BankAccReconciliationLine."Statement Line No.");
            BankAccountLedgerEntry.SETRANGE(Open, TRUE);
            BankAccountLedgerEntry.SETRANGE("Statement Status", BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
            IF BankAccountLedgerEntry.FINDFIRST THEN
                BankAccEntrySetReconNoEvents.RemoveApplication_MultiBnkLines(BankAccountLedgerEntry);
        END;
        //  UNTIL SelectedBankAccReconciliationLine.NEXT = 0;
        /* {
        IF SelectedBankAccountLedgerEntry.FINDSET THEN
          REPEAT
            BankAccountLedgerEntry.GET(SelectedBankAccountLedgerEntry."Entry No.");
            BankAccEntrySetReconNo.RemoveReconNo_MultiBnkLines(BankAccountLedgerEntry,BankAccReconciliationLine,FALSE);
          UNTIL SelectedBankAccountLedgerEntry.NEXT = 0;
          } */
    END;

    var
        BankAccEntrySetReconNoEvents: Codeunit 50005;
        Relation: Option "One-to-One","One-to-Many";
    //END >>>>>>>>>>>>>>>>>>>>>>>>  Codeunit-1252 Match Bank Rec. Lines  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>END




}