report 50002 "Auto Post SO"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Order),
                                      Status = FILTER(Open));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                //MESSAGE('%1',"Sales Header"."No.");
                "Sales Header".Ship := TRUE;
                "Sales Header".Invoice := TRUE;
                SalesPost.RUN("Sales Header");
            end;

            trigger OnPreDataItem();
            begin
                IF (Fromdate <> 0D) AND (Todate <> 0D) THEN
                    "Sales Header".SETRANGE("Sales Header"."Posting Date", Fromdate, Todate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Filters';
                field("From Date"; Fromdate)
                {
                }
                field("To Date"; Todate)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Fromdate: Date;
        Todate: Date;
        SalesPost: Codeunit 80;
}

