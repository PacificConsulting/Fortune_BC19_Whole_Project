tableextension 50002 "Salesperson_Purchaser_ext" extends "Salesperson/Purchaser"
{
    // version NAVW19.00.00.45778


    fields
    {
        modify(Code)
        {

            Width = 10; // the value represents number of characters

        }
        //Unsupported feature: Deletion on ""Privacy Blocked"(Field 150)". Please convert manually.

        field(50000; "Is Manager"; Boolean)
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(50001; "Reporting to"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE("Is Manager" = FILTER(true));
        }
    }
    keys
    {
        key(Name; Name)
        {
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

