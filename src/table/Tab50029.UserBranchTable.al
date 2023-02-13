table 50029 "User Branch Table"
{
    // version CCIT-PRI


    fields
    {
        field(1;"User ID";Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(2;"Location Code";Code[20])
        {
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1;"User ID","Location Code")
        {
        }
    }

    fieldgroups
    {
    }
}

