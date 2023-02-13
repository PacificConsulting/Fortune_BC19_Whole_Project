xmlport 50014 "Physical Inventory - Export"
{
    // version CCIT san

    DefaultFieldsValidation = true;
    Direction = Export;
    FileName = 'PhysicalInventory.csv';
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(Root)
        {
            tableelement("Reservation Entry"; "Reservation Entry")
            {
                XmlName = 'ReservationEntry';
                fieldelement(JournalTemplateName; "Reservation Entry"."Source ID")
                {
                    FieldValidate = Yes;
                }
                fieldelement(JournalBatchName; "Reservation Entry"."Source Batch Name")
                {
                    FieldValidate = Yes;
                }
                fieldelement(LineNo; "Reservation Entry"."Source Ref. No.")
                {
                }
                textelement(PostingDate)
                {
                }
                fieldelement(EntryType; "Reservation Entry"."Source Subtype")
                {
                    FieldValidate = Yes;
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
                textelement(QtyCalculated)
                {
                }
                fieldelement(Lot; "Reservation Entry"."Lot No.")
                {
                }
                fieldelement(QauntityBase; "Reservation Entry"."Quantity (Base)")
                {
                }
                fieldelement(QtyBaseInPCS; "Reservation Entry"."Qty. to Handle (Base) In KG")
                {
                }
                textelement(MfgDate)
                {
                }
                textelement(ExpDate)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    recItemJnlLine.RESET;
                    recItemJnlLine.SETRANGE("Journal Template Name", "Reservation Entry"."Source ID");
                    recItemJnlLine.SETRANGE("Journal Batch Name", "Reservation Entry"."Source Batch Name");
                    recItemJnlLine.SETRANGE("Line No.", "Reservation Entry"."Source Ref. No.");
                    IF recItemJnlLine.FINDFIRST THEN BEGIN
                        PostingDate := FORMAT(recItemJnlLine."Posting Date");
                        DocNo := recItemJnlLine."Document No.";
                        ItemNo := recItemJnlLine."Item No.";
                        Description := recItemJnlLine.Description;
                        Location := recItemJnlLine."Location Code";
                        UOM := recItemJnlLine."Unit of Measure Code";
                        QtyCalculated := FORMAT(recItemJnlLine."Qty. (Calculated)");

                        EntriesExist := TRUE;
                        ExpDate := FORMAT(ItemTrackingMgt.ExistingExpirationDate(
                                  recItemJnlLine."Item No.", recItemJnlLine."Variant Code",
                                  "Reservation Entry"."Lot No.", recItemJnlLine."Serial No.", FALSE, EntriesExist));
                        /* //PCPL/MIG/NSW
                        MfgDate := FORMAT(ItemTrackingMgt.ExistingManufacturingDate(
                                    recItemJnlLine."Item No.", recItemJnlLine."Variant Code",
                                  "Reservation Entry"."Lot No.", recItemJnlLine."Serial No.", FALSE, EntriesExist));
                        */ //PCPL/MIG/NSW
                    END;

                    "Reservation Entry"."Quantity (Base)" := ABS("Reservation Entry"."Quantity (Base)");

                    cnt += 1;
                end;

                trigger OnPreXmlItem();
                begin

                    "Reservation Entry".SETRANGE("Reservation Entry"."Source ID", 'PHYS. INVE');
                    "Reservation Entry".SETRANGE("Reservation Entry"."Source Batch Name", 'DEFAULT');
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

        MESSAGE('%1 no. of records exported sucessfully..', cnt);
    end;

    trigger OnPreXmlPort();
    begin

        cnt := 0;
    end;

    var
        lastEntryNo: Integer;
        LastTrackSpec: Record 336;
        recTrackSpec: Record 336;
        LastResEntry: Record 337;
        recResEntry: Record 337;
        ItemTrackingMgt: Codeunit 6500;
        EntriesExist: Boolean;
        cnt: Integer;
        recItemJnlLine: Record 83;
}

