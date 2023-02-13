tableextension 50035 "No_Series_ext" extends "No. Series"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    fields
    {
        field(50000; Type; Option)
        {
            Description = 'CCIT-JAGA';
            OptionMembers = " ",Customer,Vendor;
        }
        field(50001; "Customer/Vendor"; Code[20])
        {
            Description = 'CCIT-JAGA';
            TableRelation = IF (Type = CONST(Customer)) Customer."No."
            ELSE
            IF (Type = CONST(Vendor)) Vendor."No.";

            trigger OnValidate();
            begin
                //CCIT-JAGA
                IF "Customer/Vendor" <> '' THEN BEGIN
                    IF Type = Type::Customer THEN BEGIN
                        recCust.GET("Customer/Vendor");
                        Description := recCust.Name;
                    END;

                    IF Type = Type::Vendor THEN BEGIN
                        recVend.GET("Customer/Vendor");
                        Description := recVend.Name;
                    END;
                END;
                //CCIT-JAGA
            end;
        }
        field(50002; PostCode; Code[20])
        {
            Description = 'CCIT-JAGA';
        }
        field(50003; "Location Code"; Code[10])
        {
            Description = 'Location Code';
            TableRelation = Location.Code;
        }
        field(50004; "Posting No. Series"; Code[10])
        {
            Description = 'Posting No. Series';
            TableRelation = "No. Series".Code;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        recCust: Record 18;
        recVend: Record 23;
}

