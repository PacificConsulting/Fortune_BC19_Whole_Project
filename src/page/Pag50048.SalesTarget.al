page 50048 "Sales Target"
{
    PageType = List;
    SourceTable = "Sales Target";
    SourceTableView = WHERE(Status = FILTER(<> Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Name"; "Salesperson Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Salesperson Name',
                                ENN = 'Salesperson Code';
                }
                field("From Date"; "From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; "To Date")
                {
                    ApplicationArea = All;
                }
                field("General Posting Group"; "General Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Target; Target)
                {
                    ApplicationArea = All;
                }
                field("Invoice Value"; "Invoice Value")
                {
                    ApplicationArea = All;
                }
                field("Return Value"; "Return Value")
                {
                    ApplicationArea = All;
                }
                field("Actual Invoice Value"; "Actual Invoice Value")
                {
                    ApplicationArea = All;
                }
                field("Target to Achieve"; "Target to Achieve")
                {
                    ApplicationArea = All;
                }
                field("Amount to Collect"; "Amount to Collect")
                {
                    ApplicationArea = All;
                }
                field("Amount Collected"; "Amount Collected")
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("Achievement as a % to sales"; "Achievement as a % to sales")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Target Missed %"; "Target Missed %")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send for approval")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin

                    IF CONFIRM('Do You want to send selected lines for approval?', FALSE) THEN BEGIN
                        SalesTargetRec.RESET;
                        CurrPage.SETSELECTIONFILTER(SalesTargetRec);
                        IF SalesTargetRec.FINDSET THEN
                            REPEAT
                                IF SalesTargetRec.Status = SalesTargetRec.Status::"Pending for approval" THEN
                                    ERROR('Approval request exsist');
                                SalesTargetRec.TESTFIELD(SalesTargetRec.Target);
                                SalesTargetRec.Status := SalesTargetRec.Status::"Pending for approval";
                                SalesTargetRec.MODIFY;
                            UNTIL SalesTargetRec.NEXT = 0;
                        MESSAGE('Approval request entries have been created');
                    END;
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin

                    IF CONFIRM('Do You want to approve selected lines?', FALSE) THEN BEGIN
                        SalesTargetRec.RESET;
                        CurrPage.SETSELECTIONFILTER(SalesTargetRec);
                        IF SalesTargetRec.FINDSET THEN
                            REPEAT
                                SalesTargetRec.Status := SalesTargetRec.Status::Approved;
                                SalesTargetRec.MODIFY;
                            UNTIL SalesTargetRec.NEXT = 0;
                        MESSAGE('Selected lines have been successfully approved');
                    END;
                end;
            }
        }
    }

    var
        SalesTargetRec: Record 50031;
}

