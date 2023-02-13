tableextension 50339 "Transfer_shipment_header_ext" extends "Transfer Shipment Header"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    fields
    {
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
        field(50064; "E-Way Bill No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50065; "E-Way Bill Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50066; "Seal No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50067; "Load Type"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FTL,PTL;
        }
        field(50112; "JWL Transfer No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50113; "JWL Transfer Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50114; "Transport Vendor"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50117; "Customer License No."; Text[50])
        {
            Description = 'CCIT';
        }
        field(50118; "Calculate Custom Duty"; Boolean)
        {
            Description = 'CCIT-SD';
        }
        field(50119; "Vehicle Reporting Date"; Date)
        {
            Description = 'Rdk';
        }
        field(50120; "Vehicle Reporting Time"; Time)
        {
            Description = 'Rdk';
        }
        field(50121; "Vehicle Release Time"; Time)
        {
            Description = 'Rdk';
        }
        field(50139; "Order Time"; Time)
        {
            Description = 'CCIT';
        }
        field(50140; "Inv Time"; Time)
        {
            Description = 'CCIT';
        }
        field(50141; "E-Invoice Error Remarks"; Text[250])
        {
            Description = 'CITS_RS(E-Invoicing)';
        }
        field(50142; "QR Code"; BLOB)
        {
            Description = 'CITS_RS(E-Invoicing)';
            SubType = Bitmap;
        }
        field(50143; "E-Invoice IRN"; Text[64])
        {
            Description = 'CITS_RS(E-Invoicing)';
        }
        field(50144; "GST Acknowledgement No."; Text[100])
        {
            Description = 'CITS_RS(E-Invoicing)';
        }
        field(50145; "GST Acknowledgement Dt"; DateTime)
        {
            Description = 'CITS_RS(E-Invoicing)';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

