tableextension 50006 "customer_ext" extends Customer
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune,TFS225977,CCIT-TDS

    fields
    {

        modify("Salesperson Code")
        {
            trigger OnAfterValidate();
            var
                SalesPerson: Record 13;
            begin
                IF SalesPerson.GET("Salesperson Code") THEN
                    "Sales Person Name" := SalesPerson.Name;

            end;
        }

        modify("Gen. Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                SalesPrice_1.RESET;
                SalesPrice_1.SETRANGE("Customer Code", "No.");
                IF SalesPrice_1.FINDFIRST THEN
                    REPEAT
                        SalesPrice_1."Gen.Bus.Posting Group" := "Gen. Bus. Posting Group";
                        SalesPrice_1.MODIFY;
                    UNTIL SalesPrice_1.NEXT = 0;

            end;
        }
        /* //PCPL/MIG/NSW This Field is Not Exist in BC 19 Now Thats why Code Comment Below
        modify("P.A.N. No.")
        {
            trigger OnBeforeValidate()
            begin
                IF ("GST Registration No." <> '') AND ("P.A.N. No." <> COPYSTR("GST Registration No.", 3, 10)) THEN
                    ERROR(SamePANErr);
            end;
        }
        */


        // modify("GST Registration No.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         GSTRegistrationNos: Record 18008
        // Begin
        //         IF ("P.A.N. No." <> '') AND ("P.A.N. Status" = "P.A.N. Status"::" ") THEN
        //             GSTRegistrationNos.CheckGSTRegistrationNo("State Code", "GST Registration No.", "P.A.N. No.")
        //         ELSE
        //             IF "GST Registration No." <> '' THEN
        //                 ERROR(PANErr);
        //         "GST Customer Type"::"SEZ Development","GST Customer Type"::"SEZ Unit",
        //                     "GST Customer Type"::"Deemed Export"])

        //   "GST Customer Type" := "GST Customer Type"::" ";
        //     End;
        // }


        // //Unsupported feature: CodeInsertion on ""GST Registration Type"(Field 16603)". Please convert manually.
        // modify("GST Registration Type")
        // {
        //     trigger OnAfterValidate();
        //     var
        //         GSTRegistrationNos: Record 18008;
        //     begin

        //         IF NOT ("GST Customer Type" IN ["GST Customer Type"::Registered, "GST Customer Type"::" "]) AND NOT
        //            ("GST Registration Type" = "GST Registration Type"::GSTIN)
        //         THEN
        //             ERROR(GSTCustRegErr);
        //         IF ("P.A.N. No." <> '') AND ("P.A.N. Status" = "P.A.N. Status"::" ") THEN
        //             GSTRegistrationNos.CheckGSTRegistrationNo("State Code", "GST Registration No.", "P.A.N. No.")
        //         ELSE
        //             IF "GST Registration No." <> '' THEN
        //                 ERROR(PANErr);

        //     end;
        // }


        modify("GST Customer Type")
        {
            trigger OnAfterValidate();
            var
                GSTRegistrationNos: Record 18008;
            Begin
                IF NOT ("GST Customer Type" IN ["GST Customer Type"::Registered]) AND NOT
                  ("GST Registration Type" = "GST Registration Type"::GSTIN)
              THEN
                    ERROR(GSTCustRegErr);

            End;

        }
        field(50001; "FSSAI License No"; Code[15])
        {
        }
        field(50002; "Accepted Product Shelf Life"; Text[100])
        {
            Description = 'CCIT-SG';
        }
        field(50003; "Sales Return Allowed"; Boolean)
        {
            Description = 'CCIT-SG';
        }
        field(50005; "Route Days Applicable"; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50006; Sunday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50007; Monday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50008; Tuesday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50009; Wednesday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50010; Thursday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50011; Friday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50012; Saturday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50013; "Contact No.(Sales)"; Text[30])
        {
            Description = 'CCIT-SG';
        }
        field(50014; "Contact No.(Purchase)"; Text[30])
        {
            Description = 'CCIT-SG';
        }
        field(50015; "Contact No.(Accounts)"; Text[30])
        {
            Description = 'CCIT-SG';
        }
        field(50016; "Sales E-Mail"; Text[80])
        {
            Description = 'CCIT-SG';
            ExtendedDatatype = EMail;
        }
        field(50017; "Purchase E-Mail"; Text[80])
        {
            Description = 'CCIT-SG';
            ExtendedDatatype = EMail;
        }
        field(50018; "Accounts E-Mail"; Text[80])
        {
            Description = 'CCIT-SG';
            ExtendedDatatype = EMail;
        }
        field(50019; "Address 3"; Text[50])
        {
        }
        field(50020; "Address 4"; Text[50])
        {
        }
        field(50021; "Vertical Category"; Code[50])
        {
            Description = 'CCIT-SG';
            TableRelation = "Vertical Category";
        }
        field(50022; "Vertical Sub Category"; Code[50])
        {
            Description = 'CCIT-SG';
            TableRelation = "Vertical Sub Category".Code WHERE("Vertical Category Code" = FIELD("Vertical Category"));
        }
        field(50023; "Outlet Area"; Text[30])
        {
            Description = 'CCIT-SG';
        }
        field(50024; "Responsible Collection Person"; Code[10])
        {
            Description = 'CCIT-SG';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50025; "Business Format / Outlet Name"; Text[100])
        {
        }
        field(50026; "BOND Dispatch"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50027; "Duty Free"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50028; "Customer Category"; Option)
        {
            Description = 'CCIT';
            OptionMembers = ,A,B,C,D,E,New,Discontinued;
        }
        field(50029; Referance; Boolean)
        {
            Description = 'CCIT';
        }
        field(50030; "EAN Code"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50031; "Sales Reporting Field"; Text[200])
        {
            Description = 'CCIT';
        }
        field(50032; "Contact Name (Accounts)"; Text[200])
        {
        }
        field(50033; "Contact (Purchase)"; Text[200])
        {
        }
        field(50034; "UIN Number"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50035; "Created Date"; Date)
        {
            Description = 'CCIT';
            Editable = false;
        }
        field(50036; "Delivery Outlet"; Text[30])
        {
            Description = 'CCIT';
        }
        field(50037; "FSSAI License Start Date"; Date)
        {
            Description = 'RDK';
        }
        field(50038; "FSSAI License End Date"; Date)
        {
            Description = 'RDK';
        }
        field(50039; "Sales Code"; Code[20])
        {
            Description = 'RDK';
            TableRelation = "Customer Price Group";
        }
        field(50040; "Line Discount Allow"; Boolean)
        {
            Description = 'RDK';
        }
        field(50041; "Free Sample"; Boolean)
        {
            Description = 'CCIT-TK-121219';
        }
        field(50042; "Sales Person Name"; Text[30])
        {
        }
        field(50045; "194Q Applicable"; Option)
        {
            Description = 'CCIT-SG';
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(50046; "TCS 206 CAA Applicable"; Option)
        {
            Description = 'CCIT-SG';
            OptionCaption = 'Comply,Non Comply';
            OptionMembers = Comply,"Non Comply";
        }
        field(50047; "Balance at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                         "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                         "Currency Code" = FIELD("Currency Filter")));
            CaptionML = ENU = 'Balance at Date',
                        ENN = 'Balance at Date';
            Description = 'RL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70000; "Minimum Shelf Life %"; Decimal)
        {
            Description = 'SC';
        }
        field(70001; "Editable Sales Order"; Boolean)
        {

        }
    }
    keys
    {
        key(Newkey; "Name 2")
        {

        }
    }


    trigger OnDelete();
    var
        SalesOrderLine: Record 37;
    begin

        SalesOrderLine.SETFILTER(
          "Document Type", '%1|%2',
          SalesOrderLine."Document Type"::Order,
          SalesOrderLine."Document Type"::"Return Order");

    end;

    trigger OnInsert();
    begin
        //rdk 12-07-2019
        "Created Date" := TODAY;

    end;

    LOCAL PROCEDURE CheckGSTRegBlankInRef();
    VAR
        ShipToAddress: Record 222;
    BEGIN
        ShipToAddress.SETRANGE("Customer No.", "No.");
        ShipToAddress.SETFILTER("GST Registration No.", '<>%1', '');
        IF ShipToAddress.FINDSET THEN
            REPEAT
                IF "P.A.N. No." <> COPYSTR(ShipToAddress."GST Registration No.", 3, 10) THEN
                    ERROR(GSTPANErr, ShipToAddress.Code);
            UNTIL ShipToAddress.NEXT = 0;
    END;

    var
        SalesPerson: Record 13;
        SalesPrice_1: Record 7002;

    var
        PANErr: TextConst ENU = 'PAN No. must be entered.', ENN = 'PAN No. must be entered.';
        GSTPANErr: TextConst Comment = '%1 = GST Registration No.', ENU = 'Please update GST Registration No. to blank in the record %1 from Ship To Address.', ENN = 'Please update GST Registration No. to blank in the record %1 from Ship To Address.';
        SamePANErr: TextConst ENU = 'From postion 3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.', ENN = 'From postion 3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.';
        GSTCustRegErr: TextConst ENU = 'GST Customer type ''Blank'' & ''Registered'' is allowed to select when GST Registration Type is UID or GID.', ENN = 'GST Customer type ''Blank'' & ''Registered'' is allowed to select when GST Registration Type is UID or GID.';

}

