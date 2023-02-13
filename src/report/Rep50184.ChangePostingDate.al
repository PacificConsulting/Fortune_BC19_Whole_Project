report 50184 "Change Posting Date"
{
    // version CCIT-Fortune-SG

    Permissions = TableData 17 = rimd,
                  TableData 21 = rimd,
                  TableData 112 = rimd,
                  TableData 113 = rimd,
                  TableData 379 = rimd,
                  TableData 5802 = rimd,
                  TableData "GST Ledger Entry" = rimd,
                  TableData "Detailed GST Ledger Entry" = rimd;
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Temp Document Change"; "Temp Document Change")
        {
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    //"G/L Entry"."Document No." := "Temp Document Change"."New Document No.";
                    "G/L Entry"."Posting Date" := 20181126D;  //112618D
                    "G/L Entry".MODIFY;
                end;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin

                    //"Cust. Ledger Entry"."Document No." := "Temp Document Change"."New Document No.";
                    "Cust. Ledger Entry"."Posting Date" := 20181126D;  //112618D
                    "Cust. Ledger Entry".MODIFY;
                end;
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin

                    //"Detailed Cust. Ledg. Entry"."Document No." := "Temp Document Change"."New Document No.";
                    "Detailed Cust. Ledg. Entry"."Posting Date" := 20181126D;  //112618D
                    "Detailed Cust. Ledg. Entry".MODIFY;
                end;
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin

                    //"Value Entry"."Document No." := "Temp Document Change"."New Document No.";
                    "Value Entry"."Posting Date" := 20181126D;  //112618D
                    "Value Entry".MODIFY;
                end;
            }
            dataitem("GST Ledger Entry"; "GST Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin

                    //"GST Ledger Entry"."Document No." := "Temp Document Change"."New Document No.";
                    "GST Ledger Entry"."Posting Date" := 20181126D;  //112618D
                    "GST Ledger Entry".MODIFY;
                end;
            }
            dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin

                    //"Detailed GST Ledger Entry"."Document No." := "Temp Document Change"."New Document No.";
                    //"Detailed GST Ledger Entry"."Original Doc. No." := "Temp Document Change"."New Document No.";
                    "Detailed GST Ledger Entry"."Posting Date" := 20181126D;  //112618D
                    "Detailed GST Ledger Entry".MODIFY;
                end;
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    "Sales Invoice Line"."Posting Date" := 20181126D;  //112618D
                    "Sales Invoice Line".MODIFY;
                    /*OldString:='';
                    OldString := ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line",
                                   0,"Sales Invoice Line"."Document No.",'',0,"Sales Invoice Line"."Line No.");
                    
                    ValueEntryRelation.RESET;
                    ValueEntryRelation.SETRANGE("Source RowId",OldString);
                    IF ValueEntryRelation.FINDFIRST THEN BEGIN
                        NewString := '';
                        NewString := ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line",
                                       0,"Temp Document Change"."New Document No.",'',0,"Sales Invoice Line"."Line No.");
                        ValueEntryRelation."Source RowId" := NewString;
                        ValueEntryRelation.MODIFY;
                    
                    END
                    */

                end;
            }
            dataitem(SalesInvoiceLine_Rename; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    //SalesInvoiceLine_Rename.RENAME("Temp Document Change"."New Document No.",SalesInvoiceLine_Rename."Line No.")
                end;
            }
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "No." = FIELD("Old Document No.");

                trigger OnAfterGetRecord();
                begin
                    //"Sales Invoice Header".RENAME("Temp Document Change"."New Document No.");
                    "Sales Invoice Header"."Posting Date" := 20181126D;  //112618D
                    "Sales Invoice Header".MODIFY;
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
    //RecPostStrcOrderLineDet : Record "13798";
}

