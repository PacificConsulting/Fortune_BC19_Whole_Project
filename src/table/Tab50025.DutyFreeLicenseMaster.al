table 50025 "Duty Free License Master"
{
    // version CCIT-Fortune

    DrillDownPageID = 50034;
    LookupPageID = 50034;

    fields
    {
        field(1; "License No."; Code[25])
        {
        }
        field(2; "License Name"; Text[50])
        {
        }
        field(3; "License Date"; Date)
        {
        }
        field(4; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF RecCust.GET("Customer No.") THEN
                    "Customer Name" := RecCust.Name;
            end;
        }
        field(5; "Customer Name"; Text[50])
        {
        }
        field(6; "Total License Quantity"; Decimal)
        {

            trigger OnValidate();
            begin
                "Remainig License Quantity" := "Total License Quantity";
                //"Remainig License Quantity" := "Total License Quantity" - "Utilized License Quantity";
            end;
        }
        field(7; "Utilized License Quantity"; Decimal)
        {

            trigger OnValidate();
            begin
                "Remainig License Quantity" := "Total License Quantity" - "Utilized License Quantity";
            end;
        }
        field(8; "Remainig License Quantity"; Decimal)
        {
        }
        field(9; "Location Code"; Code[10])
        {
            TableRelation = Location.Code;
        }
    }

    keys
    {
        key(Key1; "License No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RecCust: Record 18;
        LicExpDate: Integer;
        Recvend: Record 23;
        RecCountry: Record 9;
        PermitPeriod: Date;
        PermitPeriod1: Integer;
}

