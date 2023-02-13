tableextension 50422 "Return_Shipment_Header_ext" extends "Return Shipment Header"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune

    fields
    {


        field(50002; "Port of Loading-Air"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Loading-Air";
        }
        field(50003; "Port of Loading-Ocean"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Looading-Ocean";
        }
        field(50004; "Port of Destination-Air"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Destination-Air";
        }
        field(50005; "Port of Destination-Ocean"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Destination-Ocean";
        }
        field(50016; "Bill Of Lading Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50018; "Bill Of Lading No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50019; "Container Filter"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ","20ft","40ft";
        }
        field(50020; "BL/AWB"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50021; "ETD - Supplier Warehouse"; Date)
        {
            Description = 'CCIT';
        }
        field(50022; "ETD - Origin Port"; Date)
        {
            Description = 'CCIT';
        }
        field(50023; "Container Number"; Code[30])
        {
            Description = 'CCIT';
        }
        field(50024; "Container Seal #"; Code[30])
        {
            Description = 'CCIT';
        }
        field(50025; "ETA - Destination Port"; Date)
        {
            Description = 'CCIT';
        }
        field(50026; "ETA - Destination CFS"; Date)
        {
            Description = 'CCIT';
        }
        field(50027; "ETA - Bond"; Date)
        {
            Description = 'CCIT';
        }
        field(50028; "ETA - Availability for Sale"; Date)
        {
            Description = 'CCIT';
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
        field(50062; "E-Way Bill No."; Code[20])
        {
            Description = 'CCIT';
            Enabled = false;
        }
        field(50063; "E-Way Bill Date"; Date)
        {
            Description = 'CCIT';
            Enabled = false;
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
        field(50112; "JWL Transfer No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50113; "JWL Transfer Date"; Date)
        {
            Description = 'CCIT';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

