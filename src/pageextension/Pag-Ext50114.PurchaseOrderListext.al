pageextension 50114 "Purchase_Order_List_ext" extends "Purchase Order List"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621,CCIT-Fortune

    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Ship-to Country/Region Code")
        {
            field(PutAwayCreated; PutAwayCreated)
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field(Receive; Receive)
            {
                ApplicationArea = all;
            }
            field(Invoice; Invoice)
            {
                ApplicationArea = all;
            }
            field("Outstanding Quantity In KG"; "Outstanding Quantity In KG")
            {
                ApplicationArea = all;
            }
            field("Outstanding Quantity In PCS"; "Outstanding Quantity In PCS")
            {
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")
        {
            field("PO Date"; "Order Date")
            {
                CaptionML = ENU = 'PO Date',
                            ENN = 'Order Date';
                ApplicationArea = all;
            }

            field("<Ship By Date-Vendor>"; "Ship By Date")
            {
                Caption = 'Ship By Date-Vendor';
                ApplicationArea = all;
            }
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = all;
            }
            field("ETD - Origin Port"; "ETD - Origin Port")
            {
                ApplicationArea = all;
            }
            field("ETA - Destination Port"; "ETA - Destination Port")
            {
                ApplicationArea = all;
            }
            field("ETA - Availability for Sale"; "ETA - Availability for Sale")
            {
                ApplicationArea = all;
            }
            field("Created User"; "Created User")
            {
                ApplicationArea = all;
            }
            field("Transport Method"; "Transport Method")
            {
                ApplicationArea = all;
            }
        }
        addafter("Job Queue Status")
        {
            field("Short Closed"; "Short Closed")
            {
                ApplicationArea = all;
            }
            field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
            {
                ApplicationArea = all;
            }
            field("In-Bond BOE Date"; "In-Bond BOE Date")
            {
                ApplicationArea = all;
            }
            field("Bond Number"; "Bond Number")
            {
                ApplicationArea = all;
            }
            field("Bond Sr.No."; "Bond Sr.No.")
            {
                ApplicationArea = all;
            }
            field("Bond Date"; "Bond Date")
            {
                ApplicationArea = all;
            }
            field("BL/AWB No."; "BL/AWB No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Invoice No."; "Vendor Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Invoiced Date"; "Vendor Invoiced Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118
            end;
        }
        modify(PostBatch)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118
            end;
        }


        addafter("Whse. Receipt Lines")
        {

            action(GRN)
            {
                ApplicationArea = all;
                trigger OnAction();
                begin
                    //CCIT_SG
                    RECPRH.RESET;
                    RECPRH.SETRANGE(RECPRH."Order No.", "No.");
                    REPORT.RUNMODAL(50011, TRUE, FALSE, RECPRH);
                    //CCIT-SG
                end;
            }
        }
        addafter(Reopen)
        {
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
                    TESTFIELD("Short Closed Reason Code");//CCIT-12092019
                    //CCIT-SG
                    RecWAH.RESET;
                    RecWAH.SETRANGE(RecWAH."Source No.", "No.");
                    IF RecWAH.FINDFIRST THEN
                        ERROR('Warehouse Activity Lines are Created first deleted that and then Short Cloesd.');
                    //CCIT-SG
                    //CCIT-PRI
                    IF NOT CONFIRM(Text001, FALSE, "No.") THEN
                        EXIT;

                    RecPL.RESET;
                    RecPL.SETRANGE(RecPL."Document No.", "No.");
                    //RecPL.SETFILTER(RecPL."Qty. to Receive",'<>%1',0) ;
                    IF RecPL.FINDFIRST THEN
                        REPEAT
                            RecPL."Outstanding Quantity" := 0;
                            RecPL."Outstanding Qty. (Base)" := 0;
                            RecPL."Outstanding Quantity In KG" := 0;
                            RecPL.MODIFY;
                        UNTIL RecPL.NEXT = 0;
                    Rec."Short Closed" := TRUE;
                    Rec.MODIFY;
                end;
            }
        }
        addafter(RemoveFromJobQueue)
        {
            action("Purchase Order")
            {
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //CCIT_SG
                    RecPH.RESET;
                    RecPH.SETRANGE(RecPH."No.", "No.");
                    REPORT.RUNMODAL(50007, TRUE, FALSE, RecPH);
                    //CCIT-SG
                end;
            }
            action("Purchase Order Before POST")
            {
                Promoted = false;

                trigger OnAction();
                begin
                    //CCIT-SG
                    RecPH.RESET;
                    RecPH.SETRANGE(RecPH."No.", "No.");
                    REPORT.RUNMODAL(50017, TRUE, FALSE, RecPH);
                    //CCIT-SG
                end;
            }
        }
    }

    var
        RecPH: Record 38;
        RECPRH: Record 120;
        Text001: Label 'Do you want to Short Close Purchase Order %1 ?';
        RecPL: Record 39;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[200];
        RecWAH: Record 5766;


    //Unsupported feature: CodeInsertion on "OnDeleteRecord". Please convert manually.

    //trigger OnDeleteRecord() : Boolean;
    //begin
    /*
    ERROR('You don''t have permission');
    */
    //end;


    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.

    //trigger OnOpenPage();
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;

    JobQueueActive := PurchasesPayablesSetup.JobQueueActive;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetSecurityFilterOnRespCenter;
    JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

    {//CCIT-SG-05062018
    LocCode := '';
    RecUserBranch.RESET;
    RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
    IF RecUserBranch.FINDFIRST THEN
      REPEAT
        IF RecUserBranch."Location Code" <> '' THEN
        LocCode := LocCode + RecUserBranch."Location Code" + '|';
      UNTIL RecUserBranch.NEXT=0;
    LocCodeText := DELSTR(LocCode,STRLEN(LocCode),1);
    IF LocCodeText <> '' THEN BEGIN
      SETFILTER("Location Code",LocCodeText);
    END;
    IF LocCodeText <> '' THEN
      ClearHide := FALSE
    ELSE
      ClearHide := TRUE;}
    //CCIT-SG-05062018
    */
    //end;

    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

