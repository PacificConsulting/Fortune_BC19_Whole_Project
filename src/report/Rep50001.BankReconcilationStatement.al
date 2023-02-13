report 50001 "Bank Reconcilation Statement"
{
    // version To be deleted

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Bank Reconcilation Statement.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Bank Account Ledger Entry1"; "Bank Account Ledger Entry")
        {
            DataItemTableView = WHERE("Source Code" = FILTER('BANKPYMTV' | 'GENJNL' | 'CONTRAV'),
                                      Open = CONST(true),
                                      Amount = FILTER(<= 0));
            column(BankAccNo11; BankAccNo1)
            {
            }
            column(SrNo; SrNo)
            {
            }
            column(ChequeNo_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Cheque No.")
            {
            }
            column(ChequeDate_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Cheque Date")
            {
            }
            column(Description_BankAccountLedgerEntry1; "Bank Account Ledger Entry1".Description)
            {
            }
            column(RemainingAmount_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Remaining Amount")
            {
            }
            column(Amt; Amt)
            {
            }
            column(EntryNo; "Bank Account Ledger Entry1"."Entry No.")
            {
            }
            column(BalAsPerBAVal; BalAsPerBAVal)
            {
            }
            column(StmtEndingBal; StmtEndingBal)
            {
            }
            column(datestr; datestr)
            {
            }

            trigger OnAfterGetRecord();
            begin
                SrNo += 1;

                IF "Remaining Amount" < 0 THEN
                    Amt := "Remaining Amount" * (-1)
                ELSE
                    Amt := "Remaining Amount";
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("Bank Account No.", BankAccNo1);
                SETFILTER("Posting Date", '<=%1', StmtDate);
                // SETFILTER(Revise,'No');

                //   MESSAGE('%1',COUNT);
                SrNo := 0;
                Amt := 0;
            end;
        }
        dataitem("Bank Account Ledger Entry2"; "Bank Account Ledger Entry")
        {
            DataItemTableView = WHERE("Source Code" = FILTER('BANKRCPTV' | 'CONTRAV'),
                                      Open = CONST(true),
                                      Amount = FILTER(> 0));
            column(BankAccNo22; BankAccNo1)
            {
            }
            column(SrNo1; SrNo1)
            {
            }
            column(Description_BankAccountLedgerEntry2; "Bank Account Ledger Entry2".Description)
            {
            }
            column(RemainingAmount_BankAccountLedgerEntry2; "Bank Account Ledger Entry2"."Remaining Amount")
            {
            }
            column(ChequeNo_BankAccountLedgerEntry2; "Bank Account Ledger Entry2"."Cheque No.")
            {
            }
            column(ChequeDate_BankAccountLedgerEntry2; "Bank Account Ledger Entry2"."Cheque Date")
            {
            }
            column(Amt1; Amt1)
            {
            }
            column(EntryNo1; "Bank Account Ledger Entry2"."Entry No.")
            {
            }
            column(BalAsPerBAVal2; BalAsPerBAVal2)
            {
            }
            column(datestr2; datestr2)
            {
            }
            column(StmtEndingBal2; StmtEndingBal2)
            {
            }

            trigger OnAfterGetRecord();
            begin

                SrNo1 += 1;


                Amt1 := "Remaining Amount";
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("Bank Account No.", BankAccNo1);
                SETFILTER("Posting Date", '<=%1', StmtDate);
                // SETFILTER(Revise,'No');



                SrNo1 := 0;
                Amt1 := 0;
            end;
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

    labels
    {
        Title = 'Bank Reconciliation Statement as on'; BalAsPerBA = 'Balance as per Bank Book'; Unclearchck = 'Add : Uncleared Cheques'; UnclearDep = 'Less : Uncleared Deposits'; CorrBal = 'Corrected Balance'; BalAsPerBS = 'Balance as per Bank Statement'; Difference = 'Difference';
    }

    trigger OnPreReport();
    begin

        IF StmtDate = 0D THEN
            ERROR('Statement Date should be filled..');


        BalAsPerBAVal := 0;
        BALedgerEntry.RESET;
        BALedgerEntry.SETRANGE(BALedgerEntry."Bank Account No.", BankAccNo1);
        BALedgerEntry.SETFILTER(BALedgerEntry."Posting Date", '<=%1', StmtDate);
        // BALedgerEntry.SETRANGE(BALedgerEntry.Open,TRUE);
        IF BALedgerEntry.FINDFIRST THEN
            REPEAT
                BalAsPerBAVal := BalAsPerBAVal + BALedgerEntry."Debit Amount" - BALedgerEntry."Credit Amount";
            UNTIL BALedgerEntry.NEXT = 0;
        MESSAGE('StmtEnding%1 BalAsPerBaVal =%2', StmtEndingBal, BalAsPerBAVal);

        /*  RecBankAccLedEntry1.RESET;
          RecBankAccLedEntry1.SETFILTER("Source Code",'REVERSAL');
          RecBankAccLedEntry1.SETRANGE(Open,TRUE);
          RecBankAccLedEntry1.SETRANGE("Bank Account No.",BankAccNo1);
          RecBankAccLedEntry1.SETFILTER("Posting Date",'<=%1',StmtDate);
          IF RecBankAccLedEntry1.FINDFIRST THEN
             REPEAT
                RecBankAccLedEntry2.RESET;
                RecBankAccLedEntry2.SETRANGE("Document No.",RecBankAccLedEntry1."Document No.");
                IF RecBankAccLedEntry2.FINDFIRST THEN
                   REPEAT
                       RecBankAccLedEntry2.Revise := TRUE;
                       RecBankAccLedEntry2.MODIFY;
                   UNTIL RecBankAccLedEntry2.NEXT=0;

             UNTIL RecBankAccLedEntry1.NEXT=0;*/




        datestr := FORMAT(StmtDate, 0, '<Day> <Month Text> <Year4>');

        //..CCIT-PRI
        BalAsPerBAVal2 := 0;
        BALedgerEntry2.RESET;
        BALedgerEntry2.SETRANGE(BALedgerEntry2."Bank Account No.", BankAccNo1);
        BALedgerEntry2.SETFILTER(BALedgerEntry2."Posting Date", '<=%1', StmtDate);
        // BALedgerEntry.SETRANGE(BALedgerEntry.Open,TRUE);
        IF BALedgerEntry2.FINDFIRST THEN
            REPEAT
                BalAsPerBAVal2 := BalAsPerBAVal2 + BALedgerEntry2."Debit Amount" - BALedgerEntry2."Credit Amount";
            UNTIL BALedgerEntry2.NEXT = 0;

        datestr2 := FORMAT(StmtDate, 0, '<Day> <Month Text> <Year4>');
        //..

    end;

    var
        BankAccNo1: Code[20];
        StmtDate: Date;
        BALedgerEntry: Record 271;
        BalAsPerBAVal: Decimal;
        SrNo: Integer;
        Amt: Decimal;
        SrNo1: Integer;
        Amt1: Decimal;
        RecBankAccLedEntry: Record 271;
        datestr: Text;
        StmtEndingBal: Decimal;
        RecBankAccLedEntry1: Record 271;
        RecBankAccLedEntry2: Record 271;
        BALedgerEntry2: Record 271;
        BalAsPerBAVal2: Decimal;
        datestr2: Text;
        StmtEndingBal2: Decimal;

    procedure GetParameter(BankAccNo: Code[20]; Date: Date; StmtEndBal: Decimal);
    begin
        BankAccNo1 := BankAccNo;
        StmtDate := Date;
        StmtEndingBal := StmtEndBal;
        StmtEndingBal2 := StmtEndBal;
    end;
}

