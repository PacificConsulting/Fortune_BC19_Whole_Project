page 50071 "Value Ent"
{
    // version NAVW19.00.00.45778

    CaptionML = ENU = 'Value Entries',
                ENN = 'Value Entries';
    DataCaptionExpression = GetCaption;
    Editable = true;
    PageType = List;
    Permissions = TableData 5802 = rimd;
    SourceTable = "Value Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Valuation Date"; "Valuation Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Ledger Entry Type"; "Item Ledger Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Variance Type"; "Variance Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Adjustment; Adjustment)
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; "Document Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Charge No."; "Item Charge No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Sales Amount (Expected)"; "Sales Amount (Expected)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Sales Amount (Actual)"; "Sales Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Expected)"; "Cost Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual)"; "Cost Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Non-Invtbl.)"; "Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = All;
                }
                field("Cost Posted to G/L"; "Cost Posted to G/L")
                {
                    ApplicationArea = All;
                }
                field("Expected Cost Posted to G/L"; "Expected Cost Posted to G/L")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cost Amount (Expected) (ACY)"; "Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)"; "Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; "Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cost Posted to G/L (ACY)"; "Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Ledger Entry Quantity"; "Item Ledger Entry Quantity")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Item Ledger Entry Quantity In KG',
                                ENN = 'Item Ledger Entry Quantity';
                }
                field("Valued Quantity"; "Valued Quantity")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Valued Quantity In KG',
                                ENN = 'Valued Quantity';
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Invoiced Quantity In KG',
                                ENN = 'Invoiced Quantity';
                }
                field("Cost per Unit"; "Cost per Unit")
                {
                    ApplicationArea = All;
                }
                field("Cost per Unit (ACY)"; "Cost per Unit (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Discount Amount"; "Discount Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Source Posting Group"; "Source Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Order Type"; "Order Type")
                {
                    ApplicationArea = All;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Valued By Average Cost"; "Valued By Average Cost")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry No."; "Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Capacity Ledger Entry No."; "Capacity Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Ledger Entry No."; "Job Ledger Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1900383209; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                CaptionML = ENU = 'Ent&ry',
                            ENN = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                action("General Ledger")
                {
                    CaptionML = ENU = 'General Ledger',
                                ENN = 'General Ledger';
                    Image = GLRegisters;

                    trigger OnAction();
                    begin
                        ShowGL;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                CaptionML = ENU = '&Navigate',
                            ENN = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var

                begin

                    // Navigate.SetDoc("Posting Date", "Document No.");
                    //Navigate.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        FilterGroupNo := FILTERGROUP; // Trick: FILTERGROUP is used to transfer an integer value
    end;

    var
        Navigate: Page "Navigate";
        FilterGroupNo: Integer;

    local procedure GetCaption(): Text[250];
    var
        GLSetup: Record 98;
        ObjTransl: Record 377;
        Item: Record 27;
        ProdOrder: Record 5405;
        Cust: Record 18;
        Vend: Record 23;
        Dimension: Record 348;
        DimValue: Record 349;
        SourceTableName: Text[100];
        SourceFilter: Text[200];
        Description: Text[100];
    begin
        Description := '';

        CASE TRUE OF
            GETFILTER("Item Ledger Entry No.") <> '':
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 32);
                    SourceFilter := GETFILTER("Item Ledger Entry No.");
                END;
            GETFILTER("Capacity Ledger Entry No.") <> '':
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5832);
                    SourceFilter := GETFILTER("Capacity Ledger Entry No.");
                END;
            GETFILTER("Item No.") <> '':
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);
                    SourceFilter := GETFILTER("Item No.");
                    IF MAXSTRLEN(Item."No.") >= STRLEN(SourceFilter) THEN
                        IF Item.GET(SourceFilter) THEN
                            Description := Item.Description;
                END;
            (GETFILTER("Order No.") <> '') AND ("Order Type" = "Order Type"::Production):
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5405);
                    SourceFilter := GETFILTER("Order No.");
                    IF MAXSTRLEN(ProdOrder."No.") >= STRLEN(SourceFilter) THEN
                        IF ProdOrder.GET(ProdOrder.Status::Released, SourceFilter) OR
                           ProdOrder.GET(ProdOrder.Status::Finished, SourceFilter)
                        THEN BEGIN
                            SourceTableName := STRSUBSTNO('%1 %2', ProdOrder.Status, SourceTableName);
                            Description := ProdOrder.Description;
                        END;
                END;
            GETFILTER("Source No.") <> '':
                CASE "Source Type" OF
                    "Source Type"::Customer:
                        BEGIN
                            SourceTableName :=
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                            SourceFilter := GETFILTER("Source No.");
                            IF MAXSTRLEN(Cust."No.") >= STRLEN(SourceFilter) THEN
                                IF Cust.GET(SourceFilter) THEN
                                    Description := Cust.Name;
                        END;
                    "Source Type"::Vendor:
                        BEGIN
                            SourceTableName :=
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 23);
                            SourceFilter := GETFILTER("Source No.");
                            IF MAXSTRLEN(Vend."No.") >= STRLEN(SourceFilter) THEN
                                IF Vend.GET(SourceFilter) THEN
                                    Description := Vend.Name;
                        END;
                END;
            GETFILTER("Global Dimension 1 Code") <> '':
                BEGIN
                    GLSetup.GET;
                    Dimension.Code := GLSetup."Global Dimension 1 Code";
                    SourceFilter := GETFILTER("Global Dimension 1 Code");
                    SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
                    IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
                        IF DimValue.GET(GLSetup."Global Dimension 1 Code", SourceFilter) THEN
                            Description := DimValue.Name;
                END;
            GETFILTER("Global Dimension 2 Code") <> '':
                BEGIN
                    GLSetup.GET;
                    Dimension.Code := GLSetup."Global Dimension 2 Code";
                    SourceFilter := GETFILTER("Global Dimension 2 Code");
                    SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
                    IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
                        IF DimValue.GET(GLSetup."Global Dimension 2 Code", SourceFilter) THEN
                            Description := DimValue.Name;
                END;
            GETFILTER("Document Type") <> '':
                BEGIN
                    SourceTableName := GETFILTER("Document Type");
                    SourceFilter := GETFILTER("Document No.");
                    Description := GETFILTER("Document Line No.");
                END;
            FilterGroupNo = DATABASE::"Item Analysis View Entry":
                BEGIN
                    IF Item."No." <> "Item No." THEN
                        IF NOT Item.GET("Item No.") THEN
                            CLEAR(Item);
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DATABASE::"Item Analysis View Entry");
                    SourceFilter := Item."No.";
                    Description := Item.Description;
                END;
        END;

        EXIT(STRSUBSTNO('%1 %2 %3', SourceTableName, SourceFilter, Description));
    end;
}

