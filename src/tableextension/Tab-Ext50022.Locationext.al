tableextension 50022 "Location_ext" extends Location
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822TFS225977

    fields
    {
        field(50000; "FSSAI No"; Code[25])
        {
        }
        field(50001; "P.A.N No"; Code[15])
        {
        }
        field(50002; "Duty Free"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50003; "BOND Dispatch"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50004; "Quarantine Location"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50005; "Used In Reports"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50006; "Used In Stock Ageing Report"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50007; "Used In Inventory Planning HO"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50008; "Used In MA-Product"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50009; "Used In InventoryPAN INDIA"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50010; Loc_DF; Boolean)
        {
            Description = 'CCIT';
        }
        field(50011; Loc_Main; Boolean)
        {
            Description = 'CCIT';
        }
        field(50012; Loc_Intra; Boolean)
        {
            Description = 'CCIT';
        }
        field(50013; Loc_Block; Boolean)
        {
            Description = 'CCIT';
        }
        field(50014; Loc_Reco; Boolean)
        {
            Description = 'CCIT';
        }
        field(50015; "Used In GST Calculation"; Boolean)
        {
            Description = 'CCIT-SD-19-02-2018';
        }
        field(50016; "Used In Quarantine Report"; Boolean)
        {
            Description = 'CCIT-SD-27-02-2018';
        }
        field(50017; Loc_Branch; Code[10])
        {
            Description = 'CCIT';
            TableRelation = "Branch Master".Code;
        }
        field(50018; Loc_Bond; Boolean)
        {
            Description = 'CCIT';
        }
        field(50019; "SO GST Calculation"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50020; "Branch Code"; Code[10])
        {
            Description = 'CCIT-JAGA 02/11/2019';
            TableRelation = "Dimension Value".Code;
        }
        // field(50021; "Posting No. Series"; Code[10])
        // {
        //     Description = 'Invoice Posting No. Series';
        //     TableRelation = "No. Series".Code;
        // }
        // field(50022; "Sales Cr Memo No."; Code[10])
        // {
        //     Description = 'Sales Cr Memo No.';
        //     TableRelation = "No. Series".Code;
        // }

    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

