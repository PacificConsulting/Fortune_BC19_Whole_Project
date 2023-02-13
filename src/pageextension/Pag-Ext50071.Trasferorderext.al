pageextension 50071 "Trasfer_order_ext" extends "Transfer Order"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621,CCIT-Fortune

    layout
    {
        modify("Transfer-to Code")
        {
            Visible = true;
            trigger OnAfterValidate()
            var
            //rectransferorder:Record 
            begin
                if StrLen(Rec."Transfer-from Code") >= 4 then begin
                    Loc := CopyStr(Rec."Transfer-from Code", StrLen(Rec."Transfer-from Code") - 3, 4);
                    if (Loc = 'MAIN') AND (Rec."Transfer-to Code" = 'SNOW BOND') then
                        Error('You cannot select "SNOW BOND" Location with any MAIN location');
                End else
                    Loc := Rec."Transfer-from Code";
            end;
        }
        modify("Transfer-from Code")
        {
            trigger OnAfterValidate()

            begin

                RecLocation.reset();
                RecLocation.SetRange(Code, rec."Transfer-from Code");
                if RecLocation.FindFirst then begin
                    Rec."Shortcut Dimension 1 Code" := RecLocation."Branch Code";
                    Rec.Modify();

                end;


            end;
        }

        addafter("In-Transit Code")
        {
            field("Date Filter"; "Date Filter")
            {
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Customer PO/SO No."; "External Document No.")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Customer PO/SO No.',
                            ENN = 'External Document No.';
            }
            field("Last Shipment No."; "Last Shipment No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {
            field("Last Receipt No."; "Last Receipt No.")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill No."; "E-Way Bill No.")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill Date"; "E-Way Bill Date")
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
            field("SNW Transfer No."; "JWL Transfer No.")
            {
                ApplicationArea = all;
                Caption = 'SNW Transfer No';
            }
            field("SNWTransfer Date"; "JWL Transfer Date")
            {
                ApplicationArea = all;
            }
            field("Transport Vendor"; "Transport Vendor")
            {
                ApplicationArea = all;
            }
            field("Customer PO/SO Date"; "Customer PO/SO Date")
            {
                ApplicationArea = all;
            }
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = all;
            }
            field("Created User"; "Created User")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Short Closed"; "Short Closed")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Customer License No."; "Customer License No.")
            {
                ApplicationArea = all;
            }
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    //CCIT-SG
                    NewTransferLines.RESET;
                    NewTransferLines.SETRANGE(NewTransferLines."Document No.", Rec."No.");
                    //NewTransferLines.SETRANGE(NewTransferLines."Storage Categories",Rec."Storage Categories");
                    IF NewTransferLines.FINDFIRST THEN
                        ERROR('Transfer Lines already Created...');
                    //CCIT-SG
                end;
            }
            field(Reserved; Reserved)
            {
                ApplicationArea = all;
                Editable = edit;
                trigger OnValidate();

                begin
                    //CCIT-SG

                    IF RecLoc.GET("Transfer-to Code") THEN BEGIN
                        IF RecLoc."Duty Free" = TRUE THEN BEGIN
                            IF Reserved = TRUE THEN BEGIN
                                RecTranLine.RESET;
                                RecTranLine.SETRANGE(RecTranLine."Document No.", "No.");
                                RecTranLine.SETRANGE("Customer No.", '');
                                IF RecTranLine.FINDFIRST THEN BEGIN
                                    Reserved := FALSE;
                                    Rec.MODIFY;
                                    edit := TRUE;
                                    COMMIT;
                                    ERROR('Customer No. Should not Blank');
                                END;

                                RecTranLine.RESET;
                                RecTranLine.SETRANGE(RecTranLine."Document No.", "No.");
                                IF RecTranLine.FINDFIRST THEN
                                    REPEAT
                                        RecTranLine.Reserved := TRUE;
                                        RecTranLine.MODIFY;
                                        edit := FALSE;
                                    UNTIL RecTranLine.NEXT = 0;

                            END;
                        END;
                    END;
                    //CCIT-SG


                end;
            }
            field("Calculate Custom Duty"; "Calculate Custom Duty")
            {
                ApplicationArea = all;
            }
            field("DF License Type"; "DF License Type")
            {
                ApplicationArea = all;
            }
            field("DF License Date"; "DF License Date")
            {
                ApplicationArea = all;
            }
            field("Customer License name"; "Customer License name")
            {
                ApplicationArea = all;
            }
            field("CHA Name"; "CHA Name")
            {
                ApplicationArea = all;
            }
            field("Ex Bond Order No."; "Ex Bond Order No.")
            {
                ApplicationArea = all;
            }
            field("Ex Bond Order Date"; "Ex Bond Order Date")
            {
                ApplicationArea = all;
            }
            field("Supplier PO No."; "Supplier PO No.")
            {
                ApplicationArea = all;
            }
            field("Supplier PO Date"; "Supplier PO Date")
            {
                ApplicationArea = all;
            }
            field("Supplier Name"; "Supplier Name")
            {
                ApplicationArea = all;
            }
            field("CHA Contact Person"; "CHA Contact Person")
            {
                ApplicationArea = all;
            }
            field("Supplier No."; "Supplier No.")
            {
                ApplicationArea = all;
            }
            field("Vehicle Reporting Date"; "Vehicle Reporting Date")
            {
                ApplicationArea = all;
            }
            field("Vehicle Reporting Time"; "Vehicle Reporting Time")
            {
                ApplicationArea = all;
            }
            field("Vehicle Release Time"; "Vehicle Release Time")
            {
                ApplicationArea = all;
            }
        }
        addafter(TransferLines)
        {
            group("Bond Details")
            {
                field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
                {
                    ApplicationArea = all;
                }
                field("ICA No."; "ICA No.")
                {
                    ApplicationArea = all;
                }
                field("In-Bond BOE Date"; "In-Bond BOE Date")
                {
                    ApplicationArea = all;
                }
                field("BL/AWB No."; "BL/AWB No.")
                {
                    ApplicationArea = all;
                }
                field("BL Date"; "BL Date")
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
                field("Ex-bond BOE No."; "Ex-bond BOE No.")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date"; "Ex-bond BOE Date")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.1"; "Ex-bond BOE No.1")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 1"; "Ex-bond BOE Date 1")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.2"; "Ex-bond BOE No.2")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 2"; "Ex-bond BOE Date 2")
                {
                    ApplicationArea = all;
                }
                group(Control1000000067)
                {
                    Visible = false;
                    field("Ex-bond BOE No.3"; "Ex-bond BOE No.3")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 3"; "Ex-bond BOE Date 3")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE No.4"; "Ex-bond BOE No.4")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 4"; "Ex-bond BOE Date 4")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE No.5"; "Ex-bond BOE No.5")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 5"; "Ex-bond BOE Date 5")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE No.6"; "Ex-bond BOE No.6")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 6"; "Ex-bond BOE Date 6")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE No.7"; "Ex-bond BOE No.7")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 7"; "Ex-bond BOE Date 7")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE No.8"; "Ex-bond BOE No.8")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 8"; "Ex-bond BOE Date 8")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE No.9"; "Ex-bond BOE No.9")
                    {
                        ApplicationArea = all;
                    }
                    field("Ex-bond BOE Date 9"; "Ex-bond BOE Date 9")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    actions
    {
        //Unsupported feature: CodeInsertion on "Action 59". Please convert manually.
        modify("Re&lease")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-SG
                //TESTFIELD(Structure);// rdk
                //blocked by rdk 250619
                IF RecLoc1.GET("Transfer-from Code") THEN
                    FromStateCode := RecLoc1."State Code";
                IF RecLoc1.GET("Transfer-to Code") THEN
                    ToStateCode := RecLoc1."State Code";
                IF NOT (FromStateCode = ToStateCode) THEN
                    //TESTFIELD(Structure);

                TESTFIELD("External Document No.");
                TESTFIELD("Order Date");
                //CCIT-SG
                //pcpl064

                // rdk230919 -
                RecExBond.RESET;
                RecExBond.SETRANGE("Ex-Bond Entry No.", "Ex-bond BOE No.");
                IF RecExBond.FINDFIRST THEN BEGIN
                    RecExBond."Ex-Bond Entry Date" := "Ex Bond Order Date";
                    RecExBond."In-Bond Entry No." := "In-Bond Bill of Entry No.";
                    RecExBond.MODIFY;
                END
                ELSE BEGIN
                    RecExBond.INIT;
                    RecExBond."Ex-Bond Entry No." := "Ex-bond BOE No.";
                    RecExBond."Ex-Bond Entry Date" := "Ex-bond BOE Date";
                    RecExBond."In-Bond Entry No." := "In-Bond Bill of Entry No.";
                    RecExBond.INSERT;
                END;
                // rdk230919 +

            end;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            trigger OnBeforeAction()
            begin
                TESTFIELD("Shortcut Dimension 1 Code");//CCIT-SG-12062018
                                                       //Vikas 29-07-2021
                IF FromLoc.GET("Transfer-from Code") THEN BEGIN
                    IF ToLoc.GET("Transfer-to Code") THEN BEGIN
                        IF FromLoc."State Code" <> ToLoc."State Code" THEN
                            CheckGST;
                    END;
                END;
                //Vikas 29-07-2021

            end;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                // //CCIT-PRI-191118
                // ERROR('You do not have following permission');
                // //CCIT-PRI-191118


                //CCIT-SG
                IF RecLoc1.GET("Transfer-from Code") THEN
                    FromStateCode := RecLoc1."State Code";
                IF RecLoc1.GET("Transfer-to Code") THEN
                    ToStateCode := RecLoc1."State Code";
                IF FromStateCode <> ToStateCode THEN;


                //TESTFIELD(Structure);

            END;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have following permission');
                //CCIT-PRI-191118
            end;
        }




        addafter(Dimensions)
        {
            action("Create Transfer Lines")
            {
                ApplicationArea = all;
                trigger OnAction();
                begin
                    //CCIT-SG
                    RecItem.RESET;
                    RecItem.SETRANGE(RecItem."Storage Categories", Rec."Storage Categories");
                    RecItem.SETRANGE(RecItem.Blocked, FALSE);
                    //RecItem.SETFILTER(RecItem.Inventory,'<>%1',0);
                    IF NOT RecItem.FINDSET THEN BEGIN
                        ERROR('No Items Found For this Storage Category');
                    END ELSE
                        REPEAT
                            NewTransferLines.RESET;
                            NewTransferLines.SETRANGE(NewTransferLines."Document No.", Rec."No.");
                            IF NewTransferLines.FINDLAST THEN;
                            NewTransferLines.INIT;
                            NewTransferLines."Line No." += 10000;
                            NewTransferLines."Item No." := RecItem."No.";

                            //VALIDATE(NewTransferLines."Item No.",RecItem."No.");
                            NewTransferLines."Document No." := Rec."No.";
                            NewTransferLines."Unit of Measure Code" := RecItem."Base Unit of Measure";
                            NewTransferLines.Description := RecItem.Description;
                            NewTransferLines."Item Category Code" := RecItem."Item Category Code";
                            NewTransferLines."Conversion UOM" := RecItem."Conversion UOM";
                            NewTransferLines."Gen. Prod. Posting Group" := RecItem."Gen. Prod. Posting Group";
                            NewTransferLines."Storage Categories" := RecItem."Storage Categories";
                            NewTransferLines.VALIDATE(Quantity);
                            NewTransferLines.VALIDATE("Item No.");
                            NewTransferLines.INSERT(TRUE);
                            StorageCategoryEditable := FALSE;
                        //No := NewTransferLines.COUNT;
                        UNTIL RecItem.NEXT = 0;
                    //MESSAGE(' Count %1',No);
                    //CCIT-SG
                end;
            }
        }
        addafter("&Print")
        {
            action(PickList)
            {
                ApplicationArea = all;
                trigger OnAction();
                begin
                    RecWAH.RESET;
                    RecWAH.SETRANGE(RecWAH."No.", "No.");
                    REPORT.RUNMODAL(50012, TRUE, FALSE, RecWAH);
                end;
            }
            action("Ex Bond Transfer Order")
            {
                Promoted = true;
                ApplicationArea = all;

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
            action("Short Closed1")
            {
                Image = PostOrder;
                ApplicationArea = all;
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
                    "Short Closed" := TRUE;
                    IF "Short Closed" = TRUE THEN;
                    //IsEditable := FALSE ;
                end;
            }
        }

    }

    var
        Loc: Text;
        FromLoc: Record 14;
        ToLoc: Record 14;
        RecLoc: Record 14;
        RecTranLine: Record 5741;
        edit: Boolean;
        RecTranLine1: Record 5741;
        RecLoc1: Record 14;
        RecLoc2: Record 14;
        RecWAH: Record 5766;
        NewTransferLines: Record 5741;
        RecItem: Record 27;
        No: Integer;
        StorageCategoryEditable: Boolean;
        FromStateCode: Code[20];
        ToStateCode: Code[20];
        TrnasferLine: Record 5741;
        Text003: Label 'Do you want to Short Close Transfer Order %1 ?';
        RecTH: Record 5740;
        TL: Record 5741;
        RecExBond: Record 50012;
        FromLocation: Record 14;
        ToLocation: Record 14;
        StructureEditable: Boolean;
        RecLocation: Record 14;


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin
        //"Order Date" := TODAY; //CCIT-SG
        StructureEditable := TRUE;
        IF FromLocation.GET("Transfer-from Code") THEN BEGIN
            IF ToLocation.GET("Transfer-to Code") THEN BEGIN
                IF FromLocation."State Code" = ToLocation."State Code" THEN
                    StructureEditable := FALSE;
            END;
        END;
        // FILTERGROUP(2);
        // SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
        // FILTERGROUP(0);
    end;



    trigger OnOpenPage();
    begin
        IF NOT Reserved THEN
            edit := TRUE
        ELSE
            edit := FALSE;

        // FILTERGROUP(2);
        // SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
        // FILTERGROUP(0);
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer);
    var
        ItemCheckAvail: Codeunit 311;
    begin
        /*IF (CurrFieldNo <> 0) AND
           (CurrFieldNo = CalledByFieldNo) AND
           ("Item No." <> '') AND
           ("Outstanding Quantity" > 0)
        THEN
          IF ItemCheckAvail.TransferLineCheck(Rec) THEN
            ItemCheckAvail.RaiseUpdateInterruptedError;
          */

    end;

    local procedure CheckGST();
    var
        RecTransferLine: Record 5741;
        SalesOrder: Page "Sales Order";
    begin
        RecTransferLine.RESET();
        RecTransferLine.SETRANGE("Document No.", "No.");
        RecTransferLine.SETRANGE("Derived From Line No.", 0);
        RecTransferLine.SETFILTER("Quantity Shipped", '>%1', 0);
        RecTransferLine.SETFILTER("Qty. to Receive", '>%1', 0);
        IF RecTransferLine.FIND('-') THEN
            REPEAT
            //RecTransferLine.TESTFIELD("Total GST Amount");


            UNTIL RecTransferLine.NEXT = 0;

    end;
}

