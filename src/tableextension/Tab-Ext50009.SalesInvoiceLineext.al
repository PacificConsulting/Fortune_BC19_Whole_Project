tableextension 50009 "Sales_Invoice_Line_ext" extends "Sales Invoice Line"
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
        field(50065; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = false;
            TableRelation = "Unit of Measure";
        }
        field(50082; FOC; Boolean)
        {
            Description = 'CCIT';
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
            Description = 'CCIT_TK';
            TableRelation = "Reason Code";

            trigger OnValidate();
            begin
                //CCIT AN
                IF RecReasonCode.GET("Reason Code") THEN BEGIN
                    IF RecReasonCode.Blocked = TRUE THEN
                        ERROR('This Reason Code is Blocked');
                END;
                //CCIT AN
            end;
        }
        field(50124; "Rate In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50125; "Amount In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50126; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH","CPL-GOA","DPL 20-21";
        }
        field(50127; "Main Quantity in KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-14-05-2018';
        }
        field(50128; "Main Quantity in PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-14-05-2018';
        }
        field(50129; Tolerance; Boolean)
        {
            Description = 'CCIT-SD-14-05-2018';
        }
        field(50140; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
        }
    }
    keys
    {
        key(KeyExt1; "No.")
        {
        }
        key(KeyExt2; "Sell-to Customer No.", "No.", "Customer Price Group", "Posting Date")
        {
        }
        key(KeExty3; "Sell-to Customer No.", "Posting Date", "No.")
        {
        }
    }


    var
        RecItem2: Record 27;
        RecUOM: Record 5404;
        LCYTxt: TextConst ENU = ' (LCY)', ENN = ' (LCY)';
        RecReasonCode: Record 231;
}

