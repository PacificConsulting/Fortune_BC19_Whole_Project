tableextension 50347 "Transfer_Header_ext" extends "Transfer Header"
{
    // version NAVW19.00.00.46773,NAVIN9.00.00.46773,CCIT-Fortune

    fields
    {



        //Unsupported feature: CodeModification on ""Transfer-from Code"(Field 2).OnValidate". Please convert manually.

        modify("Transfer-from Code")
        {
            trigger OnAfterValidate()
            begin
                "Order Time" := TIME;//CCIT-SG-15072019
            end;
        }


        //Unsupported feature: CodeModification on ""Transfer-to Code"(Field 11).OnValidate". Please convert manually.
        modify("Transfer-to Code")
        {
            trigger OnAfterValidate()
            begin
                //ccit
                //IF TransferRoute.GET("Transfer-from Code", "Transfer-to Code") THEN; PCPl/MIG/NSW
                //Structure := TransferRoute.Structure; Field Not Exist in BC18  PCPl/MIG/NSW
                //ccit
            end;

        }

        field(50004; "Created User"; Code[21])
        {
            Description = 'CCIT';
        }
        field(50005; "ETA - Destination Port"; Date)
        {
            Description = 'CCIT';
        }
        field(50006; "ETA - Destination CFS"; Date)
        {
            Description = 'CCIT';
        }
        field(50007; "ETA - Bond"; Date)
        {
            Description = 'CCIT';
        }
        field(50008; "JWL BOND GRN No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50009; "JWL BOND GRN Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master";
        }
        field(50030; Reserved; Boolean)
        {
            Description = 'CCIT';
        }
        field(50032; "Customer No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF RecCust.GET("Customer No.") THEN
                    "Customer Name" := RecCust.Name;
            end;
        }
        field(50033; "Customer Name"; Text[50])
        {
            Description = 'CCIT';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(50035; "BL Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Bond Master"."In-Bond Bill of Entry No.";

            trigger OnValidate();
            begin
                //CCIT-SG

                RecBondMaster.RESET;
                RecBondMaster.SETRANGE(RecBondMaster."In-Bond Bill of Entry No.", "In-Bond Bill of Entry No.");
                IF RecBondMaster.FINDFIRST THEN BEGIN
                    "BL/AWB No." := RecBondMaster."BL/AWB No.";
                    "BL Date" := RecBondMaster."BL Date";
                    "In-Bond BOE Date" := RecBondMaster."In-Bond BOE Date";
                    "Bond Number" := RecBondMaster."Bond Number";
                    "Bond Sr.No." := RecBondMaster."Bond Sr.No.";
                    "Bond Date" := RecBondMaster."Bond Date";
                    "Ex-bond BOE No." := RecBondMaster."Ex-bond BOE No.";
                    "Ex-bond BOE Date" := RecBondMaster."Ex-bond BOE Date";
                    "Ex-bond BOE No.1" := RecBondMaster."Ex-bond BOE No.1";
                    "Ex-bond BOE Date 1" := RecBondMaster."Ex-bond BOE Date 1";
                    "Ex-bond BOE No.2" := RecBondMaster."Ex-bond BOE No.2";
                    "Ex-bond BOE Date 2" := RecBondMaster."Ex-bond BOE Date 2";
                    "Ex-bond BOE No.3" := RecBondMaster."Ex-bond BOE No.3";
                    "Ex-bond BOE Date 3" := RecBondMaster."Ex-bond BOE Date 3";
                    "Ex-bond BOE No.4" := RecBondMaster."Ex-bond BOE No.4";
                    "Ex-bond BOE Date 4" := RecBondMaster."Ex-bond BOE Date 4";
                    "Ex-bond BOE No.5" := RecBondMaster."Ex-bond BOE No.5";
                    "Ex-bond BOE Date 5" := RecBondMaster."Ex-bond BOE Date 5";
                    "Ex-bond BOE No.6" := RecBondMaster."Ex-bond BOE No.6";
                    "Ex-bond BOE Date 6" := RecBondMaster."Ex-bond BOE Date 6";
                    "Ex-bond BOE No.7" := RecBondMaster."Ex-bond BOE No.7";
                    "Ex-bond BOE Date 7" := RecBondMaster."Ex-bond BOE Date 7";
                    "Ex-bond BOE No.8" := RecBondMaster."Ex-bond BOE No.8";
                    "Ex-bond BOE Date 8" := RecBondMaster."Ex-bond BOE Date 8";
                    "Ex-bond BOE No.9" := RecBondMaster."Ex-bond BOE No.9";
                    "Ex-bond BOE Date 9" := RecBondMaster."Ex-bond BOE Date 9";
                    "ICA No." := RecBondMaster."FSSAI ICA No.";
                END;
                //CCIT-SG
            end;
        }
        field(50037; "In-Bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50038; "Bond Number"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50039; "Bond Sr.No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50040; "Bond Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50041; "BL/AWB No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50042; "Ex-bond BOE No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50043; "Ex-bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50044; "Ex-bond BOE No.1"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50045; "Ex-bond BOE Date 1"; Date)
        {
            Description = 'CCIT';
        }
        field(50046; "Ex-bond BOE No.2"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50047; "Ex-bond BOE Date 2"; Date)
        {
            Description = 'CCIT';
        }
        field(50048; "Ex-bond BOE No.3"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50049; "Ex-bond BOE Date 3"; Date)
        {
            Description = 'CCIT';
        }
        field(50050; "Ex-bond BOE No.4"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50051; "Ex-bond BOE Date 4"; Date)
        {
            Description = 'CCIT';
        }
        field(50052; "Ex-bond BOE No.5"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50053; "Ex-bond BOE Date 5"; Date)
        {
            Description = 'CCIT';
        }
        field(50054; "Ex-bond BOE No.6"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50055; "Ex-bond BOE Date 6"; Date)
        {
            Description = 'CCIT';
        }
        field(50056; "Ex-bond BOE No.7"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50057; "Ex-bond BOE Date 7"; Date)
        {
            Description = 'CCIT';
        }
        field(50058; "Ex-bond BOE No.8"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50059; "Ex-bond BOE Date 8"; Date)
        {
            Description = 'CCIT';
        }
        field(50060; "Ex-bond BOE No.9"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50061; "Ex-bond BOE Date 9"; Date)
        {
            Description = 'CCIT';
        }
        field(50062; "ICA No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50063; "Storage Categories"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FREEZER,CHILLED,DRY;
        }
        field(50064; "E-Way Bill No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50065; "E-Way Bill Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50066; "Seal No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50067; "Load Type"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FTL,PTL;
        }
        field(50068; PickListCreated; Boolean)
        {
            Description = 'CCIT';
        }
        field(50069; PutAwayCreated; Boolean)
        {
            Description = 'CCIT';
        }
        field(50112; "JWL Transfer No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50113; "JWL Transfer Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50114; "Transport Vendor"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50115; "Order Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50116; "Customer PO/SO Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50117; "Customer License No."; Text[50])
        {
            Description = 'CCIT';
        }
        field(50118; "Calculate Custom Duty"; Boolean)
        {
            Description = 'CCIT-SD';

            trigger OnValidate();
            begin
                //CCIT-SD-26-02-2018 -
                IF "Calculate Custom Duty" THEN
                    //  IF NOT (Structure = 'GST') THEN//PCPL/MIG/NSW Field not Exist in BC18
                    ERROR('Please Select GST Structure');
                //ELSE
            end;
        }
        field(50119; "Short Closed"; Boolean)
        {
            Description = 'CCIT-PRI';
        }
        field(50120; "Last Date And Time"; DateTime)
        {
            Description = 'CCIT';
        }
        field(50121; "Outstanding Quantity In KG"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Quantity" WHERE("Document No." = FIELD("No.")));
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50122; "Outstanding Quantity In PCS"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Quantity In KG" WHERE("Document No." = FIELD("No.")));
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50123; "DF License Type"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",SFIS,MEIS,DFIA;
        }
        field(50124; "DF License Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50125; "CHA Name"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ","Sai Shipping","Freight Expendite";
        }
        field(50126; "Ex Bond Order No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50127; "Ex Bond Order Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50128; "Supplier PO No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Purchase Header"."No.";

            trigger OnValidate();
            begin
                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", "Supplier PO No.");
                IF RecPH.FINDFIRST THEN
                    "Supplier PO Date" := RecPH."Order Date";
            end;
        }
        field(50129; "Supplier PO Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50130; "Supplier Name"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50131; "CHA Contact Person"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50132; "Supplier No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                IF RecVend.GET("Supplier No.") THEN
                    "Supplier Name" := RecVend.Name;
            end;
        }
        field(50133; "Customer License name"; Text[250])
        {
            Description = 'CCIT';
        }
        field(50134; "Total Amount"; Decimal)
        {
            Description = 'rdk';
            Editable = false;
            FieldClass = Normal;
        }
        field(50135; "Total GST"; Decimal)
        {
            Description = 'rdk';
        }
        field(50136; "Vehicle Reporting Date"; Date)
        {
            Description = 'rdk';
        }
        field(50137; "Vehicle Reporting Time"; Time)
        {
            Description = 'rdk';
        }
        field(50138; "Vehicle Release Time"; Time)
        {
            Description = 'rdk';
        }
        field(50139; "Order Time"; Time)
        {
            Description = 'CCIT';
        }
    }


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    trigger OnInsert();
    begin

        //CCIT-SG-30052018
        IF UserSetup.GET(USERID) THEN BEGIN
            "Created User" := UserSetup."User ID";
        END;
        //CCIT-SG-30052018


        "Order Date" := TODAY;//CCIT-SG-27122018

    end;

    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        RecTransList1: Record 5741;
        RecTranLine: Record 5741;
        RecLoc: Record 14;
        edit: Boolean;
        RecBondMaster: Record 50022;
        RecCust: Record 18;
        UserSetup: Record 91;
        RecPH: Record 38;
        RecVend: Record 23;
        FromLocation: Record 14;
        ToLocation: Record 14;
}

