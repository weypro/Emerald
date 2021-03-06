VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ToNewPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   页面绘制器
    Dim Page As GPage
    Public PageIndex As Integer
    Dim Maker As String
    Dim AcceptMIT As Boolean, CopyModel As Boolean, CreateContentMenu As Boolean
    Public ProjectName As String, InitWindow As Boolean, InitPage As Boolean, OpenPro As Boolean
'======================================
Public Sub DrawPage0()
    Page.Writes "欢迎使用 Emerald", GW / 2, 220, 18, argb(255, 64, 64, 64), align:=StringAlignmentCenter, animation:=1
    Page.Writes "创造不一样的vb应用", GW / 2, 250, 18, argb(255, 96, 96, 96), align:=StringAlignmentCenter, animation:=2
    
    If Page.ShowColorButton(2, GW / 2 - 200, GH - 110, 400, 40, "开始吧", argb(255, 255, 255, 255), argb(255, 105, 227, 218), argb(255, 59, 205, 195), 40, size:=18, style:=FontStyleBold) = 3 Then
        If IsRegCreated("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\Emerald\DisplayIcon") Then
            PageIndex = 1
        Else
            PageIndex = 2
        End If
        ECore.NewTransform transToRight, 1000
    End If
End Sub
Public Sub DrawPage1()
    Page.DrawImageEx "old.png", GW / 2, GH / 2 - 80, 128, 128, posOnCenter
    Page.Writes "开始之前", GW / 2, GH / 2 + 30, 24, argb(255, 64, 64, 64), align:=StringAlignmentCenter, animation:=1
    Page.Writes "你必须卸载旧版本的Emerald", GW / 2, GH / 2 + 70, 18, argb(255, 96, 96, 96), align:=StringAlignmentCenter, animation:=2
    If Page.ShowColorButton(0, GW / 2 - 70, GH - 150, 140, 40, "卸载", argb(255, 255, 255, 255), argb(255, 35, 170, 242), argb(255, 75, 210, 255), 40, size:=18) = 3 Then
        Dim Error As String
        Error = UninstallOld
        If Error <> "" Then
            MsgBox "卸载失败。" & vbCrLf & Error, 16
        Else
            PageIndex = 2
            ECore.NewTransform transToRight, 1000
        End If
    End If
End Sub
Public Sub DrawPage2()
    Page.Writes "留下你的足迹", GW / 2, 190, 18, argb(255, 64, 64, 64), align:=StringAlignmentCenter, animation:=1
    Page.Writes "告诉我你的名字，它将会显示在你的应用中。", GW / 2, 230, 18, argb(255, 96, 96, 96), align:=StringAlignmentCenter, animation:=2
    Page.ShowEdit Maker, 0, GW / 2 - 180, 270, 360, 40, argb(200, 32, 32, 36), argb(255, 242, 242, 242), argb(255, 232, 232, 232), argb(255, 62, 206, 196), size:=18
    If Page.ShowColorButton(2, GW / 2 - 200, GH - 110, 400, 40, "下一步", argb(255, 255, 255, 255), argb(255, 105, 227, 218), argb(255, 59, 205, 195), 40, size:=18, style:=FontStyleBold) = 3 Then
        If Maker = "" Then MsgBox "请告诉我你的名字。", 64: Exit Sub
        ESave.PutData "Maker", Maker
        PageIndex = 3
        ECore.NewTransform transToRight, 1000
    End If
End Sub
Public Sub DrawPage3()
    Page.Writes "最后一步 ...", GW / 2, 170, 18, argb(255, 64, 64, 64), align:=StringAlignmentCenter, animation:=1, style:=FontStyleBold
    Page.ShowColorCheckBox AcceptMIT, GW / 2 - 150, 230, 300, 20, "开启Emerald调试栏", argb(255, 198, 198, 198), argb(255, 59, 205, 195), argb(255, 96, 96, 96), 18
    Page.ShowColorCheckBox CopyModel, GW / 2 - 150, 270, 300, 20, "请将示例文件复制到我的VB目录中", argb(255, 198, 198, 198), argb(255, 59, 205, 195), argb(255, 96, 96, 96), 18
    Page.ShowColorCheckBox CreateContentMenu, GW / 2 - 150, 310, 300, 20, "在右键菜单中添加Emerald", argb(255, 198, 198, 198), argb(255, 59, 205, 195), argb(255, 96, 96, 96), 18
    
    Dim m As Long
    m = CheckMouse(125, GH - 175, 200, 30)
    Page.Writes "如何使用调试模式？", 125, GH - 175, 18, IIf(m = 0, argb(255, 96, 96, 96), argb(255, 59, 205, 195)), 200, 30, StringAlignmentNear, FontStyleUnderline
    If m = 3 Then
        ShellExecuteA 0, "open", App.path & "\wiki\05.调试模式.html", "", "", SW_SHOW
    End If
    
    
    If Page.ShowColorButton(2, GW / 2 - 200, GH - 110, 400, 40, "完成", argb(255, 255, 255, 255), argb(255, 105, 227, 218), argb(255, 59, 205, 195), 40, size:=18, style:=FontStyleBold) = 3 Then
        If CopyModel Then
            If Dir(VBIDEPath & "Template", vbDirectory) = "" Then MkDir VBIDEPath & "Template"
            FileCopy App.path & "\Example\Emerald Window.frm", VBIDEPath & "Template\Forms\Emerald Window.frm"
            FileCopy App.path & "\Example\Emerald Page.cls", VBIDEPath & "Template\Classes\Emerald Page.cls"
        End If
        If CreateContentMenu Then OperContentMenu False
        ESave.PutData "Emerald 3.1", "√"
        ESave.PutData "DebugMode", IIf(AcceptMIT, 1, 0)
        GdipResetClip WelcomePage.Page.GG
        SelectClipRgn GCore.GDC, 0
        SelectClipRgn ECore.CDC, 0
        WelcomePage.Cliped = 0
        ECore.ActivePage = "WelcomePage"
    End If
