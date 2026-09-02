B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13
@EndOfDesignText@
Sub Class_Globals
	Public mParent As B4XView
	Private mBase As B4XView 'ignore
	Private xui As XUI 'ignore
	Private Background As B4XView
	Private clr As Int
	Private bgclr As Int
	Private index As Int
	Private cvs As B4XCanvas
	Private duration As Int
	Private DrawingSubName As String
	Private Radial As Float = 0
	Dim bmpBubble As B4XBitmap
	Private mLblText As String = ""
	Private mLabel As B4XView
	Private mColor As Int = Colors.blue
	Public INDICATOR_THREE_CIRCLES As String = "Three Circles"
	Public INDICATOR_TEN_CIRCLES As String = "Ten Circles"
	Public INDICATOR_TEN_LINES As String = "Ten Lines"
	Public INDICATOR_FOLLOW_CIRCLES As String = "Follow Circles"
	Public INDICATOR_FOLLOW_CIRCLES2 As String = "Follow Circles 2"
	Public INDICATOR_ARC As String = "Arc"
	Public INDICATOR_FOLLOW_ARCS As String = "Follow Arcs"
	Public INDICATOR_SQUARE As String = "Square"
	Public INDICATOR_SQUARE_ROUNDED As String = "Square Rounded"
	Public INDICATOR_FIVE_LINES As String = "Five Lines"
	Public INDICATOR_INFINITY As String = "Infinity"
	Public INDICATOR_HEARTH As String = "Hearth"
	Public INDICATOR_BUBBLE As String = "Bubble"
	Public INDICATOR_FOUR_SQUARES As String = "Four Squares"
	Public INDICATOR_THREE_CIRCLES1 As String = "Three Circles 1"
	Public INDICATOR_THREE_CIRCLES2 As String = "Three Circles 2"
	Public INDICATOR_SINGLE_CIRCLE As String = "Single Circle"
	Public INDICATOR_FIVE_LINES1 As String = "Five Lines 1"
	Public INDICATOR_ARC1 As String = "Arc 1"
	Public INDICATOR_ARC2 As String = "Arc 2"
	Public INDICATOR_PACMAN As String = "PacMan"
	Private style As String
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize (Parent As B4XView,Width As Int, Height As Int)
	mParent=Parent
	mBase=xui.CreatePanel("base")
	mBase.RequestFocus
	mBase.Color=Colors.Red
	Background = xui.CreatePanel("background")
	Background.Tag = "background"
	Background.Visible=False
	Background.Color=0x33000000
	#if B4A
	Dim p As Panel = Background
	p.Elevation = 4dip
	#End If
		'Dim baseLeft As Int = (mParent.Width - Width) / 2
	'Dim baseTop As Int = (mParent.Height - Height) / 2
	Dim containerPanel As B4XView = xui.CreatePanel("")
	containerPanel.SetColorAndBorder(0xFFE0E0E0, 1dip, 0xFFE0E0E0, 20dip)	
	Dim baseLeft As Int = (mParent.Width - Width) / 2
	Dim baseTop As Int = (mParent.Height - (Height + 70dip)) / 2
	Dim lbl As Label
	lbl.Initialize("")
	mLabel = lbl
	XUIViewsUtils.SetTextOrCSBuilderToLabel(mLabel, mLblText)
	'mLabel.Text =mLblText
	mLabel.Font = xui.CreateDefaultBoldFont(14)
	mLabel.TextColor = mColor
	mLabel.SetTextAlignment("CENTER", "CENTER")	
	mParent.AddView(Background, 0, 0, mParent.Width, mParent.Height)
	Background.AddView(containerPanel, baseLeft - 60dip, baseTop - 10dip, Width + 120dip, Height + 90dip)
	containerPanel.AddView(mBase, 60dip, 10dip, Width, Height)
	containerPanel.AddView(mLabel, 60dip, Height + 20dip, Width, 60dip)  		
	'Background.AddView(mLabel, baseLeft, baseTop + Height + 10dip, Width, 60dip)
	clr = xui.PaintOrColorToColor(mColor)
	bgclr=Colors.Transparent
	Dim duration As Int = 1000
	style=INDICATOR_TEN_CIRCLES
	refreshStyle
	mBase.Color=xui.Color_White
	mBase.RequestFocus
	mBase.SetColorAndBorder(0xFFE0E0E0, 1dip, 0xFFE0E0E0, 20dip)
	'Background.AddView(mBase,baseLeft,baseTop,Width,Height)
	mBase.SetVisibleAnimated(100, True)
	cvs.Initialize(mBase)
	bmpBubble = Gradient
	'MainLoop
