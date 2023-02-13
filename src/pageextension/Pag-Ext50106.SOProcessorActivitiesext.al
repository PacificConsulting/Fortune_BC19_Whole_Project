pageextension 50106 "SO_Processor_Activities_ext" extends "SO Processor Activities"
{
    // version NAVW19.00.00.45778

    layout
    {



        addafter("Sales CrM. - Pending Doc.Exch.")
        {
            cuegroup("Sales This Month")
            {
                Caption = 'Sales This Month';
                field("Sales Invoices"; "Sales This Month")
                {
                    ToolTip = 'Total Invoice Amount (in Lacs)';
                    ApplicationArea = all;

                    trigger OnDrillDown();
                    var
                        SINV: Record 112;
                    begin
                        SINV.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SINV.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SINV) = ACTION::LookupOK THEN;
                    end;
                }
                field("Sales Cr Memo"; "Sales Cr Memo This Month")
                {
                    ToolTip = 'Total SCM Amount (In Lacs)';
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        SCM: Record 114;
                    begin
                        SCM.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SCM.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SCM) = ACTION::LookupOK THEN;
                    end;
                }
                field("PDC Open cheques"; "PDC Open cheques")
                {
                    DrillDownPageID = "PDC Cheques";
                    Editable = false;
                    ToolTip = 'Total PDCs in Lacs';
                    ApplicationArea = all;
                }
                field("Invoices Due Next Week"; "Invoices Due Next Week")
                {
                    ToolTip = 'Based on Invoice Due Date (Amount in Lacs)';
                    ApplicationArea = all;

                    trigger OnDrillDown();
                    var
                        SINVH: Record 112;
                    begin
                        SINVH.SETRANGE("Due Date", TODAY, CALCDATE('0D+1W', TODAY));
                        SINVH.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SINVH) = ACTION::LookupOK THEN;
                    end;
                }
            }
            cuegroup("HORECA Sales Breakup")
            {
                Caption = 'HORECA Sales Breakup';

                field("Horeca Sales"; "Horeca Sales")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        SINVH: Record 112;
                    begin
                        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SINVH.SETFILTER("Customer Posting Group", '%1', 'HORECA');
                        SINVH.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SINVH) = ACTION::LookupOK THEN;
                    end;
                }
                field("Horeca CM"; "Horeca CM")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        SCM: Record 114;
                    begin
                        SCM.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SCM.SETFILTER("Customer Posting Group", '%1', 'HORECA');
                        SCM.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SCM) = ACTION::LookupOK THEN;
                    end;
                }
            }
            cuegroup("RETAIL Sales Breakup")
            {
                Caption = 'RETAIL Sales Breakup';
                field("Retail Sales"; "Retail Sales")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown();
                    var
                        SINVH: Record 112;
                    begin
                        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SINVH.SETFILTER("Customer Posting Group", '%1', 'RETAIL');
                        SINVH.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SINVH) = ACTION::LookupOK THEN;
                    end;
                }
                field("Retail CM"; "Retail CM")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        SCM: Record 114;
                    begin
                        SCM.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SCM.SETFILTER("Customer Posting Group", '%1', 'RETAIL');
                        SCM.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SCM) = ACTION::LookupOK THEN;
                    end;
                }
            }
            cuegroup("TRADER Sales Breakup")
            {
                Caption = 'TRADER Sales Breakup';
                field(Traders; Traders)
                {
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        SINVH: Record 112;
                    begin
                        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SINVH.SETFILTER("Customer Posting Group", '%1', 'TRADER');
                        SINVH.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SINVH) = ACTION::LookupOK THEN;
                    end;
                }
                field("Traders CM"; "Traders CM")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        SCM: Record 114;
                    begin
                        SCM.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
                        SCM.SETFILTER("Customer Posting Group", '%1', 'TRADER');
                        SCM.SETFILTER("Location Code", LocCodeText);
                        IF PAGE.RUNMODAL(0, SCM) = ACTION::LookupOK THEN;
                    end;
                }
            }
        }
    }

    var
        LocCodeText: Text[1024];



    trigger OnOpenPage();
    begin
        SetLocationFilter; //rdk 260719    
    end;



}

