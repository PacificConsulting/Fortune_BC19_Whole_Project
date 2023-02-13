report 50084 "DocDet"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/DocDet.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = WHERE("G/L Account No." = CONST('507120'));

            trigger OnAfterGetRecord();
            begin
                TransferReceiptHeader.RESET();
                TransferReceiptHeader.SETRANGE("No.", "G/L Entry"."Document No.");
                IF TransferReceiptHeader.FIND('-') THEN BEGIN
                    //  IF FromLocation.GET(TransferReceiptHeader."Transfer-from Code") THEN BEGIN
                    //   IF ToLocation.GET(TransferReceiptHeader."Transfer-to Code") THEN BEGIN
                    //    IF FromLocation."State Code" <> ToLocation."State Code" THEN BEGIN
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(TransferReceiptHeader."Transfer Order No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("G/L Entry".Amount, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("G/L Entry"."Document No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    // END;
                    //END;
                    //  END;
                END;

                TransferShipHeader.RESET();
                TransferShipHeader.SETRANGE("No.", "G/L Entry"."Document No.");
                IF TransferShipHeader.FIND('-') THEN BEGIN
                    // IF FromLocation.GET(TransferReceiptHeader."Transfer-from Code") THEN BEGIN
                    // IF ToLocation.GET(TransferReceiptHeader."Transfer-to Code") THEN BEGIN
                    //  IF FromLocation."State Code" <> ToLocation."State Code" THEN BEGIN
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(TransferShipHeader."Transfer Order No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("G/L Entry".Amount, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("G/L Entry"."Document No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    //   END;
                    //  END;
                    //  END;

                END;
            end;

            trigger OnPreDataItem();
            begin
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('Transfer Order No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Document No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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
        //ExcelBuffer.CreateBookAndOpenExcel('E:\Reports\Docs.xlsx', 'Docs', 'Docs', COMPANYNAME, USERID);
        ExcelBuffer.CreateBookAndOpenExcel('D:\Reports\Docs.xlsx', 'Docs', 'Docs', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    trigger OnPreReport();
    begin
        ExcelBuffer.DELETEALL;
    end;

    var
        ExcelBuffer: Record 370;
        TransferShipHeader: Record 5744;
        TransferReceiptHeader: Record 5746;
        FromLocation: Record 14;
        ToLocation: Record 14;
}

