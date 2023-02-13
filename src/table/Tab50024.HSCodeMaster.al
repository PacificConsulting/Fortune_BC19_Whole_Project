table 50024 "HS Code Master"
{
    // version CCIT-Fortune

    DrillDownPageID = 50030;
    LookupPageID = 50030;

    fields
    {
        field(1; "License Code"; Code[20])
        {
            TableRelation = "License Master"."Permit No.";
        }
        field(2; "HS Code"; Code[20])
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "Item Code"; Code[10])
        {
            TableRelation = Item."No.";

            trigger OnValidate();
            begin
                IF RecItem.GET("Item Code") THEN
                    "Item Description" := RecItem.Description;
            end;
        }
        field(5; "Item Description"; Text[50])
        {
        }
        field(6; "Total Quantity"; Decimal)
        {

            trigger OnValidate();
            begin
                "Avilable Quantity" := "Total Quantity";
            end;
        }
        field(7; "Used Quantity"; Decimal)
        {

            trigger OnValidate();
            begin
                "Avilable Quantity" := "Total Quantity" - "Used Quantity";
            end;
        }
        field(8; "Avilable Quantity"; Decimal)
        {
        }
        field(9; "Supplier Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "License Code", "HS Code", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RecItem: Record 27;
}

