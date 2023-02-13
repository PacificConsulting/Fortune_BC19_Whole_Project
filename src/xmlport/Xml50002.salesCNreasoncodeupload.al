xmlport 50002 "salesCN-reasoncode upload"
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
            tableelement("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                XmlName = 'SCML';
                fieldelement(DocNo; "Sales Cr.Memo Line"."Document No.")
                {
                }
                fieldelement(lineno; "Sales Cr.Memo Line"."Line No.")
                {
                }
                fieldelement(ItemNo; "Sales Cr.Memo Line"."No.")
                {
                }
                fieldelement(LocNo; "Sales Cr.Memo Line"."Location Code")
                {
                }
                fieldelement(ReasoneCode; "Sales Cr.Memo Line"."Reason Code")
                {
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

    var
        lastEntryNo: Integer;
        LastTrackSpec: Record 336;
        recTrackSpec: Record 336;
        LastResEntry: Record 337;
        recResEntry: Record 337;
}

