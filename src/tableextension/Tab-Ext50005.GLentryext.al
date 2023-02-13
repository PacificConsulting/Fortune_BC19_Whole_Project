tableextension 50005 "GL_entry_ext" extends "G/L Entry"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    fields
    {

        //  modify("Dimension Set ID")
        //  {
        //     trigger OnAfterValidate()
        //     {
        //         v: Enum ;
        //     }
        //  }


        //Unsupported feature: Change Editable on ""Dimension Set ID"(Field 480)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""User ID"(Field 27)". Please convert manually.


        //Unsupported feature: CodeInsertion on ""Source No."(Field 58)". Please convert manually.
        modify("Source No.")
        {
            trigger OnAfterValidate();
            begin

                IF Recved.GET("Source No.") THEN
                    "Vendor Name" := Recved.Name;

            end;
        }
        field(50000; "RTGS/NEFT"; Option)
        {
            OptionMembers = " ",RTGS,NEFT;
        }
        field(50001; "Vendor Name"; Text[50])
        {
        }
        field(50002; Comment1; Text[250])
        {
        }
        field(50003; "CashFlow Vendor Type"; Text[50])
        {
            Description = 'RDK';
        }
        field(50057; "Bill of Entry Date"; Date)
        {
            //PCPL/MIG/NSW   'Bill of Entry Date' Field not Exist in BC18
            // CalcFormula = Lookup("Purch. Inv. Header"."Bill of Entry Date" WHERE ("No."=FIELD("Document No.")));
            CaptionML = ENU = 'Bill of Entry Date',
                        ENN = 'Bill of Entry Date';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(50058; "Bill of Entry No"; Text[30])
        {
            /* //PCPL/MIG/NSW   'Bill of Entry Date' Field not Exist in BC18
            CalcFormula = Lookup("Purch. Inv. Header"."Bill of Entry No." WHERE(No.=FIELD(Document No.)));
            CaptionML = ENU='Bill of Entry Value',
                        ENN='Bill of Entry Value';
            Editable = false;
            FieldClass = FlowField;
            */
        }
    }
    keys
    {

        //Unsupported feature: Deletion on ""G/L Account No.,Posting Date"(Key)". Please convert manually.


        //Unsupported feature: Deletion on ""G/L Account No.,Business Unit Code,Global Dimension 1 Code,Global Dimension 2 Code,Close Income Statement Dim. ID,Posting Date,Location Code"(Key)". Please convert manually.

        key(ExtKey; "G/L Account No.", "Posting Date", "Document Type")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(ExtKey1; "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Close Income Statement Dim. ID", "Posting Date", /*"Location Code",*/ "Document Type")//PCPL/MIG/NSW Locatio Code not exist in BC180
        {
            SumIndexFields = Amount;
        }
    }

    var
        Recved: Record 23;
}

