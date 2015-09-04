#SingleInstance Force
#MaxThreadsPerHotkey 10

/*
Usage: 
	Win+NumPad * to reset opacity of active window
	Win+NumPad / to decrease opacity 
	Win+'A' to toggle Always On Top 

Based on 
	http://www.autohotkey.com/board/topic/667-transparent-windows/
and
	http://www.autohotkey.com/board/topic/53249-transparent-andor-always-on-top/
*/

SetBatchLines, -1
AutoTrim, Off


WinGetTransparency:
	WinGet, Transparency, Transparent, A
	If Transparency = 
		Transparency = -1
Return

WinSetTransparency:
   WinGetClass, WindowClass, ahk_id %WindowID%
   If WindowClass = Progman
   {
      Trans0 = 100
   }
   Else If Trans0 < 10
   {
      Trans0 = 10
   }
   Else If Trans0 > 100
   {
      Trans0 = 100
   }
   a = %Transparency%
   b = %Trans0%
   Trans = %Trans0%
   Trans_%WindowID% = %Transparency%
   If WindowClass = Progman
   {
      Return
   }
   a *= 2.55
   Alpha0 = %a%				; Starting Alpha
   b *= 2.55
   Alpha = %b%
   Transform, Alpha, Round, %Alpha%	; Ending Alpha
   c = %Alpha0%				; Init iteration var.
   d = %Alpha%
   d -= %Alpha0%			; Range to iterate
   Transform, e, Abs, %d%
   If e > 0
   {
      f = %d%
      f /= %e%				; Unity increment (+/- 1)
   }
   Else
   {
      f = 0
   }
   g = %f%
   g *= %AlphaIncrement%		; Increment
   Loop
   {
      Transform, c, Round, %c%
      WinSet, Trans, %c%, ahk_id %WindowID%
      If c = %Alpha%
      {
         Break
      }
      Else If e >= %AlphaIncrement%
      {
         c += %g%
         e -= %AlphaIncrement%
      }
      Else
      {
         c = %Alpha%
      }
   }
Return

ShowTransparencyToolTip:
   h = %Transparency%
   h /= 4
   ToolTipText = Opacity :%A_Space%
   Loop, %h%
   {
      ToolTipText = %ToolTipText%|
   }
   If h > 0
   {
      ToolTipText = %ToolTipText%%A_Space%
   }
   ToolTipText = %ToolTipText%%Transparency%
   ToolTip, %TooltipText%
   MouseGetPos, MouseX0, MouseY0
   SetTimer, RemoveToolTip
Return

ShowAlwaysOnTopToolTip:
   ToolTipText = AlwaysOnTop :%A_Space%
   ToolTipText = %ToolTipText% %AlwaysOnTop%
   ToolTip, %TooltipText%
   MouseGetPos, MouseX0, MouseY0
   SetTimer, RemoveToolTip
Return

RemoveToolTip:
   If A_TimeIdle < 600
   {
      MouseGetPos, MouseX, MouseY
      If MouseX = %MouseX0%
      {
         If MouseY = %MouseY0%
         {
            Return
         }
      }
   }
   SetTimer, RemoveToolTip, Off
   ToolTip
Return

#A::
  WinGet, currentWindow, ID, A
  WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
  if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
  {
    Winset, AlwaysOnTop, off, ahk_id %currentWindow%
    AlwaysOnTop=Off
    Gosub, ShowAlwaysOnTopToolTip
  }
  else
  {
    WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
    AlwaysOnTop=On
    Gosub, ShowAlwaysOnTopToolTip
  }
Return

#NumpadMult::
	WinSet, Transparent, 255, A
	Transparency  = 255
	Gosub, ShowTransparencyToolTip
Return

#NumpadDiv::
	Gosub, WinGetTransparency
	If Transparency > 90
	{
		Transparency -= 30
		WinSet, Transparent, %Transparency%, A
		Gosub, ShowTransparencyToolTip
	}
Return
