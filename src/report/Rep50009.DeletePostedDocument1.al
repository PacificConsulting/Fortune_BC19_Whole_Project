report 50009 "Delete Posted Document1"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Temp Table1"; "Temp Table1")
        {
            RequestFilterFields = DocNo;
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Sales Invoice Header".DELETE;

                end;
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Sales Invoice Line".DELETE;
                end;
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "G/L Entry".DELETE;
                end;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Cust. Ledger Entry".DELETE;
                end;
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Detailed Cust. Ledg. Entry".DELETE;
                end;
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Value Entry".DELETE;
                end;
            }
            dataitem("GST Ledger Entry"; "GST Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "GST Ledger Entry".DELETE;
                end;
            }
            dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Detailed GST Ledger Entry".DELETE;
                end;
            }
            // dataitem(DataItem1000000010;"Posted Structure Order Details")
            // {
            //     DataItemLink = No.=FIELD(DocNo);

            //     trigger OnAfterGetRecord();
            //     begin
            //         "Posted Structure Order Details".DELETE;
            //     end;
            // }
            // dataitem(DataItem1000000011;Table13798)
            // {
            //     DataItemLink = Invoice No.=FIELD(DocNo);

            //     trigger OnAfterGetRecord();
            //     begin
            //         "Posted Str Order Line Details".DELETE;
            //     end;
            // }
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
        MESSAGE('Document Nos has Deleted Sucessfully');
    end;

    var
        OldDocNo: Code[20];
        NewDocNo: Code[20];
}

