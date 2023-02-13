table 50031 "Sales Target"
{

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            CaptionML = ENU = 'Salesperson Code',
                        ENN = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            begin
                IF SalesprsnRec.GET("Salesperson Code") THEN BEGIN
                    "Salesperson Name" := SalesprsnRec.Name;
                    /*
                    "Sales Officer":=SalesprsnRec."Sales Officer";
                    "Area Manager":=SalesprsnRec."Area Manager";
                    "Zonal Manager":=SalesprsnRec."Zonal Manager";
                    "Regional Manager":=SalesprsnRec."Regional Manager";
                    */
                END
                ELSE BEGIN
                    "Salesperson Name" := '';
                    /*
                    "Sales Officer":='';
                    "Area Manager":='';
                    "Zonal Manager":='';
                    "Regional Manager":='';
                    */
                END;

            end;
        }
        field(2; "Salesperson Name"; Text[50])
        {
            CaptionML = ENU = 'Salesperson Code',
                        ENN = 'Salesperson Code';
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
        }
        field(3; "From Date"; Date)
        {

            trigger OnValidate();
            begin
                SalesTargetRec.RESET;
                SalesTargetRec.SETRANGE(SalesTargetRec."Salesperson Code", "Salesperson Code");
                IF SalesTargetRec.FINDLAST THEN
                    IF "From Date" <= SalesTargetRec."To Date" THEN
                        ERROR('From date should be greater than %1', SalesTargetRec."To Date");
            end;
        }
        field(4; "To Date"; Date)
        {

            trigger OnValidate();
            begin
                TESTFIELD("From Date");
                IF "To Date" < "From Date" THEN
                    ERROR('To date should be greater than %1', "From Date");
            end;
        }
        field(5; Target; Decimal)
        {

            trigger OnValidate();
            begin
                //"Target to Achieve":=Target; CCIT
            end;
        }
        field(6; Status; Option)
        {
            OptionCaption = '" ,Pending for approval,Approved"';
            OptionMembers = " ","Pending for approval",Approved;
        }
        field(7; "Invoice Value"; Decimal)
        {

            trigger OnLookup();
            begin
                /*
                 CLE.RESET;
                CLE.SETRANGE("Document Type",CLE."Document Type"::Invoice);
                CLE.SETRANGE(CLE."Salesperson Code","Salesperson Code");
                CLE.SETRANGE("Posting Date","From Date","To Date");
                CLE.FINDSET;
                PAGE.RUNMODAL(0,CLE);
                */

            end;
        }
        field(8; "Return Value"; Decimal)
        {
        }
        field(9; "Actual Invoice Value"; Decimal)
        {
        }
        field(10; "Target to Achieve"; Decimal)
        {
        }
        field(11; "Amount to Collect"; Decimal)
        {
        }
        field(12; "Amount Collected"; Decimal)
        {
        }
        field(13; "Sales Officer"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('SALES OFFICER'),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(14; "Area Manager"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            begin
                IF SalesprsnRec.GET("Area Manager") THEN
                    "Area Manager Name" := SalesprsnRec.Name;
            end;
        }
        field(15; "Zonal Manager"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(16; "Regional Manager"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(17; Item; Code[20])
        {
            TableRelation = Item;
        }
        field(18; Quantity; Decimal)
        {
        }
        field(19; Branch; Code[20])
        {
            TableRelation = Location;
        }
        field(20; "Achievement as a % to sales"; Decimal)
        {
        }
        field(21; "Target Missed %"; Decimal)
        {
        }
        field(22; "Area Manager Name"; Text[50])
        {
        }
        field(23; "General Posting Group"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Salesperson Code", "From Date", "To Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SalesprsnRec: Record 13;
        SalesTargetRec: Record 50031;
        CLE: Record 21;
}

