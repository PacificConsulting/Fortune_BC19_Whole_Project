xmlport 50021 "TDS TCS Data Upload"
{
    // version CCIT san
    DefaultFieldsValidation = true;
    Direction = Both;
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(Root)
        {
            tableelement("TDS TCS Setup"; "TDS TCS Setup")
            {
                XmlName = 'TDSUpload';
                fieldelement(TaxTpe; "TDS TCS Setup"."Tax Type")
                {
                    FieldValidate = Yes;
                }
                fieldelement(SectionCode; "TDS TCS Setup"."Section Code")
                {

                }
                fieldelement(JournalBatchName; "TDS TCS Setup"."Assessee Code")
                {
                    FieldValidate = Yes;
                }
                fieldelement(LineNo; "TDS TCS Setup"."Effective Date")
                {
                }
                fieldelement(PostingDate; "TDS TCS Setup"."Concessional Code")
                {
                }
                fieldelement(EntryType; "TDS TCS Setup"."Nature of Remittance")
                {
                    FieldValidate = Yes;
                }
                fieldelement(DocNo; "TDS TCS Setup"."Act Applicable")
                {
                }
                fieldelement(ItemNo; "TDS TCS Setup"."Country Code")
                {
                    FieldValidate = Yes;
                }
                fieldelement(Location; "TDS TCS Setup"."TDS %")
                {
                }
                fieldelement(UOM; "TDS TCS Setup"."Non PAN TDS %")
                {
                }
                fieldelement(Quantity; "TDS TCS Setup"."Surcharge %")
                {
                }
                fieldelement(MfgDate; "TDS TCS Setup"."eCESS %")
                {
                }
                fieldelement(ExpDate; "TDS TCS Setup"."SHE Cess  %")
                {
                }
                fieldelement(ConQty; "TDS TCS Setup"."Surcharge Threshold Amount")
                {
                    FieldValidate = No;
                }
                fieldelement(UnitCostInKG; "TDS TCS Setup"."TDS Threshold Amount")
                {
                    FieldValidate = Yes;
                }
                fieldelement(Dim1; "TDS TCS Setup"."Per Contract Value")
                {
                    FieldValidate = Yes;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort();
    begin
        MESSAGE('uploaded successfully....');
    end;

    trigger OnPreXmlPort();
    begin
        "TDS TCS Setup".Reset();
        IF "TDS TCS Setup".FindFirst() then begin
            "TDS TCS Setup".DeleteAll();
            Message('Delete data');
        end;
    end;

    var
        lastEntryNo: Integer;
        LastTrackSpec: Record 336;
        recTrackSpec: Record 336;
        LastResEntry: Record 337;
        recResEntry: Record 337;
}

