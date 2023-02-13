tableextension 50306 "Sales_header_archive_ext" extends "Sales Header Archive"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992

    fields
    {



        // modify("Invoice Type")
        // {
        //     OptionCaptionML = ENU = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST', ENN = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';

        //     //Unsupported feature: Change OptionString on ""Invoice Type"(Field 16605)". Please convert manually.

        // }



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
        field(50013; "Post Batch Selection"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50014; "Short Closed"; Boolean)
        {
            Description = 'CCIT';
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
        field(50025; "Business Format / Outlet Name"; Text[100])
        {
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master"."Permit No." WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(50030; PutAwayCreated; Boolean)
        {
            Description = 'CCIT';
        }
        field(50035; "BL Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Bond Master"."In-Bond Bill of Entry No.";

            trigger OnValidate();
            begin
                //CCIT-SG
                RecBondMaster.RESET;
                RecBondMaster.SETRANGE(RecBondMaster."In-Bond Bill of Entry No.", "In-Bond Bill of Entry No.");
                IF RecBondMaster.FINDFIRST THEN BEGIN
                    "BL/AWB No." := RecBondMaster."BL/AWB No.";
                    "BL Date" := RecBondMaster."BL Date";
                    "In-Bond BOE Date" := RecBondMaster."In-Bond BOE Date";
                    "Bond Number" := RecBondMaster."Bond Number";
                    "Bond Sr.No." := RecBondMaster."Bond Sr.No.";
                    "Bond Date" := RecBondMaster."Bond Date";
                    "Ex-bond BOE No." := RecBondMaster."Ex-bond BOE No.";
                    "Ex-bond BOE Date" := RecBondMaster."Ex-bond BOE Date";
                    "Ex-bond BOE No.1" := RecBondMaster."Ex-bond BOE No.1";
                    "Ex-bond BOE Date 1" := RecBondMaster."Ex-bond BOE Date 1";
                    "Ex-bond BOE No.2" := RecBondMaster."Ex-bond BOE No.2";
                    "Ex-bond BOE Date 2" := RecBondMaster."Ex-bond BOE Date 2";
                    "Ex-bond BOE No.3" := RecBondMaster."Ex-bond BOE No.3";
                    "Ex-bond BOE Date 3" := RecBondMaster."Ex-bond BOE Date 3";
                    "Ex-bond BOE No.4" := RecBondMaster."Ex-bond BOE No.4";
                    "Ex-bond BOE Date 4" := RecBondMaster."Ex-bond BOE Date 4";
                    "Ex-bond BOE No.5" := RecBondMaster."Ex-bond BOE No.5";
                    "Ex-bond BOE Date 5" := RecBondMaster."Ex-bond BOE Date 5";
                    "Ex-bond BOE No.6" := RecBondMaster."Ex-bond BOE No.6";
                    "Ex-bond BOE Date 6" := RecBondMaster."Ex-bond BOE Date 6";
                    "Ex-bond BOE No.7" := RecBondMaster."Ex-bond BOE No.7";
                    "Ex-bond BOE Date 7" := RecBondMaster."Ex-bond BOE Date 7";
                    "Ex-bond BOE No.8" := RecBondMaster."Ex-bond BOE No.8";
                    "Ex-bond BOE Date 8" := RecBondMaster."Ex-bond BOE Date 8";
                    "Ex-bond BOE No.9" := RecBondMaster."Ex-bond BOE No.9";
                    "Ex-bond BOE Date 9" := RecBondMaster."Ex-bond BOE Date 9";
                END;
                //CCIT-SG
            end;
        }
        field(50037; "In-Bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50038; "Bond Number"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50039; "Bond Sr.No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50040; "Bond Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50041; "BL/AWB No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50042; "Ex-bond BOE No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50043; "Ex-bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50044; "Ex-bond BOE No.1"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50045; "Ex-bond BOE Date 1"; Date)
        {
            Description = 'CCIT';
        }
        field(50046; "Ex-bond BOE No.2"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50047; "Ex-bond BOE Date 2"; Date)
        {
            Description = 'CCIT';
        }
        field(50048; "Ex-bond BOE No.3"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50049; "Ex-bond BOE Date 3"; Date)
        {
            Description = 'CCIT';
        }
        field(50050; "Ex-bond BOE No.4"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50051; "Ex-bond BOE Date 4"; Date)
        {
            Description = 'CCIT';
        }
        field(50052; "Ex-bond BOE No.5"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50053; "Ex-bond BOE Date 5"; Date)
        {
            Description = 'CCIT';
        }
        field(50054; "Ex-bond BOE No.6"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50055; "Ex-bond BOE Date 6"; Date)
        {
            Description = 'CCIT';
        }
        field(50056; "Ex-bond BOE No.7"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50057; "Ex-bond BOE Date 7"; Date)
        {
            Description = 'CCIT';
        }
        field(50058; "Ex-bond BOE No.8"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50059; "Ex-bond BOE Date 8"; Date)
        {
            Description = 'CCIT';
        }
        field(50060; "Ex-bond BOE No.9"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50061; "Ex-bond BOE Date 9"; Date)
        {
            Description = 'CCIT';
        }
        // field(50062; "E-Way Bill No."; Code[20])
        // {
        //     Description = 'CCIT';
        // }
        field(50063; "E-Way Bill Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50064; "Seal No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50065; "Customer Type"; Option)
        {
            OptionCaption = '" ,New,Existing"';
            OptionMembers = " ",New,Existing;
        }
        field(50066; "Sample For"; Option)
        {
            OptionCaption = '" ,Chef, Purchase Manager,Category Manager,Individual,Trade Events,Sponsorship"';
            OptionMembers = " ",Chef," Purchase Manager","Category Manager",Individual,"Trade Events",Sponsorship;
        }
        field(50067; "Outstanding Quantity KG"; Decimal)
        {
            CalcFormula = Sum("Sales Line Archive"."Outstanding Quantity" WHERE("Document Type" = FIELD("Document Type"),
                                                                                 "Document No." = FIELD("No.")));
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
        }
        field(50068; "Outstanding Quantity PCS"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Quantity In KG" WHERE("Document Type" = FIELD("Document Type"),
                                                                               "Document No." = FIELD("No.")));
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
        }
        field(50069; "SO Creation Time"; Time)
        {
            Description = 'CCIT';
        }
        field(50117; "ShortClose Reason Code"; Option)
        {
            OptionCaption = ',No Inventory,Weight Short';
            OptionMembers = ,"No Inventory","Weight Short";
        }
        field(70000; "Minimum Shelf Life %"; Decimal)
        {
            Description = 'SC';
        }
        field(500122; "Free Sample"; Boolean)
        {
            Description = 'CCIT-TK-121219';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        RecBondMaster: Record 50022;
}

