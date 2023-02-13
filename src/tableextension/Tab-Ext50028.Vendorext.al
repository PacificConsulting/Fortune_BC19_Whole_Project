tableextension 50028 "Vendor_ext" extends Vendor
{

    fields
    {
        field(50000; "FSSAI No."; Code[20])
        {
            Description = 'CCIT-SG';
        }
        field(50001; "Transport Method"; Code[10])
        {
            Description = 'CCIT-SG';
            TableRelation = "Transport Method";
        }
        field(50002; "Port of Loading-Air"; Code[20])
        {
            TableRelation = "Port Of Loading-Air";
        }
        field(50003; "Port of Loading-Ocean"; Code[20])
        {
            TableRelation = "Port Of Looading-Ocean";
        }
        field(50004; "Port of Destination-Air"; Code[20])
        {
            TableRelation = "Port Of Destination-Air";
        }
        field(50005; "Port of Destination-Ocean"; Code[20])
        {
            TableRelation = "Port Of Destination-Ocean";
        }
        field(50006; "Mode of Shipment"; Option)
        {
            OptionMembers = " ",Air,Ocean,"Air/Ocean";
        }
        field(50007; "Lead Time Air ETD"; DateFormula)
        {
            Description = 'RDK';
        }
        field(50008; "Lead Time Ship ETD"; DateFormula)
        {
            Description = 'RDK';
        }
        field(50009; "Avail.for Sale  Air ETA"; DateFormula)
        {
            Description = 'RDK';
        }
        field(50010; "Avail.for Sale Ship ETA"; DateFormula)
        {
            Description = 'RDK';
        }
        field(50011; "Stock Last for Days"; DateFormula)
        {
            Description = 'RDK';
        }
        field(50012; "CashFlow Vendor Type"; Text[50])
        {
            Description = 'RDK';
        }
        field(50013; "Custome Duty Exm."; Boolean)
        {
            Description = 'CCIT';
        }
        field(50015; "Applicability of 206AB"; Option)
        {
            Description = 'CCIT-SG';
            OptionCaption = 'Not Comply,Comply';
            OptionMembers = "Not Comply",Comply;
        }
        field(50016; "GST Custom House"; Boolean)
        {
            Description = 'PCPL/MIG/NSW 040422';
        }
        field(50017; SSI; Boolean)
        {
            Description = 'PCPL/064/31Jan2023';
        }
        field(50018; "SSI Validity Date"; Date)
        {
            Description = 'PCPL/064/31Jan2023';
        }

    }





    var
        PANErr: Label 'PAN No. must be entered.';
}

