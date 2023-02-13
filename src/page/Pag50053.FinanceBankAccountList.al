page 50053 "Finance Bank Account List"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    CaptionML = ENU = 'Bank Account List',
                ENN = 'Bank Account List';
    CardPageID = "Finance Bank Account Card";
    Editable = false;
    PageType = List;
    SourceTable = "Bank Account";

    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("SWIFT Code"; "SWIFT Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(IBAN; IBAN)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Our Contact Code"; "Our Contact Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bank Acc. Posting Group"; "Bank Acc. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(FIN; 9083)
            {
                SubPageLink = "Table ID" = CONST(270),
                              "No." = FIELD("No.");
                Visible = false;
            }
            systempart(Sys1; Links)
            {
                Visible = false;
            }
            systempart(Sys2; Notes)
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
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Bank Account"),
                                  "No." = FIELD("No.");
                }
                action(PositivePayExport)
                {
                    CaptionML = ENU = 'Positive Pay Export',
                                ENN = 'Positive Pay Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Positive Pay Export";
                    RunPageLink = "No." = FIELD("No.");
                    Visible = false;
                }
                group(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        CaptionML = ENU = 'Dimensions-Single',
                                    ENN = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(270),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple',
                                    ENN = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction();
                        var
                            BankAcc: Record "Bank Account";
                            DefaultDimMultiple: Page 542;
                        begin
                            CurrPage.SETSELECTIONFILTER(BankAcc);
                            //DefaultDimMultiple.SetMultiBankAcc(BankAcc);

                            //DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action(Balance)
                {
                    CaptionML = ENU = 'Balance',
                                ENN = 'Balance';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bank Account Balance";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action(Statements)
                {
                    CaptionML = ENU = 'St&atements',
                                ENN = 'St&atements';
                    Image = List;
                    RunObject = Page "Bank Account Statement List";
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
                    RunObject = Page "Bank Account Ledger Entries";
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
                action(PagePosPayEntries)
                {
                    CaptionML = ENU = 'Positive Pay Entries',
                                ENN = 'Positive Pay Entries';
                    Image = CheckLedger;
                    RunObject = Page 1231;
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    Visible = false;
                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                CaptionML = ENU = 'Detail Trial Balance',
                            ENN = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 1404;
            }
            action("Check Details")
            {
                CaptionML = ENU = 'Check Details',
                            ENN = 'Check Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 1406;
            }
            action("Trial Balance by Period")
            {
                CaptionML = ENU = 'Trial Balance by Period',
                            ENN = 'Trial Balance by Period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 38;
            }
            action("Trial Balance")
            {
                CaptionML = ENU = 'Trial Balance',
                            ENN = 'Trial Balance';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 6;
            }
            action("Bank Book")
            {
                CaptionML = ENU = 'Bank Book',
                            ENN = 'Bank Book';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                //  RunObject = Report 16566;
            }
            action("Bank Account Statements")
            {
                CaptionML = ENU = 'Bank Account Statements',
                            ENN = 'Bank Account Statements';
                Image = "Report";
                RunObject = Report 1407;
                ToolTipML = ENU = 'View, print, or save statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.',
                            ENN = 'View, print, or save statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CALCFIELDS("Check Report Name");
    end;
}

