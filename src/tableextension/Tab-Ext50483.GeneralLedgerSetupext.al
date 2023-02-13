tableextension 50483 "General_Ledger_Setup_ext" extends "General Ledger Setup"
{
    // version TFS225977

    fields
    {

        field(50000; "Custom Duty Payable A/c"; Code[20])
        {
            Description = 'CCIT-SD-28-02-2018';
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false),
                                                 "Account Type" = FILTER(Posting));
        }
        field(50001; "Custom Duty Expense A/c"; Code[20])
        {
            Description = 'CCIT-SD-28-02-2018';
            TableRelation = "G/L Account" WHERE(Blocked = CONST(false),
                                                 "Account Type" = FILTER(Posting));
        }
        field(50002; "GST Public Key Directory Path"; Text[250])
        {
            Description = 'CITS';
        }
        field(50003; "GST Authorization URL"; Text[250])
        {
            Description = 'CITS';
        }
        field(50004; "GST IRN Generation URL"; Text[250])
        {
            Description = 'CITS';
        }
        field(50005; Vendor; Code[20])
        {
            Description = 'CITS';
            TableRelation = Vendor;
        }
        field(50006; "EWAY Bill URL"; Text[250])
        {
            Description = 'CCIT';
        }
        field(50007; "Cancel Eway Bill URL"; Text[250])
        {
            Description = 'CCIT';
        }
    }

}

