pageextension 50051 "Bank_Acc_Led_Entries_ext" extends "Bank Account Ledger Entries"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621

    layout
    {
        addafter("Stale Cheque")
        {

            field("RTGS/NEFT"; "RTGS/NEFT")
            {
                ApplicationArea = all;
            }
        }
        addafter("Global Dimension 1 Code")
        {
            field("Statement Status"; "Statement Status")
            {
                ApplicationArea = all;
            }
            field("Statement No."; "Statement No.")
            {
                ApplicationArea = all;
            }
            field("Statement Line No."; "Statement Line No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Bal. Account No.")
        {
            field("Balance Account Name"; "Balance Account Name")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {



        modify("Print Voucher")
        {
            trigger OnBeforeAction()
            begin
                GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                GLEntry.SETRANGE("Document No.", "Document No.");
                GLEntry.SETRANGE("Posting Date", "Posting Date");
                IF GLEntry.FIND('-') THEN
                    REPORT.RUNMODAL(REPORT::"Posted Voucher", TRUE, TRUE, GLEntry);
            end;
        }

    }

    var
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecLoc: Record 14;
        GLEntry: Record 17;


    //Unsupported feature: CodeInsertion on "OnOpenPage". Please convert manually.

    trigger OnOpenPage();
    begin
        //23-04-2019 start rdk
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN BEGIN
            REPEAT
                //IF RecUserBranch."Location Code" <> '' THEN
                IF RecLoc.GET(RecUserBranch."Location Code") THEN
                    IF RecLoc."Branch Code" <> '' THEN
                        LocCode := LocCode + RecLoc."Branch Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
            IF STRLEN(LocCode) <> 0 THEN BEGIN
                LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
                IF LocCodeText <> '' THEN BEGIN
                    SETFILTER("Global Dimension 1 Code", LocCodeText);
                END;
                IF LocCodeText <> '' THEN
                    ClearHide := FALSE
                ELSE
                    ClearHide := TRUE;
            END;
        END;
    end;
    //24-04-2019 end
    //end;
}

