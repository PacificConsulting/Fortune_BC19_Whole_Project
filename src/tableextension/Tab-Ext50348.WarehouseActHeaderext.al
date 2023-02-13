tableextension 50348 "Warehouse_Act_Header_ext" extends "Warehouse Activity Header"
{
    // version NAVW19.00.00.47256,CCIT-Fortune

    fields
    {

        //Unsupported feature: CodeInsertion on ""Posting Date"(Field 20)". Please convert manually.
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                //ccit san-261118
                IF "Posting Date" > CALCDATE('<2D>', TODAY) THEN
                    ERROR('You cannot change the posting date..');
            end;
        }
        field(48; "Transport Method"; Code[10])
        {
            CaptionML = ENU = 'Transport Method',
                        ENN = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(16506; "LR/RR No."; Code[20])
        {
            CaptionML = ENU = 'LR/RR No.',
                        ENN = 'LR/RR No.';
        }
        field(16507; "LR/RR Date"; Date)
        {
            CaptionML = ENU = 'LR/RR Date',
                        ENN = 'LR/RR Date';
        }
        field(16508; "Vehicle No."; Code[20])
        {
            CaptionML = ENU = 'Vehicle No.',
                        ENN = 'Vehicle No.';
        }
        field(16509; "Mode of Transport"; Text[15])
        {
            CaptionML = ENU = 'Mode of Transport',
                        ENN = 'Mode of Transport';
        }
        field(50000; "Total Qty"; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line".Quantity WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50001; "Total Qty to Handle"; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. to Handle" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50002; "Responsibility Center"; Code[10])
        {
        }
        field(50003; "Country Code"; Code[10])
        {
            Description = 'CCIT';
        }
        field(50004; "Country Name"; Text[50])
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
        field(50067; "OrderDate WareActHed"; Date)
        {
            Description = 'CCIT';
        }
        field(50068; "Load Type"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FTL,PTL;
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
        field(50115; "Vehicle Reporting Date"; Date)
        {
            Description = 'rdk';
        }
        field(50116; "Vehicle Reporting Time"; Time)
        {
            Description = 'rdk';
        }
        field(50117; "Vehicle Releasing Time"; Time)
        {
            Description = 'rdk';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        RecCountry: Record 9;
        RecVendor: Record 23;
}

