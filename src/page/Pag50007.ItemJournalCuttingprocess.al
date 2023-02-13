page 50007 "Item Journal - Cutting process"
{
    // version CCIT-Fortune-SD.I1.0.001

    AutoSplitKey = true;
    CaptionML = ENU = 'Item Journal - Cutting process',
                ENN = 'Item Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ItemJnlMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control02585)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                    OptionCaptionML = ENU = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.',
                                      ENN = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';

                    trigger OnValidate();
                    begin
                        UpdateNatureOfDisposal;
                    end;
                }
                field("Document No."; "Document No.")
                {
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {

                    trigger OnValidate();
                    begin
                        ItemJnlMgt.GetItem("Item No.", ItemDescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;

                    trigger OnValidate();
                    var
                        WMSManagement: Codeunit 7302;
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec, xRec);
                    end;
                }
                field("Select Lot No."; "Select Lot No.")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    //trigger OnAfterLookup(Text: Text): Boolean;
                    begin
                        //CCIT-SD-I1-02-01-2017 -
                        UpdateTempLotNo;
                        IF PAGE.RUNMODAL(6507, RecTempSpecification) = ACTION::LookupOK THEN BEGIN
                            VALIDATE("Select Lot No.", RecTempSpecification."Lot No.");
                            VALIDATE("Manufacturing Date", RecTempSpecification."Manufacturing Date");
                            VALIDATE("Expiration Date", RecTempSpecification."Expiration Date");
                            //CCIT-SD-I1-02-01-2017 -
                            //ReserveItemJnlLine.DeleteLine(Rec);
                            //UpdateReservationEntry;
                            //CCIT-SD-I1-02-01-2017 +
                        END;
                        //CCIT-SD-I1-02-01-2017 +
                    end;

                    trigger OnValidate();
                    begin
                        //CCIT-SD-I1-02-01-2017 -
                        //UpdateTempLotNo;
                        ItemLE.RESET;
                        ItemLE.SETRANGE("Item No.", "Item No.");
                        ItemLE.SETRANGE("Location Code", "Location Code");
                        ItemLE.SETRANGE("Lot No.", "Select Lot No.");
                        ItemLE.SETFILTER(ItemLE."Remaining Quantity", '>=%1', Rec.Quantity);//CCIT-SG-11102018
                        ItemLE.SETRANGE(Open, TRUE);
                        IF ItemLE.FINDFIRST THEN BEGIN
                            //VALIDATE("Select Lot No.",RecTempSpecification."Lot No.");
                            VALIDATE("Manufacturing Date", ItemLE."Manufacturing Date");
                            VALIDATE("Expiration Date", ItemLE."Expiration Date");
                        END ELSE BEGIN
                            VALIDATE("Manufacturing Date", 0D);
                            VALIDATE("Expiration Date", 0D);
                        END;
                        //CCIT-SD-I1-02-01-2017 +
                    end;
                }
                field("Manufacturing Date"; "Manufacturing Date")
                {
                }
                field("Expiration Date"; "Expiration Date")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    CaptionML = ENU = 'Quantity In KG',
                                ENN = 'Quantity';
                }
                field("Conversion Qty"; "Conversion Qty")
                {
                    Caption = 'Quantity In PCS';
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Cutting In (Pc)"; "Cutting In (Pc)")
                {
                }
                field("Storage Categories"; "Storage Categories")
                {
                }
                field("Unit Amount"; "Unit Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Discount Amount"; "Discount Amount")
                {
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    Visible = false;
                }

                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                }
                field("Applies-from Entry"; "Applies-from Entry")
                {
                    Visible = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Visible = false;
                }
                field("Transport Method"; "Transport Method")
                {
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    Visible = false;
                }

            }
            group(Control0012)
            {
                fixed(Action02589)
                {
                    group("Item Description")
                    {
                        CaptionML = ENU = 'Item Description',
                                    ENN = 'Item Description';
                        field(ItemDescription; ItemDescription)
                        {
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Sys01; 9090)
            {
                SubPageLink = "No." = FIELD("Item No.");
                Visible = false;
            }
            systempart(Sys2; Links)
            {
                Visible = false;
            }
            systempart(Sys3; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                CaptionML = ENU = '&Line',
                            ENN = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(ItemTrackingLines)
                {
                    CaptionML = ENU = 'Item &Tracking Lines',
                                ENN = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction();
                    begin
                        OpenItemTrackingLines(FALSE);
                    end;
                }
                action("Bin Contents")
                {
                    CaptionML = ENU = 'Bin Contents',
                                ENN = 'Bin Contents';
                    Image = BinContent;
                    RunObject = Page 7305;
                    RunPageLink = "Location Code" = FIELD("Location Code"),
                                  "Item No." = FIELD("Item No."),
                                  "Variant Code" = FIELD("Variant Code");
                    RunPageView = SORTING("Location Code", "Item No.", "Variant Code");
                }
                separator("Control58589")
                {
                    CaptionML = ENU = '-',
                                ENN = '-';
                }
                action("&Recalculate Unit Amount")
                {
                    CaptionML = ENU = '&Recalculate Unit Amount',
                                ENN = '&Recalculate Unit Amount';
                    Image = UpdateUnitCost;

                    trigger OnAction();
                    begin
                        RecalculateUnitAmount;
                        CurrPage.SAVERECORD;
                    end;
                }
            }
            group("&Item")
            {
                CaptionML = ENU = '&Item',
                            ENN = '&Item';
                Image = Item;
                action(Card)
                {
                    CaptionML = ENU = 'Card',
                                ENN = 'Card';
                    Image = EditLines;
                    RunObject = Page 30;
                    RunPageLink = "No." = FIELD("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries',
                                ENN = 'Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 38;
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                group("Item Availability by")
                {
                    CaptionML = ENU = 'Item Availability by',
                                ENN = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        CaptionML = ENU = 'Event',
                                    ENN = 'Event';
                        Image = "Event";

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU = 'Period',
                                    ENN = 'Period';
                        Image = Period;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU = 'Variant',
                                    ENN = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData 14 = R;
                        CaptionML = ENU = 'Location',
                                    ENN = 'Location';
                        Image = Warehouse;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU = 'BOM Level',
                                    ENN = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ENN = 'F&unctions';
                Image = "Action";
                action("E&xplode BOM")
                {
                    CaptionML = ENU = 'E&xplode BOM',
                                ENN = 'E&xplode BOM';
                    Image = ExplodeBOM;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 246;
                }
                action("&Calculate Whse. Adjustment")
                {
                    CaptionML = ENU = '&Calculate Whse. Adjustment',
                                ENN = '&Calculate Whse. Adjustment';
                    Ellipsis = true;
                    Image = CalculateWarehouseAdjustment;

                    trigger OnAction();
                    begin
                        CalcWhseAdjmt.SetItemJnlLine(Rec);
                        CalcWhseAdjmt.RUNMODAL;
                        CLEAR(CalcWhseAdjmt);
                    end;
                }
                separator("-")
                {
                    CaptionML = ENU = '-',
                                ENN = '-';
                }
                action("&Get Standard Journals")
                {
                    CaptionML = ENU = '&Get Standard Journals',
                                ENN = '&Get Standard Journals';
                    Ellipsis = true;
                    Image = GetStandardJournal;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        StdItemJnl: Record 752;
                    begin
                        StdItemJnl.FILTERGROUP := 2;
                        StdItemJnl.SETRANGE("Journal Template Name", "Journal Template Name");
                        StdItemJnl.FILTERGROUP := 0;
                        IF PAGE.RUNMODAL(PAGE::"Standard Item Journals", StdItemJnl) = ACTION::LookupOK THEN BEGIN
                            StdItemJnl.CreateItemJnlFromStdJnl(StdItemJnl, CurrentJnlBatchName);
                            MESSAGE(Text001, StdItemJnl.Code);
                        END
                    end;
                }
                action("&Save as Standard Journal")
                {
                    CaptionML = ENU = '&Save as Standard Journal',
                                ENN = '&Save as Standard Journal';
                    Ellipsis = true;
                    Image = SaveasStandardJournal;

                    trigger OnAction();
                    var
                        ItemJnlBatch: Record 233;
                        ItemJnlLines: Record 83;
                        StdItemJnl: Record 752;
                        SaveAsStdItemJnl: Report 751;
                    begin
                        ItemJnlLines.SETFILTER("Journal Template Name", "Journal Template Name");
                        ItemJnlLines.SETFILTER("Journal Batch Name", CurrentJnlBatchName);
                        CurrPage.SETSELECTIONFILTER(ItemJnlLines);
                        ItemJnlLines.COPYFILTERS(Rec);

                        ItemJnlBatch.GET("Journal Template Name", CurrentJnlBatchName);
                        SaveAsStdItemJnl.Initialise(ItemJnlLines, ItemJnlBatch);
                        SaveAsStdItemJnl.RUNMODAL;
                        IF NOT SaveAsStdItemJnl.GetStdItemJournal(StdItemJnl) THEN
                            EXIT;

                        MESSAGE(Text002, StdItemJnl.Code);
                    end;
                }
            }
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting',
                            ENN = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    CaptionML = ENU = 'Test Report',
                                ENN = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction();
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    CaptionML = ENU = 'P&ost',
                                ENN = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Post and &Print")
                {
                    CaptionML = ENU = 'Post and &Print',
                                ENN = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
            action("&Print")
            {
                CaptionML = ENU = '&Print',
                            ENN = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ItemJnlLine: Record 83;
                begin
                    ItemJnlLine.COPY(Rec);
                    ItemJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    REPORT.RUNMODAL(REPORT::"Inventory Movement", TRUE, TRUE, ItemJnlLine);
                end;
            }
            group("Cutting Function")
            {
                Caption = 'Cutting Function';
                Image = "Action";
                action("Cutting Process")
                {
                    Caption = 'Cutting Process';
                    Image = PostBatch;

                    trigger OnAction();
                    begin
                        //CCIT-SD-I1-02-01-2017 -
                        CuttingProcess;
                        //CCIT-SD-I1-02-01-2017 +
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        ItemJnlMgt.GetItem("Item No.", ItemDescription);
        UpdateNatureOfDisposal;
        MakeFieldNonEditable;
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        UpdateNatureOfDisposal;
        MakeFieldNonEditable;
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        ReserveItemJnlLine: Codeunit 99000835;
    begin
        COMMIT;
        IF NOT ReserveItemJnlLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
        ReserveItemJnlLine.DeleteLine(Rec);
    end;

    trigger OnInit();
    begin
        "Nature of DisposalEditable" := TRUE;
        "Other UsageEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        IF "Entry Type" > "Entry Type"::"Negative Adjmt." THEN
            ERROR(Text000, "Entry Type");
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine(xRec);
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        IF IsOpenedFromBatch THEN BEGIN
            CurrentJnlBatchName := "Journal Batch Name";
            ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
            EXIT;
        END;
        ItemJnlMgt.TemplateSelection(PAGE::"Item Journal", 0, FALSE, Rec, JnlSelected);
        IF NOT JnlSelected THEN
            ERROR('');
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
        UpdateNatureOfDisposal;
        MakeFieldNonEditable;
        OnActivateForm;
    end;

    var
        Text000: TextConst ENU = 'You cannot use entry type %1 in this journal.', ENN = 'You cannot use entry type %1 in this journal.';
        ItemJnlMgt: Codeunit 240;
        ReportPrint: Codeunit 228;
        ItemAvailFormsMgt: Codeunit 353;
        CalcWhseAdjmt: Report 7315;
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        Text001: TextConst ENU = 'Item Journal lines have been successfully inserted from Standard Item Journal %1.', ENN = 'Item Journal lines have been successfully inserted from Standard Item Journal %1.';
        Text002: TextConst ENU = 'Standard Item Journal %1 has been successfully created.', ENN = 'Standard Item Journal %1 has been successfully created.';
        [InDataSet]
        "Other UsageEditable": Boolean;
        [InDataSet]
        "Nature of DisposalEditable": Boolean;
        RecTempSpecification: Record 337 temporary;
        PageItemTrackingList: Page 6507;
        ReserveItemJnlLine: Codeunit 99000835;
        ItemLE: Record 32;

    procedure UpdateNatureOfDisposal();
    begin
        IF "Entry Type" <> "Entry Type"::"Negative Adjmt." THEN BEGIN
            "Other UsageEditable" := FALSE;
            "Nature of DisposalEditable" := FALSE;
            //  "Other Usage" := 0;
            //          "Nature of Disposal" := '';
        END ELSE BEGIN
            "Other UsageEditable" := TRUE;
            "Nature of DisposalEditable" := TRUE;
        END;
        //IF "Other Usage" <> "Other Usage"::"Wasted/Destroyed" THEN
        //"Nature of DisposalEditable" := FALSE;
    end;

    procedure MakeFieldNonEditable();
    begin
        //IF ("Other Usage" = "Other Usage"::"Wasted/Destroyed") OR ("Other Usage" = "Other Usage"::" ") THEN BEGIN //PCPL/MIG/NSW Filed not Exist in BC18
        //  "Nature of DisposalEditable" := FALSE;
        // "Nature of Disposal" := '';
        //END ELSE
        "Nature of DisposalEditable" := TRUE; //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    local procedure CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OtherUsageOnActivate();
    begin
        MakeFieldNonEditable;
    end;

    local procedure OnActivateForm();
    begin
        UpdateNatureOfDisposal;
    end;

    local procedure OtherUsageOnAfterInput(var Text: Text[1024]);
    begin
        MakeFieldNonEditable;
    end;

    local procedure OtherUsageOnInputChange(var Text: Text[1024]);
    begin
        MakeFieldNonEditable;
    end;

    local procedure UpdateTempLotNo();
    var
        ILE: Record 32;
        EntryNo: Integer;
        ILE1: Record 32;
        Qty: Decimal;
        QTYKg: Decimal;
    begin
        RecTempSpecification.DELETEALL;
        EntryNo := 1;
        ILE.RESET;
        ILE.SETRANGE("Item No.", "Item No.");
        ILE.SETRANGE("Location Code", "Location Code");
        ILE.SETRANGE(Open, TRUE);
        IF ILE.FINDSET THEN
            REPEAT
                RecTempSpecification.RESET;
                RecTempSpecification.SETRANGE("Item No.", ILE."Item No.");
                RecTempSpecification.SETRANGE("Lot No.", ILE."Lot No.");
                IF NOT RecTempSpecification.FINDFIRST THEN BEGIN
                    Qty := 0;
                    QTYKg := 0;
                    ILE1.RESET;
                    ILE1.SETRANGE("Item No.", "Item No.");
                    ILE1.SETRANGE("Location Code", "Location Code");
                    ILE1.SETRANGE("Lot No.", ILE."Lot No.");
                    //ILE1.SETRANGE(Open,TRUE);
                    IF ILE1.FINDSET THEN
                        REPEAT
                            Qty += ILE1.Quantity;
                            QTYKg += ILE1."Qty. to Handle (Base) In KG";
                        UNTIL ILE1.NEXT = 0;
                    RecTempSpecification.INIT;
                    RecTempSpecification."Entry No." := EntryNo;
                    RecTempSpecification."Item No." := ILE."Item No.";
                    RecTempSpecification."Lot No." := ILE."Lot No.";
                    RecTempSpecification."Manufacturing Date" := ILE."Manufacturing Date";
                    RecTempSpecification."Expiration Date" := ILE."Expiration Date";
                    RecTempSpecification."Source ID" := ILE."Document No.";
                    RecTempSpecification.Quantity := Qty;
                    RecTempSpecification."Quantity (Base)" := Qty;
                    RecTempSpecification."Qty. to Handle (Base) In KG" := QTYKg;
                    RecTempSpecification.INSERT;
                    RecTempSpecification.RESET;
                END;
                EntryNo += 1;
            UNTIL ILE.NEXT = 0;
        RecTempSpecification.RESET;
        RecTempSpecification.SETRANGE("Item No.", ILE."Item No.");
    end;

    local procedure CreateItemJournalLine(_ItemNo: Code[20]; _EntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output; _Qty: Decimal);
    var
        ItemJournalLine: Record 83;
        ItemJournalBatch: Record 233;
        NoSeriesManagement: Codeunit 396;
        DocNo: Code[20];
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        LineNo: Integer;
        CreateReservEntry: Codeunit 99000830;
        ForReservEntry: Record "Reservation Entry"; //PCPL/MIG/NSW/040522
    begin
        //CCIT-SD-I1-02-01-2017 -
        LineNo := 0;

        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        IF ItemJournalLine.FINDLAST THEN BEGIN
            DocNo := ItemJournalLine."Document No.";
            LineNo := ItemJournalLine."Line No.";
        END;

        LineNo := LineNo + 10000;

        ItemJournalBatch.GET("Journal Template Name", "Journal Batch Name");
        IF DocNo = '' THEN
            DocNo := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series", WORKDATE, FALSE);
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        ItemJournalLine.SETRANGE("Item No.", _ItemNo);
        ItemJournalLine.SETRANGE("Select Lot No.", "Select Lot No.");
        IF NOT ItemJournalLine.FINDFIRST THEN BEGIN
            ItemJournalLine.INIT;
            ItemJournalLine."Journal Template Name" := "Journal Template Name";
            ItemJournalLine."Journal Batch Name" := "Journal Batch Name";
            ItemJournalLine."Line No." := LineNo;

            ItemJournalLine."Document No." := DocNo;
            ItemJournalLine.VALIDATE("Posting Date", WORKDATE);
            ItemJournalLine.VALIDATE("Item No.", _ItemNo);
            ItemJournalLine.VALIDATE("Location Code", "Location Code");
            ItemJournalLine.VALIDATE("Entry Type", _EntryType);
            ItemJournalLine.VALIDATE(Quantity, Quantity);//("Conversion Qty"/"Cutting In (Pc)"));
                                                         //ItemJournalLine.VALIDATE("Lot No.","Lot No.");
            ItemJournalLine.VALIDATE("Select Lot No.", "Select Lot No.");
            ItemJournalLine.VALIDATE("Manufacturing Date", "Manufacturing Date");
            ItemJournalLine.VALIDATE("Expiration Date", "Expiration Date");
            ItemJournalLine.INSERT(TRUE);

            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETRANGE("Lot No.", "Select Lot No.");
            ItemLedgerEntry.SETRANGE(Open, TRUE);
            ItemLedgerEntry.SETRANGE("Location Code", "Location Code");
            IF ItemLedgerEntry.FINDSET THEN
                REPEAT
                    WhseEntry.RESET;
                    WhseEntry.SETCURRENTKEY("Reference No.", "Registering Date");
                    WhseEntry.SETFILTER("Reference No.", ItemLedgerEntry."Document No.");
                    WhseEntry.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                    WhseEntry.SETRANGE("Lot No.", "Select Lot No.");
                    IF WhseEntry.FINDFIRST THEN BEGIN
                        ItemJournalLine.VALIDATE("Bin Code", WhseEntry."Bin Code");
                        ItemJournalLine.MODIFY;
                    END;

                    IF _EntryType = _EntryType::"Negative Adjmt." THEN BEGIN

                        /*//<<PCPL/MIG/NSW/040522
                        CreateReservEntry.CreateReservEntryFor(
                          DATABASE::"Item Journal Line",
                          ItemJournalLine."Entry Type",
                          "Journal Template Name",
                          "Journal Batch Name",
                          0,
                          ItemJournalLine."Line No.",
                          ItemJournalLine."Qty. per Unit of Measure",
                          ItemJournalLine.Quantity,
                          ItemJournalLine.Quantity,
                          ItemLedgerEntry."Serial No.",
                          ItemLedgerEntry."Lot No.");
                          //>>PCPL/MIG/NSW/040522
                          */

                        //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
                        CreateReservEntry.CreateReservEntryFor(
                          DATABASE::"Item Journal Line",
                          ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
                          ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
                          ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
                        //>>PCPL/MIG/NSW/040522

                        CreateReservEntry.SetDates(
                          ItemLedgerEntry."Warranty Date", ItemLedgerEntry."Expiration Date");//, ItemLedgerEntry."Manufacturing Date"); //PCPL/MIG/NSW Filed not Exist in BC18
                                                                                              //CreateReservEntry.SetPOData(
                                                                                              //ItemLedgerEntry."Expiration Date", ItemLedgerEntry."PO Lot No.", ItemLedgerEntry."PO Manufacturing Date"); //PCPL/MIG/NSW Filed not Exist in BC18
                        CreateReservEntry.SetApplyToEntryNo(ItemLedgerEntry."Entry No.");
                        //CreateReservEntry.SetQtyToHandleBaseInKG(ItemJournalLine."Conversion Qty"); //PCPL/MIG/NSW Filed not Exist in BC18
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
                WhseEntry.SETFILTER("Reference No.", ItemLedgerEntry."Document No.");
                WhseEntry.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                WhseEntry.SETRANGE("Lot No.", "Select Lot No.");
                IF WhseEntry.FINDFIRST THEN BEGIN
                    ItemJournalLine.VALIDATE("Bin Code", WhseEntry."Bin Code");
                    ItemJournalLine.MODIFY;
                END;
                /* //<<PCPL/MIG/NSW/040522
                CreateReservEntry.CreateReservEntryFor(
                  DATABASE::"Item Journal Line",
                  ItemJournalLine."Entry Type",
                  "Journal Template Name",
                  "Journal Batch Name",
                  0,
                  ItemJournalLine."Line No.",
                  ItemJournalLine."Qty. per Unit of Measure",
                  ItemJournalLine.Quantity,
                  ItemJournalLine.Quantity,
                  ItemLedgerEntry."Serial No.",
                  ItemLedgerEntry."Lot No.");
                */ //>>PCPL/MIG/NSW/040522

                //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
                CreateReservEntry.CreateReservEntryFor(
                  DATABASE::"Item Journal Line",
                  ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
                  ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
                  ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
                //>>PCPL/MIG/NSW/040522
                //PCPL/MIG/NSW Below Code Comment
                //CreateReservEntry.SetDates(
                //ItemLedgerEntry."Warranty Date", ItemLedgerEntry."Expiration Date", ItemLedgerEntry."Manufacturing Date");
                //CreateReservEntry.SetQtyToHandleBaseInKG(ItemJournalLine."Conversion Qty");
                //CreateReservEntry.SetRemainQtyInKG("Conversion Qty");
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
        //CCIT-SD-I1-02-01-2017 +
    end;

    local procedure CuttingProcess();
    var
        ToItem: Record 27;
        i: Integer;
        IUOM: Record 5404;
    begin
        //CCIT-SD-I1-02-01-2017 -
        RESET;
        SETRANGE("Journal Batch Name", 'CUTTING');
        SETRANGE("Journal Template Name", 'ITEM');
        SETFILTER("Entry Type", '<>%1', "Entry Type"::"Positive Adjmt.");
        FINDFIRST;
        REPEAT
            ToItem.RESET;
            ToItem.SETRANGE("Parent item", "Item No.");
            IF ToItem.FINDFIRST THEN BEGIN
                ToItem.TESTFIELD("Item Tracking Code");
                IUOM.RESET;
                IUOM.SETRANGE("Item No.", ToItem."No.");
                IF IUOM.FINDFIRST THEN BEGIN
                    IF Quantity = (IUOM.Weight * "Cutting In (Pc)") THEN
                        //CreateItemJournalLine(ToItem."No.",2, "Conversion Qty" / "Cutting In (Pc)")
                        CreateItemJournalLine(ToItem."No.", 2, Quantity / "Cutting In (Pc)")  //CCIT-SG-22012018
                    ELSE
                        ERROR('Cutting quantity not equal to original quantity');
                END;
            END;

            IF "Entry Type" = "Entry Type"::Purchase THEN BEGIN
                "Entry Type" := "Entry Type"::"Negative Adjmt.";
                MODIFY;
            END;
            UpdateReservationEntry("Select Lot No.", "Line No.");

        UNTIL NEXT = 0;
        MESSAGE('Process Completed Successfully');
        RESET;
        SETRANGE("Journal Template Name", "Journal Template Name");
        SETRANGE("Journal Batch Name", "Journal Batch Name");
        CurrPage.UPDATE(TRUE);
        //CCIT-SD-I1-02-01-2017 +
    end;

    local procedure UpdateReservationEntry(pSelectLot: Code[20]; pLineNo: Integer);
    var
        ItemJournalLine: Record 83;
        ItemJournalBatch: Record 233;
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        CreateReservEntry: Codeunit 99000830;
    begin


    end;
}