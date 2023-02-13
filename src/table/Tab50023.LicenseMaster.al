table 50023 "License Master"
{
    // version CCIT-Fortune

    DrillDownPageID = 50128;
    LookupPageID = 50128;

    fields
    {
        field(1; "Permit No."; Code[25])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF RecCust.GET("Customer No.") THEN
                    "Customer Name" := RecCust.Name;
            end;
        }
        field(4; "Customer Name"; Text[50])
        {

        }
        field(5; "Permit Validity"; Code[20])
        {
        }
        field(6; "Permit Start Date"; Date)
        {

            trigger OnValidate();
            begin
                //CCIT-SG
                //IF ("Permit Validity" <> '') AND ("Permit Start Date" <> 0D) THEN BEGIN
                //   LicExpDate := CALCDATE("Permit Validity","Permit Start Date");
                //  VALIDATE("Permit Expiry Date",LicExpDate-1);
                //END;
                //CCIT-SG
            end;
        }
        field(7; "Permit Expiry Date"; Date)
        {

            trigger OnValidate();
            begin
                //CCIT-SG
                IF ("Permit Start Date" <> 0D) AND ("Permit Expiry Date" <> 0D) THEN BEGIN
                    //LicExpDate := CALCDATE("Permit Validity","Permit Start Date");
                    LicExpDate := "Permit Expiry Date" - "Permit Start Date";
                    "Permit Validity" := FORMAT(LicExpDate);
                    //    VALIDATE("Permit Validity",LicExpDate);
                END;
                //CCIT-SG
            end;
        }
        field(8; "Total License Value"; Decimal)
        {
        }
        field(9; "Utilized License Value"; Decimal)
        {
        }
        field(10; "License Quantity"; Decimal)
        {

            trigger OnValidate();
            begin
                "Balance Quantity" := "License Quantity";
            end;
        }
        field(11; "Utilized License Quantity"; Decimal)
        {

            trigger OnValidate();
            begin
                "Balance Quantity" := "License Quantity" - "Utilized License Quantity";
            end;
        }
        field(12; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                IF Recvend.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := Recvend.Name;
                    "Country Code" := Recvend.County;
                END;
            end;
        }
        field(13; "Vendor Name"; Text[50])
        {
        }
        field(14; "Product Category"; Code[20])
        {
        }
        field(15; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region".Code;

            trigger OnValidate();
            begin
                IF RecCountry.GET("Country Code") THEN
                    "Country Name" := RecCountry.Name;
            end;
        }
        field(16; "HS Code"; Code[20])
        {
        }
        field(17; "Next Permit Application Date"; Date)
        {
        }
        field(18; "Application Sent On. Date"; Date)
        {
        }
        field(19; "New Permit Application No."; Code[25])
        {
        }
        field(20; "New Permit Application Date"; Date)
        {
        }
        field(21; "New Permit Appl Qty In KG"; Decimal)
        {
        }
        field(22; "Country Name"; Text[50])
        {
        }
        field(23; "Permit Period"; Code[20])
        {

            trigger OnValidate();
            begin

                IF (FORMAT("Permit Period") <> '') AND ("Permit Expiry Date" <> 0D) THEN BEGIN
                    PermitPeriod := CALCDATE("Permit Period", "Permit Expiry Date");
                    //PermitPeriod := CALCDATE('<"Permit Expiry Date"-"Permit Period">',"Permit Expiry Date");
                    VALIDATE("Next Permit Application Date", PermitPeriod);
                    //"Next Permit Application Date" := "Permit Expiry Date" + ;

                END;
            end;
        }
        field(24; "Balance Quantity"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Permit No.")
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

