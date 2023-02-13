page 50074 "Vend LE"
{
    // version TFS225977

    CaptionML = ENU = 'Vendor Ledger Entries',
                ENN = 'Vendor Ledger Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = true;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData 25 = rimd;
    SourceTable = "Vendor Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Message to Recipient"; "Message to Recipient")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Reference"; "Payment Reference")
                {
                    ApplicationArea = All;
                }
                field("Creditor No."; "Creditor No.")
                {
                    ApplicationArea = All;
                }
                field("Original Amount"; "Original Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Original Amt. (LCY)"; "Original Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amt. (LCY)"; "Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Bill of Entry Date"; "Bill of Entry Date")
                {
                    ApplicationArea = All;
                }
                field("Bill of Entry No"; "Bill of Entry No")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Disc. Tolerance Date"; "Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = All;
                }
                field("Original Pmt. Disc. Possible"; "Original Pmt. Disc. Possible")
                {
                    ApplicationArea = All;
                }
                field("Remaining Pmt. Disc. Possible"; "Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = All;
                }
                field("Max. Payment Tolerance"; "Max. Payment Tolerance")
                {
                    ApplicationArea = All;
                }
                field(Open; Open)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("On Hold"; "On Hold")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Reversed by Entry No."; "Reversed by Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Reversed Entry No."; "Reversed Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Exported to Payment File"; "Exported to Payment File")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("GST on Advance Payment"; "GST on Advance Payment")
                {
                    ApplicationArea = All;
                }
                field("GST Group Code"; "GST Group Code")
                {
                    ApplicationArea = All;
                }
                field("HSN/SAC Code"; "HSN/SAC Code")
                {
                    ApplicationArea = All;
                }
                field("GST Reverse Charge"; "GST Reverse Charge")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; 193)
            {
                ShowFilter = false;
            }
            systempart(Control09; Links)
            {
                Visible = false;
            }
            systempart(Control110; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                CaptionML = ENU = 'Ent&ry',
                            ENN = 'Ent&ry';
                Image = Entry;
                action("Applied E&ntries")
                {
                    CaptionML = ENU = 'Applied E&ntries',
                                ENN = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page 62;
                    RunPageOnRec = true;
                    Scope = Repeater;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    CaptionML = ENU = 'Detailed &Ledger Entries',
                                ENN = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page 574;
                    RunPageLink = "Vendor Ledger Entry No." = FIELD("Entry No."),
                                  "Vendor No." = FIELD("Vendor No.");
                    RunPageView = SORTING("Vendor Ledger Entry No.", "Posting Date");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                }
                // action(Narration)
                // {
                //     CaptionML = ENU = 'Narration',
                //                 ENN = 'Narration';
                //     Image = Description;
                //     RunObject = Page 16578;
                //     RunPageLink = "Entry No." = FILTER(0),
                //                   "Transaction No." = FIELD("Transaction No.");
                // }
                // action("Line Narration")
                // {
                //     CaptionML = ENU = 'Line Narration',
                //                 ENN = 'Line Narration';
                //     Image = LineDescription;
                //     RunObject = Page 16578;
                //     RunPageLink = "Entry No." = FIELD("Entry No."),
                //     "Transaction No." = FIELD("Transaction No.");
                // }
                action("Print Voucher")
                {
                    CaptionML = ENU = 'Print Voucher',
                                ENN = 'Print Voucher';
                    Ellipsis = true;
                    Image = PrintVoucher;

                    trigger OnAction();
                    var
                        GLEntry: Record 17;
                    begin
                        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                        GLEntry.SETRANGE("Document No.", "Document No.");
                        GLEntry.SETRANGE("Posting Date", "Posting Date");
                        IF GLEntry.FIND('-') THEN;
                        //  REPORT.RUNMODAL(REPORT::"Posted Voucher 4", TRUE, TRUE, GLEntry);
                    end;
                }
                action("Print GST Voucher")
                {
                    CaptionML = ENU = 'Print GST Voucher',
                                ENN = 'Print Voucher';
                    Ellipsis = true;
                    Image = PrintVoucher;

                    trigger OnAction();
                    var
                        VendorLedgerEntry: Record 25;
                    begin
                        VendorLedgerEntry.RESET;
                        VendorLedgerEntry.SETFILTER("Document Type", '%1|%2', VendorLedgerEntry."Document Type"::Payment,
                          VendorLedgerEntry."Document Type"::Refund);
                        VendorLedgerEntry.SETRANGE("Document No.", "Document No.");
                        REPORT.RUNMODAL(16412, TRUE, TRUE, VendorLedgerEntry);
                    end;
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
                action(ActionApplyEntries)
                {
                    CaptionML = ENU = 'Apply Entries',
                                ENN = 'Apply Entries';
                    Image = ApplyEntries;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction();
                    var
                        VendLedgEntry: Record 25;
                        VendEntryApplyPostEntries: Codeunit 227;
                    begin
                        VendLedgEntry.COPY(Rec);
                        VendEntryApplyPostEntries.ApplyVendEntryFormEntry(VendLedgEntry);
                        Rec := VendLedgEntry;
                        CurrPage.UPDATE;
                    end;
                }
                separator(Control111)
                {
                }
                action(UnapplyEntries)
                {
                    CaptionML = ENU = 'Unapply Entries',
                                ENN = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;
                    Scope = Repeater;

                    trigger OnAction();
                    var
                        VendEntryApplyPostedEntries: Codeunit 227;
                    begin
                        VendEntryApplyPostedEntries.UnApplyVendLedgEntry("Entry No.");
                    end;
                }
                separator(Control1112)
                {
                }
                action(ReverseTransaction)
                {
                    CaptionML = ENU = 'Reverse Transaction',
                                ENN = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;

                    trigger OnAction();
                    var
                        ReversalEntry: Record 179;
                    begin
                        CLEAR(ReversalEntry);
                        IF Reversed THEN
                            ReversalEntry.AlreadyReversedEntry(TABLECAPTION, "Entry No.");
                        IF "Journal Batch Name" = '' THEN
                            ReversalEntry.TestFieldError;
                        TESTFIELD("Transaction No.");
                        ReversalEntry.ReverseTransaction("Transaction No.");
                    end;
                }
                group(IncomingDocument)
                {
                    CaptionML = ENU = 'Incoming Document',
                                ENN = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        CaptionML = ENU = 'View Incoming Document',
                                    ENN = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTipML =;

                        trigger OnAction();
                        var
                            IncomingDocument: Record 130;
                        begin
                            IncomingDocument.ShowCard("Document No.", "Posting Date");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData 130 = R;
                        CaptionML = ENU = 'Select Incoming Document',
                                    ENN = 'Select Incoming Document';
                        Enabled = NOT HasIncomingDocument;
                        Image = SelectLineToApply;
                        ToolTipML =;

                        trigger OnAction();
                        var
                            IncomingDocument: Record 130;
                        begin
                            //IncomingDocument.SelectIncomingDocumentForPostedDocument("Document No.", "Posting Date");
                            //IncomingDocument.SelectIncomingDocumentForPostedDocument("Document No.", "Posting Date", Rec);
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        CaptionML = ENU = 'Create Incoming Document from File',
                                    ENN = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = NOT HasIncomingDocument;
                        Image = Attach;
                        ToolTipML =;

                        trigger OnAction();
                        var
                            IncomingDocumentAttachment: Record 133;
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPostedDocument("Document No.", "Posting Date");
                        end;
                    }
                }
            }
            action("&Navigate")
            {
                CaptionML = ENU = '&Navigate',
                            ENN = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;

                trigger OnAction();
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
            action("Show Posted Document")
            {
                CaptionML = ENU = 'Show Posted Document',
                            ENN = 'Show Posted Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction();
                begin
                    ShowDoc
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    var
        IncomingDocument: Record 130;
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists("Document No.", "Posting Date");
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord();
    begin
        StyleTxt := SetStyle;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        //CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
        //EXIT(FALSE);
    end;

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
        HasIncomingDocument: Boolean;
}

