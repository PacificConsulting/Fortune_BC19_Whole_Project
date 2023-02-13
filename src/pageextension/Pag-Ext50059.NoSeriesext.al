pageextension 50059 "No_Series_ext" extends "No. Series"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {
        addafter(Description)
        {
            field(Type; Type)
            {
                ApplicationArea = all;
            }
            field("Customer/Vendor"; "Customer/Vendor")
            {
                ApplicationArea = all;
            }
        }
        addafter("Date Order")
        {
            field(PostCode; PostCode)
            {
                ApplicationArea = all;
            }
        }
        addafter(PostCode)
        {
            field("Location Code"; "Location Code")
            {
                ApplicationArea = all;
            }
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

