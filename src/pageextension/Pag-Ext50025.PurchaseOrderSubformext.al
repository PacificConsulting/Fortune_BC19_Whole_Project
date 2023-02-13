pageextension 50025 "Purchase_Order_Subform_ext" extends "Purchase Order Subform"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune

    layout
    {

        Modify("Location Code")
        {
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }
        modify("Description 2")
        {
            Editable = false;
        }
        modify("Bin Code")
        {
            Editable = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        modify("Act Applicable")
        {
            Editable = false;
        }
        modify("GST Credit")
        {
            Editable = false;
        }




        modify(Type)
        {
            trigger OnAfterValidate()
            begin

                IF recPH1.GET("Document Type", "Document No.") THEN
                    "Buy-from Vendor No." := recPH1."Buy-from Vendor No.";

            end;
        }
        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                IF (Rec.Type = Rec.Type::Item) then begin
                    Itemvendor.Reset();
                    Itemvendor.SetRange("Vendor No.", "Buy-from Vendor No.");
                    Itemvendor.SetRange(Blocked, false);
                    // IF Itemvendor.FindFirst() then
                    //  RecItem.Reset();
                    //RecItem.SetRange("No.", Itemvendor."Item No.");
                    IF Page.RunModal(Page::"Item Vendor Catalog", Itemvendor) = Action::LookupOK then
                        rec.Validate("No.", Itemvendor."Item No.");


                end;
            end;

            trigger OnAfterValidate()
            var
                NewItemVendor: Record "Item Vendor";
            begin
                NewItemVendor.Reset();
                NewItemVendor.SetRange("Vendor No.", "Buy-from Vendor No.");
                IF NewItemVendor.FindFirst() then begin
                    Itemvendor.Reset();
                    Itemvendor.SetRange("Vendor No.", "Buy-from Vendor No.");
                    Itemvendor.SetRange(Blocked, false);
                    Itemvendor.SetRange("Item No.", "No.");
                    IF Itemvendor.IsEmpty() then
                        Error('Please select Proper Item No from drop down List');
                end;
            end;
        }

        modify("GST Group Code")
        {
            Editable = true;
        }
        modify("Quantity Received") //PCPL-064
        {
            Visible = true;
            Caption = 'GRN Qty Received In KG';

        }
        addafter(Description)
        {
            field("Vendor Description"; "Description 2")
            {
                ApplicationArea = all;
            }
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
                Editable = false;
            }
            // field(quat)
            // field("HSN/SAC Code"; "HSN/SAC Code")
            // {
            //     ApplicationArea = all;
            //     Editable = true;
            //     TableRelation = "HSN/SAC".Code where("GST Group Code" = field("GST Group Code"));
            // }
        }
        addafter("Bin Code")
        {
            field("HS Code"; "HS Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter(Quantity)
        {
            field(Weight; Weight)
            {
                ApplicationArea = all;
            }
            // field("Net Weight"; "Net Weight")
            // {
            //     ApplicationArea = all;
            // }
            // field("Gross Weight"; "Gross Weight")
            // {
            //     ApplicationArea = all;
            // }
        }
        addafter("Unit of Measure")
        {
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Inv. Discount Amount")
        {
            field("Purchasing Code"; "Purchasing Code")
            {
                ApplicationArea = all;
                Editable = false;

            }
            field("Special Order"; "Special Order")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Special Order Sales No."; "Special Order Sales No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Special Order Sales Line No."; "Special Order Sales Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }

            field("Qty. to Receive In KG"; "Qty. to Receive In KG")
            {
                BlankZero = true;
                Caption = 'WH.Qty. to Receive Ins PCS';
                ApplicationArea = all;
                Editable = false;
            }

            field("Quantity Received In KG"; "Quantity Received In KG")
            {
                BlankZero = true;
                Caption = 'GRN Qty Received In PCS';
                ApplicationArea = all;
                Editable = false;
            }
            field("Qty. to Invoice In KG"; "Qty. to Invoice In KG")
            {
                Caption = 'Qty. to Invoice In PCS-Bill';
                ApplicationArea = all;
                Editable = false;
            }

            field("Quantity Invoiced In KG"; "Quantity Invoiced In KG")
            {
                BlankZero = true;
                Caption = 'GRN Qty Invoiced In PCS';
                Editable = false;
                ApplicationArea = all;

            }
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                Caption = 'Outstanding Quantity In KG';
                ApplicationArea = all;
                Editable = false;
            }
            field("Outstanding Quantity In KG"; "Outstanding Quantity In KG")
            {
                Caption = 'Outstanding Quantity In PCS';
                Editable = false;
                ApplicationArea = all;
            }
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                Caption = 'Saleable Qty. In KG';
                Editable = false;
                ApplicationArea = all;
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                Caption = 'Variance Qty. In PCS';
                Editable = false;
                ApplicationArea = all;
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                Caption = 'Saleable Qty. In PCS';
                Editable = false;
                ApplicationArea = all;
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                Caption = 'Variance Qty. In KG';
                Editable = false;
                ApplicationArea = all;
            }
            field("BOE Qty.In PCS"; "BOE Qty.In PCS")
            {
                Caption = 'BOE Qty.In KG';
                ApplicationArea = all;
                Editable = false;
            }
            field("BOE Qty.In KG"; "BOE Qty.In KG")
            {
                Caption = 'BOE Qty.In PCS';
                ApplicationArea = all;
                Editable = false;
            }
            field("Excess Qty In KG"; "Excess Qty In KG")
            {
                Caption = 'Excess Qty In PCS';
                ApplicationArea = all;
                Editable = false;
            }
            field("Excess Qty In PCS"; "Excess Qty In PCS")
            {
                Caption = 'Excess Qty In KG';
                ApplicationArea = all;
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
            field("Tracking Exists"; "Tracking Exists")
            {
                ApplicationArea = all;
                Editable = false;
            }

            field("License No."; "License No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Qty. In KG"; "Conversion Qty")
            {
                ApplicationArea = all;
                Caption = 'PO Qty. In PCS';
                Editable = false;
            }
            field("Bill Of Entry No."; "Bill Of Entry No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("TCS Nature of Collection"; "TCS Nature of Collection")
            {
                ApplicationArea = all;
            }
            field("TCS %"; "TCS %")
            {
                ApplicationArea = all;
            }
            field("TCS Base Amount"; "TCS Base Amount")
            {
                ApplicationArea = all;
            }
            field("TCS Type"; "TCS Type")
            {
                ApplicationArea = all;
            }
            field("TCS Amount"; "TCS Amount")
            {
                ApplicationArea = all;
            }
        }
        addafter("Invoice Disc. Pct.")
        {
            field("Total Qty. In KG"; "Total Qty. In KG")
            {
                Caption = 'Total PO Qty. In KG';
                Editable = false;
                ApplicationArea = all;
            }
            field("Total PO Amount"; "Total PO Amount")
            {
                Enabled = false;
                ApplicationArea = all;
            }
        }
    }

    var
        recVend: Record 23;
        recPH1: Record 38;
        Itemvendor: Record "Item Vendor";

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //CCIT
        IF recPH1.GET("Document Type", "Document No.") THEN
            "Buy-from Vendor No." := recPH1."Buy-from Vendor No.";

    end;

    trigger OnOpenPage();
    begin
        //CCIT
        IF recPH1.GET("Document Type", "Document No.") THEN
            "Buy-from Vendor No." := recPH1."Buy-from Vendor No.";

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        IF Rec.Quantity <> 0 THEN
            TESTFIELD("Unit Cost"); //CCIT-SG

    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

