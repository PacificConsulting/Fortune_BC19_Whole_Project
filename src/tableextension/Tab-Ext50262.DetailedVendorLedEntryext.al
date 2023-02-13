tableextension 50262 "Detailed_Vendor_Led_Entry_ext" extends "Detailed Vendor Ledg. Entry"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    fields
    {

        //Unsupported feature: PropertyDeletion on ""User ID"(Field 11)". Please convert manually.

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
            CalcFormula = Lookup("Purch. Inv. Header"."Bill of Entry No." WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Bill of Entry Value',
                        ENN = 'Bill of Entry Value';
            Editable = true;
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

