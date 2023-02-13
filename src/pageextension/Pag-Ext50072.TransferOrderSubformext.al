pageextension 50072 "Transfer_Order_Subform_ext" extends "Transfer Order Subform"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    layout
    {

        modify(Description)
        {
            Editable = false;
        }
        addafter(Quantity)
        {
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
            }
        }
        addbefore(Quantity)
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    IF "Reason Code" <> '' THEN
                        "Reason For TO" := TRUE
                    ELSE
                        IF "Reason Code" = '' THEN
                            "Reason For TO" := FALSE;
                end;
            }
            field("Qty. In KG"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'TO Qty In PCS';
                //For GST Auto Calculate
                trigger OnValidate()
                var
                    TaxCaseExecution: Codeunit "Use Case Execution";
                begin
                    CurrPage.SaveRecord();
                    TaxCaseExecution.HandleEvent('OnAfterTransferPrirce', Rec, '', 0);
                end;
            }
            field("Product SR No.BE"; "Product SR No.BE")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Invoice SR No.BE"; "Invoice SR No.BE")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Box/Case No."; "Box/Case No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Duty Free Available Qty. KG"; "Duty Free Available Qty. KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Tracking Exists"; "Tracking Exists")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Qty. to Ship")
        {
            field("Qty. to Ship In KG"; "Qty. to Ship In KG")
            {
                ApplicationArea = all;
                Caption = 'Pick List Qty. In PCS';
            }
            field("Quantity Shipped In KG"; "Quantity Shipped In KG")
            {
                Caption = 'Quantity Shipped In PCS';
                Editable = false;
                ApplicationArea = all;

            }
            field("Qty. to Receive In KG"; "Qty. to Receive In KG")
            {
                Caption = 'Qty. to Receive In PCS';
                ApplicationArea = all;
                Editable = false;
            }
            field("Quantity Received In KG"; "Quantity Received In KG")
            {
                Caption = 'Quantity Received In PCS';
                Editable = false;
                ApplicationArea = all;
            }
            field("No. of Boxes"; "No. of Boxes")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Transfer Serial No."; "Transfer Serial No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                ApplicationArea = all;
                Caption = 'Outstanding Quantity In KG';
                Editable = false;
            }
            field("Outstanding Quantity In KG"; "Outstanding Quantity In KG")
            {
                ApplicationArea = all;
                Caption = 'Outstanding Quantity In PCS';
                Editable = false;
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Excess Qty In KG"; "Excess Qty In KG")
            {
                ApplicationArea = all;
                Caption = 'Excess Qty In PCS';
                Editable = false;
            }
            field("Excess Qty In PCS"; "Excess Qty In PCS")
            {
                ApplicationArea = all;
                Caption = 'Excess Qty In KG';
                Editable = false;
            }
            field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Quarantine Qty In KG"; "Quarantine Qty In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Qty In PCS"; "Actual Qty In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Qty In KG"; "Actual Qty In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Receipt Date")
        {
            field("GST Assessable Value1"; "GST Assessable Value1")
            {
                ApplicationArea = all;
                Caption = 'GST Assessable Value';
            }
            field("Custom Duty Amount1"; "Custom Duty Amount1")
            {
                ApplicationArea = all;
                Caption = 'Custom Duty Amount';
                Editable = false;
            }
            field(Duty; Duty)
            {
                ApplicationArea = all;
                Caption = 'Duty';
                Editable = false;
            }
            field(Cess; Cess)
            {
                ApplicationArea = all;
                Caption = 'Cess Amount';
                Editable = false;
            }
            field(Surcharge; Surcharge)
            {
                ApplicationArea = all;
                Caption = 'Surcharge Amount';
                Editable = false;
            }

            field("Customer License No."; "Customer License No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Customer License Name"; "Customer License Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Customer License Date"; "Customer License Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("In-Bond BOE Date"; "In-Bond BOE Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Bond Number"; "Bond Number")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Bond Sr.No."; "Bond Sr.No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Bond Date"; "Bond Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sales Category"; "Sales Category")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice No.1"; "Supplier Invoice No.1")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Sr.No.1"; "Supplier Invoice Sr.No.1")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Date 1"; "Supplier Invoice Date 1")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice No.2"; "Supplier Invoice No.2")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Sr.No.2"; "Supplier Invoice Sr.No.2")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Date 2"; "Supplier Invoice Date 2")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice No.3"; "Supplier Invoice No.3")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Sr.No.3"; "Supplier Invoice Sr.No.3")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Date 3"; "Supplier Invoice Date 3")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice No.4"; "Supplier Invoice No.4")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Sr.No.4"; "Supplier Invoice Sr.No.4")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Date 4"; "Supplier Invoice Date 4")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice No."; "Supplier Invoice No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Supplier Invoice Sr.No."; "Supplier Invoice Sr.No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Transfer From Reason Code"; "Transfer From Reason Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Transfer To Reason Code"; "Transfer To Reason Code")
            {
                ApplicationArea = all;
            }
            field("Supplier Invoice Date"; "Supplier Invoice Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Weight; Weight)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Reserved; Reserved)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Batch"; "Actual Batch")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual MFG Date"; "Actual MFG Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual EXP Date"; "Actual EXP Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Batch PCS"; "Actual Batch PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Batch KGS"; "Actual Batch KGS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reason For TO"; "Reason For TO")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter(Reserve)
        {
            action("Get Receipt Lines")
            {
                ApplicationArea = all;
                trigger OnAction();
                begin
                    CLEAR(GetPOReceipts);
                    Rec_TH.SETRANGE("No.", "Document No.");
                    Rec_TH.SETFILTER(Rec_TH."Supplier PO No.", '<>%1', '');
                    IF Rec_TH.FINDFIRST THEN BEGIN

                        //    PurchRcptLine.SETCURRENTKEY("Pay-to Vendor No.");
                        PurchRcptLine.SETRANGE(PurchRcptLine."Order No.", Rec_TH."Supplier PO No.");
                        IF PurchRcptLine.FINDSET THEN
                            REPEAT
                                PurchRcptLine."Trans.Ord." := Rec_TH."No.";
                                PurchRcptLine.MODIFY;
                            UNTIL PurchRcptLine.NEXT = 0;
                        COMMIT;
                        PurchRcptLine.SETRANGE(PurchRcptLine."Order No.", Rec_TH."Supplier PO No.");
                        GetPOReceipts.SETTABLEVIEW(PurchRcptLine);
                        GetPOReceipts.LOOKUPMODE := TRUE;
                        GetPOReceipts.RUNMODAL;
                    END;
                end;
            }
        }
    }

    var
        NewTransferLines: Record 5741;
        NewTransferHeader: Record 5740;
        Rec_TH: Record 5740;
        Rec_TL: Record 5741;
        PurchRcptLine: Record 121;
        GetPOReceipts: Page 50012;
        PRL: Record 121;

    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

