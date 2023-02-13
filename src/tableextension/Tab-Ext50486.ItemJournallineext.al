tableextension 50486 "Item_Journal_line_ext" extends "Item Journal Line"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    fields
    {

        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                IF Ritem.get("Item No.") then;
                "Storage Categories" := Ritem."Storage Categories"; //CCIT-SG

            end;

        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                        END
                    END
                END;
                UpdateAmount;
                //CCIT-SG
            end;

        }

        field(50000; "MFG Date"; Date)
        {
            Description = 'CCIT-JAGA';
        }
        field(50005; "ETA - Destination Port"; Date)
        {
            Description = 'CCIT';
        }
        field(50006; "ETA - Destination CFS"; Date)
        {
            Description = 'CCIT';
        }
        field(50007; "ETA - Bond"; Date)
        {
            Description = 'CCIT';
        }
        field(50008; "JWL BOND GRN No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50009; "JWL BOND GRN Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50028; "Conversion Qty To Handle"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
        }
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            VALIDATE(Quantity, Rec."Conversion Qty" * RecUOM.Weight);
                        END
                    END
                END;
                //CCIT-SG
            end;
        }
        field(50032; "Customer No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = Customer;
        }
        field(50033; "Customer Name"; Text[50])
        {
            Description = 'CCIT';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(50034; Reserved; Boolean)
        {
            Description = 'CCIT';
        }
        field(50035; "BL Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50037; "In-Bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50038; "Bond Number"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50039; "Bond Sr.No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50040; "Bond Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50041; "BL/AWB No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50042; "Ex-bond BOE No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50043; "Ex-bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50044; "Ex-bond BOE No.1"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50045; "Ex-bond BOE Date 1"; Date)
        {
            Description = 'CCIT';
        }
        field(50046; "Ex-bond BOE No.2"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50047; "Ex-bond BOE Date 2"; Date)
        {
            Description = 'CCIT';
        }
        field(50048; "Ex-bond BOE No.3"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50049; "Ex-bond BOE Date 3"; Date)
        {
            Description = 'CCIT';
        }
        field(50050; "Ex-bond BOE No.4"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50051; "Ex-bond BOE Date 4"; Date)
        {
            Description = 'CCIT';
        }
        field(50052; "Ex-bond BOE No.5"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50053; "Ex-bond BOE Date 5"; Date)
        {
            Description = 'CCIT';
        }
        field(50054; "Ex-bond BOE No.6"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50055; "Ex-bond BOE Date 6"; Date)
        {
            Description = 'CCIT';
        }
        field(50056; "Ex-bond BOE No.7"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50057; "Ex-bond BOE Date 7"; Date)
        {
            Description = 'CCIT';
        }
        field(50058; "Ex-bond BOE No.8"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50059; "Ex-bond BOE Date 8"; Date)
        {
            Description = 'CCIT';
        }
        field(50060; "Ex-bond BOE No.9"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50061; "Ex-bond BOE Date 9"; Date)
        {
            Description = 'CCIT';
        }
        field(50062; "ICA No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50065; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = false;
            TableRelation = "Unit of Measure";
        }
        field(50066; "Storage Categories"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FREEZER,CHILLED,DRY;
        }
        field(50067; "OrderDate WareActHed"; Date)
        {
            Description = 'CCIT';
        }
        field(50068; "Qty. to Invoice In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50069; "Qty. to Receive In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50070; "HS Code"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50071; "Quantity (Base) In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50072; "Outstanding Qty. (Base) In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
            Editable = false;
        }
        field(50073; "Lot No.GRN"; Code[10])
        {
            Description = 'CCIT';
        }
        field(50074; "Expiration Date GRN"; Date)
        {
            Description = 'CCIT';
        }
        field(50075; "Manufacturing Date GRN"; Date)
        {
            Description = 'CCIT';
        }
        field(50076; "Qty. Handled In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50082; FOC; Boolean)
        {
            Description = 'CCIT';
        }
        field(50083; "Gen.Prod.Post.Group"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50084; "Customer License No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50085; "Customer License Name"; Text[100])
        {
            Description = 'CCIT';
        }
        field(50086; "Customer License Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category";
        }
        field(50088; "Supplier Invoice No.1"; Code[20])
        {
        }
        field(50089; "Supplier Invoice Sr.No.1"; Code[20])
        {
        }
        field(50090; "Supplier Invoice Date 1"; Date)
        {
        }
        field(50091; "Gross Weight 1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50092; "Net Weight 1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50093; "Supplier Invoice No.2"; Code[20])
        {
        }
        field(50094; "Supplier Invoice Sr.No.2"; Code[20])
        {
        }
        field(50095; "Supplier Invoice Date 2"; Date)
        {
        }
        field(50096; "Gross Weight 2"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50097; "Net Weight 2"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50098; "Supplier Invoice No.3"; Code[20])
        {
        }
        field(50099; "Supplier Invoice Sr.No.3"; Code[20])
        {
        }
        field(50100; "Supplier Invoice Date 3"; Date)
        {
        }
        field(50101; "Gross Weight 3"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50102; "Net Weight 3"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50103; "Supplier Invoice No.4"; Code[20])
        {
        }
        field(50104; "Supplier Invoice Sr.No.4"; Code[20])
        {
        }
        field(50105; "Supplier Invoice Date 4"; Date)
        {
        }
        field(50106; "Gross Weight 4"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50107; "Net Weight 4"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50108; "Supplier Invoice No."; Code[100])
        {
        }
        field(50109; "Supplier Invoice Sr.No."; Code[20])
        {
        }
        field(50110; "Supplier Invoice Date"; Date)
        {
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50112; "JWL Transfer No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50113; "JWL Transfer Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50114; "Invoiced Quantity In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50124; "Custom Duty Amount1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            MinValue = 0;

            trigger OnValidate();
            var
                Vendor: Record 23;
            begin
            end;
        }
        field(50500; "Actual Batch"; Code[20])
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50501; "Actual MFG Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50502; "Actual EXP Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50503; "Actual Batch PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(70000; "Manufacturing Date"; Date)
        {
        }
        field(70001; "New Item Manufacturing Date"; Date)
        {
        }
        field(70004; "PO Lot No."; Code[20])
        {
            Description = 'CCIT-SD-02-01-18';
        }
        field(70005; "PO Expiration Date"; Date)
        {
            Description = 'CCIT-SD-02-01-18';
        }
        field(70006; "PO Manufacturing Date"; Date)
        {
            Description = 'CCIT-SD-02-01-18';
        }
        field(70007; "Select Lot No."; Code[20])
        {
            Description = 'CCIT-SD-02-01-18';
        }
        field(70008; "Cutting In (Pc)"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-02-01-18';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Text012: TextConst ENU = 'The update has been interrupted to respect the warning.', ENN = 'The update has been interrupted to respect the warning.';

    var
        RecUOM: Record 5404;
        RecItem2: Record 27;
        Ritem: record 27;
}

