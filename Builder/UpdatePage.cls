VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "UpdatePage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim Step As Long
    Dim PIndex As Long
    Private Type CopyList
        path As String
        mark As Integer '    0=���� 1=�仯 2=�û��޸�
        Rep As Boolean
    End Type
    Dim FileList() As CopyList
    Dim BackupSwitch As Boolean
'======================================
Public Sub CheckFiles()
    Dim f As String, fl() As String
    ReDim FileList(0), fl(0)
    
    f = Dir(App.path & "\core\")
    Do While f <> ""
        DoEvents
        ReDim Preserve fl(UBound(fl) + 1)
        fl(UBound(fl)) = f
        f = Dir()
    Loop
    
    For i = 1 To UBound(fl)
        If Dir(Cmd & "\core\" & fl(i)) = "" Then
            ReDim Preserve FileList(UBound(FileList) + 1)
            With FileList(UBound(FileList))
                .path = fl(i)
                .mark = 0
                .Rep = True
            End With
        End If
    Next
    
    Dim om As Boolean, t As String
    
    For i = 1 To UBound(fl)
        om = False
        If Dir(Cmd & "\core\" & fl(i)) <> "" Then
            If Dir(Cmd & "\.emr\cache\" & fl(i)) <> "" Then
                Open Cmd & "\.emr\cache\" & fl(i) For Input As #1
                Line Input #1, t
                Close #1
                If Val(t) <> FileLen(Cmd & "\core\" & fl(i)) Then om = True
            End If
            If (om = False) And (FileLen(Cmd & "\core\" & fl(i)) <> FileLen(App.path & "\core\" & fl(i))) Then
                ReDim Preserve FileList(UBound(FileList) + 1)
                With FileList(UBound(FileList))
                    .path = fl(i)
                    .mark = 1
                    .Rep = True
                End With
            End If
        End If
    Next
    
    For i = 1 To UBound(fl)
        om = True
        If Dir(Cmd & "\core\" & fl(i)) <> "" Then
            If Dir(Cmd & "\.emr\cache\" & fl(i)) <> "" Then
                Open Cmd & "\.emr\cache\" & fl(i) For Input As #1
                Line Input #1, t
                Close #1
                If Val(t) <> FileLen(Cmd & "\core\" & fl(i)) Then om = False
            End If
            If (om = False) Then
                ReDim Preserve FileList(UBound(FileList) + 1)
                With FileList(UBound(FileList))
                    .path = fl(i)
                    .mark = 2
                    .Rep = False
                End With
            End If
        End If
    Next
End Sub
Public Sub Update2()
    Page.Clear argb(255 * 0.85, 242, 242, 249) '��ջ���
    
    Page.Writes "�滻�����ļ�", 50, 100, 24, argb(255, 27, 27, 27)
    Page.Writes "��ѡ������Ҫ�滻�Ĵ���", 50, 140, 18, argb(150, 27, 27, 27)
    
    Dim Color As Long
    
    For i = PIndex + 1 To PIndex + 5
        If i > UBound(FileList) Then Exit For
        
        Page.Paint 1, 50, 170 + (i - PIndex) * 40, 24, 24, IIf(FileList(i).Rep, argb(255, 95, 229, 221), argb(255, 222, 222, 222))
        If CheckMouse2 = mMouseUp Then FileList(i).Rep = Not FileList(i).Rep
        
        Select Case FileList(i).mark
            Case 0
                Color = argb(180, 27, 27, 27)
                Page.Paint 0, GW - 150, 170 + (i - PIndex) * 40, 90, 24, argb(255, 95, 229, 221)
                Page.Writes "����", GW - 150, 170 + (i - PIndex) * 40, 16, argb(255, 255, 255, 255), 90, 24, StringAlignmentCenter
            Case 1
                Color = argb(255, 240, 127, 34)
                Page.Paint 0, GW - 150, 170 + (i - PIndex) * 40, 90, 24, Color
                Page.Writes "�и���", GW - 150, 170 + (i - PIndex) * 40, 16, argb(255, 255, 255, 255), 90, 24, StringAlignmentCenter
            Case 2
                Color = argb(255, 232, 76, 61)
                Page.Paint 0, GW - 150, 170 + (i - PIndex) * 40, 90, 24, Color
                Page.Writes "���޸Ĺ�", GW - 150, 170 + (i - PIndex) * 40, 16, argb(255, 255, 255, 255), 90, 24, StringAlignmentCenter
        End Select
        Page.Writes FileList(i).path, 80, 170 + (i - PIndex) * 40, 18, Color, style:=IIf(FileList(i).mark = 2, FontStyleBold, 0)
        
        If i <> PIndex + 5 Then Page.PaintLine 50, 170 + (i - PIndex) * 40 + 32, GW - 50, 170 + (i - PIndex) * 40 + 32, argb(255, 222, 222, 222), 1
    Next
    
    Page.Writes (Int(PIndex / 5) + 1) & " / " & (Int(UBound(FileList) / 5) + 1), GW / 2, GH - 140, 16, argb(150, 27, 27, 27), align:=StringAlignmentCenter
    If Page.ShowColorButton(2, GW / 2 - 80 - 20, GH - 140, 40, 22, "<", argb(150, 27, 27, 27), argb(255, 222, 222, 222), argb(130, 95, 229, 221), size:=16, Radius:=60) = 3 Then
        If PIndex > 0 Then PIndex = PIndex - 5: ECore.NewTransform
    End If
    If Page.ShowColorButton(2, GW / 2 + 80 - 20, GH - 140, 40, 22, ">", argb(150, 27, 27, 27), argb(255, 222, 222, 222), argb(130, 95, 229, 221), size:=16, Radius:=60) = 3 Then
        If (Int(PIndex / 5) + 1) < (Int(UBound(FileList) / 5) + 1) Then PIndex = PIndex + 5: ECore.NewTransform
    End If
    
    If Page.ShowColorButton(0, GW - 120 - 50, GH - 80, 120, 40, "�滻", argb(150, 27, 27, 27), argb(255, 222, 222, 222), argb(130, 95, 229, 221), size:=18) = 3 Then
        If Dialog("����", "�����滻��ѡ�ļ���", "��", "�ȵȣ�") <> 1 Then Exit Sub
        If Val(AppInfo(0)) < 19051004 Then
            Dialog "����", "��Դ���غ����Ѿ�Ǩ�ơ�" & vbCrLf & "Page->Page.Res" & vbCrLf & vbCrLf & "* �������Emerald�ṩ�Ĵ���ģ��", "Ŷ"
        End If
        If Val(AppInfo(0)) < 19051110 Then
            Dialog "����", "����������������" & vbCrLf & "�����DebugSwitchģ�����ע���޸Ĵ��룡" & vbCrLf & vbCrLf & "* �������Emerald�ṩ�Ĵ���ģ��", "Ŷ"
            Dialog "����", "������ջ����޸�" & vbCrLf & "������Ļ�ͼ���̼���Page.Clear��" & vbCrLf & vbCrLf & "* �������Emerald�ṩ�Ĵ���ģ��", "Ŷ"
        End If
        ECore.NewTransform transFadeIn, 700, "WaitPage"
        
        Dim Backstr As String
        If BackupSwitch Then
            Backstr = year(Now) & "��" & Month(Now) & "��" & Day(Now) & "��" & Hour(Now) & "ʱ" & Minute(Now) & "��" & Second(Now) & "��"
            If Dir(Cmd & "\.emr\backup\" & Backstr, vbDirectory) = "" Then MkDir Cmd & "\.emr\backup\" & Backstr
            CopyInto Cmd & "\core", Cmd & "\.emr\backup\" & Backstr
            If Dir(Cmd & "\.emr\backup\" & Backstr & "\cache", vbDirectory) = "" Then MkDir Cmd & "\.emr\backup\" & Backstr & "\cache"
            CopyInto Cmd & "\.emr\cache", Cmd & "\.emr\backup\" & Backstr & "\cache"
        End If
        
        Dim NoUpdate As Boolean
        For i = 1 To UBound(FileList)
            If FileList(i).Rep Then
                FileCopy App.path & "\core\" & FileList(i).path, Cmd & "\core\" & FileList(i).path
                Open Cmd & "\.emr\cache\" & FileList(i).path For Output As #1
                Print #1, FileLen(Cmd & "\core\" & FileList(i).path)
                Close #1
            Else
                NoUpdate = True
            End If
            Call FakeSleep(30)
        Next
        CopyInto App.path & "\assets\debug", Cmd & "\assets\debug"
        CopyInto App.path & "\framework", Cmd
        
        Open Cmd & "\.emerald" For Output As #1
        Print #1, Version 'version
        Print #1, Now 'Update Time
        Print #1, NoUpdate
        Close #1
        
        Dialog "���", "��Ĺ����Ѿ������ˣ�", "��"
        Unload MainWindow: End
    End If
    
    Page.Writes "������ѡ��...", 50, GH - 30 - 40, 16, argb(150, 27, 27, 27), 200, 20, style:=FontStyleUnderline
    If CheckMouse2 = mMouseUp Then
        Call CheckFiles
    End If
End Sub
Public Sub Update()
    '�����¼�
    If Step = 1 Then Call Update2: Exit Sub
    
    Page.Clear argb(255 * 0.85, 242, 242, 249) '��ջ���
    
    Page.Writes "��ӭʹ�ù��̸�����", 50, 100, 24, argb(255, 27, 27, 27)
    Page.Writes "���򵼽��������˳������Emerald�йش��롣", 50, 140, 18, argb(150, 27, 27, 27)
    
    Dim lead As String, leadstr As String
    lead = format(Version - Val(AppInfo(0)), "00000000")
    If Left(lead, 2) <> "00" Then leadstr = leadstr & Val(Left(lead, 2)) & "��"
    If Right(Left(lead, 4), 2) <> "00" Then leadstr = leadstr & Val(Right(Left(lead, 4), 2)) & "����"
    If Right(Left(lead, 6), 2) <> "00" Then leadstr = leadstr & Val(Right(Left(lead, 6), 2)) & "��"
    If leadstr = "" Then
        If Right(Left(lead, 8), 2) <> "00" Then leadstr = leadstr & Val(Right(Left(lead, 8), 2)) & "�����"
    Else
        leadstr = leadstr & "�����������"
    End If
    
    Page.Writes "���°汾��  " & Version & "������" & leadstr & "��", 50, 220, 18, argb(220, 27, 27, 27)
    Page.Writes "���̰汾��  " & Val(AppInfo(0)), 50, 250, 18, argb(130, 27, 27, 27)
    
    If Page.ShowColorButton(0, GW - 150 - 50, GH - 100, 150, 50, "��������", argb(150, 27, 27, 27), argb(255, 222, 222, 222), argb(130, 95, 229, 221), size:=18) = 3 Then
        Call CheckFiles
        ECore.NewTransform , 700
        PIndex = 0
        Step = 1
    End If
    
    Page.Paint 1, 50, GH - 30 - 40 - 40, 24, 24, IIf(BackupSwitch, argb(255, 95, 229, 221), argb(255, 222, 222, 222))
    If CheckMouse2 = mMouseUp Then BackupSwitch = Not BackupSwitch
    Page.Writes "��������", 50 + 35, GH - 30 - 40 - 40 + 1, 16, argb(150, 27, 27, 27)
    
    Page.Writes "��ϣ���˽��������", 50, GH - 30 - 40, 16, argb(150, 27, 27, 27), 200, 20, style:=FontStyleUnderline
    If CheckMouse2 = mMouseUp Then ShellExecuteA 0, "open", "https://github.com/Red-Error404/Emerald/commits/master", "", "", SW_SHOW
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub Enter()
    'ҳ������¼�
    Step = 0: BackupSwitch = True
End Sub
Public Sub Leave()
    'ҳ���뿪�¼�
End Sub
Public Sub Gotfocus()
    '����ȡ�ý����¼�
End Sub
Public Sub Lostfocus()
    '����ʧȥ�����¼�
End Sub
Public Sub AnimationDone(id As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    '����ҳ�������
    Set Page = New GPage
    Page.Create Me
    '������Ϸ��Դ
    Page.Res.NewImages App.path & "\assets\debug"
    '����ҳ��
    ECore.Add Page, "UpdatePage"
    
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub