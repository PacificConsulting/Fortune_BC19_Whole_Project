report 50082 "GLE Cashflo vend type update"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/GLE Cashflo vend type update.rdl';
    Permissions = TableData 17 = rm;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vend; Vendor)
        {
            DataItemTableView = WHERE("CashFlow Vendor Type" = FILTER(<> ''));
            dataitem(GLE; "G/L Entry")
            {
                DataItemLink = "Source No." = FIELD("No.");
                DataItemTableView = WHERE("Source Type" = FILTER(Vendor));

                trigger OnAfterGetRecord();
                begin
                    IF GLE."Source Type" = GLE."Source Type"::Vendor THEN
                        IF GLE."Source No." = Vend."No." THEN BEGIN
                            GLE."CashFlow Vendor Type" := Vend."CashFlow Vendor Type";
                            GLE.MODIFY;
                        END;
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
}

