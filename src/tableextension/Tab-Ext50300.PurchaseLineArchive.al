tableextension 50300 Purchase_Line_Archive_ext extends "Purchase Line Archive"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    fields
    {

        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
        }
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                /*
                IF Rec."License No." <>'' THEN BEGIN
                  IF RecLicNo.GET(Rec."License No.") THEN BEGIN
                    IF RecLicNo."Permit Expiry Date" <> 0D THEN BEGIN
                       recPH.RESET;
                       recPH.SETRANGE(recPH."No.","Document No.");
                       IF recPH.FINDFIRST THEN
                        PODate := recPH."Posting Date";
                        EXPDate := RecLicNo."Permit Expiry Date";
                        IF PODate < EXPDate THEN BEGIN
                            TotalLicConversionQty :=0;
                            RecILE.RESET;
                            RecILE.SETRANGE(RecILE."Item No.",Rec."No.");
                            RecILE.SETRANGE(RecILE."License No.",Rec."License No.");
                            IF RecILE.FINDSET THEN
                              REPEAT
                                TotalLicConversionQty := TotalLicConversionQty + RecILE."Conversion Qty";
                                //MESSAGE('%1   %2',TotalLicQty,Rec.Quantity);
                              UNTIL RecILE.NEXT = 0;
                
                          IF (Quantity > TotalLicConversionQty) THEN
                            ERROR('Inventory not available for this Item No. against License No. %1',Rec."License No.");
                          END ELSE  IF PODate > EXPDate THEN
                              ERROR('License has been Expired');
                    END;
                  END;
                END;
                //---- CCIT-SG
                */

            end;
        }
        field(50065; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = false;
            TableRelation = "Unit of Measure";
        }
        field(50066; "Storage Categories"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FREEZER,CHILLED,DRY;
        }
        field(50068; "Qty. to Invoice In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50069; "Qty. to Receive In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50070; "HS Code"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "HS Code Master"."HS Code" WHERE("License Code" = FIELD("License No."));
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

