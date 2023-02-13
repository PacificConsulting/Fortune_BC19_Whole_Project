table 50013 "cust pay"
{

    fields
    {
        field(1;"cust code";Code[20])
        {
        }
        field(2;"Doc ref.";Code[20])
        {
        }
        field(3;"doc date";Date)
        {
        }
        field(4;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"cust code")
        {
        }
    }

    fieldgroups
    {
    }
}

