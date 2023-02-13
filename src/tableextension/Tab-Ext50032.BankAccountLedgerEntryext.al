tableextension 50032 "Bank_Account_Ledger_Entry_ext" extends "Bank Account Ledger Entry"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    fields
    {



        field(50000; "RTGS/NEFT"; Option)
        {
            OptionMembers = " ",RTGS,NEFT;
        }
        field(50001; "Value Date"; Date)
        {
            Description = 'CCIT-JAGA';
        }
        field(50002; "Balance Account Name"; Text[100])
        {
            Description = 'ccit';
        }
    }



    trigger OnInsert();
    begin
        //ccit san - 261118 - update Balance Account Name
        IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
            IF recBankAcc.GET("Bal. Account No.") THEN
                "Balance Account Name" := recBankAcc.Name;
        END;
        IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN BEGIN
            IF recCust.GET("Bal. Account No.") THEN
                "Balance Account Name" := recCust.Name;
        END;
        IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN BEGIN
            IF recFA.GET("Bal. Account No.") THEN
                "Balance Account Name" := recFA.Description;
        END;
        IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN BEGIN
            IF recGLAccount.GET("Bal. Account No.") THEN
                "Balance Account Name" := recGLAccount.Name;
        END;
        IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN BEGIN
            IF recVend.GET("Bal. Account No.") THEN
                "Balance Account Name" := recVend.Name;
        END;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        recBankAcc: Record 270;
        recCust: Record 18;
        recVend: Record 23;
        recGLAccount: Record 15;
        recFA: Record 5600;
}

