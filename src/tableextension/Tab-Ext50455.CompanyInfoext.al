tableextension 50455 "Company_Info_ext" extends "Company Information"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    fields
    {
        field(50000; "CIN No."; Code[25])
        {
            Description = 'CCIT-SG';
        }
        field(50001; "Purchase E mail"; Text[80])
        {
            ExtendedDatatype = EMail;
        }
        field(50002; "Auto IRN Generation"; Boolean)
        {
        }
        field(50003; "MSME No."; Text[50])
        {
        }
        field(50004; "UPI QR Code"; Blob)
        {
            Subtype = Bitmap;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

