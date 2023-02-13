tableextension 50492 "Item_Vendor_ext" extends "Item Vendor"
{
    // version NAVW19.00.00.48316,CCIT-Fortune

    fields
    {

        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                IF RecItem.GET("Item No.") THEN BEGIN
                    "Fortune Description" := RecItem.Description;
                    "Vendor Description" := RecItem."Description 2";
                    IF RecItem.Blocked = TRUE THEN
                        Blocked := TRUE
                    ELSE
                        Blocked := FALSE;
                END;

            end;
        }


        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            var
                vend: Record vendor;
            begin
                IF Type = Type::Vendor THEN  //CCIT-SG
                    Vend.GET("Vendor No.");
                "Lead Time Calculation" := Vend."Lead Time Calculation";

                //Vend.GET("Vendor/Customer No.");
                //"Lead Time Calculation" := Vend."Lead Time Calculation";

            end;

        }

        field(50000; "Fortune Description"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50001; Type; Option)
        {
            Description = 'CCIT';
            OptionCaption = '" ,Customer,Vendor"';
            OptionMembers = " ",Customer,Vendor;
        }
        field(50002; "Vendor Description"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50003; Blocked; Boolean)
        {
            CaptionML = ENU = 'Blocked',
                        ENN = 'Blocked';
            Description = 'CCIT';
        }
    }
    keys
    {
        key(Key4; "Fortune Description", "Vendor Description")
        {
        }
    }

    var
        RecItem: Record 27;
        Cust: Record 18;
}