End Sub
Public Sub DrawPage4()
    Page.DrawImageEx "emerald.png", GW / 2, GH / 2 - 80, 128, 128, posOnCenter
    Page.Writes "欢迎使用 Emerald 3.0", GW / 2, GH / 2 + 30, 24, argb(255, 64, 64, 64), align:=StringAlignmentCenter, animation:=1
    Page.Writes "你的工程信息需要更新", GW / 2, GH / 2 + 70, 18, argb(255, 96, 96, 96), align:=StringAlignmentCenter, animation:=2
    
    If Page.ShowColorButton(0, GW / 2 - 70, GH - 150, 140, 40, "更新", argb(255, 255, 255, 255), argb(255, 35, 170, 242), argb(255, 75, 210, 255), 40, size:=18) = 3 Then
        Dim temp As String
        'On Error Resume Next
        Open OPath & "\.emerald" For Input As #1
        Line Input #1, temp: EmrPC.Version = Val(temp)
        Line Input #1, temp
        Line Input #1, temp: EmrPC.FUpdate = CBool(temp)
        Close #1
        If Dir(OPath & "\.emerald") <> "" Then Kill OPath & "\.emerald"
        temp = Split(Dir(OPath & "\*.vbp"), ".vbp")(0)
        EmrPC.Name = temp
        EmrPC.AFileHeader = "Emerald Project Config File"
        EmrPC.Maker = ESave.GetData("Maker")
        Open OPath & "\.emerald" For Binary As #1
        Put #1, , EmrPC
        Close #1
        ECore.NewTransform transToRight, 1000, "WelcomePage"
    End If
