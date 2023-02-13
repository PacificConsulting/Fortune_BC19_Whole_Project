tableextension 50027 "Post_Code_ext" extends "Post Code"
{
    // version NAVW19.00.00.45778

    fields
    {
        field(50000; State; Code[10])
        {
            TableRelation = State.Code;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

