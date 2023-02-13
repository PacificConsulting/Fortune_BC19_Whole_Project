tableextension 50413 "Whse_Item_Tracking_Line" extends "Whse. Item Tracking Line"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    fields
    {
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
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category".Code;
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

            trigger OnValidate();
            begin
                //>> CS
                "New Expiration Date" := "Expiration Date";
                //<< CS
            end;
        }
        field(70001; "New Manufacturing Date"; Date)
        {
        }
        field(70002; "Qty. to Handle (Base) In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(70003; "Remainig Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(70004; "PO Lot No."; Code[20])
        {
            Description = 'CITS-SD-26-12-17';
        }
        field(70005; "PO Expiration Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';
        }
        field(70006; "PO Manufacturing Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';
        }
    }

    PROCEDURE InitManufacturingDate();
    VAR
        Location: Record 14;
        ItemTrackingMgt: Codeunit 6500;
        MfgDate: Date;
        WarDate: Date;
    BEGIN
        //>> CS
        IF ("Serial No." = xRec."Serial No.") AND ("Lot No." = xRec."Lot No.") THEN
            EXIT;

        "Manufacturing Date" := 0D;
        "Buffer Status2" := 0;

        Location.INIT;
        IF "Location Code" <> '' THEN
            Location.GET("Location Code");
        //PCPL/MIG/NSW GetWhseManufacturingDate Fun not exist in BC18
        //IF ItemTrackingMgt.GetWhseManufacturingDate("Item No.","Variant Code",Location,"Lot No.","Serial No.",MfgDate) THEN BEGIN
        "Manufacturing Date" := MfgDate;
        //END;

        IF IsReclass("Source Type", "Source Batch Name") THEN BEGIN
            "New Manufacturing Date" := "Manufacturing Date";
        END;
        //<< CS
    END;


}