End Sub


Public Sub SetColor(Color As Int)
	clr = xui.PaintOrColorToColor(Color)
	mColor = Color
End Sub
private  Sub refreshStyle
	DrawingSubName = "Draw_" & style.Replace(" ", "")
End Sub
Private Sub MainLoop
	index = index + 1
	Dim MyIndex As Int = index
	Dim n As Long = DateTime.Now
	Do While MyIndex = index
		Dim progress As Float = (DateTime.Now - n) / duration
		progress = progress - Floor(progress)
		cvs.ClearRect(cvs.TargetRect)
		CallSub2(Me, DrawingSubName, progress)
		cvs.Invalidate
		Sleep(30)
	Loop
End Sub
public Sub SetLabelText(Text As String)
	mLblText = Text
	If mLabel.IsInitialized Then
		XUIViewsUtils.SetTextOrCSBuilderToLabel(mLabel, mLblText)
		mLabel.TextColor = mColor
		'mLabel.Text = Text
	End If
End Sub

public Sub GetLabelText As String
	Return mLblText
End Sub
Private Sub Gradient As B4XBitmap
	Dim bc As BitmapCreator
	
	bc.Initialize(mBase.Width,mBase.Height)
	bc.FillRadialGradient(Array As Int (clr,bgclr),cvs.TargetRect)
	
	Return bc.Bitmap
End Sub

Public Sub show
	
	Background.Visible=True
 	MainLoop
End Sub
public Sub Hide
	Background.Visible=False
	index = index + 1
	
End Sub
Private Sub Draw_Arc1 (Progress As Float)
	Dim p As B4XPath
	Dim r As Float = cvs.TargetRect.CenterX - 5dip
	If Progress < 0.5 Then
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, Progress * 2 * 360)
	Else
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, -(1 - Progress) * 2 * 360)
	End If
	cvs.ClipPath(p)
	cvs.DrawRect(cvs.TargetRect, clr, True, 0)
	cvs.RemoveClip
End Sub

Private Sub Draw_Arc2 (Progress As Float)
	Dim p As B4XPath
	Dim r As Float = cvs.TargetRect.CenterX - 5dip
	If Progress < 0.5 Then
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, Progress * 2 * 360)
	Else
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, 360 - (Progress - 0.5) * 2 * 360)
	End If
	cvs.ClipPath(p)
	cvs.DrawRect(cvs.TargetRect, clr, True, 0)
	cvs.RemoveClip
End Sub

Private Sub Draw_PacMan(Progress As Float)
	Dim DotR As Int = 5dip
	cvs.DrawCircle(cvs.TargetRect.Width - DotR - Progress * (cvs.TargetRect.CenterX - 10dip), cvs.TargetRect.CenterY, DotR, SetAlpha(clr, 255 - 200 * Progress), True, 0)
	Dim p As B4XPath
	Dim angle As Int = 70 * SinD(Progress * 180)
	Dim cx As Int = cvs.TargetRect.CenterX - 5dip
	Dim cy As Int = cvs.TargetRect.CenterY
	Dim r As Int = cvs.TargetRect.CenterY - 5dip
	If angle = 0 Then
		cvs.DrawCircle(cx, cy, r, clr, True, 0)
	Else
		p.InitializeArc(cx, cy , r, -angle / 2, -(360-angle))
		cvs.ClipPath(p)
		cvs.DrawRect(cvs.TargetRect, clr, True, 0)
		cvs.RemoveClip
	End If

