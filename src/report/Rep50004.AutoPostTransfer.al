report 50004 "Auto Post Transfer"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = WHERE(Status = FILTER(Open));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin

                //MESSAGE('%1',"Transfer Header"."No.");

                TransferPostShipment.RUN("Transfer Header");
                TransferPostReceipt.RUN("Transfer Header");
            end;

            trigger OnPreDataItem();
            begin
                IF (Fromdate <> 0D) AND (Todate <> 0D) THEN
                    "Transfer Header".SETRANGE("Transfer Header"."Posting Date", Fromdate, Todate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                // Caption = 'Filters';
                field("From Date"; Fromdate)
                {
                    ApplicationArea = all;
                }
                field("To Date"; Todate)
                {
                    ApplicationArea = all;
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
        TransferPostShipment: Codeunit 5704;
        TransferPostReceipt: Codeunit 5705;
}

