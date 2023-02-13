page 50070 "Session List with addi info"
{
    // version NAVW19.00.00.45778

    CaptionML = ENU = 'Session List',
                ENN = 'Session List';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Session,SQL Trace,Events',
                                 ENN = 'New,Process,Report,Session,SQL Trace,Events';
    RefreshOnActivate = true;
    SourceTable = "Active Session";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SessionIdText; SessionIdText)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Session ID',
                                ENN = 'Session ID';
                    Editable = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'User ID',
                                ENN = 'User ID';
                    Editable = false;
                }
                field(IsSQLTracing; IsSQLTracing)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'SQL Tracing',
                                ENN = 'SQL Tracing';

                    trigger OnValidate();
                    begin
                        DEBUGGER.ENABLESQLTRACE("Session ID", IsSQLTracing);
                    end;
                }
                field("Client Type"; ClientTypeText)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Client Type',
                                ENN = 'Client Type';
                    Editable = false;
                }
                field("Login Datetime"; "Login Datetime")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Login Date',
                                ENN = 'Login Date';
                    Editable = false;
                }
                field("Server Computer Name"; "Server Computer Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Server Computer Name',
                                ENN = 'Server Computer Name';
                    Editable = false;
                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Server Instance Name',
                                ENN = 'Server Instance Name';
                    Editable = false;
                }
                field(IsDebugging; IsDebugging)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Debugging',
                                ENN = 'Debugging';
                    Editable = false;
                }
                field(IsDebugged; IsDebugged)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Debugged',
                                ENN = 'Debugged';
                    Editable = false;
                }
                field(UserBranch; UserBranch)
                {
                    ApplicationArea = All;
                }
                field(UserLicType; UserLicType)
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
            separator(Action001)
            {
            }
            group(Session)
            {
                CaptionML = ENU = 'Session',
                            ENN = 'Session';
                action("Debug Selected Session")
                {
                    CaptionML = ENU = 'Debug',
                                ENN = 'Debug';
                    Enabled = CanDebugSelectedSession;
                    Image = Debug;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+S';
                    ToolTipML = ENU = 'Debug the selected session',
                                ENN = 'Debug the selected session';

                    // trigger OnAction();
                    // begin
                    //     DebuggerManagement.SetDebuggedSession(Rec);
                    //     DebuggerManagement.OpenDebuggerTaskPage;
                    // end;
                }
                action("Debug Next Session")
                {
                    CaptionML = ENU = 'Debug Next',
                                ENN = 'Debug Next';
                    Enabled = CanDebugNextSession;
                    Image = DebugNext;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+N';
                    ToolTipML = ENU = 'Debug the next session that breaks code execution.',
                                ENN = 'Debug the next session that breaks code execution.';

                    // trigger OnAction();
                    // var
                    //     DebuggedSessionTemp: Record 2000000110;
                    // begin
                    //     DebuggedSessionTemp."Session ID" := 0;
                    //     DebuggerManagement.SetDebuggedSession(DebuggedSessionTemp);
                    //     DebuggerManagement.OpenDebuggerTaskPage;
                    // end;
                }
            }
            group("SQL Trace")
            {
                CaptionML = ENU = 'SQL Trace',
                            ENN = 'SQL Trace';
                action("Start Full SQL Tracing")
                {
                    CaptionML = ENU = 'Start Full SQL Tracing',
                                ENN = 'Start Full SQL Tracing';
                    Enabled = NOT FullSQLTracingStarted;
                    Image = Continue;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    begin
                        DEBUGGER.ENABLESQLTRACE(0, TRUE);
                        FullSQLTracingStarted := TRUE;
                    end;
                }
                action("Stop Full SQL Tracing")
                {
                    CaptionML = ENU = 'Stop Full SQL Tracing',
                                ENN = 'Stop Full SQL Tracing';
                    Enabled = FullSQLTracingStarted;
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    begin
                        DEBUGGER.ENABLESQLTRACE(0, FALSE);
                        FullSQLTracingStarted := FALSE;
                    end;
                }
            }
            group("Event")
            {
                CaptionML = ENU = 'Event',
                            ENN = 'Event';
                action(Subscriptions)
                {
                    CaptionML = ENU = 'Subscriptions',
                                ENN = 'Subscriptions';
                    Image = "Event";
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page 9510;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IsDebugging := DEBUGGER.ISACTIVE AND ("Session ID" = DEBUGGER.DEBUGGINGSESSIONID);
        IsDebugged := DEBUGGER.ISATTACHED AND ("Session ID" = DEBUGGER.DEBUGGEDSESSIONID);
        IsSQLTracing := DEBUGGER.ENABLESQLTRACE("Session ID");

        // If this is the empty row, clear the Session ID and Client Type
        IF "Session ID" = 0 THEN BEGIN
            SessionIdText := '';
            ClientTypeText := '';
        END ELSE BEGIN
            SessionIdText := FORMAT("Session ID");
            ClientTypeText := FORMAT("Client Type");
        END;

        //10-04-2019 rdk
        IF UserSetupRec.GET(Rec."User ID") THEN
            UserBranch := UserSetupRec.Branch
        ELSE
            UserBranch := '';

        UserRec.RESET;
        UserRec.SETCURRENTKEY("User Name");
        UserRec.SETRANGE("User Name", Rec."User ID");
        IF UserRec.FINDFIRST THEN
            UserLicType := UserRec."License Type";
    end;

    trigger OnFindRecord(Which: Text): Boolean;
    begin
        CanDebugNextSession := NOT DEBUGGER.ISACTIVE;
        CanDebugSelectedSession := NOT DEBUGGER.ISATTACHED AND NOT ISEMPTY;

        // If the session list is empty, insert an empty row to carry the button state to the client
        IF NOT FIND(Which) THEN BEGIN
            INIT;
            "Session ID" := 0;
        END;

        EXIT(TRUE);
    end;

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        SETFILTER("Server Instance ID", '=%1', SERVICEINSTANCEID);
        SETFILTER("Session ID", '<>%1', SESSIONID);
        FILTERGROUP(0);

        FullSQLTracingStarted := DEBUGGER.ENABLESQLTRACE(0);
    end;

    var
        // DebuggerManagement: Codeunit 9500;
        [InDataSet]
        CanDebugNextSession: Boolean;
        [InDataSet]
        CanDebugSelectedSession: Boolean;
        [InDataSet]
        FullSQLTracingStarted: Boolean;
        IsDebugging: Boolean;
        IsDebugged: Boolean;
        IsSQLTracing: Boolean;
        SessionIdText: Text;
        ClientTypeText: Text;
        UserBranch: Code[20];
        UserLicType: Option "Full User","Limited User","Device Only User","Windows Group","External User";
        UserSetupRec: Record "User Setup";
        UserRec: Record 2000000120;
}

