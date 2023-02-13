report 50068 "Cutting Process"
{
    // version CS

    //   26Oct2017   CS    New report created

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord();
            begin
                FromItem.GET("No.");
                CreateItemJournalLine(FromItem."No.", 3, Quantity);

                FOR i := 1 TO NoOfOutput DO BEGIN
                    ToItem.RESET;
                    ToItem.SETRANGE("Parent item", FromItem."No.");
                    ToItem.FINDFIRST;

                    //CreateItem(FromItem);
                    CreateItemJournalLine(ToItem."No.", 2, Quantity / NoOfOutput);
                END;
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("Document No.", DocNoFilter);
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
                field(JournalTemplateName; JournalTemplateName)
                {
                    Caption = 'Journal Template Name';
                    TableRelation = "Item Journal Template";
                }
                field(JournalBatchName; JournalBatchName)
                {
                    Caption = 'Journal Batch Name';
                    TableRelation = "Item Journal Batch".Name;
                }
                field(DocNoFilter; DocNoFilter)
                {
                    Caption = 'Document No.';
                    TableRelation = "Purch. Rcpt. Header"."No.";
                }
                field(NoOfOutput; NoOfOutput)
                {
                    Caption = 'No. Of Output';
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

    trigger OnPreReport();
    begin
        LineNo := 0;
    end;

    var
        FromItem: Record 27;
        ToItem: Record 27;
        i: Integer;
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        LineNo: Integer;
        DocNoFilter: Code[20];
        CreateReservEntry: Codeunit 99000830;
        NoOfOutput: Integer;

    local procedure CreateItem(_FromItem: Record 27);
    var
        InvtSetup: Record 313;
        NoSeriesManagement: Codeunit 396;
        ItemUOMFrom: Record 5404;
        ItemUOMTo: Record 5404;
    begin
        ToItem.INIT;
        ToItem.TRANSFERFIELDS(_FromItem);

        InvtSetup.GET;
        InvtSetup.TESTFIELD("Item Nos.");
        ToItem."No." := NoSeriesManagement.GetNextNo(InvtSetup."Item Nos.", WORKDATE, TRUE);

        ItemUOMFrom.RESET;
        ItemUOMFrom.SETRANGE("Item No.", _FromItem."No.");
        IF ItemUOMFrom.FINDSET THEN
            REPEAT
                ItemUOMTo.INIT;
                ItemUOMTo."Item No." := ToItem."No.";
                ItemUOMTo.Code := ItemUOMFrom.Code;
                ItemUOMTo."Qty. per Unit of Measure" := ItemUOMFrom."Qty. per Unit of Measure";
                ItemUOMTo.Length := ItemUOMFrom.Length;
                ItemUOMTo.Width := ItemUOMFrom.Width;
                ItemUOMTo.Height := ItemUOMFrom.Height;
                ItemUOMTo.Cubage := ItemUOMFrom.Cubage;
                ItemUOMTo.Weight := ItemUOMFrom.Weight / 8;
                ItemUOMTo.INSERT;
            UNTIL ItemUOMFrom.NEXT = 0;

        ToItem."Unit Cost" := 0;
        ToItem."Parent item" := _FromItem."No.";
        ToItem.INSERT;
    end;

    local procedure CreateItemJournalLine(_ItemNo: Code[20]; _EntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output; _Qty: Decimal);
    var
        ItemJournalLine: Record 83;
        ItemJournalBatch: Record 233;
        NoSeriesManagement: Codeunit 396;

        DocNo: Code[20];
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        ForReservEntry: Record "Reservation Entry";//PCPL/MIG/NSW/040522
    begin
        LineNo := 0;

        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF ItemJournalLine.FINDLAST THEN BEGIN
            DocNo := ItemJournalLine."Document No.";
            LineNo := ItemJournalLine."Line No.";
        END;

        LineNo := LineNo + 10000;

        ItemJournalBatch.GET(JournalTemplateName, JournalBatchName);
        IF DocNo = '' THEN
            DocNo := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series", WORKDATE, FALSE);

        ItemJournalLine.INIT;
        ItemJournalLine."Journal Template Name" := JournalTemplateName;
        ItemJournalLine."Journal Batch Name" := JournalBatchName;
        ItemJournalLine."Line No." := LineNo;

        ItemJournalLine."Document No." := DocNo;
        ItemJournalLine.VALIDATE("Posting Date", WORKDATE);
        ItemJournalLine.VALIDATE("Item No.", _ItemNo);
        ItemJournalLine.VALIDATE("Location Code", "Purch. Rcpt. Line"."Location Code");
        ItemJournalLine.VALIDATE("Entry Type", _EntryType);
        ItemJournalLine.VALIDATE(Quantity, _Qty);
        ItemJournalLine.INSERT(TRUE);

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Document No.", "Purch. Rcpt. Line"."Document No.");
        ItemLedgerEntry.SETRANGE("Document Line No.", "Purch. Rcpt. Line"."Line No.");
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                WhseEntry.RESET;
                WhseEntry.SETCURRENTKEY("Reference No.", "Registering Date");
                WhseEntry.SETFILTER("Reference No.", DocNoFilter);
                WhseEntry.SETRANGE("Line No.", "Purch. Rcpt. Line"."Line No.");
                IF WhseEntry.FINDFIRST THEN BEGIN
                    ItemJournalLine.VALIDATE("Bin Code", WhseEntry."Bin Code");
                    ItemJournalLine.MODIFY;
                END;

                IF _EntryType = _EntryType::"Negative Adjmt." THEN BEGIN
                    /* //<<PCPL/MIG/NSW/040522
                    CreateReservEntry.CreateReservEntryFor(
                      DATABASE::"Item Journal Line",
                      ItemJournalLine."Entry Type",
                      JournalTemplateName,
                      JournalBatchName,
                      0,
                      ItemJournalLine."Line No.",
                      ItemJournalLine."Qty. per Unit of Measure",
                      ItemJournalLine.Quantity,
                      ItemJournalLine.Quantity,
                      ItemLedgerEntry."Serial No.",
                      ItemLedgerEntry."Lot No.");
                      */ //<<PCPL/MIG/NSW/040522
                    //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
                    CreateReservEntry.CreateReservEntryFor(
                      DATABASE::"Item Journal Line",
                      ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
                      ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
                      ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
                    //>>PCPL/MIG/NSW/040522

                    CreateReservEntry.SetDates(
                      ItemLedgerEntry."Warranty Date", ItemLedgerEntry."Expiration Date");//, ItemLedgerEntry."Manufacturing Date"); //PCPL/MIG/NSW Filed not Exist in BC18

                    CreateReservEntry.SetApplyToEntryNo(ItemLedgerEntry."Entry No.");

                    CreateReservEntry.CreateEntry(
                      ItemJournalLine."Item No.",
                      ItemJournalLine."Variant Code",
                      ItemJournalLine."Location Code",
                      ItemJournalLine.Description,
                      ItemLedgerEntry."Posting Date",
                      ItemLedgerEntry."Document Date",
                      0,
                      3);
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;

        IF _EntryType = _EntryType::"Positive Adjmt." THEN BEGIN
            WhseEntry.RESET;
            WhseEntry.SETCURRENTKEY("Reference No.", "Registering Date");
            WhseEntry.SETFILTER("Reference No.", DocNoFilter);
            WhseEntry.SETRANGE("Line No.", "Purch. Rcpt. Line"."Line No.");
            IF WhseEntry.FINDFIRST THEN BEGIN
                ItemJournalLine.VALIDATE("Bin Code", WhseEntry."Bin Code");
                ItemJournalLine.MODIFY;
            END;
            /* //<<PCPL/MIG/NSW/040522
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type",
              JournalTemplateName,
              JournalBatchName,
              0,
              ItemJournalLine."Line No.",
              ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity,
              ItemJournalLine.Quantity,
              ItemLedgerEntry."Serial No.",
              ItemLedgerEntry."Lot No.");
            */ //<<PCPL/MIG/NSW/040522

            //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
              ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
            //>>PCPL/MIG/NSW/040522

            CreateReservEntry.SetDates(
              ItemLedgerEntry."Warranty Date", ItemLedgerEntry."Expiration Date");//, ItemLedgerEntry."Manufacturing Date"); //PCPL/MIG/NSW Filed not Exist in BC18

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
    end;
}

