report 50111 "REm Qty Iles"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/REm Qty Iles.rdl';
    Permissions = TableData 32 = rimd;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry No." = FILTER(> '600000'));

            trigger OnAfterGetRecord();
            begin
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn("Item Ledger Entry"."Item No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Item Ledger Entry"."Location Code", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Item Ledger Entry"."Lot No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Item Ledger Entry"."Manufacturing Date", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("Item Ledger Entry"."Expiration Date", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("Item Ledger Entry".Quantity, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Item Ledger Entry"."Remaining Quantity", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Item Ledger Entry".Quantity - "Item Ledger Entry"."Remaining Quantity", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            end;

            trigger OnPreDataItem();
            begin
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('Item No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Batch No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Manufacturing Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Expiry Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Quantity', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Remaining Quantity', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Quantity Difference', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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

    trigger OnPostReport();
    begin
        //ExcelBuffer.CreateBookAndOpenExcel('E:\Reports\Open Transfer Tracking.xlsx', 'Open Transfer Tracking', 'Open Transfer Tracking', COMPANYNAME, USERID);
        ExcelBuffer.CreateBookAndOpenExcel('D:\Reports\Open Transfer Tracking.xlsx', 'Open Transfer Tracking', 'Open Transfer Tracking', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    trigger OnPreReport();
    begin
        ExcelBuffer.DELETEALL;
    end;

    var
        ExcelBuffer: Record 370;
}

