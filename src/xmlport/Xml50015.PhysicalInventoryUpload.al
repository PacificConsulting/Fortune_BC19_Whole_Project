xmlport 50015 "Physical Inventory - Upload"
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
            tableelement(Integer;Integer)
            {
                XmlName = 'PhysicalJnl';
                textelement(JournalTemplateName)
                {
                }
                textelement(JournalBatchName)
                {
                }
                textelement(LineNo)
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(EntryType)
                {
                }
                textelement(DocNo)
                {
                }
                textelement(ItemNo)
                {
                }
                textelement(Description)
                {
                }
                textelement(Location)
                {
                }
                textelement(UOM)
                {
                }
                textelement(PhysicalQty)
                {
                }
                textelement(Lot)
                {
                }
                textelement(QauntityBase)
                {
                }
                textelement(QtyBaseInPCS)
                {
                }
                textelement(MfgDate)
                {
                }
                textelement(ExpDate)
                {
                }

                trigger OnBeforeInsertRecord();
                begin

                    EVALUATE(line,LineNo);
                    EVALUATE(PhysInv,PhysicalQty);
                end;
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

        MESSAGE('%1 no. of records imported sucessfully..',cnt);
    end;

    trigger OnPreXmlPort();
    begin

        cnt := 0;
    end;

    var
        lastEntryNo : Integer;
        LastTrackSpec : Record 336;
        recTrackSpec : Record 336;
        LastResEntry : Record 337;
        recResEntry : Record 337;
        ItemTrackingMgt : Codeunit 6500;
        EntriesExist : Boolean;
        cnt : Integer;
        recItemJnlLine : Record 83;
        line : Integer;
        PhysInv : Decimal;
}

