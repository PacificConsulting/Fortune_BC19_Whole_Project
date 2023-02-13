page 50065 "Short Closed Transfer List"
{
    // version NAVW19.00.00.46621,CCIT-Fortune

    CaptionML = ENU = 'Transfer List',
                ENN = 'Transfer List';
    CardPageID = "Transfer Order";
    Editable = true;
    PageType = List;
    SourceTable = "Transfer Header";
    SourceTableView = WHERE("Short Closed" = FILTER(true));
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control01)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }
                field("Last Date And Time"; "Last Date And Time")
                {
                    ApplicationArea = All;
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                    ApplicationArea = All;
                }
                field("In-Transit Code"; "In-Transit Code")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Customer SO/PO No.',
                                ENN = 'External Document No.';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Outstanding Quantity In KG"; "Outstanding Quantity In KG")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity In PCS"; "Outstanding Quantity In PCS")
                {
                    ApplicationArea = All;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Short Closed"; "Short Closed")
                {
                    ApplicationArea = All;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Storage Categories"; "Storage Categories")
                {
                    ApplicationArea = All;
                }
                field("ICA No."; "ICA No.")
                {
                    ApplicationArea = All;
                }
                field("E-Way Bill No."; "E-Way Bill No.")
                {
                    ApplicationArea = All;
                }
                field("E-Way Bill Date"; "E-Way Bill Date")
                {
                    ApplicationArea = All;
                }
                field("Created User"; "Created User")
                {
                    ApplicationArea = All;
                }
                field("Seal No."; "Seal No.")
                {
                    ApplicationArea = All;
                }
                field("Load Type"; "Load Type")
                {
                    ApplicationArea = All;
                }
                field(PutAwayCreated; PutAwayCreated)
                {
                    ApplicationArea = All;
                }
                field(PickListCreated; PickListCreated)
                {
                    ApplicationArea = All;
                }
                field("Receipt Date"; "Receipt Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control02; Links)
            {
                Visible = false;
            }
            systempart(Control03; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                CaptionML = ENU = 'O&rder',
                            ENN = 'O&rder';
                Image = "Order";
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics',
                                ENN = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 5755;
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 5750;
                    RunPageLink = "Document Type" = CONST("Transfer Order"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
            }
            group(Documents)
            {
                CaptionML = ENU = 'Documents',
                            ENN = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    CaptionML = ENU = 'S&hipments',
                                ENN = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page 5752;
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
                action("Re&ceipts")
                {
                    CaptionML = ENU = 'Re&ceipts',
                                ENN = 'Re&ceipts';
                    Image = PostedReceipts;
                    RunObject = Page 5753;
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
            }
            group(Warehouse)
            {
                CaptionML = ENU = 'Warehouse',
                            ENN = 'Warehouse';
                Image = Warehouse;
                action("Whse. Shi&pments")
                {
                    CaptionML = ENU = 'Whse. Shi&pments',
                                ENN = 'Whse. Shi&pments';
                    Image = Shipment;
                    RunObject = Page 7341;
                    RunPageLink = "Source Type" = CONST(5741),
                                  "Source Subtype" = CONST(0),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("&Whse. Receipts")
                {
                    CaptionML = ENU = '&Whse. Receipts',
                                ENN = '&Whse. Receipts';
                    Image = Receipt;
                    RunObject = Page 7342;
                    RunPageLink = "Source Type" = CONST(5741),
                                  "Source Subtype" = CONST(1),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    CaptionML = ENU = 'In&vt. Put-away/Pick Lines',
                                ENN = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page 5774;
                    RunPageLink = "Source Document" = FILTER("Inbound Transfer" | "Outbound Transfer"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                CaptionML = ENU = '&Print',
                            ENN = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
            action("Ex Bond Transfer Order")
            {
                Promoted = true;

                trigger OnAction();
                begin
                    RecTH.RESET;
                    RecTH.SETRANGE(RecTH."No.", "No.");
                    IF RecTH.FINDFIRST THEN
                        REPORT.RUNMODAL(50070, TRUE, FALSE, RecTH);
                end;
            }
            group(Release)
            {
                CaptionML = ENU = 'Release',
                            ENN = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    CaptionML = ENU = 'Re&lease',
                                ENN = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 5708;
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Reo&pen")
                {
                    CaptionML = ENU = 'Reo&pen',
                                ENN = 'Reo&pen';
                    Image = ReOpen;

                    trigger OnAction();
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
                action("Short Closed")
                {
                    Image = PostOrder;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //CCIT-SG
                        RecWAH.RESET;
                        RecWAH.SETRANGE(RecWAH."Source No.", "No.");
                        IF RecWAH.FINDFIRST THEN
                            ERROR('Warehouse Activity Lines are Created first deleted that and then Short Cloesd.');
                        //CCIT-SG

                        //CCIT-PRI
                        IF NOT CONFIRM(Text003, FALSE, "No.") THEN
                            EXIT;

                        TrnasferLine.RESET;
                        TrnasferLine.SETRANGE(TrnasferLine."Document No.", "No.");
                        TrnasferLine.SETFILTER(TrnasferLine."Qty. to Ship", '<>%1', 0);
                        IF TrnasferLine.FINDFIRST THEN
                            REPEAT
                                TrnasferLine."Outstanding Quantity" := 0;
                                TrnasferLine."Outstanding Quantity In KG" := 0;
                                TrnasferLine."Outstanding Qty. (Base)" := 0;
                                TrnasferLine.MODIFY;
                            UNTIL TrnasferLine.NEXT = 0;
                        //CCIT-PRI
                        Rec."Short Closed" := TRUE;
                        Rec.MODIFY;
                        //IF "Short Closed" = TRUE THEN
                        //IsEditable := FALSE ;
                    end;
                }
            }
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ENN = 'F&unctions';
                Image = "Action";
                action("Create Whse. S&hipment")
                {
                    AccessByPermission = TableData 7320 = R;
                    CaptionML = ENU = 'Create Whse. S&hipment',
                                ENN = 'Create Whse. S&hipment';
                    Image = NewShipment;

                    trigger OnAction();
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
                action("Create &Whse. Receipt")
                {
                    AccessByPermission = TableData 7316 = R;
                    CaptionML = ENU = 'Create &Whse. Receipt',
                                ENN = 'Create &Whse. Receipt';
                    Image = NewReceipt;

                    trigger OnAction();
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    CaptionML = ENU = 'Create Inventor&y Put-away/Pick',
                                ENN = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreatePutawayPick;

                    trigger OnAction();
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
                action("Get Bin Content")
                {
                    AccessByPermission = TableData 7302 = R;
                    CaptionML = ENU = 'Get Bin Content',
                                ENN = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;

                    trigger OnAction();
                    var
                        BinContent: Record "Bin Content";
                        GetBinContent: Report "Whse. Get Bin Content";
                    begin
                        BinContent.SETRANGE("Location Code", "Transfer-from Code");
                        GetBinContent.SETTABLEVIEW(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RUNMODAL;
                    end;
                }
            }
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting',
                            ENN = 'P&osting';
                Image = Post;
                action(Post)
                {
                    CaptionML = ENU = 'P&ost',
                                ENN = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction();
                    begin
                        //CCIT-PRI-191118
                        ERROR('You do not have permission');
                        //CCIT-PRI-191118

                        CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post (Yes/No)", Rec);
                    end;
                }
                action(PostAndPrint)
                {
                    CaptionML = ENU = 'Post and &Print',
                                ENN = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction();
                    begin
                        //CCIT-PRI-191118
                        ERROR('You do not have permission');
                        //CCIT-PRI-191118

                        CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post + Print", Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Inventory - Inbound Transfer")
            {
                CaptionML = ENU = 'Inventory - Inbound Transfer',
                            ENN = 'Inventory - Inbound Transfer';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 5702;
            }
        }
    }

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        SETFILTER("Short Closed", '%1', true); //PCPL/NSW/07 30May22
        FILTERGROUP(0);

    end;

    trigger OnAfterGetRecord()
    begin
        FILTERGROUP(2);
        SETFILTER("Short Closed", '%1', true); //PCPL/NSW/07 30May22
        FILTERGROUP(0);
    end;

    var
        Text003: Label 'Do you want to Short Close Transfer Order %1 ?';
        TrnasferLine: Record "Transfer Line";
        RecWAH: Record "Warehouse Activity Header";
        LocCode: Code[1024];
        RecTH: Record "Transfer Header";
        RecUserBranch: Record "User Branch Table";
        LocCodeText: Text[1024];
        RecUserSetup: Record "User Setup";
        ClearHide: Boolean;
}

