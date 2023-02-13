tableextension 50040 MyExtension extends "TCS Nature Of Collection"
{
    fields
    {
        field(50000; eTCS; Code[10])
        {
            Caption = 'eTCS';
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}