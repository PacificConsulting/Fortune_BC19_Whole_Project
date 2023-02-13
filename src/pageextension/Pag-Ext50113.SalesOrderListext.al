pageextension 50113 "Sales_Order_List_ext" extends "Sales Order List"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {


        // moveafter("No."; "Posting Date")
        //movebefore("External Document No."; Status)




        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; "Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }

        }
        addafter("External Document No.")
        {
            field("Outstanding Quantity PCS"; rec."Outstanding Quantity PCS")
            {
                ApplicationArea = all;
            }
            field("Outstanding Quantity KG"; "Outstanding Quantity KG")
            {
                ApplicationArea = all;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }

        }
        addafter("Posting Date")
        {
            field(PutAwayCreated; PutAwayCreated)
            {
                Caption = 'Pick List Created';
                ApplicationArea = all;
            }

            field("Sales Person Name"; SalesPersonName)
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("Created User"; "Created User")
            {
                ApplicationArea = all;


            }
        }
        addafter("Currency Code")
        {
            field("Short Closed"; "Short Closed")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Customer Posting Group"; "Customer Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("Promised Delivery Date"; "Promised Delivery Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipping Advice")
        {
            field("Outlet Area"; "Outlet Area")
            {
                ApplicationArea = all;

            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Post Batch Selection"; "Post Batch Selection")
            {
                ApplicationArea = all;
            }

            field("Last Date And Time"; "Last Date And Time")
            {
                ApplicationArea = all;
            }

        }



    }

    actions
    {


        modify("In&vt. Put-away/Pick Lines")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-SG-21022018
                RecWAH.RESET;
                RecWAH.SETRANGE(RecWAH."Source No.", Rec."No.");
                RecWAH.SETFILTER(RecWAH."Source Document", '%1', RecWAH."Source Document"::"Sales Order");
                IF NOT "Short Closed" THEN;

                IF "Short Closed" then
                    ERROR('You can not open this Pick List because This Sales Order Already Short Closed..');
                //CCIT-SG-21022018

            end;

        }
        modify("Create Inventor&y Put-away/Pick")
        {
            trigger OnBeforeAction()
            begin
                IF NOT "Short Closed" THEN;
                IF "Short Closed" = false then
                    ERROR('You can not create the Pick List Because This SO is Short Closed');
            end;

        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

                IF NOT "Short Closed" THEN BEGIN
                    //CCIT-JAGA
                    RecDate.GET(RecDate."Period Type"::Date, "Posting Date");

                    AllowPost := FALSE;

                    IF Rec.Sunday = TRUE THEN
                        IF RecDate."Period Name" = 'Sunday' THEN
                            AllowPost := TRUE;
                    IF Rec.Monday = TRUE THEN
                        IF RecDate."Period Name" = 'Monday' THEN
                            AllowPost := TRUE;
                    IF Rec.Tuesday = TRUE THEN
                        IF RecDate."Period Name" = 'Tuesday' THEN
                            AllowPost := TRUE;
                    IF Rec.Wednesday = TRUE THEN
                        IF RecDate."Period Name" = 'Wednesday' THEN
                            AllowPost := TRUE;
                    IF Rec.Thursday = TRUE THEN
                        IF RecDate."Period Name" = 'Thursday' THEN
                            AllowPost := TRUE;
                    IF Rec.Friday = TRUE THEN
                        IF RecDate."Period Name" = 'Friday' THEN
                            AllowPost := TRUE;
                    IF Rec.Saturday = TRUE THEN
                        IF RecDate."Period Name" = 'Saturday' THEN
                            AllowPost := TRUE;

                    IF AllowPost OR ((AllowPost = FALSE) AND ("Route Days Applicable" = FALSE)) THEN BEGIN
                        IF RecCust.GET(Rec."Sell-to Customer No.") THEN BEGIN
                            IF RecCust.Referance = TRUE THEN BEGIN
                                ERROR('Customer PO/SO No. must have value in Sales Header.');
                            END;


                        END ELSE
                            ERROR('Day is not matching');
                    END;
                END ELSE BEGIN
                    ERROR('You can not post Short Closed SO');
                END;
                //CCIT-JAGA

            end;

        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

                //CCIT-SG
                RecSH1.RESET;
                RecSH1.SETRANGE(RecSH1."Post Batch Selection", TRUE);
                IF RecSH1.FINDSET THEN
                    REPEAT
                        //REPORT.RUNMODAL(REPORT::"Batch Post Sales Orders", TRUE, TRUE, RecSH1);
                        CurrPage.UPDATE(FALSE);
                    UNTIL RecSH1.NEXT = 0;
                //CCIT-SG

            end;

        }

        addafter("Prepayment Credi&t Memos")
        {
            action(TaxInvoice)
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    /*
                    //CCIT_SG
                    RecPH.RESET;
                    RecPH.SETRANGE(RecPH."No.","No.");
                    REPORT.RUNMODAL(50007,TRUE,FALSE,RecPH);
                    //CCIT-SG
                    
                    */
                    RecSH.RESET;
                    RecSH.SETRANGE(RecSH."No.", "No.");
                    REPORT.RUNMODAL(50048, TRUE, FALSE, RecSH);

                end;
            }
            group(Process)
            {
                CaptionML = ENU = 'Process',
                            ENN = 'P&osting';
                Image = Post;
                action("Short Closed1")
                {
                    Caption = 'Short Closed';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        TESTFIELD("ShortClose Reason Code");
                        //CCIT-SG
                        RecWAH.RESET;
                        RecWAH.SETRANGE(RecWAH."Source No.", "No.");
                        IF RecWAH.FINDFIRST THEN
                            ERROR('Warehouse Activity Lines are Created first deleted that and then Short Cloesd.');
                        //CCIT-SG

                        //CCIT-PRI
                        IF NOT CONFIRM(Text003, FALSE, "No.") THEN
                            EXIT;

                        RecSL.RESET;
                        RecSL.SETRANGE(RecSL."Document No.", "No.");
                        RecSL.SETFILTER(RecSL."Qty. to Ship", '<>%1', 0);
                        IF RecSL.FINDFIRST THEN
                            REPEAT
                                RecSL."Outstanding Quantity" := 0;
                                RecSL."Outstanding Qty. (Base)" := 0;
                                RecSL."Outstanding Quantity In KG" := 0;
                                RecSL.MODIFY;
                            UNTIL RecSL.NEXT = 0;
                        Rec."Short Closed" := TRUE;
                        Rec.MODIFY;
                        //CCIT-PRI

                        //COMMIT;
                    end;
                }
            }
            group("Clear Filter")
            {
                Enabled = ClearHide;
            }
        }
        addafter("Work Order")
        {
            action("Sales Order")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //CCIT-SG
                    RecSH1.RESET;
                    RecSH1.SETRANGE(RecSH1."No.", "No.");
                    REPORT.RUNMODAL(50008, TRUE, FALSE, RecSH1);
                    //CCIT-SG
                end;
            }
        }
        addafter("Print Confirmation")
        {
            group(Clear)
            {
                Caption = 'Clear';
                Enabled = ClearHide;

            }
        }
        addafter("&Print")
        {
            action("Print Confirmation 1")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RecSH1.RESET;
                    RecSH1.SETRANGE(RecSH1."No.", "No.");
                    REPORT.RUNMODAL(50123, TRUE, FALSE, RecSH1);
                end;
            }
        }


    }

    var
        RecUserSetup: Record 91;
        RecSH: Record 36;
        RecSH1: Record 36;
        SalesPersonName: Text[100];
        RecSaleaPerson: Record 13;
        Text001: TextConst ENU = 'Do you want to change %1 in all related records in the warehouse?', ENN = 'Do you want to change %1 in all related records in the warehouse?';
        ShortClosed: Boolean;
        RecDate: Record 2000000007;
        AllowPost: Boolean;
        RecCust: Record 18;
        RecSH2: Record 36;
        RecWAH: Record 5766;
        Text003: Label 'Do you want to Short Close Sales Order %1 ?';
        RecSL: Record 37;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecCust1: Record 18;
        CustBal: Decimal;
        CustCreditLimit: Decimal;


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin

        SalesPersonName := '';
        IF RecSaleaPerson.GET("Salesperson Code") THEN BEGIN
            SalesPersonName := RecSaleaPerson.Name;
            // MESSAGE('%1',RecSaleaPerson.Name);
            FILTERGROUP(2);
            SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
            FILTERGROUP(0);
        END;

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
            FILTERGROUP(2);
            SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
            SETFILTER("Location Code", LocCodeText);
            FILTERGROUP(0);
        END;
        IF LocCodeText <> '' THEN
            ClearHide := FALSE
        ELSE
            ClearHide := TRUE;
        //CCIT-SG-05062018
        //CCIT-SG
        IF RecUserSetup.GET(USERID) THEN BEGIN
            IF RecUserSetup.Location <> '' THEN BEGIN
                //FILTERGROUP(2);
                SETRANGE(State, RecUserSetup.Location);
                SetFilter("Short Closed", '%1', false); //PCPL/NSW/07 30May22
                //FILTERGROUP(0);
            END;
        END;
        //CCIT-SG

        //CCIT
        IF "Short Closed" = FALSE THEN
            ShortClosed := TRUE;
        //CCIT


    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