End Sub
Public Sub DrawPage5()
    Page.Writes "Emerald·创造", RGW / 2, 120, 18, argb(255, 0, 0, 0), align:=StringAlignmentCenter, style:=FontStyleBold
    Page.Writes "使用此向导快速创建您的工程", RGW / 2, 160, 18, argb(200, 16, 16, 30), align:=StringAlignmentCenter
    
    Page.Writes "工程名称", 85, 200, 18, argb(255, 0, 0, 0)
    Page.ShowEdit ProjectName, 0, 200, 200, 250, 30, argb(200, 32, 32, 36), argb(0, 255, 255, 255), argb(255, 242, 242, 242), argb(255, 62, 206, 196), size:=18

    Page.Writes "选项", 85, 240, 18, argb(255, 0, 0, 0)
    Page.ShowColorCheckBox InitWindow, 85 + 3, 280, 500, 20, "创建好一个应用窗口", argb(255, 200, 200, 200), argb(255, 60, 205, 195), argb(200, 32, 32, 36), 18
    Page.ShowColorCheckBox InitPage, 85 + 3, 320, 500, 20, "创建好一个应用页面", argb(255, 200, 200, 200), argb(255, 60, 205, 195), argb(200, 32, 32, 36), 18
    Page.ShowColorCheckBox OpenPro, 85 + 3, 360, 500, 20, "在我创建完之后打开工程", argb(255, 200, 200, 200), argb(255, 60, 205, 195), argb(200, 32, 32, 36), 18

    If Page.ShowColorButton(2, GW / 2 - 200, GH - 110, 400, 40, "开始创造", argb(255, 255, 255, 255), argb(255, 105, 227, 218), argb(255, 59, 205, 195), 40, size:=18, style:=FontStyleBold) = 3 Then
        If CheckFileName(ProjectName) = False Or ProjectName = "" Then MsgBox "这个应用名称不能被接受呢。换一个吧。", 64: Exit Sub
        
        If Dir(OPath & "\core", vbDirectory) = "" Then MkDir OPath & "\core"
        If Dir(OPath & "\code", vbDirectory) = "" Then MkDir OPath & "\code"
        If Dir(OPath & "\.emr", vbDirectory) = "" Then MkDir OPath & "\.emr"
        If Dir(OPath & "\assets", vbDirectory) = "" Then MkDir OPath & "\assets"
        If Dir(OPath & "\assets\debug", vbDirectory) = "" Then MkDir OPath & "\assets\debug"
        If Dir(OPath & "\animation", vbDirectory) = "" Then MkDir OPath & "\animation"
        If Dir(OPath & "\music", vbDirectory) = "" Then MkDir OPath & "\music"
        
        Dim t As String, f As String
        Open App.path & "\Example\example.vbp" For Input As #1
        Do While Not EOF(1)
        Line Input #1, t
        f = f & t & vbCrLf
        Loop
        Close #1
        
        EmrPC.Maker = ESave.GetData("Maker")
        EmrPC.AFileHeader = "Emerald Project Config File"
        EmrPC.Name = ProjectName
        EmrPC.Version = Version
        
        f = Replace(f, "{app}", ProjectName)
        f = Replace(f, "{maker}", EmrPC.Maker)
        f = Replace(f, "{include}", IIf(InitWindow, "Form=Code\AppWindow.frm" & vbCrLf, "") & IIf(InitPage, "Class=AppPage; Code\AppPage.cls" & vbCrLf, ""))
        
        If InitWindow Then FileCopy App.path & "\Example\Emerald Window.frm", OPath & "\code\AppWindow.frm"
        If InitPage Then FileCopy App.path & "\Example\Emerald Page.cls", OPath & "\code\AppPage.cls"
        
        Open OPath & "\" & ProjectName & ".vbp" For Output As #1
        Print #1, f
        Close #1
        
        '先下手忽略Emerald文件夹
        Open OPath & "\.gitignore" For Output As #1
        Print #1, ".emr/*"
        Close #1
        
        CopyInto App.path & "\core", OPath & "\core"
        CopyInto App.path & "\assets\debug", OPath & "\assets\debug"
        CopyInto App.path & "\framework", OPath
        
        Open OPath & "\.emerald" For Binary As #1
        Put #1, , EmrPC
        Close #1
        
        GdipResetClip WelcomePage.Page.GG
        SelectClipRgn GCore.GDC, 0
        SelectClipRgn ECore.CDC, 0
        WelcomePage.Cliped = 0
        ECore.ActivePage = "WelcomePage"
        
        WelcomePage.UpdateProject
        WelcomePage.WriteCache
        
        If OpenPro Then ShellExecuteA 0, "Open", VBIDEPath & "\VB6.EXE", """" & OPath & "\" & ProjectName & ".vbp""", "", SW_SHOW
    End If
End Sub
Public Sub Update()
    '游戏每一帧的过程（绘制过程请放在此处）
    
    Page.Clear 0 '清空画布
    Page.DrawImage "background.png", 0, 0, alpha:=1
    
    CallByName Me, "DrawPage" & PageIndex, VbMethod
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '鼠标滚轮事件
    'Direction:方向，Depth：深度
End Sub
Public Sub AnimationMsg(id As String, msg As String)
    '动画消息接收
End Sub
Public Sub Enter()
    '页面进入事件
    AcceptMIT = True: CopyModel = True: CreateContentMenu = True
    Page.StartAnimation 1, 500
    Page.StartAnimation 2, 750
    Maker = ESave.GetData("Maker")
    Dim temp() As String
    temp = Split(OPath, "\")
    If UBound(temp) > 0 Then
        If temp(UBound(temp)) = "" Then ReDim Preserve temp(UBound(temp) - 1)
    End If
    If UBound(temp) > 0 Then
        ProjectName = temp(UBound(temp))
    Else
        ProjectName = "MyProject"
    End If
End Sub
Public Sub Leave()
    '页面离开事件
End Sub
Public Sub Gotfocus()
    '窗口取得焦点事件
End Sub
Public Sub Lostfocus()
    '窗口失去焦点事件
End Sub
Public Sub AnimationDone(id As Integer)
    '动画播放结束事件
    'id：结束的动画ID
End Sub
Private Sub Class_Initialize()
    '创建页面绘制器
    Set Page = New GPage
    Page.Create Me
    '导入游戏资源
    If PackPos = -1 Then Page.Res.NewImages App.path & "\assets", 0.8
    '创建页面
    ECore.Add Page, "ToNewPage"
    
    Page.NewAnimation False, "FadeIn", 2, 500
    Page.NewAnimation False, "FadeIn", 2, 500
    '===============================================
    '   动画
    
    '===============================================
End Sub
