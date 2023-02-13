pageextension 50112 "Sales_Ret_Ord_List_ext" extends "Sales Return Order List"
{
    // version NAVW19.00.00.45778

    layout
    {

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-JAGA
                IF RecSPorP.GET("Salesperson Code") THEN
                    SalesPersonName := RecSPorP.Name;
                //CCIT-JAGA

            end;
        }
        addafter("Ship-to Contact")
        {
            field("Outlet Area"; "Outlet Area")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("Customer Posting Group"; "Customer Posting Group")
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
        addafter("Sales Person Name")
        {
            field("Created User"; "Created User")
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {

        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-JAGA 30/10/2018
                IF "Applies-to Doc. No." <> '' THEN
                    TESTFIELD("Your Reference");
                //CCIT-JAGA 30/10/2018
                //TESTFIELD(Structure);

                //CCIT-JAGA 30/10/2018
                IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                    ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');
                //CCIT-JAGA 30/10/2018
            end;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

                //CCIT-JAGA 30/10/2018
                IF "Applies-to Doc. No." <> '' THEN
                    TESTFIELD("Your Reference");
                //CCIT-JAGA 30/10/2018
                //TESTFIELD(Structure);
                //CCIT-JAGA 30/10/2018
                IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                    ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');
                //CCIT-JAGA 30/10/2018

            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }
        modify("Post and Email")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }

    }

    var
        SalesPersonName: Text[50];
        RecSPorP: Record 13;
        RecUserSetup: Record 91;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record 50029;



    trigger OnAfterGetRecord();
    begin
        //CCIT-JAGA
        CLEAR(SalesPersonName);
        IF RecSPorP.GET("Salesperson Code") THEN
            SalesPersonName := RecSPorP.Name;
        //CCIT-JAGA    
    end;


    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.

    trigger OnOpenPage()
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
}

