pageextension 50046 "Posted_Sales_Credit_Memos_ext" extends "Posted Sales Credit Memos"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {
        addafter("No.")
        {
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; "Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Currency Code")
        {
            field("Customer GRN/RTV No."; "Customer GRN/RTV No.")
            {
                ApplicationArea = all;
            }
            field("GRN/RTV Date"; "GRN/RTV Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Amount Including VAT")
        {

            field("Pre-Assigned No. Series"; "Pre-Assigned No. Series")
            {
                ApplicationArea = all;
            }
            field("Pre-Assigned No."; "Pre-Assigned No.")
            {
                ApplicationArea = all;
            }
            field("Return Order No."; "Return Order No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Shortcut Dimension 2 Code")
        {
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {
            field("Amount To Customer"; "Amount To Customer")
            {
                ApplicationArea = all;
            }
        }

        addafter("Document Exchange Status")
        {
            field("Tally Invoice No."; "Tally Invoice No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Sales Credit Memo")
            {
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    RecSalesCredMemo.RESET;
                    RecSalesCredMemo.SETRANGE(RecSalesCredMemo."No.", Rec."No.");
                    REPORT.RUNMODAL(50071, TRUE, FALSE, RecSalesCredMemo);
                end;
            }
        }
    }

    var
        RecSalesCredMemo: Record 114;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;




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
        /*
            IF LocCodeText <> '' THEN
          ClearHide := FALSE
        ELSE
          ClearHide := TRUE;}
          */
        //CCIT-SG-05062018

    end;
}

