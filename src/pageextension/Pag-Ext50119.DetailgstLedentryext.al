pageextension 50119 "Detail_gst_Led_entry_ext" extends "Detailed GST Ledger Entry"
{
    // version TFS225977

    layout
    {

        //Unsupported feature: Change SourceExpr on "Control 1500067". Please convert manually.


        addafter("No.")
        {
            field(Description; Description)
            {
                ApplicationArea = all;
            }
        }
        addafter("Source No.")
        {
            field("Customer/Vendor Name"; "Customer/Vendor Name")
            {
                ApplicationArea = all;
            }
        }

        addafter("Amount Loaded on Item")
        {
            field("Location Code"; "Location Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Payment Type")
        {
            field("Same State GST Line"; "Same State GST Line")
            {
                ApplicationArea = all;
            }
            field("Bill of Entry No."; "Bill of Entry No.")
            {
                ApplicationArea = all;
            }
            field("Bill of Entry Date"; "Bill of Entry Date")
            {
                ApplicationArea = all;
            }


            // field("IRN No."; "IRN No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("Acknowledge No."; "Acknowledge No.")
            // {
            //     ApplicationArea = all;
            // }

            // field("Acknowledge Date"; "Acknowledge Date")
            // {
            //     ApplicationArea = all;
            // }
            // field("E-invoice Remark"; "E Invoice Remark")
            // {
            //     ApplicationArea = all;
            // }
            // field("Transfer Order No."; "Transfer Order No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("Transfer Order Date"; "Transfer Order Date")
            // {
            //     ApplicationArea = all;
            // }
            field("PTS Transfer Order"; "PTS Transfer Order")
            {
                ApplicationArea = all;
            }
            field("PTS Trasfer Order Date"; "PTS Trasfer Order Date")
            {
                ApplicationArea = all;
            }
            field("PTR Transfer Order"; "PTR Transfer Order")
            {
                ApplicationArea = all;
            }
            field("PTR Trasfer Order Date"; "PTR Trasfer Order Date")
            {
                ApplicationArea = all;
            }
            field("Nature of Supply"; "Nature of Supply")
            {
                ApplicationArea = all;
            }
            field("Original Doc Type"; "Original Doc Type")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

    }

    var
    // "IRN No.": Text;
    // "Acknowledge No.": Text;
    // "Acknowledge Date": DateTime;
    // "E Invoice Remark": Text;
    // SalesInvHeader: Record 112;
    // SalesCrHeader: Record 114;
    // TransferShipHeader: Record 5744;
    // "Transfer Order No.": Text;
    // "Transfer Order Date": Date;
    // RecTransferShipmentHeader: Record 5744;
    // RecTransferReceiptHeader: Record 5746;


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin

        //     CLEAR("IRN No.");
        //     CLEAR("Acknowledge No.");
        //     CLEAR("Acknowledge Date");
        //     CLEAR("Transfer Order No.");
        //     CLEAR("Transfer Order Date");
        //     CLEAR("E Invoice Remark");//CCIT_TK

        //     IF "Transaction Type" = "Transaction Type"::Sales THEN BEGIN
        //         IF "Document Type" = "Document Type"::Invoice THEN BEGIN
        //             SalesInvHeader.RESET();
        //             SalesInvHeader.SETRANGE("No.", "Document No.");
        //             IF SalesInvHeader.FIND('-') THEN BEGIN
        //                 "IRN No." := SalesInvHeader."E-Invoice IRN";
        //                 "Acknowledge No." := SalesInvHeader."Acknowledgement No.";
        //                 "Acknowledge Date" := SalesInvHeader."Acknowledgement Date";
        //                 "E Invoice Remark" := SalesInvHeader."E-Invoice Error Remarks";//CCIT_TK
        //             END;
        //             TransferShipHeader.SETRANGE("No.", "Document No.");
        //             IF TransferShipHeader.FIND('-') THEN BEGIN
        //                 "IRN No." := TransferShipHeader."E-Invoice IRN";
        //                 "Acknowledge No." := TransferShipHeader."GST Acknowledgement No.";
        //                 "Acknowledge Date" := TransferShipHeader."GST Acknowledgement Dt";
        //                 "E Invoice Remark" := TransferShipHeader."E-Invoice Error Remarks";//CCIT_TK
        //             END;
        //         END;
        //         IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
        //             SalesCrHeader.RESET();
        //             SalesCrHeader.SETRANGE("No.", "Document No.");
        //             IF SalesCrHeader.FIND('-') THEN BEGIN
        //                 "IRN No." := SalesCrHeader."E-Invoice IRN";
        //                 "Acknowledge No." := SalesCrHeader."E-Invoice Acknowledgment No.";
        //                 "Acknowledge Date" := SalesCrHeader."E-Invoice Acknowledement Dt";
        //                 "E Invoice Remark" := SalesCrHeader."E-Invoice Error Remarks";//CCIT_TK
        //             END;
        //         END;

        //     END;
        //     // IF "Original Doc. Type" = "Original Doc. Type"::"Transfer Shipment" THEN BEGIN  //PCPL/MIG/NSW Field not exist in BC18
        //     RecTransferShipmentHeader.RESET();
        //     RecTransferShipmentHeader.SETRANGE("No.", "Document No.");
        //     IF RecTransferShipmentHeader.FIND('-') THEN BEGIN
        //         "Transfer Order No." := RecTransferShipmentHeader."Transfer Order No.";
        //         "Transfer Order Date" := RecTransferShipmentHeader."Transfer Order Date";
        //     END;
        //     //END;

        //     // IF "Original Doc. Type" = "Original Doc. Type"::"Transfer Receipt" THEN BEGIN //PCPL/MIG/NSW Field not exist in BC18
        //     RecTransferReceiptHeader.RESET();
        //     RecTransferReceiptHeader.SETRANGE("No.", "Document No.");
        //     IF RecTransferReceiptHeader.FIND('-') THEN BEGIN
        //         "Transfer Order No." := RecTransferReceiptHeader."Transfer Order No.";
        //         "Transfer Order Date" := RecTransferReceiptHeader."Transfer Order Date";
        //     END;
        //     // END;

    end;

    //Unsupported feature: PropertyDeletion. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

