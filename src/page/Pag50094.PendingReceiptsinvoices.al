page 50094 "Pending Receipts & invoices"
{
    // version NAVW19.00.00.45778 CCIT AN

    CaptionML = ENU = 'Pending Receipts & Invoices',
                ENN = 'Get Receipt Lines';
    Editable = false;
    PageType = List;
    SourceTable = 121;
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Action0101)
            {
                field("Document No."; "Document No.")
                {
                    HideValue = "Document No.HideValue";
                    StyleExpr = 'Strong';
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Quantity In KG',
                                ENN = 'Quantity';
                }
                field("Conversion Qty"; "Conversion Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Quantity In PCS';
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Quantity Invoiced In KG',
                                ENN = 'Quantity Invoiced';
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Qty. Rcd. Not Invoiced In KG',
                                ENN = 'Qty. Rcd. Not Invoiced';
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
        //IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
        //  CreateLines;
    end;

    var
        PurchHeader: Record 38;
        PurchRcptHeader: Record 120;
        TempPurchRcptLine: Record 121 temporary;
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
        GetReceipts.SetPurchHeader(PurchHeader);
        GetReceipts.CreateInvLines(Rec);
    end;

    local procedure DocumentNoOnFormat();
    begin
        IF NOT IsFirstDocLine THEN
            "Document No.HideValue" := TRUE;
    end;
}

