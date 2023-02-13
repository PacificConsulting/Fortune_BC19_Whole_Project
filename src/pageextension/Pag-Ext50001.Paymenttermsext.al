pageextension 50001 "Payment_terms_ext" extends "Payment Terms"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {
        addafter(Description)
        {
            field("Shipment Method"; "Shipment Method")
            {
                ApplicationArea = all;
            }
            field(Type; Type)
            {
            }
            field("Customer/Vendor No."; "Customer/Vendor No.")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

