codeunit 50010 EventsSubscribers
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", 'OnAfterInsertLines', '', false, false)]
    local procedure OnAfterInsertLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    var
        SalesShptLine: Record "Sales Shipment Line";
        SH: Record "Sales Header";
    begin
        if SalesShptLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then begin
            SH.GET(1, SalesShptLine."Order No.");
            SalesHeader.Validate("Ship-to Code", SH."Ship-to Code");
            SalesHeader.Validate("Ship-to Address", SH."Ship-to Address");
            SalesHeader.Validate("Ship-to Address 2", SH."Ship-to Address 2");
            SalesHeader.Validate("Ship-to City", SH."Ship-to City");
            SalesHeader.Validate("Ship-to County", SH."Ship-to County");
            SalesHeader.Validate("Ship-to Post Code", SH."Ship-to Post Code");
            SalesHeader.Validate("Ship-to Country/Region Code", SH."Ship-to Country/Region Code");
            SalesHeader.Modify(true);
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    local procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header");
    var
        DGLE: Record "Detailed GST Ledger Entry";
    begin
        DGLE.Reset();
        DGLE.SetRange("Document No.", TransferShipmentHeader."No.");
        DGLE.SetRange("External Document No.", TransferShipmentHeader."Transfer Order No.");
        if DGLE.FindSet() then
            repeat
                DGLE."Original Doc Type" := DGLE."Original Doc Type"::"Transfer Shipment";
                DGLE.Modify();
            until DGLE.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnRunOnAfterInsertTransRcptLines', '', false, false)]
    local procedure OnRunOnAfterInsertTransRcptLines(TransRcptHeader: Record "Transfer Receipt Header"; TransferLine: Record "Transfer Line"; TransferHeader: Record "Transfer Header"; Location: Record Location; WhseReceive: Boolean);
    var
        DGLE: Record "Detailed GST Ledger Entry";
    begin
        DGLE.Reset();
        DGLE.SetRange("Document No.", TransRcptHeader."No.");
        if DGLE.FindSet() then
            repeat
                DGLE."Original Doc Type" := DGLE."Original Doc Type"::"Transfer Receipt";
                DGLE.Modify();
            until DGLE.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean);
    var
        DGLE: Record "Detailed GST Ledger Entry";
    begin
        if SalesCrMemoHdrNo <> '' then begin
            DGLE.Reset();
            DGLE.SetRange("Document No.", SalesCrMemoHdrNo);
            if DGLE.FindSet() then
                repeat
                    DGLE."Original Doc Type" := DGLE."Original Doc Type"::"Credit Memo";
                    DGLE.Modify();
                until DGLE.Next() = 0
        end else
            if SalesInvHdrNo <> '' then begin
                DGLE.Reset();
                DGLE.SetRange("Document No.", SalesInvHdrNo);
                if DGLE.FindSet() then
                    repeat
                        DGLE."Original Doc Type" := DGLE."Original Doc Type"::Invoice;
                        DGLE.Modify();
                    until DGLE.Next() = 0;
            end;
    end;
    //<<PCPL-064 09022023
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean);
    var
        DGLE: Record "Detailed GST Ledger Entry";
    begin
        if PurchCrMemoHdrNo <> '' then begin
            DGLE.Reset();
            DGLE.SetRange("Document No.", PurchCrMemoHdrNo);
            if DGLE.FindSet() then
                repeat
                    DGLE."Original Doc Type" := DGLE."Original Doc Type"::"Credit Memo";
                    DGLE.Modify();
                until DGLE.Next() = 0
        end else
            if PurchInvHdrNo <> '' then begin
                DGLE.Reset();
                DGLE.SetRange("Document No.", PurchInvHdrNo);
                if DGLE.FindSet() then
                    repeat
                        DGLE."Original Doc Type" := DGLE."Original Doc Type"::Invoice;
                        DGLE.Modify();
                    until DGLE.Next() = 0;
            end;
    end;
    //>>PCPL-064 09022023

    //
    var
        myInt: Integer;
}