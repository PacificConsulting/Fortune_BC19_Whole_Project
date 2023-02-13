xmlport 50006 "Item Journals with Reason Code"
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
            tableelement("Item Journal Line"; "Item Journal Line")
            {
                XmlName = 'ItemJnlLines';
                MinOccurs = Once;
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
                fieldelement(Quantity; "Item Journal Line".Quantity)
                {
                }
                fieldelement(MfgDate; "Item Journal Line"."Warranty Date")
                {
                }
                fieldelement(ExpDate; "Item Journal Line"."Expiration Date")
                {
                }
                fieldelement(ConQty; "Item Journal Line"."Conversion Qty")
                {
                    FieldValidate = No;
                }
                fieldelement(UnitCostInKG; "Item Journal Line"."Unit Amount")
                {
                    FieldValidate = Yes;
                }
                fieldelement(Dim1; "Item Journal Line"."Shortcut Dimension 1 Code")
                {
                    FieldValidate = Yes;
                }
                fieldelement(Dim2; "Item Journal Line"."Shortcut Dimension 2 Code")
                {
                    FieldValidate = Yes;
                }
                textelement(QtyBase)
                {
                }
                textelement(Lot)
                {
                }
                textelement(QtyBaseInPCS)
                {
                }
                fieldelement(ReasonCode; "Item Journal Line"."Reason Code")
                {
                    MinOccurs = Once;
                }

                trigger OnAfterInsertRecord();
                begin

                    recResEntry.INIT;
                    recResEntry."Entry No." := lastEntryNo;
                    recResEntry.VALIDATE(recResEntry."Item No.", "Item Journal Line"."Item No.");
                    recResEntry.VALIDATE(recResEntry."Location Code", "Item Journal Line"."Location Code");
                    recResEntry."Reservation Status" := recResEntry."Reservation Status"::Prospect;  //CITS-MM
                    recResEntry."Item Tracking" := recResEntry."Item Tracking"::"Lot No.";
                    recResEntry."Variant Code" := "Item Journal Line"."Variant Code";
                    recResEntry."Source Type" := 83;
                    recResEntry."Source Subtype" := "Item Journal Line"."Entry Type";
                    recResEntry."Source ID" := "Item Journal Line"."Journal Template Name";
                    recResEntry."Source Batch Name" := "Item Journal Line"."Journal Batch Name";
                    recResEntry."Source Ref. No." := "Item Journal Line"."Line No.";
                    //recResEntry.Positive := TRUE;
                    recResEntry."Qty. per Unit of Measure" := "Item Journal Line"."Qty. per Unit of Measure";
                    //recResEntry."Bin Code" := "Item Journal Line"."Bin Code";


                    recResEntry."Creation Date" := TODAY;
                    recResEntry."Created By" := USERID;

                    //EVALUATE(recResEntry."Quantity (Base)","Item Journal Line".Quantity);
                    //recResEntry.VALIDATE("Quantity (Base)","Item Journal Line".Quantity);
                    IF QtyBase <> '' THEN BEGIN
                        EVALUATE(recResEntry."Quantity (Base)", QtyBase);
                        recResEntry.VALIDATE(recResEntry."Quantity (Base)");
                    END;
                    IF QtyBaseInPCS <> '' THEN BEGIN
                        EVALUATE(recResEntry."Qty. to Handle (Base) In KG", QtyBaseInPCS);
                        recResEntry.VALIDATE(recResEntry."Qty. to Handle (Base) In KG");
                    END;
                    recResEntry.VALIDATE(recResEntry."Lot No.", Lot);
                    recResEntry.VALIDATE("Expiration Date", "Item Journal Line"."Expiration Date");
                    recResEntry.VALIDATE(recResEntry."Warranty Date", "Item Journal Line"."Warranty Date");
                    recResEntry.VALIDATE("Manufacturing Date", "Item Journal Line"."Manufacturing Date");
                    recResEntry.INSERT;

                    lastEntryNo += 1;
                end;

                trigger OnBeforeInsertRecord();
                begin
                    //ITEMJNL

                    "Item Journal Line".VALIDATE("Item Journal Line"."Source Code", 'ITEMJNL');

                    //MESSAGE('%1',"Item Journal Line"."Line No.");
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
        MESSAGE('uploaded successfully....');
    end;

    trigger OnPreXmlPort();
    begin
        /*
        LastTrackSpec.RESET;
        LastTrackSpec.FINDLAST;
        lastEntryNo := LastTrackSpec."Entry No." + 1;
        */

        LastResEntry.RESET;

        IF LastResEntry.FINDLAST THEN
            lastEntryNo := LastResEntry."Entry No." + 1
        ELSE
            lastEntryNo := 1;

    end;

    var
        lastEntryNo: Integer;
        LastTrackSpec: Record 336;
        recTrackSpec: Record 336;
        LastResEntry: Record 337;
        recResEntry: Record 337;
}

