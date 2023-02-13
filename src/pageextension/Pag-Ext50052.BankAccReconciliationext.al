pageextension 50052 "Bank_Acc_Reconciliation_ext" extends "Bank Acc. Reconciliation"
{
    // version NAVW19.00.00.45778,CCIT-PRI-BankReco,CCIT-Fortune

    actions
    {
        modify(All)
        {
            Visible = false;
        }
        addafter(ImportBankStatement)
        {
            action(ImportBankStatementFromCSV)
            {
                Image = Bank;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    CLEAR(xml1);// rdk260719
                    xml1.getdata(Rec);
                    xml1.RUN;
                end;
            }
            action(BankRecoReport)
            {
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ApplicationArea = all;

                trigger OnAction();
                var
                    BankRecoStmt: Report 50001;
                begin
                    // CCIT-PRI
                    //BankRecoStmt.GetParameter("Bank Account No.","Statement Date");
                    BankRecoStmt.RUN;
                    //
                end;
            }
        }
        addafter(RemoveMatch)
        {
            action("Match-MultiBankLines")
            {
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    TempBankAccReconciliationLine: Record 274 temporary;
                    TempBankAccountLedgerEntry: Record 271 temporary;
                    MatchBankRecLines: Codeunit 1252;
                begin
                    CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                    CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                    //MatchBankRecLines.MatchManually_MultiBankLines(TempBankAccReconciliationLine, TempBankAccountLedgerEntry); //PCPL/MIG/NSW
                end;
            }
            action("Remove-MultiBankLines")
            {
                Image = RemoveContacts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    TempBankAccReconciliationLine: Record 274 temporary;
                    TempBankAccountLedgerEntry: Record 271 temporary;
                    MatchBankRecLines: Codeunit 1252;
                begin
                    CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                    CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                    // MatchBankRecLines.RemoveMatch_MultiBankLines(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);//PCPL/MIG/NSW
                end;
            }
        }
    }

    var
        xml1: XMLport 50003;

    //Unsupported feature: PropertyChange. Please convert manually.

}

