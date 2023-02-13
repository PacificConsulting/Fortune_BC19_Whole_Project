pageextension 50044 "Posted_Sales_Shipments_ext" extends "Posted Sales Shipments"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Order No."; "Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field("Sales Person Name"; SalesPersonName)
            {
                ApplicationArea = all;
            }
        }
    }

    var
        SalesPersonName: Text[50];
        RecSP: Record 13;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    //trigger OnAfterGetRecord();
    //begin
    /*
    //CCIT-JAGA
    CLEAR(SalesPersonName);
    IF RecSP.GET("Salesperson Code") THEN
      SalesPersonName := RecSP.Name;
    //CCIT-JAGA
    */
    //end;


    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.

    trigger OnOpenPage();
    begin

        //CCIT-SG-05062018
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN
            REPEAT
                LocCode := LocCode + RecUserBranch."Location Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
        LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
        IF LocCodeText <> '' THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("Location Code", LocCodeText);
            FILTERGROUP(0);
        END;
    ENd;
    //CCIT-SG-05062018

    //end;
}

