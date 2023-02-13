tableextension 50000 "Payment_terms_ext" extends "Payment Terms"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    fields
    {
        field(50000; "Shipment Method"; Code[10])
        {
            Description = 'CCIT';
            TableRelation = "Shipment Method";
        }
        field(50001; Type; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Customer,Vendor;
        }
        field(50002; "Customer/Vendor No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = IF (Type = CONST(Customer)) Customer."No."
            ELSE
            IF (Type = CONST(Vendor)) Vendor."No.";
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

