tableextension 50385 "Return_Receipt_Header_ext" extends "Return Receipt Header"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune

    fields
    {


        // modify("Invoice Type")
        // {
        //     OptionCaptionML = ENU='Taxable,Bill of Supply,Export,Supplementary,Debit Notes,Non GST',ENN='Taxable,Bill of Supply,Export,Supplementary,Debit Notes,Non GST';

        //     //Unsupported feature: Change OptionString on ""Invoice Type"(Field 16605)". Please convert manually.

        // }

        //Unsupported feature: PropertyDeletion on ""User ID"(Field 112)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Authorized User ID"(Field 16343)". Please convert manually.


        //Unsupported feature: Deletion on ""Vehicle No."(Field 16513)". Please convert manually.


        //Unsupported feature: Deletion on ""GST Reason Type"(Field 16615)". Please convert manually.


        //Unsupported feature: Deletion on ""Location GST Reg. No."(Field 16616)". Please convert manually.


        //Unsupported feature: Deletion on ""Customer GST Reg. No."(Field 16617)". Please convert manually.


        //Unsupported feature: Deletion on ""Ship-to GST Reg. No."(Field 16618)". Please convert manually.


        //Unsupported feature: Deletion on ""Distance (Km)"(Field 16619)". Please convert manually.


        //Unsupported feature: Deletion on ""Vehicle Type"(Field 16620)". Please convert manually.


        //Unsupported feature: Deletion on ""Reference Invoice No."(Field 16621)". Please convert manually.

        field(50000; "Business Format / Outlet Name"; Text[100])
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
        field(50029; "License No."; Code[25])
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
        field(50112; "JWL Transfer No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50113; "JWL Transfer Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50120; "Tally Invoice No."; Code[30])
        {
            Description = 'CCIT-JAGA 29/10/2018';
        }
        field(50122; "Customer GRN/RTV No."; Code[30])
        {
        }
        field(50123; "GRN/RTV Date"; Date)
        {
        }
        field(70001; "Backdated Invoice No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(70002; "Backdated Invoice Date"; Date)
        {
            Description = 'CCIT';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

