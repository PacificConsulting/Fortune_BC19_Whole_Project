page 50075 "DVLE"
{
    // version NAVW17.00

    CaptionML = ENU = 'Detailed Vendor Ledg. Entries',
                ENN = 'Detailed Vendor Ledg. Entries';
    DataCaptionFields = "Vendor Ledger Entry No.", "Vendor No.";
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData 380 = rimd;
    SourceTable = "Detailed Vendor Ledg. Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Initial Entry Global Dim. 1"; "Initial Entry Global Dim. 1")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Initial Entry Global Dim. 2"; "Initial Entry Global Dim. 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Initial Entry Due Date"; "Initial Entry Due Date")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
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
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Unapplied; Unapplied)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unapplied by Entry No."; "Unapplied by Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Vendor Ledger Entry No."; "Vendor Ledger Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Links)
            {
                Visible = false;
            }
            systempart(Control11; Notes)
            {
                Visible = false;
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
                action("Unapply Entries")
                {
                    CaptionML = ENU = 'Unapply Entries',
                                ENN = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;

                    trigger OnAction();
                    var
                        VendEntryApplyPostedEntries: Codeunit 227;
                    begin
                        VendEntryApplyPostedEntries.UnApplyDtldVendLedgEntry(Rec);
                    end;
                }
            }
            action("&Navigate")
            {
                CaptionML = ENU = '&Navigate',
                            ENN = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

