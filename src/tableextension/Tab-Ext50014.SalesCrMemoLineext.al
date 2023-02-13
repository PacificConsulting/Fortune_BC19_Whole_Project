tableextension 50014 "Sales_Cr_Memo_Line_ext" extends "Sales Cr.Memo Line"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    fields
    {

        modify("Invoice Type")
        {
            OptionCaptionML = ENU = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST', ENN = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';

            //Unsupported feature: Change OptionString on ""Invoice Type"(Field 16609)". Please convert manually.

        }

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
        field(50064; "Saleable Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50065; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = false;
            TableRelation = "Unit of Measure";
        }
        field(50084; "Customer License No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50085; "Customer License Name"; Text[100])
        {
            Description = 'CCIT';
        }
        field(50086; "Customer License Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category".Code;
        }
        field(50088; "Reason For Free Sample"; Option)
        {
            OptionCaption = '" ,New Product,Liquidation,Friend & Family,Market Penetration,Competitor,Government Department"';
            OptionMembers = " ","New Product",Liquidation,"Friend & Family","Market Penetration",Competitor,"Government Department";
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50112; "Reason Code"; Code[10])
        {
            Description = 'CCIT';
            TableRelation = "Reason Code";

            trigger OnValidate();
            begin
                //CCIT AN
                IF RecReasonCode.GET("Reason Code") THEN BEGIN
                    IF RecReasonCode.Blocked = TRUE THEN
                        ERROR('This Reason Code Is Blocked');
                END;
                //
            end;
        }
        field(50126; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH","CPL-GOA","DPL 20-21";
        }
        field(50131; "Item code"; Code[20])
        {
            Description = 'RDK 190919 - for GL CN desc//TK';
            TableRelation = Item;

            trigger OnValidate();
            var
                RecItem: Record 27;
            begin
                IF RecItem.GET("Item code") THEN begin
                    "HSN/SAC Code" := RecItem."HSN/SAC Code";
                    "GST Group Code" := RecItem."GST Group Code";
                end;
                //Description := RecItem.Description;
            end;
        }
        field(50140; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
        }
    }


    trigger OnDelete();
    begin

        //CCIT-PRI-191118
        ERROR('You do not have Permission');
        //CCIT-PRI-191118    
    end;

    var
        LCYTxt: TextConst ENU = ' (LCY)', ENN = ' (LCY)';
        RecReasonCode: Record 231;
}

