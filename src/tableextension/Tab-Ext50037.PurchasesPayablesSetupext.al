tableextension 50037 "Purchases_Payables_Setup_ext" extends "Purchases & Payables Setup"
{

    fields
    {

        field(50000; Tolerance; Decimal)
        {
            Description = 'CCIT';
        }
        field(50001; "Custom Duty %"; Decimal)
        {
        }
        field(50002; "Social Welfare charges"; Decimal)
        {
        }
        field(50005; "Date 194Q Before"; Date)
        {
            Description = 'CCIT-SG';
        }
        field(50006; "Date 194Q After"; Date)
        {
            Description = 'CCIT-SG';
        }
    }


}

