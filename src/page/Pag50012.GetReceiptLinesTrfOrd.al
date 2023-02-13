page 50012 "Get Receipt Lines - Trf Ord"
{
    // version NAVW19.00.00.45778

    CaptionML = ENU = 'Get Receipt Lines',
                ENN = 'Get Receipt Lines';
    Editable = false;
    PageType = List;
    Permissions = TableData 121 = rm;
    SourceTable = "Purch. Rcpt. Line";

    layout
    {
        area(content)
        {
            repeater(Control001)
            {
                field("Document No."; "Document No.")
                {
                    HideValue = "Document No.HideValue";
                    StyleExpr = 'Strong';
                    ApplicationArea = all;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; "Currency Code")
                {
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    CaptionML = ENU = 'Quantity In KG',
                                ENN = 'Quantity';
                    ApplicationArea = all;
                }
                field("Conversion Qty"; "Conversion Qty")
                {
                    Caption = 'Quantity In PCS';
                    ApplicationArea = all;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    CaptionML = ENU = 'Quantity Invoiced In KG',
                                ENN = 'Quantity Invoiced';
                    ApplicationArea = all;
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                    CaptionML = ENU = 'Qty. Rcd. Not Invoiced In KG',
                                ENN = 'Qty. Rcd. Not Invoiced';
                    ApplicationArea = all;
                }
            }
        }
        area(factboxes)
        {
            systempart(Sys1; Links)
            {
                Visible = false;
            }
            systempart(Sys2; Notes)
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
                action("Show Document")
                {
                    CaptionML = ENU = 'Show Document',
                                ENN = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        PurchRcptHeader.GET("Document No.");
                        PAGE.RUN(PAGE::"Posted Purchase Receipt", PurchRcptHeader);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                action("Item &Tracking Entries")
                {
                    CaptionML = ENU = 'Item &Tracking Entries',
                                ENN = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        ShowItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        "Document No.HideValue" := FALSE;
        DocumentNoOnFormat;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines;
    end;

    var
        PurchHeader: Record 38;
        PurchRcptHeader: Record 120;
        TempPurchRcptLine: Record 121 temporary;
        RecTransOrdHdr: Record 5740;
        RecTransOrdLn: Record 5741;
        RecPH: Record 38;
        LNO: Integer;
        GetReceipts: Codeunit 74;
        [InDataSet]
        "Document No.HideValue": Boolean;

    procedure SetPurchHeader(var PurchHeader2: Record 38);
    begin
        PurchHeader.GET(PurchHeader2."Document Type", PurchHeader2."No.");
        PurchHeader.TESTFIELD("Document Type", PurchHeader."Document Type"::Invoice);
    end;

    local procedure IsFirstDocLine(): Boolean;
    var
        PurchRcptLine: Record 121;
    begin
        TempPurchRcptLine.RESET;
        TempPurchRcptLine.COPYFILTERS(Rec);
        TempPurchRcptLine.SETRANGE("Document No.", "Document No.");
        IF NOT TempPurchRcptLine.FINDFIRST THEN BEGIN
            PurchRcptLine.COPYFILTERS(Rec);
            PurchRcptLine.SETRANGE("Document No.", "Document No.");
            PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>0');
            IF PurchRcptLine.FINDFIRST THEN BEGIN
                TempPurchRcptLine := PurchRcptLine;
                TempPurchRcptLine.INSERT;
            END;
        END;
        IF "Line No." = TempPurchRcptLine."Line No." THEN
            EXIT(TRUE);
    end;

    local procedure CreateLines();
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        CopyGRNtoTOLines(Rec);
    end;

    local procedure DocumentNoOnFormat();
    begin
        IF NOT IsFirstDocLine THEN
            "Document No.HideValue" := TRUE;
    end;

    local procedure CopyGRNtoTOLines(var PurchRcptLine2: Record 121);
    begin
        RecTransOrdHdr.RESET;
        RecTransOrdHdr.SETRANGE("No.", PurchRcptLine2."Trans.Ord.");
        IF RecTransOrdHdr.FINDFIRST THEN BEGIN
            RecTransOrdLn.SETRANGE("Document No.", RecTransOrdHdr."No.");
            IF RecTransOrdLn.FINDLAST THEN
                LNO := RecTransOrdLn."Line No."
            ELSE
                LNO := 10000;

            RecPH.RESET;
            RecPH.SETRANGE("No.", PurchRcptLine2."Order No.");
            IF RecPH.FINDFIRST THEN;

            WITH PurchRcptLine2 DO BEGIN
                IF FIND('-') THEN BEGIN
                    REPEAT
                        LNO += 10000;
                        RecTransOrdLn.INIT;
                        RecTransOrdLn.VALIDATE("Document No.", RecTransOrdHdr."No.");
                        RecTransOrdLn.VALIDATE("Line No.", LNO);
                        RecTransOrdLn.VALIDATE("Item No.", PurchRcptLine2."No.");
                        RecTransOrdLn.VALIDATE(Quantity, PurchRcptLine2.Quantity);
                        RecTransOrdLn.VALIDATE("In-Bond Bill of Entry No.", RecPH."In-Bond Bill of Entry No.");
                        RecTransOrdLn.VALIDATE("In-Bond BOE Date", RecPH."In-Bond BOE Date");
                        RecTransOrdLn.VALIDATE("Bond Number", RecPH."Bond Number");
                        RecTransOrdLn.VALIDATE("Bond Sr.No.", RecPH."Bond Sr.No.");
                        RecTransOrdLn.VALIDATE("Bond Date", RecPH."Bond Date");


                        RecTransOrdLn.INSERT;
                        PurchRcptLine2."Trans.Ord." := RecTransOrdHdr."No.";
                        PurchRcptLine2.MODIFY;
                    UNTIL NEXT = 0;
                END;
            END;
        END
        ELSE
            ERROR('Transfer ORder %1 not found', PurchRcptLine2."Trans.Ord.");
    end;
}

