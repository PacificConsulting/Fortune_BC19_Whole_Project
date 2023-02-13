report 50062 "Permit-Test"
{
    // version CCIT-Harshal

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Permit-Test.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry Type" = CONST(Purchase));
            RequestFilterFields = "Item No.", "Source No.";
            column(ItemDescription_ItemLedgerEntry; "Item Ledger Entry"."Item Description")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(SourceNo_ItemLedgerEntry; "Item Ledger Entry"."Source No.")
            {
            }
            column(LicenseNo_ItemLedgerEntry; "Item Ledger Entry"."License No.")
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
            {
            }
            column(HSCode_ItemLedgerEntry; "Item Ledger Entry"."HS Code")
            {
            }
            column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
            {
            }
            column(CompyInfoName; CompyInfo.Name)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(slno; slno)
            {
            }
            column(Des; Des)
            {
            }
            column(TotalQty; TotalQty)
            {
            }
            column(PermitStartDate; PermitStartDate)
            {
            }
            column(PermitEndDate; PermitEndDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                slno += 1;
                HSCodeMaster.RESET;
                HSCodeMaster.SETRANGE(HSCodeMaster."HS Code", "HS Code");
                IF HSCodeMaster.FINDFIRST THEN BEGIN
                    Des := HSCodeMaster.Description;
                    TotalQty := HSCodeMaster."Total Quantity";
                END;

                IF RecLic.GET("Item Ledger Entry"."License No.") THEN BEGIN
                    PermitStartDate := RecLic."Permit Start Date";
                    PermitEndDate := RecLic."Permit Expiry Date";
                END;
            end;

            trigger OnPreDataItem();
            begin
                slno := 0;
                IF (FromDate <> 0D) AND (ToDate <> 0D) THEN BEGIN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", FromDate, ToDate);
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."License No.", '<>%1', '');
                END ELSE
                    IF (AsOnDate <> 0D) AND ((FromDate = 0D) AND (ToDate = 0D)) THEN BEGIN  //AND (ToDate = 0D) AND (LicNo <> '')
                        "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Posting Date", '..%1', AsOnDate);
                        "Item Ledger Entry".SETFILTER("Item Ledger Entry"."License No.", '<>%1', '');
                    END;
                // "Item Ledger Entry".SETRANGE("Item Ledger Entry"."License No.",LicNo);
                // "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Entry Type",'%1',"Item Ledger Entry"."Entry Type"::Purchase);
                IF (FromDate = 0D) AND (ToDate = 0D) AND (AsOnDate = 0D) AND (LicNo <> '') THEN BEGIN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."License No.", LicNo);
                END;
                IF (HSMaster <> '') THEN BEGIN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."HS Code", HSMaster);
                END;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Contro001)
                {
                    field(FromDate; FromDate)
                    {
                        Caption = 'FromDate';
                        Visible = false;

                        trigger OnValidate();
                        begin
                            LicNo := '';
                        end;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'ToDate';
                        Visible = false;

                        trigger OnValidate();
                        begin
                            LicNo := '';
                        end;
                    }
                    group(Control002)
                    {
                        field(AsOnDate; AsOnDate)
                        {
                            Caption = 'AsOnDate';
                            Visible = false;

                            trigger OnValidate();
                            begin
                                LicNo := '';
                            end;
                        }
                        field("Licence No."; LicNo)
                        {
                            Caption = 'Licence No.';
                            TableRelation = "License Master"."Permit No.";

                            trigger OnValidate();
                            begin
                                FromDate := 0D;
                                ToDate := 0D;
                                AsOnDate := 0D;
                            end;
                        }
                        field("HS Code"; HSMaster)
                        {
                            TableRelation = "HS Code Master"."HS Code";
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompyInfo.GET;
    end;

    var
        CompyInfo: Record 79;
        RecILE: Record 32;
        RecILE1: Record 32;
        slno: Integer;
        FromDate: Date;
        ToDate: Date;
        "PermitNo.": Code[10];
        HSCode: Code[10];
        "SupplierNo.": Code[10];
        AsOnDate: Date;
        HSCodeMaster: Record 50024;
        Des: Text[100];
        TotalQty: Decimal;
        LicNo: Code[25];
        HSMaster: Code[20];
        RecLic: Record 50023;
        PermitStartDate: Date;
        PermitEndDate: Date;
}