End Sub
Private Sub Draw_FiveLines1(Progress As Float)
	Dim MinR As Int = 10dip
	Dim MaxR As Int = cvs.TargetRect.Height / 2
	Dim dx As Int = (cvs.TargetRect.Width - 2dip) / 5
	For i = 0 To 4
		Dim r As Float = MinR + MaxR / 2 + MaxR / 2 * SinD(Progress * 360 - 30 * i)
		cvs.DrawLine(2dip + i * dx, cvs.TargetRect.CenterY - r, 2dip + i * dx, cvs.TargetRect.CenterY + r, clr, 4dip)
	Next
End Sub
Private Sub Draw_ThreeCircles2 (Progress As Float)
	Dim MinR As Int = 5dip
	Dim MaxR As Int = cvs.TargetRect.Width / 2 / 3 - MinR -2dip
	For i = 0 To 2
		Dim r As Float = MinR + MaxR / 2 + MaxR / 2 * SinD(Progress * 360 - 60 * i)
		cvs.DrawCircle(MaxR + MinR + (MinR + MaxR + 2dip) * 2 * i, cvs.TargetRect.CenterY, r, clr, True, 0)
	Next
End Sub

Private Sub Draw_SingleCircle(Progress As Float)
	For i = 0 To 2
		cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, cvs.TargetRect.CenterX * Progress, SetAlpha(clr, 255 - 255 * Progress), True, 0)
	Next
End Sub
Private Sub Draw_ThreeCircles1 (Progress As Float)
	Dim MaxR As Float = (cvs.TargetRect.Width / 2 - 20dip) / 2
	Dim r As Float = 10dip + MaxR + MaxR * Sin(Progress * 2 * cPI)
	For i = 0 To 2
		Dim alpha As Int = i * 120 + Progress * 360
		cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(alpha), cvs.TargetRect.CenterY + r * CosD(alpha), 7dip, clr, True, 1dip)
	Next
End Sub

Private Sub Draw_FourSquares (Progress As Float)
	Dim Rec As B4XRect
	Dim top As Int = cvs.TargetRect.Centery*0.125
	Dim left As Int = cvs.TargetRect.CenterX*0.125
	Dim bottom As Int = cvs.TargetRect.CenterY*0.925
	Dim right As Int = cvs.TargetRect.Centerx*0.925
	
	Dim top2 As Int = cvs.TargetRect.Centery*1.1
	Dim left2 As Int = cvs.TargetRect.CenterX*1.1
	Dim bottom2 As Int = cvs.TargetRect.CenterY*1.9
	Dim right2 As Int = cvs.TargetRect.Centerx*1.9
	
	Dim  Width As Int = cvs.TargetView.Width
	Dim  Height As Int = cvs.TargetView.Height
	Dim Prg As Float
		
	Rec.Initialize(0,0,Width,Height)
	Dim Path As B4XPath
	Path.InitializeRoundedRect(Rec,5dip)
	cvs.DrawPath(Path,bgclr,True,1dip)
	
	Rec.Initialize(left,top,right, bottom)
	Path.InitializeRoundedRect(Rec,3dip)
	cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
	Rec.Initialize(left2,top,right2,bottom)
	Path.InitializeRoundedRect(Rec,3dip)
	cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
	Rec.Initialize(left,top2,right,bottom2)
	Path.InitializeRoundedRect(Rec,3dip)
	cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
	Rec.Initialize(left2,top2,right2,bottom2)
	Path.InitializeRoundedRect(Rec,3dip)
	cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
	
	If Progress<=0.125 Then
		Rec.Initialize(left,top,right, bottom)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=Progress*8
		Rec.Initialize(left,top,right+(right2-right)*Prg,bottom)
	Else If Progress<=0.25 Then
		Rec.Initialize(left,top,right, bottom)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.125)*8
		Rec.Initialize(left2*Prg,top,right2,bottom)
	Else If Progress<=0.375 Then
		Rec.Initialize(left2,top,right2,bottom)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.250)*8
		Rec.Initialize(left2,top,right2,bottom+(bottom2-bottom)*Prg)
	Else If Progress<=0.5 Then
		Rec.Initialize(left2,top,right2,bottom)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.375)*8
		Rec.Initialize(left2,top2*Prg,right2,bottom2)
	Else If Progress<=0.625 Then
		Rec.Initialize(left2,top2,right2,bottom2)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.500)*8
		Rec.Initialize(left2+(left-left2)*Prg,top2,right2,bottom2)
	Else If Progress<=0.75 Then
		Rec.Initialize(left2,top2,right2,bottom2)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.625)*8
		Rec.Initialize(left,top2,right2+(right-right2)*Prg,bottom2)
	Else If Progress<=0.875 Then
		Rec.Initialize(left,top2,right,bottom2)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.750)*8
		Rec.Initialize(left,top2+(top-top2)*Prg,right,bottom2)
	Else
		Rec.Initialize(left,top2,right,bottom2)
		Path.InitializeRoundedRect(Rec,3dip)
		cvs.DrawPath(Path ,SetAlpha(clr,200),True,1dip)
		
		Prg=(Progress-0.875)*8
		Rec.Initialize(left,top,right,bottom2+(bottom-bottom2)*Prg)
	End If
	
	Dim RoundRec As B4XPath
	RoundRec.InitializeRoundedRect(Rec,5dip)
	cvs.DrawPath(RoundRec,SetAlpha(clr,100),True,1dip)
