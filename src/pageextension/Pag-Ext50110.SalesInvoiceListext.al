pageextension 50110 "Sales_Invoice_List_ext" extends "Sales Invoice List"
{
    // version NAVW19.00.00.45778

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //RL ++
                ShipmentNo;
                //RL --
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                //RL ++
                ShipmentNo;
                //RL --
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                //RL ++
                ShipmentNo;
                //RL --
            end;
        }

    }

    var
        RecUserSetup: Record 91;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record 50029;
        SalesLine: Record 37;


    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.

    trigger OnOpenPage();
    begin
        //CCIT-SG-05062018
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
            SETFILTER("Location Code", LocCodeText);
        END;
        IF LocCodeText <> '' THEN
            ClearHide := FALSE
        ELSE
            ClearHide := TRUE;
        //CCIT-SG-05062018

    end;

    local procedure ShipmentNo();
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", "No.");
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETFILTER("No.", '<>%1', '');
        IF SalesLine.FINDFIRST THEN
            REPEAT
                SalesLine.TESTFIELD("Shipment No.");
            UNTIL SalesLine.NEXT = 0;
    end;
}

