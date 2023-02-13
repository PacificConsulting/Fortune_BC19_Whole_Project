tableextension 50023 "Detailed_GST_Ledger_Entry_ext" extends "Detailed GST Ledger Entry"
{
    // version TFS225977

    fields
    {


        modify("Credit Adjustment Type")
        {
            OptionCaptionML = ENU = ' ,Credit Reversal,Credit Re-Availment,Permanent Reversal';

            //Unsupported feature: Change OptionString on ""Credit Adjustment Type"(Field 91)". Please convert manually.

        }

        //Unsupported feature: Change Editable on ""Remaining Base Amount"(Field 109)". Please convert manually.


        //Unsupported feature: Change Editable on ""Remaining GST Amount"(Field 110)". Please convert manually.

        modify("Associated Enterprises")
        {
            CaptionML = ENN = 'Associated Enterprises';
        }

        field(50000; Description; Text[100])
        {
            Description = 'ccit';
        }
        field(50001; "Customer/Vendor Name"; Text[100])
        {
            Description = 'ccit';
        }
        field(50002; "Same State GST Line"; Boolean)
        {
            Description = 'rdk';
        }
        field(50006; "Bill of Entry No."; Text[20])
        {
            CaptionML = ENU = 'Bill of Entry No.',
                        ENN = 'Bill of Entry No.';
        }
        field(50007; "Bill of Entry Date"; Date)
        {
            CaptionML = ENU = 'Bill of Entry Date',
                        ENN = 'Bill of Entry Date';
        }
        field(50008; "PTS Transfer Order"; Code[20])
        {
            CalcFormula = Lookup("Transfer Shipment Header"."Transfer Order No." WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT_TK';
            FieldClass = FlowField;
        }
        field(50009; "PTS Trasfer Order Date"; Date)
        {
            CalcFormula = Lookup("Transfer Shipment Header"."Transfer Order Date" WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT_TK';
            FieldClass = FlowField;
        }
        field(50010; "PTR Transfer Order"; Code[20])
        {
            CalcFormula = Lookup("Transfer Receipt Header"."Transfer Order No." WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT_TK';
            FieldClass = FlowField;
        }
        field(50011; "PTR Trasfer Order Date"; Date)
        {
            CalcFormula = Lookup("Transfer Receipt Header"."Transfer Order Date" WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT_TK';
            FieldClass = FlowField;
        }
        field(50012; "Nature of Supply"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Invoice Header"."Nature of Supply" WHERE("No." = FIELD("Document No.")));
            OptionCaption = 'B2B,B2C';
            OptionMembers = B2B,B2C;
            Description = 'PCPL/NSW/13July22';
        }
        field(50015; "Original Doc Type"; Option)
        {
            // OptionCaption = ' ,Payment,Invoice,Credit Memo,Transfer,Finance Charge Memo,Reminder,Refund,Transfer Shipment,Transfer Receipt';
            // OptionMembers = ,Payment,Invoice,"Credit Memo",Transfer,"Finance Charge Memo",Reminder,Refund,"Transfer Shipment","Transfer Receipt";
            OptionCaption = ' ,Invoice,Credit Memo,Transfer Shipment,Transfer Receipt';
            OptionMembers = ,Invoice,"Credit Memo","Transfer Shipment","Transfer Receipt";
            Editable = false;
            Description = 'PCPL-0070 15Nov2022';
        }
    }
    keys
    {

        //Unsupported feature: Deletion on ""Location  Reg. No.,Transaction Type,Entry Type,GST Vendor Type,GST Credit,Posting Date,Source No.,Document Type,Document No.,Document Line No."(Key)". Please convert manually.

    }


    //Unsupported feature: CodeModification on "OnInsert". Please convert manually.

    trigger OnInsert();
    begin
        //ccit san-261118---
        //Update customer/vendor name
        IF "Source Type" = "Source Type"::Vendor THEN BEGIN
            IF recVend.GET("Source No.") THEN
                "Customer/Vendor Name" := recVend.Name;
        END;
        IF "Source Type" = "Source Type"::Customer THEN BEGIN
            IF recCust.GET("Source No.") THEN
                "Customer/Vendor Name" := recCust.Name;
        END;
        //update item/GLaccount/FA name
        IF Type = Type::Item THEN BEGIN
            IF recItem.GET("No.") THEN
                Description := recItem.Description;
        END;
        IF Type = Type::"G/L Account" THEN BEGIN
            IF recGLAccount.GET("No.") THEN
                Description := recGLAccount.Name;
        END;
        IF Type = Type::"Charge (Item)" THEN BEGIN
            IF recItemCharge.GET("No.") THEN
                Description := recItemCharge.Description;
        END;
        IF Type = Type::"Fixed Asset" THEN BEGIN
            IF recFA.GET("No.") THEN
                Description := recFA.Description;
        END;
        IF Type = Type::Resource THEN BEGIN
            IF recResource.GET("No.") THEN
                Description := recResource.Name;
        END;
        //----


    end;



    var
        recVend: Record 23;
        recCust: Record 18;
        recItem: Record 27;
        recGLAccount: Record 15;
        recFA: Record 5600;
        recItemCharge: Record 5800;
        recResource: Record 156;
}