End Sub
Private Sub Draw_ThreeCircles (Progress As Float)
	Dim MaxR As Float = (cvs.TargetRect.Width / 2 - 20dip) / 2
	Dim r As Float = 15dip + MaxR + MaxR * Sin(Progress * 1 * cPI)
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	For i = 0 To 2
		Dim alpha As Int = i * 120 + Progress * 360
		cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(alpha), cvs.TargetRect.CenterY + r * CosD(alpha), 7dip, clr, True, 1dip)
	Next
	cvs.DrawCircle(cvs.TargetRect.CenterX,cvs.TargetRect.Centery,7dip,clr,True,1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX,cvs.TargetRect.Centery,r,clr,False,1dip)
End Sub

Private Sub Draw_TenCircles (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2-8dip
	Dim B As Boolean = False
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	For i=0 To 9
		'Dim alpha As Int = i * 120 + Progress * 360
		Dim Alpha As Float = i*36
		'cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), 7dip, xui.Color_LightGray, True, 1dip)
		If Alpha>Progress*360 And B=False Then
			cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD((i-1)*36), cvs.TargetRect.CenterY + r * CosD((i-1)*36), 7dip,Bit.And(clr,0xAAffffff), True, 1dip)
			cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), 8dip,clr, True, 1dip)
			B=True
		Else
			cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), 7dip, Bit.And(clr,0x55ffffff), True, 1dip)
		End If
	Next
End Sub

Private Sub Draw_TenLines (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2
	Dim B As Boolean = False
	Dim Spess As Int = 6dip
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	For i=0 To 9
		'Dim alpha As Int = i * 120 + Progress * 360
		Dim Alpha As Float = i*36
		
		If Alpha>Progress*360 And B=False Then
			cvs.DrawLine(cvs.TargetRect.CenterX + r * SinD((i-1)*36), cvs.TargetRect.CenterY + r * CosD((i-1)*36),cvs.TargetRect.CenterX + (r/2) * SinD((i-1)*36), cvs.TargetRect.CenterY + (r/2) * CosD((i-1)*36),Bit.And(clr,0xAAFFFFFF),Spess)
			cvs.DrawLine(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha),cvs.TargetRect.CenterX + (r/2) * SinD(Alpha), cvs.TargetRect.CenterY + (r/2) * CosD(Alpha),clr,Spess)
			B=True
		Else
			cvs.DrawLine(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha),cvs.TargetRect.CenterX + (r/2) * SinD(Alpha), cvs.TargetRect.CenterY + (r/2) * CosD(Alpha),Bit.And(clr,0x55FFFFFF),Spess)
		End If
	Next
End Sub

