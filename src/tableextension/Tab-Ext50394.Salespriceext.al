tableextension 50394 "Sales_price_ext" extends "Sales Price"
{
    // version NAVW19.00.00.48628,NAVIN9.00.00.48628,CCIT-Fortune

    fields
    {
        modify("Item No.")
        {
            trigger OnBeforeValidate()
            begin
                //CCIT-SG 
                IF RecItem.GET("Item No.") THEN
                    Description := RecItem.Description;
                //CCIT-SG

            end;
        }
        //Unsupported feature: CodeModification on ""Sales Code"(Field 2).OnValidate". Please convert manually.
        modify("Sales Code")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG-14062018
                IF RecCustPriceGrp.GET("Sales Code") THEN
                    "Location Code" := RecCustPriceGrp."Location Code";
                //CCIT-SG-14062018
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                RecUOM.RESET;
                RecUOM.SETRANGE(RecUOM.Code, Rec."Unit of Measure Code");
                RecUOM.SETRANGE(RecUOM."Item No.", Rec."Item No.");
                IF RecUOM.FINDFIRST THEN
                    "Conversion Price Per PCS" := "Unit Price" * RecUOM.Weight;
                //VALIDATE("Conversion Price Per PCS","Unit Price Per KG" * RecUOM.Weight);
                //CCIT-SG

            end;
        }

        field(50000; Description; Text[50])
        {
            Description = 'CCIT';
        }
        field(50001; "Discount %"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50002; "Conversion Price Per PCS"; Decimal)
        {
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                RecUOM.RESET;
                RecUOM.SETRANGE(RecUOM.Code, Rec."Unit of Measure Code");
                RecUOM.SETRANGE(RecUOM."Item No.", Rec."Item No.");
                IF RecUOM.FINDFIRST THEN
                    "Unit Price" := "Conversion Price Per PCS" / RecUOM.Weight;
                // MESSAGE('%1 %2  %3',"Conversion Price Per PCS",RecUOM.Weight,"Unit Price Per KG");
                //CCIT-SG
            end;
        }
        field(50003; "Customer Code"; Code[10])
        {
            Description = 'CCIT';
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF RecCust.GET("Customer Code") THEN BEGIN
                    "Customer Name" := RecCust.Name;
                    "Gen.Bus.Posting Group" := RecCust."Gen. Bus. Posting Group"; // rdk 270919
                END;
            end;
        }
        field(50004; "Customer Name"; Text[100])
        {
            Description = 'CCIT';
        }
        field(50005; "List Price"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50006; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = true;
            TableRelation = "Unit of Measure";
        }
        field(50007; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH","CPL-GOA","DPL 20-21";
        }
        field(50008; "Location Code"; Code[10])
        {
            Description = 'CCIT';
            TableRelation = Location.Code;
        }
        field(50009; Block; Boolean)
        {
            Description = 'CCIT';
        }
        field(50010; "Quantity in KG"; Decimal)
        {

            trigger OnValidate();
            begin
                //CCIT-SG
                RecUOM.RESET;
                RecUOM.SETRANGE(RecUOM.Code, Rec."Unit of Measure Code");
                RecUOM.SETRANGE(RecUOM."Item No.", Rec."Item No.");
                IF RecUOM.FINDFIRST THEN
                    "Quantity in PCS" := "Quantity in KG" / RecUOM.Weight;

                //CCIT-SG
            end;
        }
        field(50011; "Quantity in PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;

            trigger OnValidate();
            begin
                //CCIT-SG
                RecUOM.RESET;
                RecUOM.SETRANGE(RecUOM.Code, Rec."Unit of Measure Code");
                RecUOM.SETRANGE(RecUOM."Item No.", Rec."Item No.");
                IF RecUOM.FINDFIRST THEN
                    "Quantity in KG" := "Quantity in PCS" * RecUOM.Weight;

                //CCIT-SG
            end;
        }
        field(50012; "Monthly Qty in Kgs"; Decimal)
        {
            Description = 'RDK 09-05-2019';

            trigger OnValidate();
            begin
                /*IF "Monthly Qty in Kgs" <> 0 THEN
                  BEGIN
                    IF "Ending Date" > "Starting Date" THEN
                      BEGIN
                        DateDiff := "Ending Date" - "Starting Date";
                        NoMnths := ROUND(DateDiff/30);
                        "Target Qty in Kgs":= "Monthly Qty in Kgs" * NoMnths;
                
                        RecUOM.RESET;
                        RecUOM.SETRANGE(RecUOM.Code,Rec."Unit of Measure Code");
                        RecUOM.SETRANGE(RecUOM."Item No.",Rec."Item No.");
                        IF RecUOM.FINDFIRST THEN
                           "Target Qty in PCs" := "Monthly Qty in Kgs" / RecUOM.Weight;
                
                      END
                    ELSE
                      ERROR('Ending Date is less than Starting Date');
                  END;
                  *///CCIT-02072021

            end;
        }
        field(50013; "Target Qty in Kgs"; Decimal)
        {
            Description = 'RDK 09-05-2019';

            trigger OnValidate();
            begin
                /*IF "Target Qty in Kgs" <> 0 THEN
                  IF "Ending Date" > "Starting Date" THEN
                    BEGIN
                      DateDiff := "Ending Date" - "Starting Date";
                      NoMnths := ROUND(DateDiff/30);
                      "Monthly Qty in Kgs" := "Target Qty in Kgs" / NoMnths;
                
                      RecUOM.RESET;
                      RecUOM.SETRANGE(RecUOM.Code,Rec."Unit of Measure Code");
                      RecUOM.SETRANGE(RecUOM."Item No.",Rec."Item No.");
                      IF RecUOM.FINDFIRST THEN
                         "Target Qty in PCs" := "Target Qty in Kgs" / RecUOM.Weight;
                    END
                  ELSE
                    ERROR('Ending Date is less than Starting Date');
                    *///CCIT-02072021

            end;
        }
        field(50014; "Total Sales Qty in Kgs"; Decimal)
        {
            Description = 'RDK 09-05-2019';
        }
        field(50015; "Monthly Qty in PCs"; Decimal)
        {
            Description = 'RDK 09-05-2019';

            trigger OnValidate();
            begin
                /*RecUOM.RESET;
                RecUOM.SETRANGE(RecUOM.Code,Rec."Unit of Measure Code");
                RecUOM.SETRANGE(RecUOM."Item No.",Rec."Item No.");
                IF RecUOM.FINDFIRST THEN
                   "Monthly Qty in Kgs" := "Monthly Qty in PCs" * RecUOM.Weight;
                *///CCIT-02072021

            end;
        }
        field(50016; "Target Qty in PCs"; Decimal)
        {
            Description = 'RDK 09-05-2019';
        }
        field(50017; "Total Sales Qty in PCs"; Decimal)
        {
            Description = 'RDK 09-05-2019';
        }
        field(50018; "Line Updated On"; Date)
        {
            Description = 'RDK 28-06-2019';
            Editable = false;
        }
        field(50019; "Line Updated By"; Code[50])
        {
            Description = 'RDK 28-06-2019';
            Editable = false;
        }
        field(50020; "Reason Code"; Code[10])
        {
            Description = 'RDK 07-08-2019';
            TableRelation = "Reason Code";

            trigger OnValidate();
            begin
                IF RecReason.GET("Reason Code") THEN
                    "Reason Desc" := RecReason.Description;
            end;
        }
        field(50021; "Reason Desc"; Text[50])
        {
            Description = 'RDK 07-08-2019';
        }
        field(50022; "Ref. Expiry Date"; Date)
        {
            Description = 'RDK 18-09-2019';
        }
        field(50023; "Gen.Bus.Posting Group"; Code[20])
        {
            Description = 'RDK 27-09-2019';
            Editable = false;
        }
        field(50024; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
        }
        field(50025; MRP; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
        }
    }

    keys
    {

        //Unsupported feature: Deletion on ""Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"(Key)". Please convert manually.

        // key(Keyext1;"Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity","Customer Code")
        // {
        // }
        key(KeyExt2; "Sales Code")
        {
        }
    }



    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    trigger OnInsert();
    begin

        "Line Updated On" := TODAY; // rdk 28-06-2019
        "Line Updated By" := USERID;// rdk 28-06-2019

        RecUOM.RESET;
        RecUOM.SETRANGE(RecUOM.Code, Rec."Unit of Measure Code");
        RecUOM.SETRANGE(RecUOM."Item No.", Rec."Item No.");
        IF RecUOM.FINDFIRST THEN
            "Conversion Price Per PCS" := "Unit Price" * RecUOM.Weight;
        //CCIT-SG

    end;


    trigger OnModify();
    begin

        //>>PCPL/NSW/07  29June22
        IF (UserSetup.GET(USERID)) AND (NOT UserSetup."Sales Price Permission") THEN
            ERROR('You do not have permission to modify sales price. ');
        //<<PCPL/NSW/07  29June22
        "Line Updated On" := TODAY; // rdk 28-06-2019
        "Line Updated By" := USERID;// rdk 28-06-2019

    end;

    var
        UserSetup: Record 91;
        RecItem: Record 27;
        RecUOM: Record 5404;
        RecCust: Record 18;
        RecCustPriceGrp: Record 6;
        DateDiff: Decimal;
        NoMnths: Decimal;
        RecReason: Record 231;
        LocText: Text[20];

}

