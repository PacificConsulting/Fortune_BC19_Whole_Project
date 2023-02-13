pageextension 50074 "Posted_tra_Shpt_Sub_ext" extends "Posted Transfer Shpt. Subform"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    layout
    {
        addafter("Variant Code")
        {
            field(Exempted; Exempted)
            {
                ApplicationArea = all;
            }
        }

        addafter(Quantity)
        {
            field("Transfer From Reason Code"; "Transfer From Reason Code")
            {
                ApplicationArea = all;
            }
            field("Customer License No."; "Customer License No.")
            {
                ApplicationArea = all;
            }
            field("Unit Price"; "Unit Price")
            {
                ApplicationArea = all;
            }
            field("Unit Volume"; "Unit Volume")
            {
                ApplicationArea = all;
            }
            field("Customer License Name"; "Customer License Name")
            {
                ApplicationArea = all;
            }
            field("Customer License Date"; "Customer License Date")
            {
                ApplicationArea = all;
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("No. of Boxes"; "No. of Boxes")
            {
                ApplicationArea = all;
            }
            field("License No."; "License No.")
            {
                ApplicationArea = all;
            }
            field(Weight; Weight)
            {
                ApplicationArea = all;
            }
            field("Conversion Qty"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'Conversion Qty In PCS';
            }
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
            }
            field(Reserved; Reserved)
            {
                ApplicationArea = all;
            }
            field("Transfer Serial No."; "Transfer Serial No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Undo Transfer Shipment")
            {
                CaptionML = ENU = 'Undo Transfer Shipment',
                            ENN = '&Undo Receipt';
                ApplicationArea = all;

                trigger OnAction();
                var
                    TransReceiptHeader: Record 5746;
                    TransShipLine: Record 5745;
                begin
                    /*
                    TransShipLine.RESET;
                    TransShipLine.SETRANGE(TransShipLine."Document No.",Rec."Document No.");
                    TransShipLine.SETRANGE(TransShipLine."Line No.",Rec."Line No.");
                    //TransShipLine.SETRANGE(TransShipLine."Transfer Order No.",Rec."Transfer Order No.");
                    IF TransShipLine.FINDFIRST THEN
                      //UndoShipmentLine
                      REPORT.RUNMODAL(REPORT::"Undo Transfer Shipment Line",TRUE,FALSE,TransShipLine)
                    */
                    TransReceiptHeader.RESET;
                    TransReceiptHeader.SETRANGE(TransReceiptHeader."Transfer Order No.", Rec."Transfer Order No.");
                    IF NOT TransReceiptHeader.FINDFIRST THEN
                        UndoShipmentLine
                    ELSE
                        ERROR('Transfer order allready Received....');

                end;
            }
        }
    }

    var
    //CUUndoTransferShip: Codeunit 50003; //PCPL/MIG/NSW

    local procedure UndoShipmentLine();
    var
        TransShipLine: Record 5745;
        TransReceiptHeader: Record 5746;
    begin
        //TransShipLine.COPY(Rec);
        //CurrPage.SETSELECTIONFILTER(TransShipLine);
        //CODEUNIT.RUN(CODEUNIT::"Undo Transfer Shipment Line",TransShipLine);

        UndoNewShipmentLine(Rec);
    end;

    procedure UndoNewShipmentLine(OldTransShptLine: Record 5745);
    var
        NewTransShptLine: Record 5745;
        //DetailRG23D: Record 16533;
        //DetailRG23DUndo: Record 16533;
        EntryNo: Integer;
        NewItemLedgerEntry: Record 32;
        NewItemLedgerEntry1: Record 32;
        TransShipHeader: Record 5744;
        LastILE: Record 32;
        lastTransfShipLine: Record 5745;
    begin
        lastTransfShipLine.RESET;
        lastTransfShipLine.SETRANGE("Document No.", OldTransShptLine."Document No.");
        lastTransfShipLine.FINDLAST;

        NewTransShptLine.INIT;
        NewTransShptLine.TRANSFERFIELDS(OldTransShptLine);
        NewTransShptLine."Line No." := lastTransfShipLine."Line No." + 10000;
        //NewTransShptLine."Item Shpt. Entry No." := ItemShptEntryNo;
        NewTransShptLine.Quantity := -OldTransShptLine.Quantity;
        NewTransShptLine."Unit Price" := -OldTransShptLine."Unit Price";
        NewTransShptLine."Conversion Qty" := -OldTransShptLine."Conversion Qty";
        IF NewTransShptLine.INSERT THEN BEGIN
            NewItemLedgerEntry.RESET;
            NewItemLedgerEntry.SETRANGE("Document Type", NewItemLedgerEntry."Document Type");
            NewItemLedgerEntry.SETRANGE("Document No.", OldTransShptLine."Document No.");
            NewItemLedgerEntry.SETRANGE("Document Line No.", OldTransShptLine."Line No.");
            IF NewItemLedgerEntry.FINDFIRST THEN
                REPEAT
                    LastILE.RESET;
                    LastILE.FINDLAST;

                    NewItemLedgerEntry1.INIT;
                    NewItemLedgerEntry1.TRANSFERFIELDS(NewItemLedgerEntry);
                    NewItemLedgerEntry1."Entry No." := LastILE."Entry No." + 1;
                    NewItemLedgerEntry1."Document Line No." := NewTransShptLine."Line No.";
                    NewItemLedgerEntry1.Quantity := (-1) * NewItemLedgerEntry1.Quantity;
                    NewItemLedgerEntry1.INSERT;

                UNTIL NewItemLedgerEntry.NEXT = 0;
        END;

    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

