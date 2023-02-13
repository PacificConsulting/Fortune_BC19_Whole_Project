page 50056 "Acc. Receivables Adm. RC-Store"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    CaptionML = ENU = 'Role Center',
                ENN = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control001)
            {
                part(Rol; 9034)
                {
                }
            }
            group(Control1002)
            {
                part(Control1003; 9150)
                {
                }
                part(Control1004; 9152)
                {
                    Visible = false;
                }
                part(Control1005; 681)
                {
                }
                part(Control1006; 675)
                {
                    Visible = false;
                }
                part(Control1007; 9175)
                {
                    Visible = false;
                }
                systempart(Control1008; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Sales Register Invioce&CR-EX1")
            {
                Caption = 'Sales Register Invioce&CR-EX1';
                Image = "Report";
                //RunObject = Report 50058;
            }
            action("Stock Ageing Report-Excel")
            {
                Caption = 'Stock Ageing Report-Excel';
                Image = "Report";
                RunObject = Report 50023;
            }
            action("Open Sales & Transfer List-Exc")
            {
                Caption = 'Open Sales & Transfer List-Exc';
                Image = "report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50005;
            }
            action("Purchase GRN Register")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50020;
            }
            action("Transfer GRN Register")
            {
                Image = "report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50073;
            }
            action("Inventory Planning - Branch")
            {
                Caption = 'Inventory Planning - Branch';
                Image = "Report";
                RunObject = Report 50036;
            }
            action("Customer Month-on-Month Excel")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50092;
            }
            action("Item Month-on-Month Excel")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50087;
            }
            action("Batch-wise Sale Register")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                //RunObject = Report 50064;
            }
            group("Fortune Reports")
            {
                Caption = 'Fortune Reports';
                Visible = false;
                action("MA-Customer")
                {
                    Caption = 'MA-Customer';
                    Image = "Report";
                    RunObject = Report 50089;
                }
                action("MA-Product")
                {
                    Caption = 'MA-Product';
                    Image = "Report";
                    RunObject = Report 50039;
                }
                action("C&ustomer - List")
                {
                    CaptionML = ENU = 'C&ustomer - List',
                                ENN = 'C&ustomer - List';
                    Image = "Report";
                    RunObject = Report 101;
                }
                action("Customer - &Balance to Date")
                {
                    CaptionML = ENU = 'Customer - &Balance to Date',
                                ENN = 'Customer - &Balance to Date';
                    Image = "Report";
                    RunObject = Report 121;
                }
                action("Aged &Accounts Receivable")
                {
                    CaptionML = ENU = 'Aged &Accounts Receivable',
                                ENN = 'Aged &Accounts Receivable';
                    Image = "Report";
                    RunObject = Report 120;
                }
                action("Customer - &Summary Aging Simp.")
                {
                    CaptionML = ENU = 'Customer - &Summary Aging Simp.',
                                ENN = 'Customer - &Summary Aging Simp.';
                    Image = "Report";
                    RunObject = Report 109;
                }
                action("Customer - Trial Balan&ce")
                {
                    CaptionML = ENU = 'Customer - Trial Balan&ce',
                                ENN = 'Customer - Trial Balan&ce';
                    Image = "Report";
                    RunObject = Report 129;
                }
                action("<Report Customer - Det.trial Bal")
                {
                    Caption = 'Customer - Det.trial Bal';
                    Image = "Report";
                    RunObject = Report 104;
                }
                action("Cus&tomer/Item Sales")
                {
                    CaptionML = ENU = 'Cus&tomer/Item Sales',
                                ENN = 'Cus&tomer/Item Sales';
                    Image = "Report";
                    RunObject = Report 113;
                }
                separator(Control1100)
                {
                }
                action("Customer &Document Nos.")
                {
                    CaptionML = ENU = 'Customer &Document Nos.',
                                ENN = 'Customer &Document Nos.';
                    Image = "Report";
                    RunObject = Report 128;
                }
                action("Sales &Invoice Nos.")
                {
                    CaptionML = ENU = 'Sales &Invoice Nos.',
                                ENN = 'Sales &Invoice Nos.';
                    Image = "Report";
                    RunObject = Report 124;
                }
                action("Sa&les Credit Memo Nos.")
                {
                    CaptionML = ENU = 'Sa&les Credit Memo Nos.',
                                ENN = 'Sa&les Credit Memo Nos.';
                    Image = "Report";
                    RunObject = Report "Sales Credit Memo Nos.";
                }
                separator(Control1109)
                {
                }
                action("Daily Stock Account")
                {
                    CaptionML = ENU = 'Daily Stock Account',
                                ENN = 'Daily Stock Account';
                    Image = "Report";
                    // RunObject = Report 13710;
                }
                action("Sample Register")
                {
                    CaptionML = ENU = 'Sample Register',
                                ENN = 'Sample Register';
                    Image = "Report";
                    //RunObject = Report 16578;
                }
                separator(Control1200)
                {
                }
                action(Ledgers)
                {
                    CaptionML = ENU = 'Ledgers',
                                ENN = 'Ledgers';
                    Image = "Report";
                    // RunObject = Report 16563;
                }
                action("Voucher Register")
                {
                    CaptionML = ENU = 'Voucher Register',
                                ENN = 'Voucher Register';
                    Image = "Report";
                    //RunObject = Report 16564;
                }
                action("Day Book")
                {
                    CaptionML = ENU = 'Day Book',
                                ENN = 'Day Book';
                    Image = "Report";
                    //RunObject = Report 16562;
                }
                action("Cash Book")
                {
                    CaptionML = ENU = 'Cash Book',
                                ENN = 'Cash Book';
                    Image = "Report";
                    //RunObject = Report 16565;
                }
                separator(Control1330)
                {
                }
                action("Bank Book")
                {
                    CaptionML = ENU = 'Bank Book',
                                ENN = 'Bank Book';
                    Image = "Report";
                    RunObject = Report "Bank Book";
                }
                action("Sales Book VAT")
                {
                    CaptionML = ENU = 'Sales Book VAT',
                                ENN = 'Sales Book VAT';
                    Image = "Report";
                    // RunObject = Report 16539;
                }
            }
            separator(Control1090)
            {
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                CaptionML = ENU = 'Customers',
                            ENN = 'Customers';
                Image = Customer;
                RunObject = Page 22;
            }
            action(CustomersBalance)
            {
                CaptionML = ENU = 'Balance',
                            ENN = 'Balance';
                Image = Balance;
                RunObject = Page 22;
                RunPageView = WHERE("Balance" = FILTER(<> 0));
            }
            action("Sales Orders")
            {
                CaptionML = ENU = 'Sales Orders',
                            ENN = 'Sales Orders';
                Image = "Order";
                RunObject = Page 9305;
            }
            action("Sales Invoices")
            {
                CaptionML = ENU = 'Sales Invoices',
                            ENN = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page 9301;
            }
            action("Sales Return Orders")
            {
                CaptionML = ENU = 'Sales Return Orders',
                            ENN = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page 9304;
            }
            action("Sales Credit Memos")
            {
                Caption = 'Sales Credit Memos';
                Image = Page;
                RunObject = Page 9302;
            }
            action("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                Image = Page;
                RunObject = Page 5742;
            }
            action("Purchase Orders")
            {
                CaptionML = ENU = 'Purchase Orders',
                            ENN = 'Purchase Orders';
                RunObject = Page 9307;
            }
            action("Purchase Return Order List")
            {
                RunObject = Page 9311;
            }
            action("Bank Accounts")
            {
                CaptionML = ENU = 'Bank Accounts',
                            ENN = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page 371;
            }
            action(Items)
            {
                CaptionML = ENU = 'Items',
                            ENN = 'Items';
                Image = Item;
                RunObject = Page 31;
            }
            action(SalesJournals)
            {
                CaptionML = ENU = 'Sales Journals',
                            ENN = 'Sales Journals';
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST(Sales),
                                    Recurring = CONST(false));
            }
            action(CashReceiptJournals)
            {
                CaptionML = ENU = 'Cash Receipt Journals',
                            ENN = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                    Recurring = CONST(false));
            }
            action("Cash Receipt Voucher")
            {
                CaptionML = ENU = 'Cash Receipt Voucher',
                            ENN = 'Cash Receipt Voucher';
                Image = Journals;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST("General"),
                                    // "Sub Type" = CONST("Cash Receipt Voucher"),
                                    Recurring = CONST(false));
            }
            action("Bank Receipt Voucher")
            {
                CaptionML = ENU = 'Bank Receipt Voucher',
                            ENN = 'Bank Receipt Voucher';
                Image = Journals;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST(General),
                                    // Sub Type=CONST(Bank Receipt Voucher),
                                    Recurring = CONST(false));
            }
            action("Cash payment Voucher")
            {
                Image = Page;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST(General),
                                    //"Sub Type" = CONST("Cash Payment Voucher"),
                                    Recurring = CONST(false));
            }
            action("Journal Voucher")
            {
                CaptionML = ENU = 'Journal Voucher',
                            ENN = 'Journal Voucher';
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST(General),
                                    //Sub Type=CONST(Journal Voucher),
                                    Recurring = CONST(false));
            }
            action(GeneralJournals)
            {
                CaptionML = ENU = 'General Journals',
                            ENN = 'General Journals';
                Image = Journal;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST(General),
                                    Recurring = CONST(false));
            }
            action("Contra Entries")
            {
                Image = Journal;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST(General),
                                    Recurring = CONST(False));
                // "Sub Type" = CONST("Contra Voucher"));
            }
            action("Direct Debit Collections")
            {
                CaptionML = ENU = 'Direct Debit Collections',
                            ENN = 'Direct Debit Collections';
                RunObject = Page 1207;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                CaptionML = ENU = 'Posted Documents',
                            ENN = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    CaptionML = ENU = 'Posted Sales Shipments',
                                ENN = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page 142;
                }
                action("Posted Sales Invoices")
                {
                    CaptionML = ENU = 'Posted Sales Invoices',
                                ENN = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page 143;
                }
                action("Posted Return Receipts")
                {
                    CaptionML = ENU = 'Posted Return Receipts',
                                ENN = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page 6662;
                }
                action("Posted Sales Credit Memos")
                {
                    CaptionML = ENU = 'Posted Sales Credit Memos',
                                ENN = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page 144;
                }
                action("Posted Purchase Receipts")
                {
                    RunObject = Page 145;
                }
                action("Posted Purchase Invoices")
                {
                    RunObject = Page 146;
                }
                action("Page Posted Purchase Credit Memo")
                {
                    CaptionML = ENU = 'Posted Purchase Credit Memos',
                                ENN = 'Posted Purchase Credit Memos';
                    RunObject = Page 147;
                }
                action("Posted Transfer Shipments")
                {
                    RunObject = Page 5752;
                }
                action("Posted Transfer Receipts")
                {
                    RunObject = Page 5753;
                }
                action("General ledger Entries")
                {
                    Caption = 'General ledger Entries';
                    RunObject = Page 20;
                }
                action("Bank Account List")
                {
                    Caption = 'Bank Account List';
                    RunObject = Page 371;
                }
            }
        }
        area(processing)
        {
            separator(New)
            {
                CaptionML = ENU = 'New',
                            ENN = 'New';
                IsHeader = true;
            }
            action("C&ustomer")
            {
                CaptionML = ENU = 'C&ustomer',
                            ENN = 'C&ustomer';
                Image = Customer;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 21;
                RunPageMode = Create;
            }
            group("&Sales")
            {
                CaptionML = ENU = '&Sales',
                            ENN = '&Sales';
                Image = Sales;
                action("Sales &Order")
                {
                    CaptionML = ENU = 'Sales &Order',
                                ENN = 'Sales &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 42;
                    RunPageMode = Create;
                }
                action("Sales &Invoice")
                {
                    CaptionML = ENU = 'Sales &Invoice',
                                ENN = 'Sales &Invoice';
                    Image = Invoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 43;
                    RunPageMode = Create;
                }
                action("Sales &Credit Memo")
                {
                    CaptionML = ENU = 'Sales &Credit Memo',
                                ENN = 'Sales &Credit Memo';
                    Image = CreditMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 44;
                    RunPageMode = Create;
                }
            }
            separator(Tasks)
            {
                CaptionML = ENU = 'Tasks',
                            ENN = 'Tasks';
                IsHeader = true;
            }
            action("Cash Receipt &Journal")
            {
                CaptionML = ENU = 'Cash Receipt &Journal',
                            ENN = 'Cash Receipt &Journal';
                Image = CashReceiptJournal;
                RunObject = Page 255;
            }
            separator(Tasks1)
            {
            }
            separator(Administration)
            {
                CaptionML = ENU = 'Administration',
                            ENN = 'Administration';
                IsHeader = true;
            }
            separator(History)
            {
                CaptionML = ENU = 'History',
                            ENN = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                CaptionML = ENU = 'Navi&gate',
                            ENN = 'Navi&gate';
                Image = Navigate;
                RunObject = Page 344;
            }
        }
    }
}

