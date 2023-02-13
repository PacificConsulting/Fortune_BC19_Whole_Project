table 50038 "TDS TCS Setup"
{
    Caption = 'TDS TCS Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tax Type"; Code[20])
        {
            Caption = 'Tax Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                // IF ("Tax Type" <> 'TDS') OR ("Tax Type" <> 'TCS') then
                //   Error('Please Type only TDS OR TCS');
            end;
        }
        field(2; "Section Code"; Code[10])
        {
            Caption = 'Section Code';
            DataClassification = ToBeClassified;
            //TableRelation = "TDS Section".Code WHERE(ecode = field(eTDS));
            trigger OnValidate()
            var
                TDSSEC: Record "TDS Section";
                TCSSEC: record "TCS Nature Of Collection";
            begin
                // TDSSEC.Reset();
                // TDSSEC.SetRange(Code, "Section Code");
                // IF TDSSEC.FindFirst() then
                //     eTDS := TDSSEC.ecode;

                // TCSSEC.Reset();
                // TCSSEC.SetRange(Code, "Section Code");
                // IF TCSSEC.FindFirst() then
                //     eTDS := TCSSEC.eTCS

            end;

        }
        field(3; "Assessee Code"; Code[10])
        {
            Caption = 'Assessee Code';
            DataClassification = ToBeClassified;
            TableRelation = "Assessee Code".Code;

        }
        field(4; "Concessional Code"; Code[10])
        {
            Caption = 'Concessional Code';
            DataClassification = ToBeClassified;
        }
        field(5; "TDS %"; Decimal)
        {
            Caption = 'TDS %';
            DataClassification = ToBeClassified;
        }
        field(6; "Effective Date"; Date)
        {
            Caption = 'Effective Date';

        }
        field(7; "Nature of Remittance"; Code[10])
        {
            Caption = 'Nature of Remittance';

        }
        field(8; "Act Applicable"; Code[10])
        {
            Caption = 'Act Applicable';

        }
        field(9; "Country Code"; Code[10])
        {
            Caption = 'Country Code';


        }
        field(10; "Non PAN TDS %"; Decimal)
        {
            Caption = 'Non PAN TDS %';

        }
        field(11; "Surcharge %"; Decimal)
        {
            Caption = 'Surcharge %';

        }
        field(12; "eCESS %"; Decimal)
        {
            Caption = 'eCESS %';

        }
        field(13; "SHE Cess  %"; Decimal)
        {
            Caption = 'SHE Cess  %';

        }
        field(14; "Surcharge Threshold Amount"; Decimal)
        {
            Caption = 'Surcharge Threshold Amount';

        }
        field(15; "TDS Threshold Amount"; Decimal)
        {
            Caption = 'TDS Threshold Amount';

        }
        field(16; "Per Contract Value"; Decimal)
        {
            Caption = 'Per Contract Value';

        }
        field(17; eTDS; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'eTDS/TCS';
        }

    }

    keys
    {
        key(Key1; "Tax Type", "Section Code", "Assessee Code", "Concessional Code")
        {
            Clustered = true;
        }
        key(Key2; "TDS %")
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}