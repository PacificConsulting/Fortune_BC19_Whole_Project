report 50019 "Check GST"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Check GST.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = WHERE("G/L Account No." = CONST('106120'));

            trigger OnAfterGetRecord();
            begin
                GLEnntry.RESET();
                GLEnntry.SETRANGE("G/L Account No.", '106140');
                GLEnntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                IF NOT GLEnntry.FIND('-') THEN BEGIN
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn("G/L Entry"."G/L Account No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("G/L Entry"."Document No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                END;
            end;

            trigger OnPreDataItem();
            begin
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('GL Account No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('G/L Document No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            end;
        }
        dataitem(GLENTRY2; "G/L Entry")
        {
            DataItemTableView = WHERE("G/L Account No." = CONST('106140'));

            trigger OnAfterGetRecord();
            begin
                GLEnntry.RESET();
                GLEnntry.SETRANGE("G/L Account No.", '106120');
                GLEnntry.SETRANGE("Document No.", GLENTRY2."Document No.");
                IF NOT GLEnntry.FIND('-') THEN BEGIN
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(GLENTRY2."G/L Account No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GLENTRY2."Document No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                END;
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
        //ExcelBuffer.CreateBookAndOpenExcel('E:\Reports\GST.xlsx', 'GST', 'GST', COMPANYNAME, USERID);
        ExcelBuffer.CreateBookAndOpenExcel('D:\Reports\GST.xlsx', 'GST', 'GST', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    trigger OnPreReport();
    begin
        ExcelBuffer.DELETEALL;
    end;

    var
        GLEnntry: Record 17;
        ExcelBuffer: Record 370;
}

