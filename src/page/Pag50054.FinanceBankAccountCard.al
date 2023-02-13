page 50054 "Finance Bank Account Card"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    CaptionML = ENU = 'Bank Account Card',
                ENN = 'Bank Account Card';
    PageType = Card;
    SourceTable = "Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            ENN = 'General';
                field("No."; "No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Visible = true;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Min. Balance"; "Min. Balance")
                {
                    ApplicationArea = All;
                }
                field("Our Contact Code"; "Our Contact Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication',
                            ENN = 'Communication';
                field("Phone No.2"; "Phone No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Home Page"; "Home Page")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                CaptionML = ENU = 'Posting',
                            ENN = 'Posting';
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Last Check No."; "Last Check No.")
                {
                    ApplicationArea = All;
                }
                field("Transit No."; "Transit No.")
                {
                    ApplicationArea = All;
                }
                field("Last Statement No."; "Last Statement No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Last Payment Statement No."; "Last Payment Statement No.")
                {
                    ApplicationArea = All;
                }
                field("Balance Last Statement"; "Balance Last Statement")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate();
                    begin
                        IF "Balance Last Statement" <> xRec."Balance Last Statement" THEN
                            IF NOT CONFIRM(Text001, FALSE, "No.") THEN
                                ERROR(Text002);
                    end;
                }
                field("Stale Cheque Stipulated Period"; "Stale Cheque Stipulated Period")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Stale Cheque Stipulated Period',
                                ENN = 'Stale Cheque Stipulated Period';
                }
                field("Bank Acc. Posting Group"; "Bank Acc. Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                group("Payment Match Tolerance")
                {

                    CaptionML = ENU = 'Payment Match Tolerance',
                                ENN = 'Payment Match Tolerance';
                    field("Match Tolerance Type"; "Match Tolerance Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Match Tolerance Value"; "Match Tolerance Value")
                    {
                        ApplicationArea = All;
                        DecimalPlaces = 0 : 2;
                    }
                }
            }
            group(Transfer)
            {
                CaptionML = ENU = 'Transfer',
                            ENN = 'Transfer';
                field("Bank Branch No.2"; "Bank Branch No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Bank Account No.2"; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Transit No.2"; "Transit No.")
                {
                    ApplicationArea = All;
                }
                field("SWIFT Code"; "SWIFT Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(IBAN; IBAN)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Bank Statement Import Format"; "Bank Statement Import Format")
                {
                    ApplicationArea = All;
                }
                field("Payment Export Format"; "Payment Export Format")
                {
                    ApplicationArea = All;
                }
                field("SEPA Direct Debit Exp. Format"; "SEPA Direct Debit Exp. Format")
                {
                    ApplicationArea = All;
                }
                field("Credit Transfer Msg. Nos."; "Credit Transfer Msg. Nos.")
                {
                    ApplicationArea = All;
                }
                field("Direct Debit Msg. Nos."; "Direct Debit Msg. Nos.")
                {
                    ApplicationArea = All;
                }
                field("Creditor No."; "Creditor No.")
                {
                    ApplicationArea = All;
                }
                // field("Bank Name - Data Conversion"; "Bank Name - Data Conversion")
                // {
                //     ApplicationArea = All;
                // }
                field("Bank Clearing Standard"; "Bank Clearing Standard")
                {
                    ApplicationArea = All;
                }
                field("Bank Clearing Code"; "Bank Clearing Code")
                {
                    ApplicationArea = All;
                }
                field("Positive Pay Export Code"; "Positive Pay Export Code")
                {
                    ApplicationArea = All;
                    LookupPageID = "Bank Export/Import Setup";
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(SYS1; Links)
            {
                Visible = false;
            }
            systempart(SYS2; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bank Acc.")
            {
                CaptionML = ENU = '&Bank Acc.',
                            ENN = '&Bank Acc.';
                Image = Bank;
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics',
                                ENN = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 375;
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Bank Account"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(270),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Balance)
                {
                    CaptionML = ENU = 'Balance',
                                ENN = 'Balance';
                    Image = Balance;
                    RunObject = Page 377;
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action(Statements)
                {
                    CaptionML = ENU = 'St&atements',
                                ENN = 'St&atements';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 389;
                    RunPageLink = "Bank Account No." = FIELD("No.");
                }
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries',
                                ENN = 'Ledger E&ntries';
                    Image = BankAccountLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 372;
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    RunPageView = SORTING("Bank Account No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Chec&k Ledger Entries")
                {
                    CaptionML = ENU = 'Chec&k Ledger Entries',
                                ENN = 'Chec&k Ledger Entries';
                    Image = CheckLedger;
                    RunObject = Page 374;
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    RunPageView = SORTING("Bank Account No.");
                }
                action("C&ontact")
                {
                    CaptionML = ENU = 'C&ontact',
                                ENN = 'C&ontact';
                    Image = ContactPerson;
                    Visible = ContactActionVisible;

                    trigger OnAction();
                    begin
                        ShowContact;
                    end;
                }
                action("LC Cr. Limit")
                {
                    CaptionML = ENU = 'LC Cr. Limit',
                                ENN = 'LC Cr. Limit';
                    Image = LimitedCredit;
                    // RunObject = Page 16314;
                    //RunPageLink = "Bank No." = FIELD("No.");
                }
                separator(FIN)
                {
                }
                action("Online Map")
                {
                    CaptionML = ENU = 'Online Map',
                                ENN = 'Online Map';
                    Image = Map;

                    trigger OnAction();
                    begin
                        DisplayMap;
                    end;
                }
                action(PagePositivePayEntries)
                {
                    CaptionML = ENU = 'Positive Pay Entries',
                                ENN = 'Positive Pay Entries';
                    Image = CheckLedger;
                    RunObject = Page 1231;
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    Visible = false;
                }
            }
            action(BankAccountReconciliations)
            {
                CaptionML = ENU = 'Bank Account Reconciliations',
                            ENN = 'Bank Account Reconciliations';
                Image = BankAccountRec;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 388;
                RunPageLink = "Bank Account No." = FIELD("No.");
                RunPageView = SORTING("Bank Account No.");
            }
            action("Receivables-Payables1")
            {
                CaptionML = ENU = 'Receivables-Payables',
                            ENN = 'Receivables-Payables';
                Image = ReceivablesPayables;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 355;
            }
        }
        area(processing)
        {
            action("Cash Receipt Journals")
            {
                CaptionML = ENU = 'Cash Receipt Journals',
                            ENN = 'Cash Receipt Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = Page 255;
            }
            action("Payment Journals")
            {
                CaptionML = ENU = 'Payment Journals',
                            ENN = 'Payment Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 256;
            }
            action(PagePosPayExport)
            {
                CaptionML = ENU = 'Positive Pay Export',
                            ENN = 'Positive Pay Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 1233;
                RunPageLink = "No." = FIELD("No.");
                Visible = false;
            }
        }
        area(reporting)
        {
            action(List)
            {
                CaptionML = ENU = 'List',
                            ENN = 'List';
                Image = OpportunitiesList;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 1402;
            }
            action("Detail Trial Balance")
            {
                CaptionML = ENU = 'Detail Trial Balance',
                            ENN = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 1404;
            }
            action("Receivables-Payables")
            {
                CaptionML = ENU = 'Receivables-Payables',
                            ENN = 'Receivables-Payables';
                Image = ReceivablesPayables;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 5;
            }
            action("Check Details")
            {
                CaptionML = ENU = 'Check Details',
                            ENN = 'Check Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 1406;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CALCFIELDS("Check Report Name");
    end;

    trigger OnInit();
    begin
        MapPointVisible := TRUE;
    end;

    trigger OnOpenPage();
    var
        Contact: Record Contact;
        MapMgt: Codeunit 802;
    begin
        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;
        ContactActionVisible := Contact.READPERMISSION;
    end;

    var
        [InDataSet]
        MapPointVisible: Boolean;
        Text001: TextConst ENU = 'There may be a statement using the %1.\\Do you want to change Balance Last Statement?', ENN = 'There may be a statement using the %1.\\Do you want to change Balance Last Statement?';
        Text002: TextConst ENU = 'Canceled.', ENN = 'Canceled.';
        [InDataSet]
        ContactActionVisible: Boolean;
}

