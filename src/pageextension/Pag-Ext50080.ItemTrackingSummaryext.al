pageextension 50080 "Item_Tracking_Summary_ext" extends "Item Tracking Summary"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {
        modify("Warranty Date")
        {
            Caption = 'Manufacturing Date';
            Enabled = true;
            Visible = true;

        }
        addafter("Expiration Date")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter("Selected Quantity")
        {
            field(RemainingShelfLife; RemainingShelfLife)
            {
                Caption = 'Remaining Shelf Life %';
                ApplicationArea = all;
            }
            field(RemainingShelfLifeDays; RemainingShelfLifeDays)
            {
                ApplicationArea = all;
                Caption = 'Remaining Days';
            }
        }
    }

    var
        RemainingShelfLife: Decimal;
        RemainingShelfLifeDays: Decimal;
        recEntrySumm: Record 338;


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin
        //>> CS
        RemainingShelfLife := 0;
        IF ("Expiration Date" <> 0D) AND ("Manufacturing Date" <> 0D) THEN BEGIN
            RemainingShelfLife := ("Expiration Date" - WORKDATE) / ("Expiration Date" - "Manufacturing Date") * 100;
            RemainingShelfLifeDays := "Expiration Date" - WORKDATE;
        END;
        //<< CS

    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    var
    //recEntrySummNew: Record 338;
    begin
        //ccit san 271118---
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            recEntrySummNew := Rec;
            // recEntrySummNew.Reset();
            // recEntrySummNew.SetRange("Lot No.", Rec."Lot No.");
            // IF recEntrySummNew.FindFirst() then
            //IF recEntrySummNew."Expiration Date" < Today then //141220
            //Error('Lot is Expired New'); 141220

            IF recEntrySumm."Lot No." <> Rec."Lot No." THEN
                IF NOT CONFIRM('You have selected wrong batch please recheck. Do You want to continue?') THEN
                    ERROR('Please select correct batch');
        END;
        //--    
    end;

    trigger OnOpenPage()
    var
        ILE: Record 32;
    begin
        recEntrySummNew := Rec;
    end;

    var
        recEntrySummNew: Record 338;

}

