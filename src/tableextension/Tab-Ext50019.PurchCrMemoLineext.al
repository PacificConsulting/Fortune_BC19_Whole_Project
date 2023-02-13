tableextension 50019 "Purch_Cr_Memo_Line_ext" extends "Purch. Cr. Memo Line"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune

    fields
    {


        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50082; "BOE Qty.In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50083; "BOE Qty.In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
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
            // StrOrderDetails : Record "13794";
            // StrOrderLines : Record "13795";
            // SaleLineDetailBuffer : Record "16583";
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
    }




    trigger OnDelete();
    begin
        //CCIT-PRI-191118
        ERROR('You do not have permission');
        //CCIT-PRI-191118
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

