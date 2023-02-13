tableextension 50038 Price_List_hdr_Ext extends "Price List Header"
{

    fields
    {

        // modify("Source No.")
        // {
        //     trigger OnBeforeValidate()
        //     var
        //         CPG: Record 6;
        //     begin
        //         Message('Hiiiii....');
        //         IF "Source Type" = "Source Type"::"Customer Price Group" then begin
        //             CPG.Reset();
        //             CPG.SetRange("Location Code", Rec."Location Code");
        //             IF CPG.FindFirst() then
        //                 IF PAGE.RUNMODAL(7, CPG) = ACTION::LookupOK THEN begin
        //                     "Source No." := CPG.Code
        //                 end;
        //         end;
        //     end;

        // }


        field(50000; "Location Code"; Code[10])///new
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(50001; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH","CPL-GOA","DPL 20-21";
        }
    }


}