tableextension 50427 "Posted_Invt_Pick_Header_ext" extends "Posted Invt. Pick Header"
{
    // version NAVW17.00

    fields
    {

        //Unsupported feature: PropertyDeletion on ""Assigned User ID"(Field 4)". Please convert manually.

        field(50000; "Total Qty"; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line".Quantity WHERE("No." = FIELD("No.")));
            Description = 'CCIT-SD-08-01-17';
            FieldClass = FlowField;
        }
        field(50001; "Total Qty to Handle"; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. to Handle" WHERE("No." = FIELD("No.")));
            Description = 'CCIT-SD-08-01-17';
            FieldClass = FlowField;
        }
        field(50002; "Responsibility Center"; Code[10])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50003; "Country Code"; Code[10])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50004; "Country Name"; Text[50])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50005; "ETA - Destination Port"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50006; "ETA - Destination CFS"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50007; "ETA - Bond"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50008; "JWL BOND GRN No."; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50009; "JWL BOND GRN Date"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50064; "E-Way Bill No."; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50065; "E-Way Bill Date"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50066; "Seal No."; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50067; "OrderDate WareActHed"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50068; "Load Type"; Option)
        {
            Description = 'CCIT-SD-08-01-17';
            OptionMembers = " ",FTL,PTL;
        }
        field(50112; "JWL Transfer No."; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50113; "JWL Transfer Date"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

