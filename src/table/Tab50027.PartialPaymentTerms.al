table 50027 "Partial Payment Terms"
{
    // version CCIT-Fortune

    DrillDownPageID = 50037;
    LookupPageID = 50037;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Type; Option)
        {
            OptionMembers = " ",Advanced,Shipment,Delivery,Invoiced;
        }
        field(3; Percentage; Decimal)
        {

            trigger OnValidate();
            begin
                //TotalPer:=0;
                RecPartialPayTrems.RESET;
                RecPartialPayTrems.SETRANGE(RecPartialPayTrems.Code, Rec.Code);
                //RecPartialPayTrems.SETRANGE(RecPartialPayTrems."Shipment Method",Rec."Shipment Method");
                IF RecPartialPayTrems.FINDSET THEN
                    REPEAT
                        TotalPer += RecPartialPayTrems.Percentage;
                        ShipmentMethod := RecPartialPayTrems."Shipment Method";
                    UNTIL RecPartialPayTrems.NEXT = 0;
                IF ((TotalPer + Percentage) > 100) THEN
                    ERROR('Payment Percentage must be equal to 100');
            end;
        }
        field(4; "Due Date Calculation"; DateFormula)
        {
            CaptionML = ENU = 'Due Date Calculation',
                        ENN = 'Due Date Calculation';
        }
        field(5; Description; Text[50])
        {
        }
        field(6; "Shipment Method"; Code[10])
        {
            Description = 'CCIT';
            TableRelation = "Shipment Method";

            trigger OnValidate();
            begin
                ShipmentMethod := '';
                RecPartialPayTrems1.RESET;
                RecPartialPayTrems1.SETRANGE(RecPartialPayTrems1.Code, Rec.Code);
                //RecPartialPayTrems1.SETRANGE(RecPartialPayTrems1."Shipment Method",Rec."Shipment Method");
                IF RecPartialPayTrems1.FINDFIRST THEN BEGIN
                    ShipmentMethod := RecPartialPayTrems1."Shipment Method";

                    IF (ShipmentMethod <> Rec."Shipment Method") AND (ShipmentMethod <> '') THEN
                        ERROR('Shipment Method same as %1', ShipmentMethod);

                END;
            end;
        }
        field(7; "Customer/Vendor Type"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Customer,Vendor;
        }
        field(8; "Customer/Vendor No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = IF ("Customer/Vendor Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Customer/Vendor Type" = CONST(Vendor)) Vendor."No.";
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        RecPartialPayTrems.RESET;
        RecPartialPayTrems.SETRANGE(RecPartialPayTrems.Code, Rec.Code);
        IF RecPartialPayTrems.FINDSET THEN
            REPEAT
                TotalPer += RecPartialPayTrems.Percentage;
            UNTIL RecPartialPayTrems.NEXT = 0;
        IF ((TotalPer + Percentage) > 100) THEN
            ERROR('Payment Percentage must be equal to 100');
    end;

    var
        RecPartialPayTrems: Record 50027;
        TotalPer: Decimal;
        ShipmentMethod: Code[10];
        RecPartialPayTrems1: Record 50027;
}

