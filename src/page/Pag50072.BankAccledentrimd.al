page 50072 "Bank Acc.led ent-rimd"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621

    CaptionML = ENU = 'Bank Account Ledger Entries',
                ENN = 'Bank Account Ledger Entries';
    DataCaptionFields = "Bank Account No.";
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    PageType = List;
    Permissions = TableData 271 = rimd;
    SourceTable = "Bank Account Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Stale Cheque"; "Stale Cheque")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    ApplicationArea = All;
                }
                field("RTGS/NEFT"; "RTGS/NEFT")
                {
                    ApplicationArea = All;
                }
                field("Stale Cheque Expiry Date"; "Stale Cheque Expiry Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cheque Stale Date"; "Cheque Stale Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Statement Status"; "Statement Status")
                {
                    ApplicationArea = All;
                }
                field("Statement No."; "Statement No.")
                {
                    ApplicationArea = All;
                }
                field("Statement Line No."; "Statement Line No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Our Contact Code"; "Our Contact Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
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
                    Visible = false;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Balance Account Name"; "Balance Account Name")
                {
                    ApplicationArea = All;
                }
                field(Open; Open)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                // field("Location Code"; "Location Code")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control909; Links)
            {
                Visible = false;
            }
            systempart(Control910; Notes)
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
                action("Check Ledger E&ntries")
                {
                    CaptionML = ENU = 'Check Ledger E&ntries',
                                ENN = 'Check Ledger E&ntries';
                    Image = CheckLedger;
                    RunObject = Page 374;
                    // RunPageLink = "Bank Account Ledger Entry No." = FIELD("Entry No."");
                    //RunPageView = SORTING("Bank Account Ledger Entry No.");
                    //ShortCutKey = 'Shift+F7';
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
                action(Narration)
                {
                    CaptionML = ENU = 'Narration',
                                ENN = 'Narration';
                    Image = Description;
                    //     RunObject = Page 16578;
                    //     RunPageLink = "Entry No." = FILTER(0),
                    //                   "Transaction No." = FIELD("Transaction No.");
                    // 
                }
                action("Line Narration")
                {
                    CaptionML = ENU = 'Line Narration',
                                ENN = 'Line Narration';
                    Image = LineDescription;
                    // RunObject = Page 16578;
                    // RunPageLink = Entry No.=FIELD(Entry No.),
                    //               Transaction No.=FIELD(Transaction No.);
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
                        IF GLEntry.FIND('-') THEN
                            REPORT.RUNMODAL(REPORT::"Posted Voucher", TRUE, TRUE, GLEntry);
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
                action("Reverse Transaction")
                {
                    CaptionML = ENU = 'Reverse Transaction',
                                ENN = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;

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
                action("Stale Cheque")
                {
                    CaptionML = ENU = 'Stale Cheque',
                                ENN = 'Stale Cheque';
                    Image = StaleCheck;

                    trigger OnAction();
                    begin
                        IF "Stale Cheque" = FALSE THEN BEGIN
                            IF CONFIRM(
                                 Text16502, FALSE, "Cheque No.", "Bal. Account Type",
                                 "Bal. Account No.") THEN BEGIN
                                IF "Stale Cheque Expiry Date" >= WORKDATE THEN
                                    ERROR(Text16500, "Stale Cheque Expiry Date");
                                "Stale Cheque" := TRUE;
                                "Cheque Stale Date" := WORKDATE;
                                MODIFY;
                            END;
                        END
                        ELSE
                            MESSAGE(Text16501);
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
                var
                    Navigate: Page "Navigate";

                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        //23-04-2019 start rdk
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN BEGIN
            REPEAT
                //IF RecUserBranch."Location Code" <> '' THEN
                IF RecLoc.GET(RecUserBranch."Location Code") THEN
                    IF RecLoc."Branch Code" <> '' THEN
                        LocCode := LocCode + RecLoc."Branch Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
            IF STRLEN(LocCode) <> 0 THEN BEGIN
                LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
                IF LocCodeText <> '' THEN BEGIN
                    SETFILTER("Global Dimension 1 Code", LocCodeText);
                END;
                IF LocCodeText <> '' THEN
                    ClearHide := FALSE
                ELSE
                    ClearHide := TRUE;
            END;
        END;
        //24-04-2019 end
    end;

    var
        Navigate: Page "Navigate";
        Text16500: TextConst ENU = 'Bank Ledger Entry can be marked as stale only after %1. ', ENN = 'Bank Ledger Entry can be marked as stale only after %1. ';
        Text16501: TextConst ENU = 'The cheque has already been marked stale.', ENN = 'The cheque has already been marked stale.';
        Text16502: TextConst ENU = 'Financially stale check %1 to %2 %3', ENN = 'Financially stale check %1 to %2 %3';
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecLoc: Record 14;
}

