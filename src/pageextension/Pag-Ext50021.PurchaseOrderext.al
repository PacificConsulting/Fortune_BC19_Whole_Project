pageextension 50021 "Purchase_Order_ext" extends "Purchase Order"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    layout
    {
        modify(General)
        {
            Editable = ShortClosed;

        }
        modify("Buy-from Vendor Name")
        {
            Editable = false;
        }

        addafter("Buy-from Contact No.")
        {
            field("Short Closed Date"; "Short Closed Date")
            {
                Editable = true;
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")
        {
            field("Receiving No. Series"; "Receiving No. Series")
            {
                ApplicationArea = all;
            }
            field("Receiving No."; "Receiving No.")
            {
                ApplicationArea = all;
            }
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }

            field("Exchange Rate"; "Exchange Rate")
            {
                ApplicationArea = all;

            }
            field("Created User"; "Created User")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("JWL BOND GRN No."; "JWL BOND GRN No.")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("JWL BOND GRN Date"; "JWL BOND GRN Date")
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoiced Date"; "Vendor Invoiced Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Buy-from Contact No.")
        {
            field("Short Closed"; "Short Closed")
            {
                Editable = true;
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    /*
                    IF PurchLine."Qty. to Receive"<>0 THEN;
                    //Short Close
                    IF "Short Close"=TRUE THEN
                      CurrPage.EDITABLE(FALSE)
                    ELSE
                      CurrPage.EDITABLE(TRUE);
                    //Short Close
                    
                    
                    //CCIT-JAGA
                    IF "Short Closed" THEN
                      CurrPage.EDITABLE(FALSE);
                    //CCIT-JAGA
                    */

                end;
            }
            field("Short Closed Reason Code"; "Short Closed Reason Code")
            {
                OptionCaption = '" ,Weight Loss,Short Received,FSSAI Samples from stocks,Inv / Phy – Same,Wrong PO,Duplicate PO,Old PO Data,Order Cancelled "';
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            group("Purchase Data")
            {
                // ApplicationArea=all;
            }
        }
        addafter("Transport Method")
        {
            field("Container Type"; "Container Filter")
            {
                ApplicationArea = all;
            }
        }
        addafter("Container Type")
        {
            field("Payment Terms Description"; "Payment Terms Description")
            {
                ApplicationArea = all;
            }
            field("Partial Payment Terms"; "Partial Payment Terms")
            {
                ApplicationArea = all;
            }
        }
        addafter("Lead Time Calculation")
        {
            field("Ship By Date"; "Ship By Date")
            {
                ApplicationArea = all;
            }
        }
        addafter(PurchLines)
        {
            group("Import Clearing ")
            {
                field("In-Bond BOE No."; "In-Bond Bill of Entry No.")
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //BM.RESET;
                        //BM.FILTERGROUP(10);
                        //BM.SETRANGE(BM."In-Bond Bill of Entry No.", "In-Bond Bill of Entry No.");
                        //BM.FILTERGROUP(0);
                        IF PAGE.RUNMODAL(50023, BM) = ACTION::LookupOK THEN begin
                            "In-Bond Bill of Entry No." := BM."In-Bond Bill of Entry No.";
                            "Bill Of Lading No." := BM."BL/AWB No.";
                            "Bill Of Lading Date" := BM."BL Date";
                            "In-Bond BOE Date" := BM."In-Bond BOE Date";
                            "Bond Number" := BM."Bond Number";
                            "Bond Sr.No." := BM."Bond Sr.No.";
                            "Bond Date" := BM."Bond Date";
                            "ETA - Destination CFS" := BM."Date Of Shipment Move. at CFS";
                            "ETA - Bond" := BM."Date of Move. from CFS Bond";
                            "ETA - Destination Port" := BM."Shipment Arrival at Port Date";
                            "Container Number" := BM."Container No.";
                            "Container Seal No." := BM."Seal No";
                            "Container Filter" := BM."Container Type";
                            CHA := BM.CHA;
                            "Transit Days" := BM."Total Transit Day";
                            "Data Logger" := BM."Data Logger";
                            "Vendor Invoice No." := BM."Supplier Invoice No.";
                            //CCIT-20042021
                            "Bill of Entry No." := BM."In-Bond Bill of Entry No.";
                            "Bill of Entry Date" := BM."In-Bond BOE Date";
                            //"Bill of Entry Value" := BM."In-Bond BOE Value";
                            //"Currency Code" := BM."Currency Code";
                            // "Exchange Rate" := BM."Exchange Rate";
                            //CCIT-20042021
                            //BM.Modify();
                        end;

                    end;
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
                field("ETD - Supplier Warehouse"; "ETD - Supplier Warehouse")
                {
                    ApplicationArea = all;
                }
                field("ETD - Origin Port"; "ETD - Origin Port")
                {
                    ApplicationArea = all;
                }
                field("Transit Days"; "Transit Days")
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("Shipment Method Code")
        {
            field("Freight Forwarder"; "Freight Forwarder")
            {
                ApplicationArea = all;
            }
            field("BL/AWB No."; "Bill Of Lading No.")
            {
                ApplicationArea = all;
            }
            field("BL/AWB Date"; "Bill Of Lading Date")
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
            field("Shipping Line"; "Shipping Line")
            {
                ApplicationArea = all;
            }
            field(CHA; CHA)
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
                ShowMandatory = true;
                ApplicationArea = all;
            }
            field("Port of Loading-Air"; "Port of Loading-Air")
            {
                ApplicationArea = all;
            }
            field("Port of Loading-Ocean"; "Port of Loading-Ocean")
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
            field("Import Permit No."; "License No.")
            {
                ApplicationArea = all;
            }
            field("Data Logger"; "Data Logger")
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
                TESTFIELD("ETA - Availability for Sale"); //rdk 23-05-2019

                //CCIT_kj/Vivek_23-04-21++
                TESTFIELD("Shipment Method Code");
                TESTFIELD("Bill Of Lading Date");
                TESTFIELD("Bill Of Lading No.");
                //CCIT_kj/Vivek_23-04-21---

                // rdk 03-10-19 -
                IF "Vendor Posting Group" = 'IMPORT' THEN
                    TESTFIELD("In-Bond BOE Date");
                // rdk 03-10-19 +

                //CCIT_kj 27-04-21
                RecPL.RESET;
                RecPL.SETRANGE(RecPL."Document No.", Rec."No.");
                RecPL.SETFILTER(RecPL."Document Type", '=%1', RecPL."Document Type"::Order);
                IF RecPL.FINDSET THEN
                    REPEAT
                        //MESSAGE('%1',RecPL."Document No.");
                        RecPL."Bill Of Entry No." := Rec."Bill of Entry No.";
                        RecPL.MODIFY;
                    UNTIL RecPL.NEXT = 0;
                //CCIT_kj 27-04-21

                //PCPL-0070 08Nov2022 <<
                GetGSTAmountTotal(Rec, TotalGSTAmount1);
                GSTTDSAmountTotal(Rec, TotalTDSAmt);

                Rec."TDS Amount" := TotalTDSAmt;
                Rec."GST Amount" := TotalGSTAmount1;
                Rec.Modify();
                //PCPL-0070 08Nov2022 >>

            end;
        }

        modify("Create Inventor&y Put-away/Pick")
        {
            trigger OnBeforeAction()
            begin
                TESTFIELD("Shortcut Dimension 1 Code");//CCIT-SG-12062018
            end;

            trigger OnAfterAction()
            begin
                //----- CCIT-SG
                RecWarehouseActiveHeader.RESET;
                RecWarehouseActiveHeader.SETRANGE("Source No.", "No.");
                RecWarehouseActiveHeader.SETRANGE("Destination No.", "Buy-from Vendor No.");
                IF RecWarehouseActiveHeader.FINDSET THEN BEGIN
                    REPEAT
                        //MESSAGE('%1',RecWarehouseActiveHeader."Source No.");
                        RecWarehouseActiveHeader."Responsibility Center" := "Responsibility Center";
                        RecWarehouseActiveHeader.MODIFY;

                    UNTIL RecWarehouseActiveHeader.NEXT = 0;
                END;

                //<<PCPL/NSW/07  10Nov22
                RecWarehouseActiveHeader.RESET;
                RecWarehouseActiveHeader.SETRANGE("Source No.", "No.");
                IF RecWarehouseActiveHeader.FindFirst() THEN BEGIN
                    Rec.PutAwayCreated := true;
                    Modify();
                END;
                //>>PCPL/NSW/07  10Nov22

                // if Find('=><') then begin
                //     Rec.PutAwayCreated := true;
                //     Modify();
                //     COMMIT;
                // end
            end;
        }



        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have following permission');
                //CCIT-PRI-191118

                //CCIT-JAGA
                IF NOT "Short Closed" THEN BEGIN
                    //CCIT-SG
                    IF RecLicMaster.GET("License No.") THEN BEGIN
                        LicQty := 0;
                        RecPL.RESET;
                        RecPL.SETRANGE(RecPL."Document No.", Rec."No.");
                        RecPL.SETRANGE(RecPL."Document Type", Rec."Document Type");
                        IF RecPL.FINDSET THEN
                            REPEAT
                                LicQty := LicQty + RecPL.Quantity;
                                RecLicMaster."License Quantity" := LicQty;
                                RecLicMaster.MODIFY;
                            UNTIL RecPL.NEXT = 0;
                    END;
                END
                ELSE BEGIN
                    ERROR('You can not post Short Closed PO');
                END

                //CCIT-SG

            end;
        }

        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have following permission');
                //CCIT-PRI-191118

            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have following permission');
                //CCIT-PRI-191118
            end;
        }

        addbefore(Post)
        {
            action("Short Closed1")
            {
                Caption = 'Short Closed';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    TESTFIELD("Short Closed Reason Code");//CCIT-12092019
                    //CCIT-SG
                    RecWAH.RESET;
                    RecWAH.SETRANGE(RecWAH."Source No.", "No.");
                    IF RecWAH.FINDFIRST THEN
                        ERROR('Warehouse Activity Lines are Created first deleted that and then Short Cloesd.');
                    //CCIT-SG//CCIT-PRI
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
                    "Short Closed Date" := TODAY;//CCIT-TK-121219
                    Rec.MODIFY;
                end;
            }
        }
        addafter("&Print")
        {
            action("Purchase Order")
            {
                Promoted = true;

                trigger OnAction();
                begin
                    //CCIT-SG
                    Rec.TestField(Status, Rec.Status::Released);
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
    //PCPL-0070 08Nov2022 <<
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
    Var
        PurchLine2: record 39;
    Begin
        Clear(TDSAmount);
        PurchLine2.Setrange("Document No.", PurchHdr."No.");
        If PurchLine2.Findset() then
            Repeat
                TDSAmount += GetTDSAmount(PurchLine2.RecordID());
            Until PurchLine2.Next() = 0;
    End;

    local procedure GetTDSAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        PurchaseLine: Record "Purchase Line";
        TDSSetup: Record "TDS Setup";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
        TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then begin
            TaxTransactionValue.Calcsums(Amount);
        end;
        Exit(TaxTransactionValue.Amount);
    end;

    //PCPL-0070 08Nov2022 >>
    var
        RecWarehouseActiveHeader: Record 5766;
        Text001: Label 'Do you want to short closed PO %1';
        ShortClosed: Boolean;
        RecPH: Record 38;
        RecLicMaster: Record 50023;
        RecPL: Record 39;
        LicQty: Decimal;
        UserSetup: Record 91;
        Name: Code[20];
        RecWAH: Record 5766;
        TotalGSTAmount1: Decimal;
        TotalTDSAmt: Decimal;


    //Unsupported feature: CodeModification on "OnAfterGetRecord". Please convert manually.

    //trigger OnAfterGetRecord();
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    SetLocGSTRegNoEditable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetControlAppearance;
    */
    //end;


    //Unsupported feature: CodeModification on "OnDeleteRecord". Please convert manually.

    //trigger OnDeleteRecord() : Boolean;
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.SAVERECORD;
    EXIT(ConfirmDeletion);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //ERROR('You don''t have permission');
    CurrPage.SAVERECORD;
    EXIT(ConfirmDeletion);
    */
    //end;




    trigger OnOpenPage();
    begin
        //CCIT-JAGA
        IF "Short Closed" = FALSE THEN
            ShortClosed := TRUE;
        //CCIT-JAGA    
    end;

    //Unsupported feature: CodeInsertion on "OnQueryClosePage". Please convert manually.

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        TESTFIELD("Location Code");
        TESTFIELD("Transport Method");
        TESTFIELD("Ship By Date");
        IF "Vendor Posting Group" = 'IMPORT' THEN // 300919
            TESTFIELD("ETA - Availability for Sale");// 300919

    end;

    //Unsupported feature: PropertyChange. Please convert manually.
    var
        BM: Record 50022;

}

