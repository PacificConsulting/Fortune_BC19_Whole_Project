report 50038 "Change Post Document No."
{
    // version CCIT-Fortune-SG

    Permissions = TableData 17 = rimd,
                  TableData 32 = rimd,
                  TableData 5802 = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Temp Table1"; "Temp Table1")
        {
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "G/L Entry"."Document No." := "Temp Table1"."New Doc No.";
                    "G/L Entry".MODIFY;
                end;
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin

                    "Value Entry"."Document No." := "Temp Table1"."New Doc No.";
                    "Value Entry".MODIFY;
                end;
            }
            dataitem("GST Ledger Entry"; "GST Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin

                    "GST Ledger Entry"."Document No." := "Temp Table1"."New Doc No.";
                    "GST Ledger Entry".MODIFY;
                end;
            }
            dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin

                    "Detailed GST Ledger Entry"."Document No." := "Temp Table1"."New Doc No.";
                    "Detailed GST Ledger Entry".MODIFY;
                end;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    "Item Ledger Entry"."Document No." := "Temp Table1"."New Doc No.";
                    "Item Ledger Entry".MODIFY;
                end;
            }
            //<<PCPL/MIG/NSW
            // dataitem(DataItem1000000004;"Posted Structure Order Details")
            // {
            //     DataItemLink = No.=FIELD(DocNo);
            //     DataItemTableView = WHERE(Document Type=FILTER(Quote));

            //     trigger OnAfterGetRecord();
            //     begin
            //         //"Posted Structure Order Details"."No." := "Temp Table1"."New Doc No.";
            //         //"Posted Structure Order Details".MODIFY;
            //     end;
            // }

            // dataitem(DataItem1000000011;Table13798)
            // {
            //     DataItemLink = Invoice No.=FIELD(DocNo);
            //     DataItemTableView = WHERE(Document Type=FILTER(Quote));

            //     trigger OnAfterGetRecord();
            //     begin
            //         //"Posted Str Order Line Details"."Invoice No." := "Temp Table1"."New Doc No.";
            //         //"Posted Str Order Line Details".MODIFY;
            //     end;
            // }
            //>>PCPL/MIG/NSW
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    OldString := '';
                    OldString := ItemTrackingMgt.ComposeRowID(DATABASE::"Transfer Shipment Line",
                                   0, "Transfer Shipment Line"."Document No.", '', 0, "Transfer Shipment Line"."Line No.");

                    ValueEntryRelation.RESET;
                    ValueEntryRelation.SETRANGE(ValueEntryRelation."Source RowId", OldString);
                    IF ValueEntryRelation.FINDFIRST THEN BEGIN
                        NewString := '';
                        NewString := ItemTrackingMgt.ComposeRowID(DATABASE::"Transfer Shipment Line",
                                       0, "Temp Table1"."New Doc No.", '', 0, "Transfer Shipment Line"."Line No.");
                        ValueEntryRelation."Source RowId" := NewString;
                        ValueEntryRelation.MODIFY;

                    END //ELSE
                        //"Sales Invoice Line".RENAME("Temp Document Change"."New Document No.","Sales Invoice Line"."Line No.");
                        // MESSAGE('%1  ',OldString);
                end;
            }
            dataitem(TransferShipmentLine_Rename; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin
                    //SalesInvoiceLine_Rename.RENAME("Temp Document Change"."New Document No.",SalesInvoiceLine_Rename."Line No.")
                    TransferShipmentLine_Rename.RENAME("Temp Table1"."New Doc No.", TransferShipmentLine_Rename."Line No.");
                end;
            }
            dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
            {
                DataItemLink = "No." = FIELD(DocNo);

                trigger OnAfterGetRecord();
                begin

                    //"Sales Invoice Header".RENAME("Temp Document Change"."New Document No.");
                    "Transfer Shipment Header".RENAME("Temp Table1"."New Doc No.");
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
        RecSIH: Record 112;
        RecSIL: Record 113;
        ValueEntryRelation: Record 6508;
        RecValueEntry: Record 5802;
        ItemTrackingMgt: Codeunit 6500;
        StrArray: array[2] of Text[100];
        Pos: Integer;
        Len: Integer;
        T: Integer;
        NewString: Text[250];
        OldString: Text[250];
}

