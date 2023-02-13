pageextension 50056 "Item_Reclass_Journal" extends "Item Reclass. Journal"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    layout
    {

        //Unsupported feature: CodeModification on "Control 37.OnValidate". Please convert manually.

        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                //--- CCIT AN
                Location.RESET;
                Location.SETRANGE(Code, "Location Code");
                IF Location.FINDFIRST THEN BEGIN
                    "Shortcut Dimension 1 Code" := Location."Branch Code";
                END

            end;
        }
        modify("New Location Code")
        {
            trigger OnAfterValidate()
            begin
                //CCIT--- AN

                Location.RESET;
                Location.SETRANGE(Code, "New Location Code");
                IF Location.FIND('-') THEN BEGIN
                    "New Shortcut Dimension 1 Code" := Location."Branch Code";
                END

            end;
        }

        addafter("Posting Date")
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Item No.")
        {
            field("Entry Type"; "Entry Type")
            {
                ApplicationArea = all;

            }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In Pcs';
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("Import Data")
            {
                AccessByPermission = XMLport 50005 = X;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    CLEAR(ImportXml);
                    ImportXml.RUN;
                end;
            }
            action("Expired Moving")
            {

                trigger OnAction();
                begin
                    //CCIT-PRI-Test
                    // CUItemreclass.InsertItemReclass; //PCPL/MIG/NSW
                end;
            }
        }
    }

    var
        //CUItemreclass: Codeunit 50003; //PCPL/MIG/NSW
        ImportXml: XMLport 50005;
        Location: Record 14;
}

