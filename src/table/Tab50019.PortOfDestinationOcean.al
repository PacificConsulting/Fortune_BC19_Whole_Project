table 50019 "Port Of Destination-Ocean"
{
    // version CCIT-Fortune

    DrillDownPageID = 50019;
    LookupPageID = 50019;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;description;Text[100])
        {
        }
        field(3;"Port Of Looading-Ocean";Code[20])
        {
            TableRelation = "Port Of Looading-Ocean".Code;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

