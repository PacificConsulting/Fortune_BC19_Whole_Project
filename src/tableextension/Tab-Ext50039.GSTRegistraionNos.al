tableextension 50039 GST_Registration_Nos extends "GST Registration Nos."
{
    fields
    {
        field(6; "E-Invoice Client ID"; Text[100])
        {
            Description = 'CITS';

        }
        field(7; "E-Invoice Client Secret"; Text[100])
        {
            Description = 'CITS';
        }
        field(8; "E-Invoice Password"; Text[100])
        {
            Description = 'CITS';
        }
        field(9; "E-Invoice UserName"; Text[100])
        {
            Description = 'CITS';
        }
    }

}