pageextension 50006 "Customer_list_ext" extends "Customer List"
{
    // version NAVW19.00.00.48466,CCIT-Fortune

    layout
    {
        // modify("Control 6")
        // {
        //     Visible = false;
        // }
        // modify("Control 34")
        // {
        //     Visible = false;
        // }
        // modify("Control 200")
        // {
        //     Visible = false;
        // }
        addafter("Payments (LCY)")
        {


            field(Sunday; Sunday)
            {
                ApplicationArea = all;
            }
            field(Monday; Monday)
            {
                ApplicationArea = all;
            }
            field(Tuesday; Tuesday)
            {
                ApplicationArea = all;
            }
            field(Wednesday; Wednesday)
            {
                ApplicationArea = all;
            }
            field(Thursday; Thursday)
            {
                ApplicationArea = all;
            }
            field(Friday; Friday)
            {
                ApplicationArea = all;
            }
            field(Saturday; Saturday)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        // addafter("Page Customer Bank Account List")
        // {
        //     action("PDC Cheques")
        //     {
        //         Image = List;
        //         ApplicationArea = all;
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         RunObject = Page 50067;
        //         //RunPageLink = "Cust.Code" = FIELD("No.");


        //     }
        // }
        addafter(Sales)
        {
            action("License Details")
            {
                Promoted = true;
                ApplicationArea = all;
                RunObject = Page 50128;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageView = ORDER(Ascending);
            }
        }
        // addafter("Action 1905171704")
        // {
        //     action(Items)
        //     {
        //         Caption = 'Items';
        //         Image = Item;
        //         RunObject = Page 114;
        //         RunPageLink = "Vendor/Customer No." = FIELD("No.");
        //         RunPageView = SORTING("Vendor/Customer No.");
        //     }
        // }
    }

    var
        RecUserSetup: Record 91;
        Loccode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record 50029;




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
        //CCIT-SG
        IF RecUserSetup.GET(USERID) THEN BEGIN
            IF RecUserSetup.Location <> '' THEN BEGIN
                FILTERGROUP(2);
                SETRANGE("State Code", RecUserSetup.Location);
                FILTERGROUP(0);
            END;
        END;
        //CCIT-SG

    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

