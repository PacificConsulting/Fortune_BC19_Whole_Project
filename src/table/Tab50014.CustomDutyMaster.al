table 50014 "Custom Duty Master"
{
    DrillDownPageID = 50014;
    LookupPageID = 50014;

    fields
    {
        field(1; "Custom Duty %"; Integer)
        {
        }
        field(2; "Surcharge Applicable"; Boolean)
        {
        }
        field(3; "Start Date"; Date)
        {
        }
        field(4; "End Date"; Date)
        {
        }
        field(5; "Surcharge %"; Integer)
        {

            trigger OnValidate();
            begin
                Item.RESET();
                IF Item.GET("Item No.") THEN BEGIN

                    Item."Surcharge Per" := "Surcharge %";
                    Item.MODIFY;
                END;
            end;
        }
        field(6; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF Vendor.GET("Vendor No.") THEN
                    "Vendor Name" := Vendor.Name;
            end;
        }
        field(7; "Vendor Name"; Text[50])
        {
        }
        field(8; "Item No."; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate();
            begin
                Item.RESET();
                IF Item.GET("Item No.") THEN BEGIN
                    "Item Name" := Item.Description;
                    Item."Custom Duty Per" := "Custom Duty %";
                    Item."Surcharge Per" := "Surcharge %";
                    Item.MODIFY;
                END;
            end;
        }
        field(9; "Item Name"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Custom Duty %", "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record 23;
        Item: Record 27;
}

