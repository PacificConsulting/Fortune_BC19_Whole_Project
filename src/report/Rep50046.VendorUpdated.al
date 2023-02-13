report 50046 "Vendor Updated"
{
    // version CCIT-RL

    Permissions = TableData 17 = rimd,
                  TableData 25 = rimd,
                  TableData 271 = rimd,
                  TableData 380 = rimd,
                  TableData 18689 = rimd;
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = FILTER(<> 'Credit Memo' & <> 'Invoice'));
            RequestFilterFields = "Document No.";

            trigger OnAfterGetRecord();
            begin
                IF GetFiltertext = '' THEN
                    ERROR('Please select Document No.');
                IF VendorNo = '' THEN
                    ERROR('Please select VendorNo');

                IF VendorNo <> '' THEN BEGIN
                    CLEAR(Vendor);
                    Vendor.RESET;
                    IF Vendor.GET(VendorNo) THEN;
                    FOR I := 0 TO 50 DO BEGIN
                        I += 1;
                        VendorLedgerEntry.RESET;
                        VendorLedgerEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                        VendorLedgerEntry.SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type");
                        IF VendorLedgerEntry.FINDSET THEN BEGIN
                            VendorLedgerEntry.CALCFIELDS(VendorLedgerEntry.Amount, VendorLedgerEntry."Remaining Amount");
                            IF VendorLedgerEntry.Amount <> VendorLedgerEntry."Remaining Amount" THEN
                                //VendEntryApplyPostedEntries.UnApplyVendLedgEntry1(VendorLedgerEntry."Entry No."); //PCPL/MIG/NSW Filed not Exist in BC18 Above code commebted ddue to function not add yet
                            VendEntryApplyPostedEntries.UnApplyVendLedgEntry(VendorLedgerEntry."Entry No.");// //PCPL/MIG/NSW Filed not Exist in BC18 Above code commebted ddue to function not add yet
                        END;
                    END;
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                    VendorLedgerEntry.SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type");
                    IF VendorLedgerEntry.FINDSET THEN
                        REPEAT
                            VendorLedgerEntry."Buy-from Vendor No." := VendorNo;
                            VendorLedgerEntry."Vendor Name" := Vendor.Name;
                            VendorLedgerEntry."Vendor No." := VendorNo;
                            VendorLedgerEntry.MODIFY;
                            DetailedVendorLedgEntry.RESET;
                            DetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            IF DetailedVendorLedgEntry.FINDSET THEN
                                REPEAT
                                    DetailedVendorLedgEntry."Vendor No." := VendorNo;
                                    DetailedVendorLedgEntry.MODIFY;
                                UNTIL DetailedVendorLedgEntry.NEXT = 0;

                        UNTIL VendorLedgerEntry.NEXT = 0;



                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", "Document No.");
                    GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Vendor);
                    IF GLEntry.FINDSET THEN
                        REPEAT
                            GLEntry."Source No." := VendorNo;
                            GLEntry.MODIFY;
                        UNTIL GLEntry.NEXT = 0;

                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", "Document No.");
                    GLEntry.SETRANGE("Bal. Account Type", "Bal. Account Type"::Vendor);
                    IF GLEntry.FINDSET THEN
                        REPEAT
                            GLEntry."Bal. Account No." := VendorNo;
                            GLEntry.MODIFY;
                        UNTIL GLEntry.NEXT = 0;

                    BankAccountLedgerEntry.RESET;
                    BankAccountLedgerEntry.SETRANGE("Document No.", "Document No.");
                    BankAccountLedgerEntry.SETRANGE("Bal. Account Type", BankAccountLedgerEntry."Bal. Account Type"::Vendor);
                    IF BankAccountLedgerEntry.FINDSET THEN
                        REPEAT
                            BankAccountLedgerEntry."Bal. Account No." := VendorNo;
                            BankAccountLedgerEntry.MODIFY;
                        UNTIL BankAccountLedgerEntry.NEXT = 0;
                END;
                TDSEntry.RESET;
                TDSEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                TDSEntry.SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type");
                IF TDSEntry.FINDSET THEN
                    REPEAT
                        IF TDSEntry."Party Type" = TDSEntry."Party Type"::Vendor THEN BEGIN
                            TDSEntry."Party Code" := VendorNo;
                            TDSEntry.MODIFY;
                        END;
                    UNTIL TDSEntry.NEXT = 0;
            end;

            trigger OnPreDataItem();
            begin
                GetFiltertext := "Vendor Ledger Entry".GETFILTER("Vendor Ledger Entry"."Document No.");
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
                    field("Vendor No"; VendorNo)
                    {
                        TableRelation = Vendor;
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
        TDSEntry: Record 18689;
        VendorLedgerEntry: Record 25;
        BankAccountLedgerEntry: Record 271;
        DetailedVendorLedgEntry: Record 380;
        GLEntry: Record 17;
        Vendor: Record 23;
        VendorNo: Code[20];
        GetFiltertext: Text;
        VendEntryApplyPostedEntries: Codeunit 227;
        I: Integer;
}

