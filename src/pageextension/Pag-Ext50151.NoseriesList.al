pageextension 50151 NoSeries_Ext extends "No. Series List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {

    }

    var
        RecUserSetup: Record 91;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];

    trigger OnOpenPage()
    begin

        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN
            REPEAT
                    //IF RecUserBranch."Location Code" <> '' THEN
                    LocCode := LocCode + RecUserBranch."Location Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
        LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
        IF LocCodeText <> '' THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("Location Code", LocCodeText);
            FILTERGROUP(0);
        END;

        //CCIT-SG

    end;
}