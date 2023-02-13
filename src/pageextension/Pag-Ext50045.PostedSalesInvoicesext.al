pageextension 50045 "Posted_Sales_Invoices_ext" extends "Posted Sales Invoices"
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
            field("Customer Posting Group"; "Customer Posting Group")
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

        addafter("Salesperson Code")
        {
            field("Sales Person Name"; "Sales Person Name")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(Invoice)
        {
            action("TAX INVIOCE")
            {
                Caption = 'TAX INVIOCE';
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    RecTSH.RESET;
                    RecTSH.SETRANGE(RecTSH."No.", "No.");
                    if RecTSH.FindFirst() then
                        REPORT.RUNMODAL(50000, TRUE, FALSE, RecTSH);
                end;
            }
            action("Print Voucher")
            {
                Ellipsis = true;
                Image = PrintVoucher;
                Promoted = true;

                trigger OnAction();
                begin
                    RecGLEntry.RESET;
                    RecGLEntry.SETRANGE(RecGLEntry."Document No.", Rec."No.");
                    REPORT.RUNMODAL(16567, TRUE, FALSE, RecGLEntry);
                end;
            }
            action("Sale DebitNote")
            {
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //CCIT-Harshal 28-09-2018
                    RSIH.RESET;
                    RSIH.SETRANGE(RSIH."No.", "No.");
                    REPORT.RUNMODAL(50078, TRUE, FALSE, RSIH);
                    //CCIT-Harshal 28-09-2018
                end;
            }
        }
    }

    var
        RecTSH: Record 112;
        SalesPersonName: Text[50];
        RecSP: Record 13;
        RecGLEntry: Record 17;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RSIH: Record 112;




    trigger OnAfterGetRecord();
    begin

        //CCIT-JAGA
        CLEAR(SalesPersonName);
        IF RecSP.GET("Salesperson Code") THEN
            SalesPersonName := RecSP.Name;
        //CCIT-JAGA

    end;


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
          ClearHide := TRUE;
          */
        //CCIT-SG-05062018

    end;
}

