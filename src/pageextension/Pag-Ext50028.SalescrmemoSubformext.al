pageextension 50028 "Sales_cr_memo_Subform_ext" extends "Sales Cr. Memo Subform"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    layout
    {
        modify("Qty. to Assign")
        {
            Editable = false;
        }
        modify("Qty. Assigned")
        {
            Editable = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = false;
        }
        modify("Item Reference No.")
        {
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }
        modify("Description 2")
        {
            Editable = false;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify("GST Group Code")
        {
            Editable = false;
        }
        addafter("No.")
        {
            field("Item code"; "Item code")
            {
                ApplicationArea = all;

                trigger OnValidate();
                begin

                    // rdk 190919 -
                    IF Type <> Type::"G/L Account" THEN
                        ERROR('You cannot enter the item code for Non GL Account Type');

                    // rdk 190919 +
                end;
            }
        }
        modify("HSN/SAC Code")
        {
            Editable = false;

        }
        addafter(Description)
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
        }

        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity in PCS';
                ApplicationArea = all;
                Editable = false;
            }
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
            }
            field("Customer Price Group"; "Customer Price Group")
            {
                ApplicationArea = all;
            }
            field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Quarantine Qty In KG"; "Quarantine Qty In KG")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                Editable = false;
            }
            field("Actual Qty In PCS"; "Actual Qty In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Qty In KG"; "Actual Qty In KG")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                Editable = false;
            }

        }
        addafter("Work Type Code")
        {
            field("Variance Qty. In KG"; "Variance Qty. In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Salable Qty. In KG"; "Salable Qty. In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Variance Qty. In PCS"; "Variance Qty. In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Salable Qty. In PCS"; "Salable Qty. In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    var
        ItemCodeVisible: Boolean;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

