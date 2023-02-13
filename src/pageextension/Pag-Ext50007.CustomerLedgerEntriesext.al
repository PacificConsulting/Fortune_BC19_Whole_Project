pageextension 50007 "Customer_Ledger_Entries_ext" extends "Customer Ledger Entries"
{
    // version TFS225977

    layout
    {

        addafter("Direct Debit Mandate ID")
        {
            field("Ref. Invoice No."; "Ref. Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Tally Inv. No."; "Tally Inv. No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("Print Voucher")
        {
            trigger OnAfterAction()
            begin
                GLentry.SETCURRENTKEY("Document No.", "Posting Date");
                GLentry.SETRANGE("Document No.", "Document No.");
                GLentry.SETRANGE("Posting Date", "Posting Date");
                IF GLentry.FIND('-') THEN
                    REPORT.RUNMODAL(REPORT::"Posted Voucher", TRUE, TRUE, GLentry);

            end;
        }
        // modify(Action1500005)
        // {
        //     CaptionML = ENU = 'Print GST Voucher', ENN = 'Print Voucher';
        // }
        // modify("Action 1500000")
        // {

        //     //Unsupported feature: Change Level on "Action 1500000". Please convert manually.

        //     CaptionML = ENU = 'Narration', ENN = 'Narration';

        //     //Unsupported feature: Change Image on "Action 1500000". Please convert manually.


        //     //Unsupported feature: Change RunObject on "Action 1500000". Please convert manually.


        //     //Unsupported feature: Change RunPageLink on "Action 1500000". Please convert manually.

        // }

        addafter("IncomingDocAttachFile")
        {
            action("Update Customer Detail")
            {
                Image = Union;

                trigger OnAction();
                begin
                    //RL
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Document No.", "Document No.");
                    CustLedgerEntry.SETRANGE("Document Type", "Document Type");
                    IF CustLedgerEntry.FINDFIRST THEN
                        REPORT.RUNMODAL(50047, TRUE, TRUE, CustLedgerEntry);
                    //RL
                end;
            }
        }
        //moveafter("Action 52";"Action 1500000")
    }

    var
        CustLedgerEntry: Record 21;
        LocCode: Code[1024];
        RecUserBranch: Record 50029;
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserSetup: Record 91;
        RefInvNo: Code[20];
        TallyInvNo: Code[30];
        SCMH: Record 114;
        GLentry: Record 17;


    trigger OnAfterGetRecord();
    begin
        //StyleTxt := SetStyle(); //PCPL/MIG/NSW
        //02122021 CCIT AN
        CLEAR(RefInvNo);
        CLEAR(TallyInvNo);

        SCMH.RESET;
        SCMH.SETRANGE("No.", "Document No.");
        SCMH.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
        SCMH.SETRANGE("Posting Date", "Posting Date");
        IF SCMH.FINDFIRST THEN BEGIN
            RefInvNo := SCMH."Applies-to Doc. No.";
            TallyInvNo := SCMH."Tally Invoice No.";
        END;
        //02122021

    end;



    trigger OnOpenPage();
    begin
        /*//CCIT-SG-05062018
          LocCode := '';
          RecUserBranch.RESET;
          RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
          IF RecUserBranch.FINDFIRST THEN
            REPEAT
              //IF RecUserBranch."Location Code" <> '' THEN
              LocCode := LocCode + RecUserBranch."Location Code" + '|';
            UNTIL RecUserBranch.NEXT=0;
          LocCodeText := DELSTR(LocCode,STRLEN(LocCode),1);
          IF LocCodeText <> '' THEN BEGIN
            SETFILTER("Location Code",LocCodeText);
          END;
          IF LocCodeText <> '' THEN
            ClearHide := FALSE
          ELSE
            ClearHide := TRUE;
          //CCIT-SG-05062018
          //CCIT-SG
          {
          IF RecUserSetup.GET(USERID) THEN BEGIN
            IF RecUserSetup.Location <> '' THEN BEGIN
                FILTERGROUP(2);
                //SETRANGE("State Code",RecUserSetup.Location);
                //FILTERGROUP(0);
            END;
          END;
          }
          //CCIT-SG
          }
          */
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

