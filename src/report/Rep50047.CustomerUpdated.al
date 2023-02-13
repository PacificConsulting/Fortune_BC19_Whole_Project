report 50047 "Customer Updated"
{
    // version CCIT-RL

    Permissions = TableData 17 = rimd,
                  TableData 21 = rimd,
                  TableData 271 = rimd,
                  TableData 379 = rimd,
                  TableData "TCS Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending)
                                 WHERE("Document Type" = FILTER(<> 'Credit Memo' & <> 'Invoice'));
            RequestFilterFields = "Document No.";

            trigger OnAfterGetRecord();
            begin
                IF GetFiltertext = '' THEN
                    ERROR('Please select Document No.');
                IF CustomerNo = '' THEN
                    ERROR('Please select CustomerNo');

                IF CustomerNo <> '' THEN BEGIN
                    CLEAR(Customer);
                    Customer.RESET;
                    IF Customer.GET(CustomerNo) THEN;

                    FOR I := 0 TO 50 DO BEGIN
                        I += 1;
                        CustLedgerEntry.RESET;
                        CustLedgerEntry.SETRANGE("Document No.", "Document No.");
                        CustLedgerEntry.SETRANGE("Document Type", "Document Type");
                        IF CustLedgerEntry.FINDSET THEN BEGIN
                            CustLedgerEntry.CALCFIELDS(CustLedgerEntry.Amount, CustLedgerEntry."Remaining Amount");

                            IF CustLedgerEntry.Amount <> CustLedgerEntry."Remaining Amount" THEN
                                //CustEntryApplyPostedEntries.UnApplyCustLedgEntry1(CustLedgerEntry."Entry No.");  //PCPL/MIG/NSW Filed not Exist in BC18 Above code commebted ddue to function not add yet
                                CustEntryApplyPostedEntries.UnApplyCustLedgEntry(CustLedgerEntry."Entry No."); //PCPL/MIG/NSW Filed not Exist in BC18 Above code commebted ddue to function not add yet
                        END;
                    END;

                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Document No.", "Document No.");
                    CustLedgerEntry.SETRANGE("Document Type", "Document Type");
                    IF CustLedgerEntry.FINDSET THEN
                        REPEAT
                            CustLedgerEntry."Customer No." := CustomerNo;
                            CustLedgerEntry."Sell-to Customer No." := CustomerNo;
                            CustLedgerEntry.MODIFY;

                            DetailedCustLedgEntry.RESET;
                            DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                            IF DetailedCustLedgEntry.FINDSET THEN
                                REPEAT
                                    DetailedCustLedgEntry."Customer No." := CustomerNo;
                                    DetailedCustLedgEntry.MODIFY;
                                UNTIL DetailedCustLedgEntry.NEXT = 0;
                        UNTIL CustLedgerEntry.NEXT = 0;



                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", "Document No.");
                    GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Customer);
                    IF GLEntry.FINDSET THEN
                        REPEAT
                            GLEntry."Source No." := CustomerNo;
                            GLEntry.MODIFY;
                        UNTIL GLEntry.NEXT = 0;
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", "Document No.");
                    GLEntry.SETRANGE("Bal. Account Type", "Bal. Account Type"::Customer);
                    IF GLEntry.FINDSET THEN
                        REPEAT
                            GLEntry."Bal. Account No." := CustomerNo;
                            GLEntry.MODIFY;
                        UNTIL GLEntry.NEXT = 0;
                    BankAccountLedgerEntry.RESET;
                    BankAccountLedgerEntry.SETRANGE("Document No.", "Document No.");
                    BankAccountLedgerEntry.SETRANGE("Bal. Account Type", BankAccountLedgerEntry."Bal. Account Type"::Customer);
                    IF BankAccountLedgerEntry.FINDSET THEN
                        REPEAT
                            BankAccountLedgerEntry."Bal. Account No." := CustomerNo;
                            BankAccountLedgerEntry.MODIFY;
                        UNTIL BankAccountLedgerEntry.NEXT = 0;
                    /* //PCPL/MIG/NSW Filed Not Exist in BC
                     TCSEntry.RESET;
                     TCSEntry.SETRANGE("Document No.","Document No.");
                     TCSEntry.SETRANGE("Document Type","Document Type");
                     IF TCSEntry.FINDSET THEN REPEAT
                     IF TCSEntry."Party Type" = TCSEntry."Party Type"::Vendor THEN BEGIN
                     TCSEntry."Party Code" := CustomerNo;
                     TCSEntry.MODIFY;
                     END;
                     UNTIL TCSEntry.NEXT = 0;
                     */ //PCPL/MIG/NSW Filed Not Exist in BC
                END;
            end;

            trigger OnPreDataItem();
            begin
                GetFiltertext := "Cust. Ledger Entry".GETFILTER("Cust. Ledger Entry"."Document No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Customer No."; CustomerNo)
                    {
                        TableRelation = Customer;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        MESSAGE('Data has been updated successfully');
    end;

    var
        TCSEntry: Record "TCS Entry";
        CustLedgerEntry: Record 21;
        BankAccountLedgerEntry: Record 271;
        DetailedCustLedgEntry: Record 379;
        GLEntry: Record 17;
        Customer: Record 18;
        CustomerNo: Code[20];
        GetFiltertext: Text;
        CustEntryApplyPostedEntries: Codeunit 226;
        I: Integer;
}

