table 50032 "BufferTable-ItemLocationLot"
{
    // version To be deleted


    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Item Code";Code[20])
        {
        }
        field(3;"Lot No.";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Item Code")
        {
        }
    }

    fieldgroups
    {
    }
}

