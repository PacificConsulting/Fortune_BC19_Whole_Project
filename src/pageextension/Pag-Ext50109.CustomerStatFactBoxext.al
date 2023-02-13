pageextension 50109 "Customer_Stat_FactBox_ext" extends "Customer Statistics FactBox"
{
    // version NAVW19.00.00.48992

    layout
    {
        addfirst(Sales)
        {
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

