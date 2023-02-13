table 50036 "PDC Cheques"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Cust.Code"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF rec_cust.GET("Cust.Code") THEN BEGIN
                    "Cust.Location" := rec_cust."Location Code";
                    Salesperson := rec_cust."Salesperson Code";
                END
            end;
        }
        field(3; "Creation Date"; Date)
        {
        }
        field(4; "Cheque Date"; Date)
        {
        }
        field(5; "Cheque Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(6; Open; Boolean)
        {
        }
        field(7; Remarks; Text[250])
        {
        }
        field(8; "Cust.Location"; Code[20])
        {
        }
        field(9; Salesperson; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        cd := GETFILTER("Cust.Code");
        IF cd <> '' THEN
            VALIDATE("Cust.Code", cd);
        "Creation Date" := TODAY;
        Open := TRUE;
    end;

    var
        rec_cust: Record 18;
        cd: Code[20];
}

