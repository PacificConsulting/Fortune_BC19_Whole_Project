pageextension 50108 "Sales_Hist_Sell_FactBox_ext" extends "Sales Hist. Sell-to FactBox"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("No. of Quotes")
        {
            field("Credit Limit (LCY)"; "Credit Limit (LCY)")
            {
                CaptionML = ENU = 'Credit Limit',
                            ENN = 'Credit Limit (LCY)';
                ApplicationArea = all;
            }
            field(AvailableCreditLCY; CalcAvailableCreditUI)
            {
                CaptionML = ENU = 'Available Credit (LCY)',
                            ENN = 'Available Credit (LCY)';
                ApplicationArea = all;

                trigger OnDrillDown();
                begin
                    PAGE.RUN(PAGE::"Available Credit", Rec);
                end;
            }
        }
    }
}

