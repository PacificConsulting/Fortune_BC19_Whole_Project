tableextension 50426 "Posted_Invt_Put_away_Line_ext" extends "Posted Invt. Put-away Line"
{
    // version NAVW19.00.00.45778

    fields
    {
        field(50006; "PO No."; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
        field(50008; Completed; Boolean)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50009; Weighted; Boolean)
        {
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
        field(50012; isFirst; Boolean)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50013; "Packet Quantity To Handle"; Decimal)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50014; "Whse Act Bin Lot Line No."; Integer)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50028; "Conversion Qty To Handle"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50030; Weight1; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50032; "Reason Code"; Code[10])
        {
            Description = 'CCIT-SD-08-01-17';
            TableRelation = "Reason Code";
        }
        field(50068; "Qty. to Invoice In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50069; "Qty. to Receive In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50070; "HS Code"; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
            TableRelation = "HS Code Master"."HS Code";
        }
        field(50073; "Lot No.GRN"; Code[10])
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50074; "Expiration Date GRN"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50075; "Manufacturing Date GRN"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
        }
        field(50076; "Qty. Handled In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
        field(50077; "Qty. Outstanding In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50083; "Gen.Prod.Post.Group"; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
            TableRelation = "Sales Category".Code;
        }
        field(50088; "TO Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50089; "TO Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50090; "Tolerance Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50091; "Source Item No.1"; Code[20])
        {
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50092; "Source Line No.1"; Integer)
        {
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50093; Tolerance; Boolean)
        {
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-08-01-17';
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(70000; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            Description = 'CCIT-SD-08-01-17';

            trigger OnValidate();
            var
                WhseActLine: Record 5767;
            begin
            end;
        }
        field(70004; "PO Lot No."; Code[20])
        {
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
        field(70005; "PO Expiration Date"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
        field(70006; "PO Manufacturing Date"; Date)
        {
            Description = 'CCIT-SD-08-01-17';
            Editable = false;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

