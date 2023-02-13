page 50076 "Bank Acc Stmt Lines"
{
    // version NAVW17.00

    AutoSplitKey = true;
    CaptionML = ENU = 'Lines',
                ENN = 'Lines';
    DelayedInsert = true;
    Editable = true;
    LinksAllowed = false;
    PageType = List;
    Permissions = TableData 276 = rimd;
    SourceTable = "Bank Account Statement Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Account No."; "Bank Account No.")
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
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Statement Amount"; "Statement Amount")
                {
                    ApplicationArea = All;
                }
                field(Difference; Difference)
                {
                    ApplicationArea = All;
                }
                field("Applied Amount"; "Applied Amount")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Applied Entries"; "Applied Entries")
                {
                    ApplicationArea = All;
                }
                field("Value Date"; "Value Date")
                {
                    ApplicationArea = All;
                }
                field("Check No."; "Check No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
        CalcBalance("Statement Line No.");
    end;

    trigger OnInit();
    begin
        BalanceEnable := TRUE;
        TotalBalanceEnable := TRUE;
        TotalDiffEnable := TRUE;
    end;

    var
        TotalDiff: Decimal;
        TotalBalance: Decimal;
        Balance: Decimal;
        [InDataSet]
        TotalDiffEnable: Boolean;
        [InDataSet]
        TotalBalanceEnable: Boolean;
        [InDataSet]
        BalanceEnable: Boolean;

    local procedure CalcBalance(BankAccStmtLineNo: Integer);
    var
        BankAccStmt: Record 275;
        TempBankAccStmtLine: Record 276;
    begin
        IF BankAccStmt.GET("Bank Account No.", "Statement No.") THEN;

        TempBankAccStmtLine.COPY(Rec);

        TotalDiff := -Difference;
        IF TempBankAccStmtLine.CALCSUMS(Difference) THEN BEGIN
            TotalDiff := TotalDiff + TempBankAccStmtLine.Difference;
            TotalDiffEnable := TRUE;
        END ELSE
            TotalDiffEnable := FALSE;

        TotalBalance := BankAccStmt."Balance Last Statement" - "Statement Amount";
        IF TempBankAccStmtLine.CALCSUMS("Statement Amount") THEN BEGIN
            TotalBalance := TotalBalance + TempBankAccStmtLine."Statement Amount";
            TotalBalanceEnable := TRUE;
        END ELSE
            TotalBalanceEnable := FALSE;

        Balance := BankAccStmt."Balance Last Statement" - "Statement Amount";
        TempBankAccStmtLine.SETRANGE("Statement Line No.", 0, BankAccStmtLineNo);
        IF TempBankAccStmtLine.CALCSUMS("Statement Amount") THEN BEGIN
            Balance := Balance + TempBankAccStmtLine."Statement Amount";
            BalanceEnable := TRUE;
        END ELSE
            BalanceEnable := FALSE;
    end;
}

