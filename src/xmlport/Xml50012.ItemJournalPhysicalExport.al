xmlport 50012 "Item Journal Physical - Export"
{
    // version CCIT san

    DefaultFieldsValidation = true;
    Direction = Export;
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(Root)
        {
            tableelement("Item Journal Line"; "Item Journal Line")
            {
                RequestFilterFields = "Journal Template Name", "Journal Batch Name";
                XmlName = 'ItemJnlLines';
                fieldelement(JournalTemplateName; "Item Journal Line"."Journal Template Name")
                {
                    FieldValidate = Yes;
                }
                fieldelement(JournalBatchName; "Item Journal Line"."Journal Batch Name")
                {
                    FieldValidate = Yes;
                }
                fieldelement(LineNo; "Item Journal Line"."Line No.")
                {
                }
                fieldelement(PostingDate; "Item Journal Line"."Posting Date")
                {
                }
                fieldelement(EntryType; "Item Journal Line"."Entry Type")
                {
                    FieldValidate = Yes;
                }
                fieldelement(DocNo; "Item Journal Line"."Document No.")
                {
                }
                fieldelement(ItemNo; "Item Journal Line"."Item No.")
                {
                    FieldValidate = Yes;
                }
                fieldelement(Description; "Item Journal Line".Description)
                {
                }
                fieldelement(Location; "Item Journal Line"."Location Code")
                {
                }
                fieldelement(UOM; "Item Journal Line"."Unit of Measure Code")
                {
                }
                fieldelement(QtyCalculated; "Item Journal Line"."Qty. (Calculated)")
                {
                }
                fieldelement(Quantity; "Item Journal Line".Quantity)
                {
                }
                fieldelement(PhysicalQuantity; "Item Journal Line"."Qty. (Phys. Inventory)")
                {
                }
                fieldelement(Dim1; "Item Journal Line"."Shortcut Dimension 1 Code")
                {
                    FieldValidate = Yes;
                }
                fieldelement(Dim2; "Item Journal Line"."Shortcut Dimension 2 Code")
                {
                    FieldValidate = Yes;
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

                trigger OnAfterGetRecord();
                begin

                    Lot := '';
                    QauntityBase := '';
                    QtyBaseInPCS := '';
                    MfgDate := '';
                    ExpDate := '';


                    recResEntry.RESET;
                    recResEntry.SETRANGE("Source Type", 83);
                    recResEntry.SETRANGE("Source Subtype", 3);
                    recResEntry.SETRANGE("Source ID", "Item Journal Line"."Journal Template Name");
                    recResEntry.SETRANGE("Source Batch Name", "Item Journal Line"."Journal Batch Name");
                    recResEntry.SETRANGE("Source Ref. No.", "Item Journal Line"."Line No.");
                    IF recResEntry.FINDFIRST THEN BEGIN

                        Lot := recResEntry."Lot No.";
                        QauntityBase := FORMAT(recResEntry."Quantity (Base)");
                        QtyBaseInPCS := FORMAT(recResEntry."Qty. to Handle (Base) In KG");

                        // MfgDate := FORMAT(recResEntry."Manufacturing Date");
                        // ExpDate := FORMAT(recResEntry."Expiration Date");
                        EntriesExist := TRUE;
                        ExpDate := FORMAT(ItemTrackingMgt.ExistingExpirationDate(
                                  "Item Journal Line"."Item No.", "Item Journal Line"."Variant Code",
                                  recResEntry."Lot No.", "Item Journal Line"."Serial No.", FALSE, EntriesExist));
                        /*//<<PCPL/MIG/NSW
                        MfgDate := FORMAT(ItemTrackingMgt.ExistingManufacturingDate(
                                   "Item Journal Line"."Item No.", "Item Journal Line"."Variant Code",
                                  recResEntry."Lot No.", "Item Journal Line"."Serial No.", FALSE, EntriesExist));
                        */ //>>PCPL/MIG/NSW

                    END;

                    cnt += 1;
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

        IF "Item Journal Line".GETFILTER("Item Journal Line"."Journal Template Name") = '' THEN
            ERROR('please select Journal Template Name..');
        IF "Item Journal Line".GETFILTER("Item Journal Line"."Journal Batch Name") = '' THEN
            ERROR('please select Journal Batch Name..');

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
}