Private Sub Draw_FollowCircles (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2-8dip
	Dim X As Int = r*SinD(Progress*360)
	Dim Y As Int = r*CosD(Progress*360)
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip, clr, True, 1dip)
	For i=0 To 4
		X = r*SinD(Progress*360-i*(72*Abs(Progress-0.5)))
		Y = r*CosD(Progress*360-i*(72*Abs(Progress-0.5)))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip-(i*5dip/5), Bit.And(clr,0x55ffffff), True, 1dip)
	Next
End Sub

Private Sub Draw_FollowCircles2 (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2-8dip
	Dim X As Int
	Dim Y As Int
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX + (r*SinD(Progress*360)), cvs.TargetRect.CenterY + (r*CosD(Progress*360)), 7dip, clr, True, 1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX + (r*SinD(Progress*360+180)), cvs.TargetRect.CenterY + (r*CosD(Progress*360+180)), 7dip, clr, True, 1dip)
	
	For i=0 To 4
		X = r*SinD(Progress*360-i*(72*Abs(Progress-0.5)))
		Y = r*CosD(Progress*360-i*(72*Abs(Progress-0.5)))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip-(i*5dip/5), Bit.And(clr,0x55ffffff), True, 1dip)
		
		X = r*SinD(Progress*360+180-i*(72*Abs(Progress-0.5)))
		Y = r*CosD(Progress*360+180-i*(72*Abs(Progress-0.5)))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip-(i*5dip/5), Bit.And(clr,0x55ffffff), True, 1dip)
	Next
End Sub

Private Sub Draw_Arc (Progress As Float)
	Dim r As Float = (Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2)-1dip
	Dim r2 As Float = 2*r/3
	Dim r3 As Float = r/3
	Dim p As B4XPath

	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	p.InitializeArc(cvs.TargetRect.CenterX,cvs.TargetRect.CenterY,r,-Progress*360,180)
	cvs.ClipPath(p)
	cvs.DrawCircle(cvs.TargetRect.CenterX,cvs.TargetRect.CenterY,r-1dip,clr,False,1dip)
	cvs.RemoveClip
	
	p.InitializeArc(cvs.TargetRect.CenterX,cvs.TargetRect.CenterY,r2,Progress*360,180)
	cvs.ClipPath(p)
	cvs.DrawCircle(cvs.TargetRect.CenterX,cvs.TargetRect.CenterY,r2-1dip,clr,False,1dip)
	cvs.RemoveClip
	
	p.InitializeArc(cvs.TargetRect.CenterX,cvs.TargetRect.CenterY,r3,-Progress*360,180)
	cvs.ClipPath(p)
	cvs.DrawCircle(cvs.TargetRect.CenterX,cvs.TargetRect.CenterY,r3-1dip,clr,False,1dip)
	cvs.RemoveClip
End Sub

Private Sub Draw_FollowArcs (Progress As Float)
	Dim MaxPoint As Int = 30
	Dim Stp As Int = 270/MaxPoint
	Dim dept As Int = 4dip
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2-8dip
	
	Progress=Sin(Progress)
	'Progress=Power(Progress,2)
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
'	cvs.DrawCircle(cvs.TargetRect.CenterX + (r*CosD(Progress*360)), cvs.TargetRect.CenterY + (r*SinD(Progress*360)), dept, clr, True, 1dip)
'	cvs.DrawCircle(cvs.TargetRect.CenterX + (r*CosD(Progress*360+180)), cvs.TargetRect.CenterY + (r*SinD(Progress*360+180)), dept, clr, True, 1dip)
	
	Dim X As Int
	Dim Y As Int
	For i=0 To MaxPoint-1
		X = r*CosD(Progress*360-i*(Stp*Abs(Progress-0.5)))
		Y = r*SinD(Progress*360-i*(Stp*Abs(Progress-0.5)))
				
		'If i>0 Then cvs.DrawLine(cvs.TargetRect.CenterX + LastX,cvs.TargetRect.CenterY + LastY,cvs.TargetRect.CenterX + X,cvs.TargetRect.CenterY + Y,clr,14dip)
		cvs.DrawCircle(cvs.TargetRect.CenterX + X,cvs.TargetRect.CenterY + Y,dept,clr,True,1dip)

		X = r*CosD(Progress*360+180-i*(Stp*Abs(Progress-0.5)))
		Y = r*SinD(Progress*360+180-i*(Stp*Abs(Progress-0.5)))
		
		'If i>0 Then cvs.DrawLine(cvs.TargetRect.CenterX + LastX,cvs.TargetRect.CenterY + LastY,cvs.TargetRect.CenterX + X,cvs.TargetRect.CenterY + Y,clr,14dip)
		cvs.DrawCircle(cvs.TargetRect.CenterX + X,cvs.TargetRect.CenterY + Y,dept,clr,True,1dip)
	Next
	
