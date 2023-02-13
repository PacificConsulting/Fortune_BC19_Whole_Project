pageextension 50234 Transfer_List_Ext extends "Transfer Orders"
{
    // version NAVW19.00.00.46621,CCIT-Fortune

    layout
    {
        addafter("Shipment Date")
        {

            field("Last Date And Time"; "Last Date And Time")
            {
                ApplicationArea = all;
            }


            field("External Document No."; "External Document No.")
            {
                CaptionML = ENU = 'Customer SO/PO No.',
                            ENN = 'External Document No.';
                ApplicationArea = all;
            }
            field("Last Shipment No."; "Last Shipment No.")
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

            field("Short Closed1"; "Short Closed")
            {
                Editable = false;
                ApplicationArea = all;
            }

            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
            }

            field("Created User"; "Created User")
            {
                ApplicationArea = all;
            }
            field("Seal No."; "Seal No.")
            {
                ApplicationArea = all;
            }
            field("Load Type"; "Load Type")
            {
                ApplicationArea = all;
            }
            field(PutAwayCreated; PutAwayCreated)
            {
                ApplicationArea = all;
            }
            field(PickListCreated; PickListCreated)
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {


        modify(Post)
        {
            trigger OnAfterAction()
            begin

                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnAfterAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118
            end;


        }



        addafter("&Print")
        {
            action("Ex Bond Transfer Order")
            {
                Promoted = true;

                trigger OnAction();
                begin
                    RecTH.RESET;
                    RecTH.SETRANGE(RecTH."No.", "No.");
                    IF RecTH.FINDFIRST THEN
                        REPORT.RUNMODAL(50070, TRUE, FALSE, RecTH);
                end;
            }
        }
        addafter("Reo&pen")
        {
            action("Short Closed")
            {
                Image = PostOrder;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //CCIT-SG
                    RecWAH.RESET;
                    RecWAH.SETRANGE(RecWAH."Source No.", "No.");
                    IF RecWAH.FINDFIRST THEN
                        ERROR('Warehouse Activity Lines are Created first deleted that and then Short Cloesd.');
                    //CCIT-SG

                    //CCIT-PRI
                    IF NOT CONFIRM(Text003, FALSE, "No.") THEN
                        EXIT;

                    TrnasferLine.RESET;
                    TrnasferLine.SETRANGE(TrnasferLine."Document No.", "No.");
                    TrnasferLine.SETFILTER(TrnasferLine."Qty. to Ship", '<>%1', 0);
                    IF TrnasferLine.FINDFIRST THEN
                        REPEAT
                            TrnasferLine."Outstanding Quantity" := 0;
                            TrnasferLine."Outstanding Quantity In KG" := 0;
                            TrnasferLine."Outstanding Qty. (Base)" := 0;
                            TrnasferLine.MODIFY;
                        UNTIL TrnasferLine.NEXT = 0;
                    //CCIT-PRI
                    Rec."Short Closed" := TRUE;
                    Rec.MODIFY;
                    //IF "Short Closed" = TRUE THEN
                    //IsEditable := FALSE ;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FILTERGROUP(2);
        SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
        FILTERGROUP(0);
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
        FILTERGROUP(0);
    end;


    var
        Text003: Label 'Do you want to Short Close Transfer Order %1 ?';
        TrnasferLine: Record 5741;
        RecWAH: Record 5766;
        LocCode: Code[1024];
        RecTH: Record 5740;
        RecUserBranch: Record 50029;
        LocCodeText: Text[1024];
        RecUserSetup: Record 91;
        ClearHide: Boolean;



}

