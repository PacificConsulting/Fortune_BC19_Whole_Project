xmlport 50003 "Bank Acc. Reconcillation XML"
{
    // version CCIT-PRI-BankReco,CCIT-Fortune

    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                XmlName = 'BankAccReconsilationLine';
                fieldelement(No; "Bank Acc. Reconciliation Line"."No.")
                {
                }
                fieldelement(DocumentNo; "Bank Acc. Reconciliation Line"."Document No.")
                {
                }
                fieldelement(ValueDate; "Bank Acc. Reconciliation Line"."Value Date")
                {
                }
                fieldelement(TxnPostedDate; "Bank Acc. Reconciliation Line".TxnPostedDate)
                {
                }
                fieldelement(CheckNo; "Bank Acc. Reconciliation Line"."Check No.")
                {
                }
                fieldelement(Description; "Bank Acc. Reconciliation Line".Description)
                {
                }
                fieldelement(CRDR; "Bank Acc. Reconciliation Line".CRDR)
                {
                }
                fieldelement(StatementAmount; "Bank Acc. Reconciliation Line"."Statement Amount")
                {
                }
                fieldelement(Amt; "Bank Acc. Reconciliation Line".Amt)
                {
                }

                trigger OnBeforeInsertRecord();
                begin
                    "Bank Acc. Reconciliation Line"."Bank Account No." := bankreco1."Bank Account No.";
                    "Bank Acc. Reconciliation Line"."Statement No." := bankreco1."Statement No.";
                    line := line + 1;
                    "Bank Acc. Reconciliation Line"."Statement Line No." := line;
                    IF "Bank Acc. Reconciliation Line".CRDR = 'DR' THEN
                        "Bank Acc. Reconciliation Line"."Statement Amount" := -"Bank Acc. Reconciliation Line"."Statement Amount"; // rdk 260719

                    // rdk 290719 start
                    "Bank Acc. Reconciliation Line"."Transaction Date" := "Bank Acc. Reconciliation Line".TxnPostedDate;
                    IF "Bank Acc. Reconciliation Line".CRDR = 'Dr.' THEN
                        "Bank Acc. Reconciliation Line"."Statement Amount" := "Bank Acc. Reconciliation Line"."Statement Amount" * -1;
                    // rdk 290719 end
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort();
    begin

        bankrecoline.RESET;
        bankrecoline.SETRANGE("Bank Account No.", bankreco1."Bank Account No.");
        bankrecoline.SETRANGE("Statement No.", bankreco1."Statement No.");
        IF bankrecoline.FINDLAST THEN
            line := bankrecoline."Statement Line No.";
    end;

    var
        bankreco1: Record 273;
        line: Integer;
        bankrecoline: Record 274;

    procedure getdata(bankreco: Record 273);
    begin
        bankreco1 := bankreco;
    end;
}

