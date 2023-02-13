pageextension 50022 Purchase_Invoice_ext extends "Purchase Invoice"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    layout
    {

        modify("Buy-from Vendor Name")
        {
            Editable = false;
        }



        addafter("Location Code")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document Date")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = all;
                Editable = true;
            }

        }

        addafter("Purchaser Code")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }
            field("Receiving No. Series"; "Receiving No. Series")
            {
                ApplicationArea = all;
            }
        }
        addafter("Job Queue Status")
        {
            field("Port of Loading-Air"; "Port of Loading-Air")
            {
                ApplicationArea = all;
            }
            field("Port of Loading-Ocean"; "Port of Loading-Ocean")
            {
                ApplicationArea = all;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
            field("Port of Destination-Air"; "Port of Destination-Air")
            {
                ApplicationArea = all;
            }
            field("Port of Destination-Ocean"; "Port of Destination-Ocean")
            {
                ApplicationArea = all;
            }
            field("Bill Of Lading No."; "Bill Of Lading No.")
            {
                ApplicationArea = all;
            }
            field("Container Filter"; "Container Filter")
            {
                ApplicationArea = all;
            }
            field("ETD - Supplier Warehouse"; "ETD - Supplier Warehouse")
            {
                ApplicationArea = all;
            }
            field("ETD - Origin Port"; "ETD - Origin Port")
            {
                ApplicationArea = all;
            }
            field("Container Number"; "Container Number")
            {
                ApplicationArea = all;
            }
            field("Container Seal No."; "Container Seal No.")
            {
                ApplicationArea = all;
            }
            field("ETA - Destination Port"; "ETA - Destination Port")
            {
                ApplicationArea = all;
            }
            field("ETA - Destination CFS"; "ETA - Destination CFS")
            {
                ApplicationArea = all;
            }
            field("ETA - Bond"; "ETA - Bond")
            {
                ApplicationArea = all;
            }
            field("ETA - Availability for Sale"; "ETA - Availability for Sale")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                TESTFIELD("Shortcut Dimension 1 Code");//CCIT-SG-26032018
            end;
        }
        modify("Re&lease")
        {
            trigger OnBeforeAction()
            var
                Vend: Record 23;
                PurchLine: Record 39;
            begin
                //<<PCPL/MIG/NSW 25May22
                IF Vend.GET("Buy-from Vendor No.") then begin

                    IF vend."Applicability of 206AB" = vend."Applicability of 206AB"::Comply then begin
                        PurchLine.Reset();
                        PurchLine.SetRange("Document No.", "No.");
                        IF PurchLine.FindSet() then
                            repeat
                                PurchLine.TestField("TDS Section");
                            until PurchLine.Next = 0;
                    end;
                end;
                //>>PCPL/MIG/NSW 25May22

                //PCPL-0070 22Dec2022 <<
                GetGSTAmountTotal(Rec, TotalGSTAmount1);
                GSTTDSAmountTotal(Rec, TotalTDSAmt);

                Rec."TDS Amount" := TotalTDSAmt;
                Rec."GST Amount" := TotalGSTAmount1;
                //PCPL-0070 22Dec2022 >>
            end;
        }
    }
    //PCPL-0070 22Dec2022 <<
    procedure GetGSTAmountTotal(
              PurchHeader1: Record 38;
              var GSTAmount: Decimal)
    var
        PurchLine1: Record 39;
    begin
        Clear(GSTAmount);
        PurchLine1.SetRange("Document no.", PurchHeader1."No.");
        if PurchLine1.FindSet() then
            repeat
                GSTAmount += GetGSTAmount11(PurchLine1.RecordId());
            until PurchLine1.Next() = 0;
    end;

    local procedure GetGSTAmount11(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then begin
            TaxTransactionValue.CalcSums(Amount);
            TaxTransactionValue.CalcSums(Percent);

        end;
        exit(TaxTransactionValue.Amount);
    end;

    Procedure GSTTDSAmountTotal(PurchHdr: Record 38; var TDSAmount: Decimal)
    var
        PurchLine2: Record 39;
        TDSManagement: Codeunit "TDS Entity Management";
        i: Integer;
        RecordIDList: List of [RecordID];
    begin
        PurchLine2.SetRange("Document No.", "No.");
        if PurchLine2.FindSet() then
            repeat
                RecordIDList.Add(PurchLine2.RecordId());
            until PurchLine2.Next() = 0;

        for i := 1 to RecordIDList.Count() do begin
            TDSAmount += GetTDSAmount(RecordIDList.Get(i));
        end;
        TDSManagement.RoundTDSAmount(TDSAmount)
    end;

    local procedure GetTDSAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        PurchaseLine: Record "Purchase Line";
        TDSSetup: Record "TDS Setup";
        GSTSetup: Record "GST Setup";
    begin
        if not TDSSetup.Get() then
            exit;
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", RecID);// PurchaseLine.RecordId);
        TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then begin
            TaxTransactionValue.Calcsums(Amount);
        end;
        Exit(TaxTransactionValue.Amount);
    end;
    //PCPL-0070 22Dec2022 >>

    Var
        PH: Record 38;
        TotalGSTAmount1: Decimal;
        TotalTDSAmt: Decimal;

    // trigger OnOpenPage()
    // begin
    //     Message('Test');
    // end;
}

