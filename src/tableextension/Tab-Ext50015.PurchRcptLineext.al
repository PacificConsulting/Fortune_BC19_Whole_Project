tableextension 50015 "Purch_Rcpt_Line_ext" extends "Purch. Rcpt. Line"
{


    fields
    {
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
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
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50082; "BOE Qty.In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                IF Type = Type::Item THEN BEGIN
                    IF (Rec."Unit of Measure Code" = 'PCS') THEN BEGIN
                        IF RecUOM1.GET(Rec."No.", 'PCS') THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN BEGIN
                                "BOE Qty.In KG" := Rec."BOE Qty.In PCS" / RecUOM1.Weight;
                            END;
                        END;
                    END;
                END;
                //CCIT-SG
            end;
        }
        field(50083; "BOE Qty.In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                IF Type = Type::Item THEN BEGIN
                    IF (Rec."Unit of Measure Code" = 'PCS') THEN BEGIN
                        IF RecUOM1.GET(Rec."No.", 'PCS') THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN BEGIN
                                "BOE Qty.In PCS" := Rec."BOE Qty.In KG" * RecUOM1.Weight;
                            END;
                        END;
                    END;
                END;
                //CCIT-SG
            end;
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50124; "Trans.Ord."; Code[20])
        {
            Description = 'RDK 230919';
        }
        field(50126; "TCS Nature of Collection"; Code[10])
        {
            CaptionML = ENU = 'TCS Nature of Collection',
                        ENN = 'TCS Nature of Collection';
            TableRelation = "TCS Nature Of Collection";

            trigger OnLookup();
            var
                NatureOfCollection: Record "TCS Nature Of Collection";
                TempNatureOfCollection: Record "TCS Nature Of Collection" temporary;
            begin
            end;
        }
        field(50127; "TCS %"; Decimal)
        {
            DecimalPlaces = 2 : 3;
            Editable = false;
        }
        field(50128; "TCS Base Amount"; Decimal)
        {
            Editable = false;
        }
        field(50129; "TCS Type"; Option)
        {
            CaptionML = ENU = 'TCS Type',
                        ENN = 'TCS Type';
            OptionCaptionML = ENU = ' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H',
                              ENN = ' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H';
            OptionMembers = " ",A,B,C,D,E,F,G,H,I,J,K,L,M,N,"1H";
        }
        field(50130; "Purchase Amount"; Decimal)
        {
            Editable = false;
        }
        field(50131; "Price Inclusive of Tax"; Boolean)
        {
            CaptionML = ENU = 'Price Inclusive of Tax',
                        ENN = 'Price Inclusive of Tax';

            trigger OnValidate();
            var
            //StrOrderDetails : Record "13794";
            //StrOrderLines : Record "13795";
            //SaleLineDetailBuffer : Record 16583;
            begin
            end;
        }
        field(50132; "GST On Assessable Value"; Boolean)
        {
            CaptionML = ENU = 'GST On Assessable Value',
                        ENN = 'GST On Assessable Value';

            trigger OnValidate();
            var
                GSTGroup: Record "GST Group";
            begin
            end;
        }
        field(50133; "GST Assessable Value (LCY)"; Decimal)
        {
            CaptionML = ENU = 'GST Assessable Value (LCY)',
                        ENN = 'GST Assessable Value (LCY)';
        }
        field(50134; "TCS Amount"; Decimal)
        {
            AutoFormatType = 1;
            Editable = false;
        }
        field(500135; "Bill Of Entry No."; Text[20])
        {
            Description = 'CCIT_kj_27-04-21';
        }
    }


    trigger OnDelete();
    begin

        //CCIT-PRI-191118
        ERROR('You do not have permission');
        //CCIT-PRI-191118
    end;

    var
        RecUOM1: Record 5404;
        RecItem2: Record 27;
}

