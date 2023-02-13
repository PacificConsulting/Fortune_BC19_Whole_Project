tableextension 50020 "TDS_Setup_ext" extends "TDS Setup"
{
    // version NAVIN9.00.00.46621,CCIT-TDS

    fields
    {
        // modify("TDS Group")
        // {
        //     OptionCaptionML = ENU=' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Rent for Plant & Machinery,Rent for Land & Building,Banking Services,Compensation On Immovable Property,PF Accumulated,Payment For Immovable Property,TDS On Goods',ENN=' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Rent for Plant & Machinery,Rent for Land & Building,Banking Services,Compensation On Immovable Property,PF Accumulated,Payment For Immovable Property,TDS On Goods';

        //     //Unsupported feature: Change OptionString on ""TDS Group"(Field 20)". Please convert manually.

        // }

        //Unsupported feature: CodeInsertion on ""TDS %"(Field 12)". Please convert manually.
        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //CCIT-SG-TDS-01072021
        Rec."Double Rate Of TDS" := "TDS %" * 2;
        //CCIT-SG-TDS-01072021
        */
        //end;
        field(50000; "Rate 206AB"; Decimal)
        {
            Description = 'CCIT-SG';
        }
        field(50001; "Double Rate Of TDS"; Decimal)
        {
            Description = 'CCIT-SG';
            Editable = false;
        }
    }


}

