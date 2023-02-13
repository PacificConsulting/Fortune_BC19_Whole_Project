pageextension 50118 "TDS_Entries_ext" extends "TDS Entries"
{
    // version NAVIN9.00.00.45778

    layout
    {


    }

    var
        Party_Name: Text[100];
        RecVend: Record 23;


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin

        IF RecVend.GET("Party Code") THEN
            Party_Name := RecVend.Name;
    end;
}