End Sub

Private Sub Draw_Square (Progress As Float)
	Square(Progress,False)
End Sub

Private Sub Draw_SquareRounded (Progress As Float)
	Square(Progress,True)
End Sub

Private Sub Square (Progress As Float, Rounded As Boolean)
	Dim Rec As B4XRect
	Dim top As Int = 5dip
	Dim left As Int = 5dip
	Dim  Width As Int = cvs.TargetView.Width
	Dim  Height As Int = cvs.TargetView.Height
		
	Rec.Initialize(0,0,Width,Height)
	Dim RoundRec As B4XPath
	RoundRec.InitializeRoundedRect(Rec,5dip)
	'cvs.DrawPath(RoundRec,xui.Color_ARGB(A,R,G,B),True,1dip)
	cvs.DrawPath(RoundRec,bgclr,True,1dip)
	Height=Height-top*2
	Width=Width-left*2
	
	If Progress<=0.125 Then
		Rec.Initialize(left,top,left+Width*(0.5+Progress*4),top+Height/2)
	Else If Progress<=0.25 Then
		Rec.Initialize(left+Width*(Progress-0.125)*4,top,left+Width,top+Height/2)
	Else If Progress<=0.375 Then
		Rec.Initialize(left+Width/2,top,left+Width,top+Height*(Progress-0.125)*4)
	Else If Progress<=0.5 Then
		Rec.Initialize(left+Width/2,top+Height*(Progress-0.375)*4,left+Width,top+Height)
	Else If Progress<=0.625 Then
		Rec.Initialize(left+Width*(0.625-Progress)*4,top+Height/2,left+Width,top+Height)
	Else If Progress<=0.75 Then
		Rec.Initialize(left,top+Height/2,left+Width*(0.875-Progress)*4,top+Height)
	Else If Progress<=0.875 Then
		Rec.Initialize(left,top+Height*(0.875-Progress)*4,left+Width/2,top+Height)
	Else
		Rec.Initialize(left,top,left+Width/2,top+Height*(1.125-Progress)*4)
	End If
	
	Dim RoundRec As B4XPath
	If Rounded Then
		RoundRec.InitializeRoundedRect(Rec,Min(Width,Height)/2)
	Else
		RoundRec.InitializeRoundedRect(Rec,5dip)
	End If
	'cvs.DrawRect(Rec,clr,True,1dip)
	cvs.DrawPath(RoundRec,clr,True,1dip)
End Sub

Private Sub Draw_FiveLines(Progress As Float)
	Dim MinR As Int = 10dip
	Dim MaxR As Int = (cvs.TargetRect.Height/2)-4dip-MinR
	Dim dx As Int = (cvs.TargetRect.Width - 2dip) / 5
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	For i = 0 To 4
		Dim r As Float = MinR + (MaxR / 2) + (MaxR / 2) * SinD(Progress * 360 - 30 * i)
		cvs.DrawLine((dx/2) + i * dx, cvs.TargetRect.CenterY - r, (dx/2) + i * dx, cvs.TargetRect.CenterY + r, clr, 4dip)
	Next
End Sub

Private Sub Draw_Infinity (Progress As Float)
	Dim X As Int
	Dim Y As Int
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height)/2-4dip
	Dim Degree As Int = (Progress*360)

	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	For t=8 To 1 Step -1
		Degree=(Progress*360)-t*20
		x = (r*CosD(Degree))/(1+Power(SinD(Degree),2))
		y = (r*SinD(Degree)*CosD(Degree))/(1+Power(SinD(Degree),2))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip-t/2, SetAlpha(clr,255/(t)), True, 1dip)
	Next

	cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip, clr, True, 1dip)
