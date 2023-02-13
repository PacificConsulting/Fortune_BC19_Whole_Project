table 50026 "Transport Master"
{
    // version CCIT-Fortune

    DrillDownPageID = 50036;
    LookupPageID = 50036;

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Name; Text[50])
        {
        }
        field(3; "Name 2"; Text[50])
        {
        }
        field(4; Address; Text[50])
        {
        }
        field(5; Address2; Text[50])
        {
        }
        field(6; City; Text[30])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
        field(7; Contact; Text[50])
        {
        }
        field(8; "Phone No."; Text[30])
        {
        }
        field(9; County; Text[30])
        {
        }
        field(10; "State Code"; Code[10])
        {
            TableRelation = State;
        }
        field(11; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

