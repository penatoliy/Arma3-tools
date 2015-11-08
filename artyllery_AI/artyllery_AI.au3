#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Penatoliy

 Script Function:
	Arma 3 artyllery AI computer

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>


gui1()

Func gui1()
   $hGUI1 = GUICreate("Артиллерийский компьютер", 500, 400)
   $hButton1 = GUICtrlCreateButton("Расчитать", 20, 360, 80, 30)
   $hButton2 = GUICtrlCreateButton("Позиция...", 20, 10, 80, 30)

   $Slider1 = GUICtrlCreateSlider(178, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider1, 100, 0)
   $Slider2 = GUICtrlCreateSlider(148, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider2, 0, -100)

   $Input1 = GUICtrlCreateInput("000000", 440, 10, 45, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input1, 999999, 000000)

   $Graphic1 = GUICtrlCreateGraphic(190, 40)
   GUICtrlSetGraphic($Graphic1, $GUI_GR_RECT, 0, 0, 300, 300)

   $Graphic2 = GUICtrlCreateGraphic(186, 334)
   GUICtrlSetGraphic($Graphic2, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

   GUISetState()

   While 1
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			ExitLoop
		 Case $hButton1
			If StringLen(GUICtrlRead($Input1)) = 6 Then
			   $Input_tx = StringLeft(GUICtrlRead($Input1), 3)
			   $Input_ty = StringRight(GUICtrlRead($Input1), 3)
			   MsgBox("", "Координа", "Х= " & $Input_tx & @CRLF & "Y= " & $Input_ty)
			Else
			   MsgBox("", "Ошибка", "Неверно введён квадрат цели")
			EndIf
		 Case $hButton2
			; Disable the first GUI
			GUISetState(@SW_DISABLE, $hGUI1)
			gui2()
			; Re-enable the first GUI
			GUISetState(@SW_ENABLE, $hGUI1)
			GUISetState(@SW_RESTORE, $hGUI1)
		 Case $Slider1
			GUICtrlSetPos($Graphic2,186+GUICtrlRead($Slider1)*2.98, 334-GUICtrlRead($Slider2)*-2.98)
		 Case $Slider2
			GUICtrlSetPos($Graphic2,186+GUICtrlRead($Slider1)*2.98, 334-GUICtrlRead($Slider2)*-2.98)
	  EndSwitch
WEnd
EndFunc   ;==>gui1

Func gui2()
   $hGUI2 = GUICreate("Установка позиции батареи", 400, 400)
   $hButton3 = GUICtrlCreateButton("Установить", 100, 10, 80, 30)

   $Slider3 = GUICtrlCreateSlider(78, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider3, 100, 0)
   $Slider4 = GUICtrlCreateSlider(48, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider4, 0, -100)

   $Input2 = GUICtrlCreateInput("000000", 340, 10, 45, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input2, 999999, 000000)

   $Graphic3 = GUICtrlCreateGraphic(90, 40)
   GUICtrlSetGraphic($Graphic3, $GUI_GR_RECT, 0, 0, 300, 300)

   $Graphic4 = GUICtrlCreateGraphic(86, 334)
   GUICtrlSetGraphic($Graphic4, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

   GUISetState()

   While 1
   ; We can only get messages from the second GUI
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			GUIDelete($hGUI2)
			ExitLoop
		 Case $hButton3
			MsgBox("", "MsgBox 2", "Test from Gui 2")
			GUIDelete($hGUI2)
			ExitLoop
		 Case $Slider3
			GUICtrlSetPos($Graphic4,86+GUICtrlRead($Slider3)*2.98, 334-GUICtrlRead($Slider4)*-2.98)
		 Case $Slider4
			GUICtrlSetPos($Graphic4,86+GUICtrlRead($Slider3)*2.98, 334-GUICtrlRead($Slider4)*-2.98)
	  EndSwitch
   WEnd
EndFunc   ;==>gui2

Func range_finder($Input_tx, $Input_ty, $Input_ax, $Input_ay)
   Local $Range = Sqrt(($Input_tx-$Input_ax)^2+($Input_ty-$Input_ay)^2)
   Return $Range
EndFunc