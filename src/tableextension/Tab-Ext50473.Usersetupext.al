tableextension 50473 "User_setup_ext" extends "User Setup"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    fields
    {
        field(50000; Location; Code[10])
        {
            Description = 'CCIT';
            TableRelation = State.Code;
        }
        field(50001; Branch; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50002; "Finance Customer"; Boolean)
        {
            Description = 'CCIT_TK';
        }
        field(50003; "Customer Permission"; Boolean)
        {
            Description = 'RL';
        }
        field(50004; "Item Card Permission"; Boolean)
        {
            Description = 'PCPL/NSW/07  29June22';
        }
        field(50005; "Sales Price Permission"; Boolean)
        {
            Description = 'PCPL/NSW/07  29June22';
        }
    }
    keys
    {
        key(Key1; Location)
        {
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

