tableextension 50008 "Sales_shipment_Line" extends "Sales Shipment Line"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    fields
    {

        modify("Invoice Type")
        {
            OptionCaptionML = ENU = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST', ENN = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';

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
        field(50065; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = false;
            TableRelation = "Unit of Measure";
        }
        field(50082; FOC; Boolean)
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
            TableRelation = "Sales Category".Code;
        }
        field(50088; "Reason For Free Sample"; Option)
        {
            OptionCaption = '" ,New Product,Liquidation,Friend & Family,Market Penetration,Competitor,Government Department"';
            OptionMembers = " ","New Product",Liquidation,"Friend & Family","Market Penetration",Competitor,"Government Department";
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50112; "Reason Code"; Code[10])
        {
            Description = 'CCIT_TK';
            TableRelation = "Reason Code";
        }
        field(50124; "Rate In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50125; "Amount In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50140; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
        }
    }

    trigger OnDelete();
    begin

        //CCIT-PRI-191118
        ERROR('You do not have permission');
        //CCIT-PRI-191118
    end;

}

