tableextension 50401 "Analysis_Column_ext" extends "Analysis Column"
{
    // version NAVW19.00.00.46621

    fields
    {


        field(50000; "Entry Type"; Option)
        {
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(50001; "Vendor Type"; Text[30])
        {
            Description = 'rdk 210819';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        OriginalFormula: Code[20];
        Text001: TextConst ENU = '%1 is not a valid Period Formula', ENN = '%1 is not a valid Period Formula';
}

