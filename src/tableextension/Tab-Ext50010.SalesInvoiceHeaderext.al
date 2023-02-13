tableextension 50010 "Sales_Invoice_Header_ext" extends "Sales Invoice Header"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune

    fields
    {

        modify("Invoice Type")
        {
            OptionCaptionML = ENU = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST', ENN = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';

            //Unsupported feature: Change OptionString on ""Invoice Type"(Field 16605)". Please convert manually.

        }

        field(50000; "Business Format / Outlet Name"; Text[50])
        {
        }
        field(50021; "Vertical Category"; Code[50])
        {
            Description = 'CCIT-SG';
            TableRelation = "Vertical Category";
        }
        field(50022; "Vertical Sub Category"; Code[30])
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
        field(50067; "Invoice Time"; Time)
        {
            Description = 'CCIT';
        }
        field(50068; "IRN No."; Code[60])
        {
            Description = 'CITS';
        }
        field(50070; "E-Invoice IRN"; Text[64])
        {
            Description = 'CITS_RS E-Invoicing';
        }
        // field(50071; "Acknowledgement Date"; DateTime)
        // {
        //     Description = 'CITS_RS E-Invoicing';
        // }
        field(50072; "E-Invoice QR"; BLOB)
        {
            Description = 'CITS_RS E-Invoicing';
            SubType = Bitmap;
        }
        field(50073; "E-Invoice Error Remarks"; Text[250])
        {
            Description = 'CITS_RS E-Invoicing';
        }
        // field(50074; "Acknowledgement No."; Code[80])
        // {
        //     Description = 'CITS_RS E-Invoicing';
        // }
        field(50075; "P.A.N No."; Code[10])
        {
        }
        field(50076; "Sales Value"; Decimal)
        {
        }
        // field(50077; "Distance (Km)"; Decimal)
        // {
        //     Description = 'CCIT-EWAYBILL';
        // }
        field(50078; "E-Way Bill Valid Upto"; DateTime)
        {
            Description = 'CCIT-EWAYBILL';
        }
        field(50079; "E-Way Bill DateTime"; DateTime)
        {
            Description = 'CCIT-EWAYBILL';
        }
        field(50090; "Sales Person Name"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Salesperson Code")));
            Description = '//ccit-tk';
            FieldClass = FlowField;
        }
        field(50114; "Transport Vendor"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50115; "Last Date And Time"; DateTime)
        {
            Description = 'CCIT';
        }
        field(50116; "Calculate IGST"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50117; "ShortClose Reason Code"; Option)
        {
            OptionCaption = ',No Inventory,Weight Short';
            OptionMembers = ,"No Inventory","Weight Short";
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
        field(50124; "PAY REF DATE"; Date)
        {
            Description = '//CCIT_TK130521';
        }
        field(70001; "Backdated Invoice No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(70002; "Backdated Invoice Date"; Date)
        {
            Description = 'CCIT';
        }
        field(500122; "Free Sample"; Boolean)
        {
            Description = 'CCIT-TK-121219';
        }
         field(50155; "Amount To Customer"; Decimal)
        {
            Description = 'PCPL-NSW-07 18Oct22';
        }


    }


    var
        PostSalesLinesDelete: Codeunit 363;
}

