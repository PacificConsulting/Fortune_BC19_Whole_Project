page 50009 "Payment Entries"
{
    PageType = List;
    SourceTable = "G/L Entry";
    SourceTableView = WHERE("Source Type" = FILTER('Bank Account'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                CaptionML = ENU = '&Navigate',
                            ENN = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    Navigate: Page Navigate;

                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }

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
                    IF GLEntry.FINDFIRST THEN;
                    //PCPLVenkat
                    REPORT.RUNMODAL(REPORT::"Posted Voucher", TRUE, TRUE, GLEntry);
                end;
            }
        }
    }

    var
        GLEntry: Record 17;
}

