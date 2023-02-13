page 50049 "Approved Sales Target"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Target";
    SourceTableView = WHERE(Status = FILTER(Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Name"; "Salesperson Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Salesperson Name',
                                ENN = 'Salesperson Code';
                }
                field("From Date"; "From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; "To Date")
                {
                    ApplicationArea = All;
                }
                field("General Posting Group"; "General Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Target; Target)
                {
                    ApplicationArea = All;
                }
                field("Total Sales"; "Invoice Value")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Lookup = false;

                    trigger OnDrillDown();
                    begin
                        CLE.RESET;
                        CLE.SETRANGE(CLE."Document Type", CLE."Document Type"::Invoice);
                        CLE.SETRANGE(CLE."Salesperson Code", "Salesperson Code");
                        CLE.SETRANGE(CLE."Posting Date", "From Date", "To Date");
                        CLE.FINDSET;
                        PAGE.RUNMODAL(0, CLE);
                    end;
                }
                field("Return Value"; "Return Value")
                {
                    ApplicationArea = All;
                    DrillDown = true;

                    trigger OnDrillDown();
                    begin
                        CLE.RESET;
                        CLE.SETFILTER(CLE."Document Type", '%1|%2', CLE."Document Type"::"Credit Memo", CLE."Document Type"::Refund);
                        CLE.SETRANGE(CLE."Salesperson Code", "Salesperson Code");
                        CLE.SETRANGE(CLE."Posting Date", "From Date", "To Date");
                        CLE.FINDSET;
                        PAGE.RUNMODAL(0, CLE);
                    end;
                }
                field("Net Sales"; "Actual Invoice Value")
                {
                    ApplicationArea = All;
                }
                field("Target Missed- Value "; "Target to Achieve")
                {
                    ApplicationArea = All;
                }
                field("Amount to Collect"; "Amount to Collect")
                {
                    ApplicationArea = All;
                }
                field("Amount Collected"; "Amount Collected")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnLookup(var Text: Text): Boolean
                    //trigger OnAfterLookup(Text: Text): Boolean;
                    begin
                        CLE.RESET;
                        CLE.SETRANGE(CLE."Document Type", CLE."Document Type"::Payment);
                        CLE.SETRANGE(CLE."Salesperson Code", "Salesperson Code");
                        CLE.SETRANGE(CLE."Posting Date", "From Date", "To Date");
                        CLE.FINDSET;
                        PAGE.RUNMODAL(0, CLE);
                    end;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("Achievement as a % to sales"; "Achievement as a % to sales")
                {
                    ApplicationArea = All;
                }
                field("Target Missed- % "; "Target Missed %")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            //Caption = 'Update';
            action(Update)
            {
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    //SETFILTER("Target to Achieve",'<>0');
                    IF FINDSET THEN
                        REPEAT
                            UpdateValue;
                            //MESSAGE('%1,%2',InvValue,RetValue);
                            SalesTarget.RESET;
                            SalesTarget.SETRANGE(SalesTarget."Salesperson Code", "Salesperson Code");
                            SalesTarget.SETRANGE(SalesTarget."From Date", "From Date");
                            SalesTarget.SETRANGE(SalesTarget."To Date", "To Date");
                            IF SalesTarget.FINDFIRST THEN BEGIN
                                SalesTarget."Invoice Value" := InvValue;
                                SalesTarget."Return Value" := RetValue;
                                SalesTarget."Actual Invoice Value" := NetValue;//CCIT
                                SalesTarget."Achievement as a % to sales" := AchinAsPer;//CCIT
                                SalesTarget."Amount Collected" := CollectedValue;
                                SalesTarget."Amount to Collect" := NetValue - CollectedValue;//CCIT
                                IF SalesTarget.Target >= SalesTarget."Actual Invoice Value" THEN
                                    SalesTarget."Target to Achieve" := SalesTarget.Target - SalesTarget."Actual Invoice Value"
                                ELSE
                                    IF SalesTarget.Target < SalesTarget."Actual Invoice Value" THEN
                                        SalesTarget."Target to Achieve" := 0;

                                SalesTarget."Target Missed %" := (SalesTarget."Target to Achieve" / Target) * 100;//CCIT
                                SalesTarget.MODIFY;
                            END;

                        UNTIL NEXT = 0;
                    MESSAGE('Update successfully');
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //VALIDATE(format("Date filter"),FORMAT("From Date")+FORMAT('..')+FORMAT("To Date"));
        //EVALUATE("Date filter",FORMAT("From Date")+'..'+FORMAT("To Date"));
        /*
        UpdateValue;
        MESSAGE('%1,%2',InvValue,RetValue);
        SalesTarget.RESET;
        SalesTarget.SETRANGE("Salesperson Code","Salesperson Code");
        SalesTarget.SETRANGE("From Date","From Date");
        SalesTarget.SETRANGE("To Date","To Date");
        IF SalesTarget.FINDFIRST THEN BEGIN
         SalesTarget."Invoice Value":=InvValue;
         SalesTarget."Return Value":=RetValue;
         SalesTarget."Actual Invoice Value":="Invoice Value"-"Return Value";
        
         IF SalesTarget.Target<=SalesTarget."Actual Invoice Value" THEN
          SalesTarget."Target to Achieve":=SalesTarget.Target-SalesTarget."Actual Invoice Value"
         ELSE
          SalesTarget."Target to Achieve":=0;
         SalesTarget.MODIFY;
        END;
        */

    end;

    var
        InvValue: Decimal;
        RetValue: Decimal;
        CollectedValue: Decimal;
        CLE: Record 21;
        SalesTarget: Record 50031;
        NetValue: Decimal;
        AchinAsPer: Decimal;
        TargetMissedPer: Decimal;

    procedure UpdateValue();
    var
        CLErec: Record 21;
    begin
        CLEAR(InvValue);
        CLEAR(RetValue);
        CLEAR(CollectedValue);
        CLEAR(NetValue);
        CLEAR(AchinAsPer);
        //MESSAGE('%1',"Salesperson Code");
        CLErec.RESET;
        CLErec.SETRANGE(CLErec."Salesperson Code", "Salesperson Code");
        CLErec.SETRANGE("Posting Date", "From Date", "To Date");
        IF CLErec.FINDSET THEN
            REPEAT
                CLErec.CALCFIELDS("Amount (LCY)");
                IF CLErec."Document Type" = CLErec."Document Type"::Invoice THEN BEGIN
                    CLErec.CALCFIELDS("Item Charges Invoice");
                    InvValue += (CLErec."Sales (LCY)" - CLErec."Item Charges Invoice");
                END;


                IF (CLErec."Document Type" = CLErec."Document Type"::"Credit Memo") OR (CLErec."Document Type" = CLErec."Document Type"::Refund) THEN
                    //RetValue+=CLErec."Amount (LCY)";
                    RetValue += CLErec."Sales (LCY)";
                IF (CLErec."Document Type" = CLErec."Document Type"::Payment) THEN
                    CollectedValue += ABS(CLErec."Amount (LCY)");
                NetValue := InvValue - ABS(RetValue);//CCIT
                AchinAsPer := (NetValue / Target) * 100;//CCIT
            UNTIL CLErec.NEXT = 0;

    end;
}

