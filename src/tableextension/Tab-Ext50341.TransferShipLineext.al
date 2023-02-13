tableextension 50341 "Transfer_Ship_Line_ext" extends "Transfer Shipment Line"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

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
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Bond Master"."In-Bond Bill of Entry No.";
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
        field(50073; "No. of Boxes"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50074; "Transfer Serial No."; Code[20])
        {
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
        // field(50124;"Custom Duty Amount";Decimal)
        // {
        //     DecimalPlaces = 0:3;
        //     Description = 'CCIT-SD';
        //     MinValue = 0;

        //     trigger OnValidate();
        //     var
        //         Vendor : Record 23;
        //     begin
        //     end;
        // }
        // field(50125; "GST Assessable Value"; Decimal)
        // {
        //     DecimalPlaces = 0 : 3;
        //     Description = 'CCIT-SD';

        //     trigger OnValidate();
        //     var
        //         Vendor: Record 23;
        //     begin
        //     end;
        // }
        field(50126; "Transfer From Reason Code"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50128; Duty; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-27-04-2018';
        }
        field(50129; Cess; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-27-04-2018';
        }
        field(50130; Surcharge; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-27-04-2018';
        }
        field(50131; "TO Order QTY"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50132; "TO Order Value"; Decimal)
        {
            Description = 'CCIT';
        }
    }

}

