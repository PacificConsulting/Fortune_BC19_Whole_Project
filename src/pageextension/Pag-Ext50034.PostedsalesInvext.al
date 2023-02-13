pageextension 50034 "Posted_sales_Inv_ext" extends "Posted Sales Invoice"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    layout
    {


        modify("Nature of Supply")
        {
            Editable = false;

        }
        modify("GST Customer Type")
        {
            Editable = false;
        }

        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; "Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document Date")
        {
            field("PAY REF"; "Your Reference")
            {
                CaptionML = ENU = 'PAY REF',
                            ENN = 'Your Reference';
                ApplicationArea = all;
            }
            field("PAY REF DATE"; "PAY REF DATE")
            {
                ApplicationArea = all;
            }
        }
        addafter(Corrective)
        {
            field("Amount To Customer"; "Amount To Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field("Sales Person Name"; "Sales Person Name")
            {
                ApplicationArea = all;
            }

            field("E-Way Bill Date"; "E-Way Bill Date")
            {
                ApplicationArea = all;
            }

            field("E-Way Bill Valid Upto"; "E-Way Bill Valid Upto")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill DateTime"; "E-Way Bill DateTime")
            {
                ApplicationArea = all;
            }
            field("Customer GRN/RTV No."; "Customer GRN/RTV No.")
            {
                ApplicationArea = all;
            }
            field("GRN/RTV Date"; "GRN/RTV Date")
            {
                ApplicationArea = all;
            }
            field("Seal No."; "Seal No.")
            {
                ApplicationArea = all;
            }
            field("User ID"; "User ID")
            {
                ApplicationArea = all;
            }
            field("Last Date And Time"; "Last Date And Time")
            {
                ApplicationArea = all;
            }
            field("Calculate IGST"; "Calculate IGST")
            {
                ApplicationArea = all;
            }
            field("Free Sample"; "Free Sample")
            {
                ApplicationArea = all;
            }

            field("Transport Vendor"; "Transport Vendor")
            {
                ApplicationArea = all;
            }
            field("P.A.N No."; "P.A.N No.")
            {
                ApplicationArea = all;
            }
            field("Sales Value"; "Sales Value")
            {
                ApplicationArea = all;
            }
        }
        addfirst("Invoice Details")
        {
            field("Applies-to Doc. Type"; "Applies-to Doc. Type")
            {
                ApplicationArea = all;
            }
            field("Applies-to Doc. No."; "Applies-to Doc. No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Location State Code")
        {

            // field("E-Invoice IRN"; "E-Invoice IRN")
            // {
            //     ApplicationArea = all;
            // }

            // field("E-Invoice QR"; "E-Invoice QR")
            // {
            //     ApplicationArea = all;
            // }
            // field("E-Invoice Error Remarks"; "E-Invoice Error Remarks")
            // {
            //     ApplicationArea = all;
            // }

        }
    }
    actions
    {

        addafter(Approvals)
        {
            action("Updated Customer Name")
            {
                Image = Undo;
                Visible = false;
                ApplicationArea = all;

                trigger OnAction();
                var
                    SalesInvoiceHeader: Record 112;
                    Customer: Record 18;
                begin
                    //RL --
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("No.", "No.");
                    IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                        Customer.RESET;
                        Customer.SETRANGE("No.", SalesInvoiceHeader."Sell-to Customer No.");
                        IF Customer.FINDFIRST THEN BEGIN
                            SalesInvoiceHeader."Sell-to Customer Name" := Customer.Name;
                            SalesInvoiceHeader."Sell-to Customer Name 2" := Customer."Name 2";
                            SalesInvoiceHeader.MODIFY;
                            CurrPage.UPDATE;
                        END;
                    END;
                    //RL ++
                end;
            }
        }
        addfirst("F&unctions")
        {
            // action("TAX INVIOCE")
            // {
            //     Caption = 'TAX INVIOCE';
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedCategory = New;
            //     ApplicationArea = all;

            //     trigger OnAction();Debi
            //     begin

            //         RecTSH.RESET;
            //         RecTSH.SETRANGE(RecTSH."No.", "No.");
            //         REPORT.RUNMODAL(50000, TRUE, FALSE, RecTSH);

            //     end;
            // }
            // action("Sales Debit Note")
            // {
            //     Caption = 'Sales Debit Note';
            //     ApplicationArea = all;

            //     trigger OnAction();
            //     begin
            //         //CCIT-Harshal 28-09-2018
            //         RSIH.RESET;
            //         RSIH.SETRANGE(RSIH."No.", "No.");
            //         REPORT.RUNMODAL(50078, TRUE, FALSE, RSIH);
            //         //CCIT-Harshal 28-09-2018
            //     end;
            // }
        }
        addafter(Approvals)
        {
            action("Updated Customer Name New")
            {
                Image = Undo;
                Visible = false;
                ApplicationArea = all;

                trigger OnAction();
                var
                    SalesInvoiceHeader: Record 112;
                    Customer: Record 18;
                begin
                    //RL --
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("No.", "No.");
                    IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                        Customer.RESET;
                        Customer.SETRANGE("No.", SalesInvoiceHeader."Sell-to Customer No.");
                        IF Customer.FINDFIRST THEN BEGIN
                            SalesInvoiceHeader."Sell-to Customer Name" := Customer.Name;
                            SalesInvoiceHeader."Sell-to Customer Name 2" := Customer."Name 2";
                            SalesInvoiceHeader.MODIFY;
                            CurrPage.UPDATE;
                        END;
                    END;
                    //RL ++
                end;
            }
        }
    }

    var
        RecTSH: Record 112;
        SalesPersonName: Text[50];
        RecSP: Record 13;
        RSIH: Record 112;
        "--------------------------": Integer;
        GlobalNULL: Variant;
        bbbb: Text;
        RecLocation: Record 14;

        LRNo: Text;
        lrDate: Text;
        mont: Text;
        PDate: Text;
        Dt: Text;
        JsonString: Text;
        // GSTEInvoice: Codeunit 50008; //PCPL/MIG/NSW
        recAuthData: Record 50037;
        recGSTRegNos: Record "GST Registration Nos.";
        genledSetup: Record 98;
        signedData: Text;
        decryptedIRNResponse: Text;
        cnlrem: Text;


    //Unsupported feature: CodeModification on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin
        //CCIT-JAGA
        CLEAR(SalesPersonName);
        IF RecSP.GET("Salesperson Code") THEN
            SalesPersonName := RecSP.Name;
        //CCIT-JAGA
    end;


    local procedure ParseResponse_EWAYBILL_DECRYPT(TextResponse: Text; DocumentNumber: Code[70]; IsInvoice: Boolean): Text;
    var
        txtInfodDtls: Text;
        txtSignedData: Text;
        txtError: Text;
        recAuthData: Record 50037;
        message1: Text;
        CurrentObject: Text;
        p: Integer;
        x: Integer;
        l: Integer;
        ValuePair: Text;
        CurrentElement: Text;
        FormatChar: Label '{}';
        CurrentValue: Text;
        txtAckNum: Text;
        txtAckDate: Text;
        txtIRN: Text;
        txtSignedInvoice: Text;
        txtSignedQR: Text;
        txtEWBNum: Text;
        txtEWBDt: Text;
        txtEWBValid: Text;
        txtRemarks: Text;
        recSIHead: Record 112;
        txtStatus: Text;
        recSalesCrMemo: Record 114;
        SalesInvHdr: Record 112;
        txtErrorMsg: Text;
        BillDateTime: Text;
        temptxteno: Text;
        ValidUptoDateTime: Text;
    begin
        //Get value from Json Response >>

        //CLEAR(message1);
        //MESSAGE(TextResponse);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        // EXIT;

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');
                CurrentElement := DELCHR(CurrentElement, '=', ' ');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');
                CurrentValue := DELCHR(CurrentValue, '=', ' ');

                CASE CurrentElement OF
                    'Status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'Data':
                        BEGIN
                            temptxteno := DELCHR(CurrentValue, '=', 'EwbNo');
                            txtEWBNum := temptxteno;
                        END;
                    'EwbDt':
                        BEGIN
                            txtEWBDt := CurrentValue;
                        END;
                    'EwbValidTill':
                        BEGIN
                            txtEWBValid := CurrentValue;
                        END;
                    'ErrorMessage':
                        BEGIN
                            txtErrorMsg := CurrentValue;
                        END;
                END;
            END;
            x := x + 1;
        END;

        IF txtStatus = '1' THEN BEGIN
            SalesInvHdr.RESET();
            SalesInvHdr.SETRANGE(SalesInvHdr."No.", "No.");
            IF SalesInvHdr.FIND('-') THEN BEGIN
                SalesInvHdr."E-Way Bill No." := txtEWBNum;
                SalesInvHdr."E-Way Bill DateTime" := GetDT(txtEWBDt);
                SalesInvHdr."E-Way Bill Valid Upto" := GetDT(txtEWBValid);

                /*BillDateTime := ConvertDt(txtEWBDt);
                EVALUATE(SalesInvHdr."E-Way Bill DateTime",BillDateTime);
                ValidUptoDateTime := ConvertDt(txtEWBValid);
                EVALUATE(SalesInvHdr."E-Way Bill Valid Upto",ValidUptoDateTime);*/
                SalesInvHdr.MODIFY;
            END;
        END ELSE
            IF txtStatus = '0' THEN
                ERROR('Error : %1', TextResponse);

    end;

    local procedure ParseResponse_EWAYBILL_CANCEL_DECRYPT(TextResponse: Text; DocumentNumber: Code[70]; IsInvoice: Boolean): Text;
    var
        txtInfodDtls: Text;
        txtSignedData: Text;
        txtError: Text;
        recAuthData: Record 50037;
        message1: Text;
        CurrentObject: Text;
        p: Integer;
        x: Integer;
        l: Integer;
        ValuePair: Text;
        CurrentElement: Text;
        FormatChar: Label '{}';
        CurrentValue: Text;
        txtAckNum: Text;
        txtAckDate: Text;
        txtIRN: Text;
        txtSignedInvoice: Text;
        txtSignedQR: Text;
        txtEWBNum: Text;
        txtEWBDt: Text;
        txtEWBValid: Text;
        txtRemarks: Text;
        recSIHead: Record 112;
        txtStatus: Text;
        recSalesCrMemo: Record 114;
        SalesInvHdr: Record 112;
        txtErrorMsg: Text;
        tempewaybillno: Text;
    begin
        //Get value from Json Response >>

        //CLEAR(message1);
        //MESSAGE(TextResponse);
        CLEAR(CurrentObject);
        p := 0;
        x := 1;

        IF STRPOS(TextResponse, '{}') > 0 THEN
            EXIT;

        TextResponse := DELCHR(TextResponse, '=', FormatChar);
        l := STRLEN(TextResponse);
        // MESSAGE(TextResponse);
        // EXIT;

        WHILE p < l DO BEGIN
            ValuePair := SELECTSTR(x, TextResponse);  // get comma separated pairs of values and element names
            IF STRPOS(ValuePair, ':') > 0 THEN BEGIN
                p := STRPOS(TextResponse, ValuePair) + STRLEN(ValuePair); // move pointer to the end of the current pair in Value
                CurrentElement := COPYSTR(ValuePair, 1, STRPOS(ValuePair, ':'));
                CurrentElement := DELCHR(CurrentElement, '=', ':');
                CurrentElement := DELCHR(CurrentElement, '=', '"');
                CurrentElement := DELCHR(CurrentElement, '=', ' ');

                CurrentValue := COPYSTR(ValuePair, STRPOS(ValuePair, ':'));
                CurrentValue := DELCHR(CurrentValue, '=', ':');
                CurrentValue := DELCHR(CurrentValue, '=', '"');
                CurrentValue := DELCHR(CurrentValue, '=', ' ');

                CASE CurrentElement OF
                    'status':
                        BEGIN
                            txtStatus := CurrentValue;
                        END;
                    'ErrorDetails':
                        BEGIN
                            txtError := CurrentValue;
                        END;
                    'Data':
                        BEGIN
                            tempewaybillno := DELCHR(CurrentValue, '=', 'ewayBillNo');
                            txtEWBNum := tempewaybillno;
                        END;
                    'cancelDate':
                        BEGIN
                            txtEWBDt := CurrentValue;
                        END;
                    'error':
                        BEGIN
                            txtErrorMsg := CurrentValue;
                        END;
                END;
            END;
            x := x + 1;
        END;

        IF txtStatus = '1' THEN BEGIN
            MESSAGE('Cancel Successfully : E-Way Bill No. : %1 ,Date : %2', txtEWBNum, txtEWBDt);
            SalesInvHdr.RESET();
            SalesInvHdr.SETRANGE(SalesInvHdr."No.", "No.");
            IF SalesInvHdr.FIND('-') THEN BEGIN
                SalesInvHdr."E-Way Bill No." := '';
                SalesInvHdr."E-Way Bill DateTime" := 0DT;
                SalesInvHdr."E-Way Bill Valid Upto" := 0DT;
                SalesInvHdr.MODIFY;
            END;
        END
        ELSE
            IF txtStatus = '0' THEN
                ERROR('Error : %1', TextResponse);
    end;

    local procedure ConvertDt(AckDt2: Text): Text;
    var
        YYYY: Text;
        MM: Text;
        DD: Text;
        DateTime: Text;
        DT: Text;
    begin
        YYYY := COPYSTR(AckDt2, 1, 4);
        MM := COPYSTR(AckDt2, 6, 2);
        DD := COPYSTR(AckDt2, 9, 2);

        // TIME := COPYSTR(AckDt2,12,8);

        //DateTime := DD + '-' + MM + '-' + YYYY + ' ' + COPYSTR(AckDt2,11,8);
        DT := DD + '/' + MM + '/' + YYYY;
        EXIT(DT);
    end;

    local procedure GetDT(InputString: Text[30]) YourDT: DateTime;
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        TheTime: Time;
    begin

        EVALUATE(Day, COPYSTR(InputString, 9, 2));  //2021-10-25192500
        EVALUATE(Month, COPYSTR(InputString, 6, 2));
        EVALUATE(Year, COPYSTR(InputString, 1, 4));
        EVALUATE(TheTime, COPYSTR(InputString, 11, 6));
        YourDT := CREATEDATETIME(DMY2DATE(Day, Month, Year), TheTime);


        /*EVALUATE(Day, COPYSTR(InputString,1,2));
        EVALUATE(Month, COPYSTR(InputString,4,2));
        EVALUATE(Year, COPYSTR(InputString,7,2));
        EVALUATE(TheTime, COPYSTR(InputString,12,8));
        YourDT := FORMAT(Day)+'-'+FORMAT(Month)+'-'+FORMAT(Year); */

    end;

    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

