tableextension 50001 "Customer_Price_Group_ext" extends "Customer Price Group"
{
    // version NAVW19.00.00.45778

    fields
    {
        field(50000; "Location Code"; Code[10])
        {
            Description = 'CCIT';
            TableRelation = Location.Code;
        }
        field(50001; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH","CPL-GOA","DPL 20-21";
        }
    }
}

