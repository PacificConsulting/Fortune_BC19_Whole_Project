table 50021 "Vertical Sub Category"
{
    // version CCIT-Fortune

    DrillDownPageID = 50021;
    LookupPageID = 50021;

    fields
    {
        field(1; "Vertical Category Code"; Code[10])
        {
            TableRelation = "Vertical Category".Code;
        }
        field(2; "Code"; Code[30])
        {
        }
        field(3; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Vertical Category Code")
        {
        }
    }

    fieldgroups
    {
    }
}

