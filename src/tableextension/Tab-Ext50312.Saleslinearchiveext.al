tableextension 50312 "Sales_line_archive_ext" extends "Sales Line Archive"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    fields
    {
        // modify("Invoice Type")
        // {
        //     OptionCaptionML = ENU = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST', ENN = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';

        //     //Unsupported feature: Change OptionString on ""Invoice Type"(Field 16609)". Please convert manually.

        // }

        //Unsupported feature: Deletion on ""VAT Clause Code"(Field 88)". Please convert manually.

        field(50004; "Brand Name"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Brand Name";
        }
        field(50026; "Available Qty.In KG"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Customer No." = FIELD("Sell-to Customer No."),
                                                                  "Location Code" = FIELD("Location Code"),
                                                                  Reserved = CONST(true)));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50028; "Available Qty.In PCS"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Conversion Qty" WHERE("Item No." = FIELD("No."),
                                                                          "Customer No." = FIELD("Sell-to Customer No."),
                                                                          "Location Code" = FIELD("Location Code"),
                                                                          Reserved = CONST(true)));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
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
        }
        field(50063; "Quarantine Qty"; Decimal)
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
        field(50069; "Qty. to Ship In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50070; "Quantity Shipped In KG"; Decimal)
        {
            AccessByPermission = TableData 110 = R;
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
            Editable = false;
        }
        field(50071; "Quantity Invoiced In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
            Editable = false;
        }
        field(50072; "Outstanding Quantity In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50082; FOC; Boolean)
        {
            Description = 'CCIT';
        }
        field(50084; "Customer License No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Duty Free License Master"."License No." WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate();
            begin
                IF RecDutyFreeLicMaster.GET("Customer License No.") THEN BEGIN
                    "Customer License Name" := RecDutyFreeLicMaster."License Name";
                    "Customer License Date" := RecDutyFreeLicMaster."License Date";
                END;
            end;
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
            TableRelation = "Reason Code";
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Quarantine Qty In KG" := "Quarantine Qty In PCS" * RecUOM1.Weight;
                        END
                    END
                END;
                "Actual Qty In PCS" := "Conversion Qty" - "Quarantine Qty In PCS";
                "Actual Qty In KG" := Quantity - "Quarantine Qty In KG";
            end;
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Quarantine Qty In PCS" := "Quarantine Qty In KG" / RecUOM1.Weight;
                        END
                    END
                END;
                "Actual Qty In KG" := Quantity - "Quarantine Qty In KG";
                "Actual Qty In PCS" := "Conversion Qty" - "Quarantine Qty In PCS";
            end;
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
        field(50126; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH";
        }
        field(70000; "Minimum Shelf Life %"; Decimal)
        {
            CalcFormula = Lookup("Sales Header"."Minimum Shelf Life %" WHERE("Document Type" = FIELD("Document Type"),
                                                                              "No." = FIELD("Document No.")));
            DecimalPlaces = 0 : 3;
            Description = 'SC';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(KeyExt1; "Document No.", "Line No.", "No.")
        {
            SumIndexFields = Quantity, "Line Amount";
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        RecDutyFreeLicMaster: Record 50025;
        RecItem2: Record 27;
        RecUOM1: Record 5404;
}

