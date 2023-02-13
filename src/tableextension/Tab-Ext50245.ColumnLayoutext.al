tableextension 50245 "Column_Layout_ext" extends "Column Layout"
{
    // version NAVW19.00.00.46621

    fields
    {

        field(50000; "Entry Type"; Option)
        {
            Description = 'rdk 03-08-19';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(50001; "Document No. filter"; Text[250])
        {
            Description = 'RDK 14-08-2019';
        }
        field(50002; "Vendor Type"; Text[30])
        {
            Description = 'RDK 21-08-2019';
        }
    }



    var
        OriginalFormula: Code[20];

    var
        Text001: TextConst ENU = '%1 is not a valid Period Formula', ENN = '%1 is not a valid Period Formula';
}

