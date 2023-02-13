tableextension 50026 "Gate_Entry_Header_ext" extends "Gate Entry Header"
{
    // version NAVIN9.00.00.45778,CCIT-Fortune

    fields
    {

        //Unsupported feature: PropertyDeletion on ""User ID"(Field 20)". Please convert manually.

        field(50000; "Vehicle Reporting Date"; Date)
        {
        }
        field(50001; "AWB No."; Code[20])
        {
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

