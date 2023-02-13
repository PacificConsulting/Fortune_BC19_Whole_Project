pageextension 50092 "Posted_Return_Recei_ext" extends "Posted Return Receipts"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {

        addafter("Shipment Method Code")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
            field("Return Order No."; "Return Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Sales Goods Return")
            {
                Promoted = true;
                ShortCutKey = 'Ctrl+k';
                ApplicationArea = all;

                trigger OnAction();
                begin
                    ReturnRcptHeader.RESET;
                    ReturnRcptHeader.SETRANGE(ReturnRcptHeader."No.", "No.");
                    REPORT.RUNMODAL(50051, TRUE, FALSE, ReturnRcptHeader);
                end;
            }
        }
    }

    var
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        ReturnRcptHeader: Record "Return Receipt Header";


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
            //FILTERGROUP(2);
            SETFILTER("Location Code", LocCodeText);
            //FILTERGROUP(0);
        END;

    end;

}

