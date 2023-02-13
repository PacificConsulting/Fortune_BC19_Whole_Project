report 50102 "Auto Post PO"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = WHERE(Status = FILTER(Open),
                                      "Document Type" = FILTER(Order));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin

                "Purchase Header".Receive := TRUE;
                "Purchase Header".Invoice := TRUE;
                PurchasePost.RUN("Purchase Header");
            end;

            trigger OnPreDataItem();
            begin
                IF (Fromdate <> 0D) AND (Todate <> 0D) THEN
                    "Purchase Header".SETRANGE("Purchase Header"."Posting Date", Fromdate, Todate);
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

    trigger OnPostReport();
    begin
        MESSAGE('Post Successfully...');
    end;

    var
        Fromdate: Date;
        Todate: Date;
        PurchasePost: Codeunit 90;
}

