tableextension 50249 "Vendor_led_ent_ext" extends "Vendor Ledger Entry"
{
    // version TFS225977

    fields
    {

        //PCPL/NSW/MIG Vendor Name Field Already exist in BC 18
        // field(50000;"Vendor Name";Text[50])
        // {
        //     Description = 'CCIT';
        // }
        field(50002; Comment; Text[250])
        {
        }
        field(50051; "Partial Payment Terms"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Partial Payment Terms".Code;
        }
        field(50052; "Vendor Invoiced Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50053; "Advanced Payment"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50054; Shipment; Boolean)
        {
            Description = 'CCIT';
        }
        field(50055; "Purchase Order Reference No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Purchase Header"."No.";
        }
        field(50056; "TCS Nature of Collection"; Code[10])
        {
            CaptionML = ENU = 'TCS Nature of Collection',
                        ENN = 'TCS Nature of Collection';
            TableRelation = "TCS Nature Of Collection";
        }
        field(50057; "Bill of Entry Date"; Date)
        {
            CalcFormula = Lookup("Purch. Inv. Header"."Bill of Entry Date" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Bill of Entry Date',
                        ENN = 'Bill of Entry Date';
            Editable = true;
            FieldClass = FlowField;
        }
        field(50058; "Bill of Entry No"; Text[30])
        {
            CaptionML = ENU = 'Bill of Entry Value',
                        ENN = 'Bill of Entry Value';
            Editable = true;
        }
    }

    //Unsupported feature: PropertyDeletion. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Location: Record 14;
        Vendor: Record 23;



}

