#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

Gui, Add, Edit, vTexts w600 h400
Gui, Add, Button, vButtonSubmit gButtonSubmit, Submit
Gui, Add, Picture, x0 y0 vQRcode gExiter
GuiControl, Disable, QRcode
GuiControl, Hide, QRcode
Gui, Show
Return

ButtonSubmit:
{
Gui, Submit, Nohide
IfInString, Texts, ://
Texts := uriEncode(Texts)
urler := "http://chart.apis.google.com/chart?cht=qr&chs=200x200&chl="
url3 := "&chld=H|0"
urlname := urler . Texts . url3
UrlDownloadToFile, %urlname%, qr-code.png
Sleep 2000
GuiControl, , QRcode, %A_ScriptDir%\qr-code.png
Gui, Submit
GuiControl, Disable, Texts
GuiControl, Hide, Texts
GuiControl, Disable, ButtonSubmit
GuiControl, Hide, ButtonSubmit
Gui, Hide
GuiControl, Enable, QRcode
GuiControl, Show, QRcode
Gui, Submit
Gui, -Border
Gui, Margin, 0, 0
Gui, Submit, Nohide
Gui, Show, w200 h200
Return
}

~Esc::
Exiter:
{
#Persistent
GuiControl, Disable, QRcode
GuiControl, Hide, QRcode
Gui, Destroy
ExitApp
Return
}


uriDecode(str) {
   Loop
      If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
         StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
      Else Break
   Return, str
}

uriEncode(str) {
   f = %A_FormatInteger%
   SetFormat, Integer, Hex
   If RegExMatch(str, "^\w+:/{0,2}", pr)
      StringTrimLeft, str, str, StrLen(pr)
   StringReplace, str, str, `%, `%25, All
   Loop
      If RegExMatch(str, "i)[^\w\.~%/:]", char)
         StringReplace, str, str, %char%, % "%" . SubStr(Asc(char),3), All
      Else Break
   SetFormat, Integer, %f%
   Return, pr . str
}