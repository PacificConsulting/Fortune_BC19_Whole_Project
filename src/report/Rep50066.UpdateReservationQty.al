report 50066 "Update Reservation Qty"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            dataitem("Reservation Entry"; "Reservation Entry")
            {
                DataItemLink = "Item No." = FIELD("Item No."),
                               "Source Ref. No." = FIELD("Line No."),
                               "Location Code" = FIELD("Location Code");

                trigger OnAfterGetRecord();
                begin
                    //MESSAGE('%1  %2 %3  %4',"Item Journal Line"."Item No.","Item Journal Line".Quantity,"Reservation Entry"."Item No.","Reservation Entry"."Quantity (Base)");
                    IF "Item Journal Line"."Entry Type" = "Item Journal Line"."Entry Type"::"Negative Adjmt." THEN
                        "Reservation Entry".VALIDATE("Reservation Entry"."Quantity (Base)", -"Item Journal Line".Quantity)
                    ELSE
                        "Reservation Entry".VALIDATE("Reservation Entry"."Quantity (Base)", "Item Journal Line".Quantity);
                    "Reservation Entry".MODIFY;
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
        MESSAGE('Update Successfully..');
    end;
}

