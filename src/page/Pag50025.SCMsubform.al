page 50025 "SCM subform"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    AutoSplitKey = true;
    CaptionML = ENU = 'Lines',
                ENN = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER("Credit Memo"));

    layout
    {
        area(content)
        {
            repeater(Control001)
            {
                field(Type; Type)
                {

                    trigger OnValidate();
                    begin
                        NoOnAfterValidate;
                        //TypeChosen := HasTypeToFillMandatotyFields;

                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;

                        /*// rdk 190919 -
                        IF Type = Type::"G/L Account" THEN
                          ItemCodeVisible := TRUE
                        ELSE
                          ItemCodeVisible := FALSE;
                        
                        CurrPage.UPDATE;*/
                        // rdk 190919 +

                    end;
                }
                field("No."; "No.")
                {
                    //ShowMandatory = TypeChosen;

                    trigger OnValidate();
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Item code"; "Item code")
                {

                    trigger OnValidate();
                    begin
                        // rdk 190919 -
                        IF Type <> Type::"G/L Account" THEN
                            ERROR('You cannot enter the item code for Non GL Account Type');

                        // rdk 190919 +
                    end;
                }

                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;
                    trigger OnLookup(var Text: Text): Boolean
                    //trigger OnAfterLookup(Text: Text): Boolean;
                    begin
                        CrossReferenceNoLookUp;
                        InsertExtendedText(FALSE);
                        NoOnAfterValidate;
                    end;

                    trigger OnValidate();
                    begin
                        CrossReferenceNoOnAfterValidat;
                        NoOnAfterValidate;
                    end;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    Visible = false;
                }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type")
                {
                    Visible = false;
                }
                field("IC Partner Reference"; "IC Partner Reference")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Nonstock; Nonstock)
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Reason Code"; "Reason Code")
                {
                }

                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }

                field("Price Inclusive of Tax"; "Price Inclusive of Tax")
                {
                    Visible = false;
                }
                field("Unit Price Incl. of Tax"; "Unit Price Incl. of Tax")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;
                }
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field(Reserve; Reserve)
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ReserveOnAfterValidate;
                    end;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                    Caption = 'Quantity In KG';
                    //ShowMandatory = TypeChosen;

                    trigger OnValidate();
                    begin
                        QuantityOnAfterValidate;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Conversion Qty"; "Conversion Qty")
                {
                    Caption = 'Quantity in PCS';
                }
                field("Special Price"; "Special Price")
                {
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                }
                field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
                {
                }
                field("Quarantine Qty In KG"; "Quarantine Qty In KG")
                {
                    DecimalPlaces = 0 : 5;
                }
                field("Actual Qty In PCS"; "Actual Qty In PCS")
                {
                }
                field("Actual Qty In KG"; "Actual Qty In KG")
                {
                    DecimalPlaces = 0 : 5;
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                    BlankZero = true;
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        ShowReservationEntries(TRUE);
                        UpdateForm(TRUE);
                    end;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {

                    trigger OnValidate();
                    begin
                        UnitofMeasureCodeOnAfterValida;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;
                    //ShowMandatory = TypeChosen;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount"; "Line Amount")
                {

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("TCS Nature of Collection"; "TCS Nature of Collection")
                {
                    CaptionML = ENU = 'TCS Nature of Collection',
                                ENN = 'TCS Nature of Collection';
                }

                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(FALSE);
                    end;
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(FALSE);
                    end;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No."; "Job Task No.")
                {
                    Visible = false;
                }
                field("Tax Category"; "Tax Category")
                {
                    Visible = false;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    Visible = false;
                }
                field("Variance Qty. In KG"; "Variance Qty. In KG")
                {
                }
                field("Salable Qty. In KG"; "Salable Qty. In KG")
                {
                }
                field("Variance Qty. In PCS"; "Variance Qty. In PCS")
                {
                }
                field("Salable Qty. In PCS"; "Salable Qty. In PCS")
                {
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    Visible = false;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    Visible = false;
                }
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Deferral Code"; "Deferral Code")
                {
                    Enabled = (Type <> Type::"Fixed Asset") AND (Type <> Type::" ");
                    TableRelation = "Deferral Template"."Deferral Code";
                }
                field("GST Place of Supply"; "GST Place of Supply")
                {
                    Visible = false;
                }
                field("GST Group Code"; "GST Group Code")
                {
                    Visible = false;
                }
                field("GST Group Type"; "GST Group Type")
                {
                    Visible = false;
                }

                field("HSN/SAC Code"; "HSN/SAC Code")
                {
                    Visible = false;
                }
                field("Invoice Type"; "Invoice Type")
                {
                    Visible = false;
                }
                field(Exempted; Exempted)
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }

                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }

            }
            group(Control58585)
            {
                group(Action5689)
                {
                    field("Invoice Discount Amount"; TotalSalesLine."Inv. Discount Amount")
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionML = ENU = 'Invoice Discount Amount',
                                    ENN = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;

                        trigger OnValidate();
                        begin
                            SalesHeader.GET("Document Type", "Document No.");
                            SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalSalesLine."Inv. Discount Amount", SalesHeader);
                            CurrPage.UPDATE(FALSE);
                        end;
                    }
                    field("Invoice Disc. Pct."; SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec))
                    {
                        CaptionML = ENU = 'Invoice Discount %',
                                    ENN = 'Invoice Discount %';
                        DecimalPlaces = 0 : 2;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        Visible = true;
                    }
                }
                group(Action89875)
                {
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(SalesHeader."Currency Code");
                        CaptionML = ENU = 'Total Amount Excl. VAT',
                                    ENN = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        Visible = false;
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(SalesHeader."Currency Code");
                        CaptionML = ENU = 'Total VAT',
                                    ENN = 'Total VAT';
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        Visible = false;
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                        CaptionML = ENU = 'Total Amount Incl. VAT',
                                    ENN = 'Total Amount Incl. VAT';
                        Editable = false;
                        StyleExpr = TotalAmountStyle;
                        Visible = false;
                    }
                    field(RefreshTotals; RefreshMessageText)
                    {
                        DrillDown = true;
                        Editable = false;
                        Enabled = RefreshMessageEnabled;
                        ShowCaption = false;

                        trigger OnDrillDown();
                        begin
                            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
                            DocumentTotals.SalesUpdateTotalsControls(
                              Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
                              TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, CurrPage.EDITABLE, VATAmount);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ENN = 'F&unctions';
                Image = "Action";
                action("E&xplode BOM")
                {
                    AccessByPermission = TableData 90 = R;
                    CaptionML = ENU = 'E&xplode BOM',
                                ENN = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction();
                    begin
                        ExplodeBOM;
                    end;
                }
                action("Insert &Ext. Texts")
                {
                    AccessByPermission = TableData 279 = R;
                    CaptionML = ENU = 'Insert &Ext. Texts',
                                ENN = 'Insert &Ext. Texts';
                    Image = Text;

                    trigger OnAction();
                    begin
                        InsertExtendedText(TRUE);
                    end;
                }
                action("Get Return &Receipt Lines")
                {
                    AccessByPermission = TableData 6660 = R;
                    CaptionML = ENU = 'Get Return &Receipt Lines',
                                ENN = 'Get Return &Receipt Lines';
                    Ellipsis = true;
                    Image = ReturnReceipt;

                    trigger OnAction();
                    begin
                        GetReturnReceipt;
                    end;
                }
            }
            group("&Line")
            {
                CaptionML = ENU = '&Line',
                            ENN = '&Line';
                Image = Line;
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
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU = 'Period',
                                    ENN = 'Period';
                        Image = Period;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU = 'Variant',
                                    ENN = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByVariant)
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
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU = 'BOM Level',
                                    ENN = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
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
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction();
                    begin
                        ShowLineComments;
                    end;
                }
                action("Item Charge &Assignment")
                {
                    AccessByPermission = TableData 5800 = R;
                    CaptionML = ENU = 'Item Charge &Assignment',
                                ENN = 'Item Charge &Assignment';
                    Image = ItemCosts;

                    trigger OnAction();
                    begin
                        ItemChargeAssgnt;
                    end;
                }
                action(ItemTrackingLines)
                {
                    CaptionML = ENU = 'Item &Tracking Lines',
                                ENN = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction();
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action(DeferralSchedule)
                {
                    CaptionML = ENU = 'Deferral Schedule',
                                ENN = 'Deferral Schedule';
                    Enabled = "Deferral Code" <> '';
                    Image = PaymentPeriod;

                    trigger OnAction();
                    begin
                        SalesHeader.GET("Document Type", "Document No.");
                        ShowDeferrals(SalesHeader."Posting Date", SalesHeader."Currency Code");
                    end;
                }
                action("Struct&ure Details")
                {
                    CaptionML = ENU = 'Struct&ure Details',
                                ENN = 'Struct&ure Details';
                    Image = Hierarchy;

                    trigger OnAction();
                    begin
                        // This functionality was copied from page #44. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowStrDetailsForm;

                    end;
                }
                action("Excise Detail")
                {
                    CaptionML = ENU = 'Excise Detail',
                                ENN = 'Excise Detail';
                    Image = Excise;

                    trigger OnAction();
                    begin
                        // This functionality was copied from page #44. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        //ShowExcisePostingSetup;

                    end;
                }
                action("Detailed Tax")
                {
                    CaptionML = ENU = 'Detailed Tax',
                                ENN = 'Detailed Tax';
                    Image = TaxDetail;

                    trigger OnAction();
                    begin
                        // This functionality was copied from page #44. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _ShowDetailedTaxEntryBuffer;

                    end;
                }
                action("Detailed GST")
                {
                    CaptionML = ENU = 'Detailed GST',
                                ENN = 'Detailed GST';
                    Image = ServiceTax;
                    RunObject = Page 18390;
                    RunPageLink = "Transaction Type" = FILTER(Sales),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("Document No."),
                                  "Line No." = FIELD("Line No.");

                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        IF SalesHeader.GET("Document Type", "Document No.") THEN;

        DocumentTotals.SalesUpdateTotalsControls(
          Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, CurrPage.EDITABLE, VATAmount);

        //TypeChosen := HasTypeToFillMandatotyFields;
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        CLEAR(DocumentTotals);
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
            COMMIT;
            IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
                EXIT(FALSE);
            ReserveSalesLine.DeleteLine(Rec);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        InitType;
        CLEAR(ShortcutDimCode);
    end;

    var
        SalesHeader: Record 36;
        TotalSalesHeader: Record 36;
        TotalSalesLine: Record 37;
        TransferExtendedText: Codeunit 378;
        ItemAvailFormsMgt: Codeunit 353;
        SalesCalcDiscByType: Codeunit 56;
        DocumentTotals: Codeunit 57;
        VATAmount: Decimal;
        ShortcutDimCode: array[8] of Code[20];
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        TypeChosen: Boolean;
        ItemCodeVisible: Boolean;

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    local procedure ExplodeBOM();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    local procedure GetReturnReceipt();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Get Return Receipts", Rec);
    end;

    local procedure InsertExtendedText(Unconditionally: Boolean);
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    end;

    local procedure OpenItemTrackingLines();
    begin
        OpenItemTrackingLines;
    end;

    local procedure ItemChargeAssgnt();
    begin
        ShowItemChargeAssgnt;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    local procedure NoOnAfterValidate();
    begin
        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    end;

    local procedure CrossReferenceNoOnAfterValidat();
    begin
        InsertExtendedText(FALSE);
    end;

    local procedure ReserveOnAfterValidate();
    begin
        IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
        END;
    end;

    local procedure QuantityOnAfterValidate();
    begin
        IF Reserve = Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
        END;
    end;

    local procedure UnitofMeasureCodeOnAfterValida();
    begin
        IF Reserve = Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
        END;
    end;

    local procedure RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD;

        SalesHeader.GET("Document Type", "Document No.");
        IF DocumentTotals.SalesCheckNumberOfLinesLimit(SalesHeader) THEN
            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.UPDATE;
    end;

    procedure ShowStrDetailsForm();
    var
    //StrOrderLineDetails : Record 13795;
    //StrOrderLineDetailsForm : Page 16306;
    begin
        /*
        StrOrderLineDetails.RESET;
        StrOrderLineDetails.SETCURRENTKEY("Document Type","Document No.",Type);
        StrOrderLineDetails.SETRANGE("Document Type","Document Type");
        StrOrderLineDetails.SETRANGE("Document No.","Document No.");
        StrOrderLineDetails.SETRANGE(Type,StrOrderLineDetails.Type::Sale);
        StrOrderLineDetails.SETRANGE("Item No.","No.");
        StrOrderLineDetails.SETRANGE("Line No.","Line No.");
        StrOrderLineDetailsForm.SETTABLEVIEW(StrOrderLineDetails);
        StrOrderLineDetailsForm.RUNMODAL;
        */
    end;

    // procedure ShowStrOrderDetailsPITForm();
    // begin
    //     ShowStrOrderDetailsPIT;
    // end;

    // procedure ShowExcisePostingSetup();
    // begin
    //     GetExcisePostingSetup;
    // end;

    procedure _ShowDetailedTaxEntryBuffer();
    var
    //DetailedTaxEntryBuffer : Record 16480;
    begin
        /*
        DetailedTaxEntryBuffer.RESET;
        DetailedTaxEntryBuffer.SETCURRENTKEY("Transaction Type","Document Type","Document No.","Line No.");
        DetailedTaxEntryBuffer.SETRANGE("Transaction Type",DetailedTaxEntryBuffer."Transaction Type"::Sale);
        DetailedTaxEntryBuffer.SETRANGE("Document Type","Document Type");
        DetailedTaxEntryBuffer.SETRANGE("Document No.","Document No.");
        DetailedTaxEntryBuffer.SETRANGE("Line No.","Line No.");
        PAGE.RUNMODAL(PAGE::"Sale Detailed Tax",DetailedTaxEntryBuffer);
        */
    end;

    procedure ShowDetailedTaxEntryBuffer();
    var
    //DetailedTaxEntryBuffer : Record "16480";
    begin
        /*
        DetailedTaxEntryBuffer.RESET;
        DetailedTaxEntryBuffer.SETCURRENTKEY("Transaction Type","Document Type","Document No.","Line No.");
        DetailedTaxEntryBuffer.SETRANGE("Transaction Type",DetailedTaxEntryBuffer."Transaction Type"::Sale);
        DetailedTaxEntryBuffer.SETRANGE("Document Type","Document Type");
        DetailedTaxEntryBuffer.SETRANGE("Document No.","Document No.");
        DetailedTaxEntryBuffer.SETRANGE("Line No.","Line No.");
        PAGE.RUNMODAL(PAGE::"Sale Detailed Tax",DetailedTaxEntryBuffer);
        */
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;
}

