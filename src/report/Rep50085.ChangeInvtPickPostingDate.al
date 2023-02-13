report 50085 "Change Invt.Pick Posting Date"
{
    // version CCIT-Fortune-SG

    Permissions = TableData 32 = rimd,
                  TableData 110 = rimd,
                  TableData 111 = rimd,
                  TableData 7342 = rimd,
                  TableData 7343 = rimd;
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Temp Document Change"; "Temp Document Change")
        {
            dataitem("Posted Invt. Pick Header"; "Posted Invt. Pick Header")
            {
                DataItemLink = "Source No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    "Posted Invt. Pick Header"."Posting Date" := 20181126D; //112618D
                    "Posted Invt. Pick Header".MODIFY;

                    /*RecPostInvPickLine.RESET;
                    RecPostInvPickLine.SETRANGE(RecPostInvPickLine."No.","Posted Invt. Pick Header"."No.");
                    IF RecPostInvPickLine.FINDSET THEN
                      REPEAT
                        RecPostInvPickLine.
                      UNTIL RecPostInvPickLine.NEXT=0;*/

                end;
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    "Sales Shipment Line"."Posting Date" := 20181126D; //112618D
                    "Sales Shipment Line".MODIFY;
                end;
            }
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                DataItemLink = "No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    "Sales Shipment Header"."Posting Date" := 20181126D; //112618D
                    "Sales Shipment Header".MODIFY;
                end;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    "Item Ledger Entry"."Posting Date" := 20181126D; //112618D
                    "Item Ledger Entry".MODIFY;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
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
        MESSAGE('Tables Updated Successfully...');
    end;

    var
        NewString: Text[250];
        OldString: Text[250];
        //RecPostStrcOrderLineDet: Record "13798";
        RecPostInvPickLine: Record 7343;
}

