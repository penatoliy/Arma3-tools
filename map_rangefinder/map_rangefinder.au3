#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Penatoliy

 Script Function:
	Arma 3 map range calculator

#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>


$Form1 = GUICreate("Дальность по квадратам", 450, 350, 192, 124)

$Group1 = GUICtrlCreateGroup("", 40, 24, 185, 185)

$Slider1 = GUICtrlCreateSlider(40, 224, 177, 33)
GUICtrlSetLimit($Slider1, 100, 0)
$Inputgx = GUICtrlCreateInput("100",40,5,40,20)

$Slider2 = GUICtrlCreateSlider(40, 256, 174, 29)
GUICtrlSetLimit($Slider2, 100, 0)
$Inputgy = GUICtrlCreateInput("100",90,5,40,20)

$Graphic1 = GUICtrlCreateGraphic(36, 203, 16, 16)
GUICtrlSetGraphic($Graphic1, $GUI_GR_ELLIPSE, 0, 0, 10, 10)



$Group2 = GUICtrlCreateGroup("", 240, 24, 185, 185)

$Slider3 = GUICtrlCreateSlider(240, 224, 177, 33)
GUICtrlSetLimit($Slider3, 100, 0)
$Inputtx = GUICtrlCreateInput("100",240,5,40,20)

$Slider4 = GUICtrlCreateSlider(240, 256, 174, 29)
GUICtrlSetLimit($Slider4, 100, 0)
$Inputty = GUICtrlCreateInput("100",290,5,40,20)

$Graphic2 = GUICtrlCreateGraphic(236, 203, 16, 16)
GUICtrlSetGraphic($Graphic2, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

$Button1 = GUICtrlCreateButton("Расчитать", 40, 300, 70, 20)

GUISetState(@SW_SHOW)

While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			Exit
		 Case $Slider1
			GUICtrlSetPos($Graphic1,36+GUICtrlRead($Slider1)/100*183,203-GUICtrlRead($Slider2)/100*176)
		 Case $Slider2
			GUICtrlSetPos($Graphic1,36+GUICtrlRead($Slider1)/100*183,203-GUICtrlRead($Slider2)/100*176)
		 Case $Slider3
			GUICtrlSetPos($Graphic2,236+GUICtrlRead($Slider3)/100*183,203-GUICtrlRead($Slider4)/100*176)
		 Case $Slider4
			GUICtrlSetPos($Graphic2,236+GUICtrlRead($Slider3)/100*183,203-GUICtrlRead($Slider4)/100*176)
		 Case $Button1
			MsgBox($MB_SYSTEMMODAL, "Дальность", range(GUICtrlRead($Inputgx)+(GUICtrlRead($Slider1)/100),GUICtrlRead($Inputgy)+(GUICtrlRead($Slider2)/100),GUICtrlRead($Inputtx)+(GUICtrlRead($Slider3)/100),GUICtrlRead($Inputty)+(GUICtrlRead($Slider4)/100)))
	EndSwitch
WEnd

Func range($vgx, $vgy, $vtx, $vty)
   Local $range = Sqrt(($vtx-$vgx)^2+($vty-$vgy)^2)*100
   Return $range
EndFunc