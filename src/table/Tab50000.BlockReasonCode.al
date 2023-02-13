table 50000 "Block Reason Code"
{
    // version To be deleted

    DrillDownPageID = 50000;
    LookupPageID = 50000;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

