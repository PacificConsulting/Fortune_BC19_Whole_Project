pageextension 50048 "Posted_Purchase_Invoices_ext" extends "Posted Purchase Invoices"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
        }
        addafter("Buy-from Post Code")
        {

            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Pay-to Vendor No.")
        {
            field("Pre-Assigned No."; "Pre-Assigned No.")
            {
                CaptionML = ENU = 'Punched Purchase Invioce No.',
                            ENN = 'Pre-Assigned No.';
                ApplicationArea = all;
            }
        }
        addafter("Currency Code")
        {
            field("TDS Amount"; "TDS Amount")
            {
                ApplicationArea = all;
            }
            field("GST Amount"; "GST Amount")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addafter(Dimensions)
        {
            action("Print Voucher")
            {
                CaptionML = ENU = 'Print Voucher',
                            ENN = 'Print Voucher';
                Ellipsis = true;
                Image = PrintVoucher;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    GLEntry: Record 17;
                begin

                    RecGLEntry.RESET;
                    RecGLEntry.SETRANGE(RecGLEntry."Document No.", "No.");
                    REPORT.RUNMODAL(16567, TRUE, FALSE, RecGLEntry);
                end;
            }
        }
    }

    var
        RecGLEntry: Record 17;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];



}

