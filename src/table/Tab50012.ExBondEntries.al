table 50012 "Ex-Bond Entries"
{

    fields
    {
        field(1;"Ex-Bond Entry No.";Code[20])
        {
        }
        field(2;"Ex-Bond Entry Date";Date)
        {
        }
        field(3;"In-Bond Entry No.";Code[20])
        {
            TableRelation = "Bond Master";
        }
    }

    keys
    {
        key(Key1;"Ex-Bond Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

