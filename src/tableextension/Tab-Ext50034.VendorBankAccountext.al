tableextension 50034 "Vendor_Bank_Account_ext" extends "Vendor Bank Account"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    fields
    {
        field(50000; "BSB code"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50001; "IFSC Code"; Code[20])
        {
            Description = 'CCIT';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

