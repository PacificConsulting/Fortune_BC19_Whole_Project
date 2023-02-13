report 50035 "Update Sales Price date"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Price"; "Sales Price")
        {
            RequestFilterFields = "Item No.", "Sales Code";

            trigger OnAfterGetRecord();
            begin
                IF ("Sales Price"."Ending Date" = 20200331D) OR ("Sales Price"."Ending Date" = 20191231D) THEN  //033120D And 123119D
                BEGIN
                    //MESSAGE('%1',"Sales Price"."Sales Code");
                    "Sales Price"."Ending Date" := 20191229D;  //122919D
                    "Sales Price".MODIFY;
                END;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE('Updated Successfully...');
            end;
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
}

