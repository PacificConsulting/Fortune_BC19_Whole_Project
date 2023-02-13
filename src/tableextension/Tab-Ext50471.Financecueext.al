tableextension 50471 "Finance_cue_ext" extends "Finance Cue"
{
    // version NAVW19.00.00.45778

    fields
    {
        field(50000; "Purch.Invoices Not Posted"; Integer)
        {
            AccessByPermission = TableData 38 = R;
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = FILTER(Invoice),
                                                         Invoice = CONST(false)));
            Description = 'RDK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Bank Payments Not Posted"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line" WHERE("Journal Template Name" = CONST('BANK PAYME')));
            Description = 'RDK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Cash Payments Not Posted"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line" WHERE("Journal Template Name" = CONST('CASH PAYME')));
            Description = 'RDK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Pending Contra Entries"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line" WHERE("Journal Template Name" = CONST('CONTRA VOU')));
            Description = 'RDK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Open PDCS for the Month"; Decimal)
        {
            Description = 'RDK';
        }
    }
}

