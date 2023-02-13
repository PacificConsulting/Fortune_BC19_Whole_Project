pageextension 50020 "Sales_inv_Subform_ext" extends "Sales Invoice Subform"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    layout
    {
        modify(Description)
        {
            Editable = false;
        }
        modify("Description 2")
        {
            Editable = false;
        }
        modify("Item Reference No.")
        {
            Editable = false;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify("Tax Group Code")
        {
            Editable = false;
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                // rdk190919 -
                IF Type = Type::"G/L Account" THEN
                    ITemcodevisible := TRUE
                ELSE
                    ITemcodevisible := FALSE
                // rdk190919 +
            end;
        }
        modify("GST Group Code")
        {
            Editable = false;
            Enabled = true;
        }
        modify("HSN/SAC Code")
        {
            Editable = false;
        }

        addbefore("TCS Nature of Collection")
        {
            field("TCS Section"; "TCS Section")
            {
                ApplicationArea = all;
                Visible = TCSSecVisible;
            }
        }
        addafter("No.")
        {
            field("Item code"; "Item code")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Reason For Free Sample"; "Reason For Free Sample")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
            // field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = all;
            // }
            // field("HSN/SAC Code"; "HSN/SAC Code")
            // {
            //     ApplicationArea = all;
            //     Editable = true;
            //     Enabled = true;
            // }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
        }

    }
    trigger OnOpenPage()
    var
    // Vend: Record Vendor;
    Begin
        Clear(TCSSecVisible);
        IF Cust.Get("Sell-to Customer No.") then begin
            IF Cust."TCS 206 CAA Applicable" = Cust."TCS 206 CAA Applicable"::"Non Comply" then
                TCSSecVisible := True
            else
                TCSSecVisible := false;
        END;
    End;

    trigger OnAfterGetRecord()
    var
    // Cust: Record Vendor;
    Begin
        Clear(TCSSecVisible);
        IF Cust.Get("Sell-to Customer No.") then begin
            IF Cust."TCS 206 CAA Applicable" = Cust."TCS 206 CAA Applicable"::"Non Comply" then
                TCSSecVisible := True
            else
                TCSSecVisible := false;
        END;
    END;

    var
        ITemcodevisible: Boolean;
        TCSSecVisible: Boolean;
        Cust: Record 18;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