End Sub

Private Sub Draw_Hearth (Progress As Float)
	Dim X As Int
	Dim Y As Int
	Dim r As Float = (Min(cvs.TargetRect.Width,cvs.TargetRect.Height)-2dip)/40
	Dim Radius As Float

	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	Radial=(Radial + cPI * 0.02)
	If Radial>2*cPI Then Radial=Radial-(2*cPI)

	For I=0 To 10
		Radius=(Radial*10-i*2.5)/10
		X=cvs.TargetRect.CenterX + (16*Power(Sin(Radius),3))*r
		Y=cvs.TargetRect.CenterY - (13*Cos(Radius)-5*Cos(2*Radius)-2*Cos(3*Radius)-Cos(4*Radius))*r
		cvs.DrawCircle( x,  y, 7dip, SetAlpha(clr,110-(I*10)), True, 1dip)
	Next

	X=cvs.TargetRect.CenterX + (16*Power(Sin(Radial),3))*r
	Y=cvs.TargetRect.CenterY - (13*Cos(Radial)-5*Cos(2*Radial)-2*Cos(3*Radial)-Cos(4*Radial))*r
	cvs.DrawCircle( x,  y, 7dip, clr, True, 1dip)
End Sub


Private Sub Draw_Bubble (Progress As Float)
	Dim CenterX As Float = mBase.Width/2
	Dim CenterY As Float = mBase.Height/2
	Dim Frac As Int = 20
	Dim D As Double = Progress*360
	Dim Wdt As Int = Min (mBase.Width,mBase.Height)*0.60
	Dim X,Y As Int
	Dim rec As B4XRect
	Dim Path As B4XPath
	
	cvs.DrawRect(cvs.TargetRect,bgclr,True,1dip)
	For i=0 To Frac-1
		X=CenterX+CosD(D)*Wdt*0.20*(i+3)/Frac
		y=CenterY+SinD(D)*Wdt*0.20*(i+3)/Frac
		rec.Initialize(x-Wdt*(50-(10*i/Frac))/100,y-Wdt*(50-(10*i/Frac))/100,x+Wdt*(50-(10*i/Frac))/100,y+Wdt*(50-(10*i/Frac))/100)
		Path.InitializeOval(rec)
		cvs.ClipPath(Path)
		cvs.DrawBitmap(bmpBubble,cvs.TargetRect)
		cvs.RemoveClip
	Next
End Sub
Private Sub SetAlpha (c As Int, alpha As Int) As Int
	Return Bit.And(0xffffff, c) + Bit.ShiftLeft(alpha, 24)
End Sub
Private Sub Background_Touch (Action As Int, X As Float, Y As Float)
	
End Sub


Private Sub Background_Click
	
End Sub
Public Sub BringToFront
	mBase.BringToFront
End Sub

Public Sub setHeight(B As Int)
	mBase.Height=B
End Sub
Public Sub setLeft(B As Int)
	mBase.Left=B
End Sub

Public Sub getLeft As Int
	Return mBase.Left
End Sub

Public Sub getHeight As Int
	Return mBase.Width
End Sub

Public Sub RemoveViewFromParent
	mBase.RemoveViewFromParent
End Sub

Public Sub RequestFocus
	mBase.RequestFocus
End Sub

Public Sub SendToBack
	mBase.SendToBack
End Sub

Public Sub Snapshot As B4XView
	Return mBase.Snapshot
End Sub
Public Sub setstyle(value As String)
	style=value
	refreshStyle
End Sub


Public Sub setTop(B As Int)
	mBase.Top=B
End Sub

Public Sub getTop As Int
	Return mBase.Width
End Sub

Public Sub setVisible(B As Boolean)
	mBase.Visible=B
End Sub

Public Sub getVisible As Boolean
	Return mBase.Visible
End Sub

Public Sub setWidth(B As Int)
	mBase.Width=B
End Sub

Public Sub getWidth As Int
	Return mBase.Width
End Sub