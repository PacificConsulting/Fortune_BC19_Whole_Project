table 50018 "Port Of Destination-Air"
{
    // version CCIT-Fortune

    DrillDownPageID = 50018;
    LookupPageID = 50018;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[100])
        {
        }
        field(3;"Port Of Loading-Air";Code[20])
        {
            TableRelation = "Port Of Loading-Air".Code;
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

