tableextension 50031 "Item_ext" extends Item
{
    // version NAVW19.00.00.48628,NAVIN9.00.00.48628,CCIT-Fortune

    fields
    {




        //Unsupported feature: CodeModification on ""Unit Cost"(Field 22).OnValidate". Please convert manually.
        modify("Unit Cost")
        {
            trigger OnAfterValidate();
            begin

                //CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Unit Cost In PCS" := "Unit Cost" * RecUOM.Weight;
                            VALIDATE("Unit Cost In PCS");
                        END
                    END
                END;
                //CCIT-SG

            end;
        }

        //Unsupported feature: CodeModification on ""Vendor No."(Field 31).OnValidate". Please convert manually.
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-JAGA
                CLEAR("Vendor Name");
                RecVendor.RESET;
                IF RecVendor.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := RecVendor.Name;
                END;
                //CCIT-JAGA
            end;
        }

        //Unsupported feature: CodeInsertion on "Inventory(Field 68)". Please convert manually.
        modify(Inventory)
        {
            trigger OnAfterValidate();
            begin
                //CCIT-SG
                IF RecUOM.GET("No.") THEN BEGIN
                    "Conversion Inventory" := Inventory * RecUOM.Weight;
                END;
                //CCIT-SG

            end;
        }

        field(50000; "Shelf Life"; Integer)
        {
            Description = 'CCIT-JAGA';
        }
        field(50001; "Usable Shelf Life"; Integer)
        {
            Description = 'CCIT-JAGA';
        }
        field(50002; "Food Type"; Option)
        {
            Description = 'CCIT-JAGA';
            OptionMembers = VEG,"NON VEG";
        }
        field(50003; "Block Reason Code"; Code[20])
        {
            Description = 'CCIT-JAGA';
            TableRelation = "Block Reason Code".Code;
        }
        field(50004; "Brand Name"; Code[20])
        {
            Description = 'CCIT-JAGA';
            TableRelation = "Brand Name";
        }
        field(50005; "Product Type"; Code[20])
        {
            Description = 'CCIT-JAGA';
            TableRelation = "Product Type";
        }
        field(50006; "Sales Category"; Code[20])
        {
            Description = 'CCIT-JAGA';
            TableRelation = "Sales Category";
        }
        field(50007; "Storage Categories"; Option)
        {
            Description = 'CCIT-JAGA';
            OptionMembers = " ",FREEZER,CHILLED,DRY,"ROOM TEMP";
        }
        field(50008; "Storage Temperature"; Code[20])
        {
            Description = 'CCIT-JAGA';
            TableRelation = "Storage Temperature";
        }
        field(50009; "Inventory Classification"; Option)
        {
            Description = 'CCIT-PRI';
            OptionCaption = ',A,B,C,D,New,Dis-Continued,SMNE';
            OptionMembers = ,A,B,C,D,New,"Dis-Continued",SMNE;
        }
        field(50010; "H.S. Code"; Code[20])
        {
            Description = 'CCIT-PRI';
        }
        field(50011; "EAN Code No."; Code[20])
        {
        }
        field(50012; "EAN Code"; Boolean)
        {
        }
        field(50013; "Supplier Code"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                //CCIT-SG
                RecVendor.RESET;
                IF RecVendor.GET("Supplier Code") THEN
                    "Supplier Name" := RecVendor.Name;
                //CCIT-SG
            end;
        }
        field(50014; "Supplier Name"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50015; Tolerance; Boolean)
        {
            Description = 'CCIT';
        }
        field(50016; "Conversion Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Conversion Qty" WHERE("Item No." = FIELD("No."),
                                                                          "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                          "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                          "Location Code" = FIELD("Location Filter"),
                                                                          "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                          "Variant Code" = FIELD("Variant Filter"),
                                                                          "Lot No." = FIELD("Lot No. Filter"),
                                                                          "Serial No." = FIELD("Serial No. Filter")));
            DecimalPlaces = 0 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Purchase Order Conversion"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(50018; "Sales Order Conversion"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(50019; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = true;
            TableRelation = "Unit of Measure";
        }
        field(50020; "Unit Cost In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50021; "Safety Stock"; Code[20])
        {
            Description = 'CCIT AN';
        }
        field(50025; "Vendor Name"; Text[50])
        {
        }
        field(50026; "Duty Free"; Boolean)
        {
            Description = '//CCIT_TK';
        }
        field(50027; "Custom Duty Per"; Integer)
        {
            TableRelation = "Custom Duty Master";
        }
        field(50028; "Surcharge Per"; Integer)
        {
        }
        field(50029; "Launch Month"; Date)
        {

            trigger OnValidate();
            begin

                //"Launch Month" := FORMAT(TODAY,0,'<Month Text,20>');
                //DATE2DMY
            end;
        }
        field(70000; "Parent item"; Code[20])
        {
            Description = 'CS';
            TableRelation = Item;

            trigger OnValidate();
            begin
                IF "Parent item" = "No." THEN
                    ERROR('Prent Item and Child Item not be the same');
            end;
        }
    }

    LOCAL PROCEDURE LookupParentItem();
    VAR
        RecItem: Record 27;
    BEGIN
        RecItem.RESET;
        RecItem.SETFILTER("No.", '<>%1', "No.");
        IF PAGE.RUNMODAL(31, RecItem) = ACTION::LookupOK THEN
            "Parent item" := RecItem."No.";
    END;


    var
        Text10: Label 'Block Reason code need TO be Filled';
        RecVendor: Record 23;
        RecUOM: Record 5404;
        RecItem2: Record 27;
}

