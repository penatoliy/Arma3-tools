#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Penatoliy

 Script Function:
	Arma 3 artyllery calculator

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <Math.au3>

Global $Square_ax, $Square_ay, $Square_pax, $Square_pay, $Input_ax, $Input_ay, $Input_aalt = 0

gui1()

Func gui1()
   $hGUI1 = GUICreate("Баллистический калькулятор", 500, 400)
   $hButton1 = GUICtrlCreateButton("Рассчитать", 20, 360, 80, 30)
   $hButton2 = GUICtrlCreateButton("Позиция...", 20, 10, 80, 30)

   $Slider1 = GUICtrlCreateSlider(178, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider1, 100, 0)
   $Slider2 = GUICtrlCreateSlider(148, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider2, 0, -100)

   $Input1 = GUICtrlCreateInput("", 440, 10, 45, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input1, 999999, 000000)
   GUICtrlCreateLabel("Квадрат:", 380, 13, 50, 20, $SS_LEFT)

   $Input2 = GUICtrlCreateInput("0", 300, 10, 45, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input2, 5000, 0)
   GUICtrlCreateLabel("Высота:", 240, 13, 50, 20, $SS_LEFT)

   $Input5 = GUICtrlCreateInput("243", 80, 65, 40, 20, $ES_NUMBER)
   $Input6 = GUICtrlCreateInput("00", 125, 65, 20, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input5, 1000, 0)
   GUICtrlSetLimit($Input6, 99, 0)
   GUICtrlCreateLabel("Скорость снаряда:", 10, 60, 50, 40, $SS_LEFT)

   $Graphic1 = GUICtrlCreateGraphic(190, 40)
   GUICtrlSetGraphic($Graphic1, $GUI_GR_RECT, 0, 0, 300, 300)

   $Graphic2 = GUICtrlCreateGraphic(186, 334)
   GUICtrlSetGraphic($Graphic2, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

   $Graphic3 = GUICtrlCreateGraphic(122, 80)
   GUICtrlSetGraphic($Graphic3, $GUI_GR_DOT, 0, 0)

   $Label_range = GUICtrlCreateLabel("Дальность:", 10, 120, 120, 20, $SS_LEFT)
   $Label_altitude = GUICtrlCreateLabel("Возвышение:", 10, 140, 120, 20, $SS_LEFT)
   $Label_azimut = GUICtrlCreateLabel("Азимут:", 10, 160, 120, 20, $SS_LEFT)

   $Label_solution_0 = GUICtrlCreateLabel("Навесная:", 10, 200, 120, 20, $SS_LEFT)
   $Label_solution_0_ETA = GUICtrlCreateLabel("Время:", 10, 220, 120, 20, $SS_LEFT)

   $Label_solution_1 = GUICtrlCreateLabel("Настильная:", 10, 260, 120, 20, $SS_LEFT)
   $Label_solution_1_ETA = GUICtrlCreateLabel("Время:", 10, 280, 120, 20, $SS_LEFT)

   GUISetState()

   While 1
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			ExitLoop
		 Case $hButton1
			If StringLen(GUICtrlRead($Input1)) = 6 Then
			   $Input_tx = (StringLeft(GUICtrlRead($Input1), 3)*100)+(GUICtrlRead($Slider1))
			   $Input_ty = (StringRight(GUICtrlRead($Input1), 3)*100)+(GUICtrlRead($Slider2)*-1)
			   $Altitude = GUICtrlRead($Input2) - $Input_aalt
			   $Range = Range_finder($Input_ax, $Input_ay, $Input_tx, $Input_ty)
			   $Solution_0 = Solution_0($Range, $Altitude, GUICtrlRead($Input5)&"."& GUICtrlRead($Input6))
			   $Solution_1 = Solution_1($Range, $Altitude,  GUICtrlRead($Input5)&"."& GUICtrlRead($Input6))
			   GUICtrlSetData($Label_range, "Дальность:      " & Round($Range,0))
			   GUICtrlSetData($Label_altitude, "Возвышение:   " &  Round($Altitude,0))
			   GUICtrlSetData($Label_azimut, "Азимут:            " & Round(Azimuth_to($Input_ax,$Input_ay,$Input_tx,$Input_ty),2))

			   GUICtrlSetData($Label_solution_0, "Навесная:        " & Round($Solution_0,2))
			   GUICtrlSetData($Label_solution_0_ETA, "Время:             " & Round(Time_to($Range, GUICtrlRead($Input5),$Solution_0),0))

			   GUICtrlSetData($Label_solution_1, "Настильная:    " & Round($Solution_1,2))
			   GUICtrlSetData($Label_solution_1_ETA, "Время:             " & Round(Time_to($Range, GUICtrlRead($Input5),$Solution_1),0))
	        Else
			   MsgBox("", "Ошибка", "Неверно введён квадрат цели")
			EndIf
		 Case $hButton2
			GUISetState(@SW_DISABLE, $hGUI1)
			gui2()
			GUISetState(@SW_ENABLE, $hGUI1)
			WinActivate($hGUI1)
		 Case $Slider1
			GUICtrlSetPos($Graphic2,186+GUICtrlRead($Slider1)*2.98, 334-GUICtrlRead($Slider2)*-2.98)
		 Case $Slider2
			GUICtrlSetPos($Graphic2,186+GUICtrlRead($Slider1)*2.98, 334-GUICtrlRead($Slider2)*-2.98)
	  EndSwitch
WEnd
EndFunc   ;==>gui1

Func gui2()
   $hGUI2 = GUICreate("Установка позиции батареи", 400, 440)
   $hButton3 = GUICtrlCreateButton("Установить", 10, 400, 80, 30)

   $Slider3 = GUICtrlCreateSlider(78, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider3, 100, 0)
   $Slider4 = GUICtrlCreateSlider(48, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
   GUICtrlSetLimit($Slider4, 0, -100)

   $Input3 = GUICtrlCreateInput("", 340, 10, 45, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input3, 999999, 000000)
   GUICtrlCreateLabel('Квадрат:', 280, 13, 50, 20, $SS_LEFT)

   $Input4 = GUICtrlCreateInput("", 200, 10, 45, 20, $ES_NUMBER)
   GUICtrlSetLimit($Input4, 5000, 0)
   GUICtrlCreateLabel('Высота:', 140, 13, 50, 20, $SS_LEFT)

   $Graphic3 = GUICtrlCreateGraphic(90, 40)
   GUICtrlSetGraphic($Graphic3, $GUI_GR_RECT, 0, 0, 300, 300)

   $Graphic4 = GUICtrlCreateGraphic(86, 334)
   GUICtrlSetGraphic($Graphic4, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

   GUICtrlSetData($Input3, StringLeft($Square_ax, 3)& StringLeft($Square_ay, 3))
   GUICtrlSetData($Input4, $Input_aalt)
   GUICtrlSetData($Slider3, $Square_pax)
   GUICtrlSetData($Slider4, $Square_pay)
   GUICtrlSetPos($Graphic4,86+GUICtrlRead($Slider3)*2.98, 334-GUICtrlRead($Slider4)*-2.98)

   GUISetState()

   While 1
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			GUIDelete($hGUI2)
			ExitLoop
		 Case $hButton3
			If StringLen(GUICtrlRead($Input3)) = 6 Then
			   $Square_ax = StringLeft(GUICtrlRead($Input3), 3)
			   $Square_ay = StringRight(GUICtrlRead($Input3), 3)
			   $Square_pax = GUICtrlRead($Slider3)
			   $Square_pay = GUICtrlRead($Slider4)
			   $Input_aalt = GUICtrlRead($Input4)
			   $Input_ax = ($Square_ax*100)+(GUICtrlRead($Slider3))
			   $Input_ay = ($Square_ay*100)+(GUICtrlRead($Slider4)*-1)
			   GUIDelete($hGUI2)
			   ExitLoop
			Else
			   MsgBox("", "Ошибка", "Неверно введён квадрат позиции")
			EndIf
		 Case $Slider3
			GUICtrlSetPos($Graphic4,86+GUICtrlRead($Slider3)*2.98, 334-GUICtrlRead($Slider4)*-2.98)
		 Case $Slider4
			GUICtrlSetPos($Graphic4,86+GUICtrlRead($Slider3)*2.98, 334-GUICtrlRead($Slider4)*-2.98)
	  EndSwitch
   WEnd
EndFunc   ;==>gui2

Func Range_finder($Input_ax, $Input_ay, $Input_tx, $Input_ty)
   Local $Range = Sqrt(($Input_tx-$Input_ax)^2+($Input_ty-$Input_ay)^2)
   Return $Range
EndFunc

Func Time_to($Range, $Velocity, $Solution)
   Local $ETA = ($Range/($Velocity*Cos(_Radian($Solution))))
   Return $ETA
EndFunc

Func Azimuth_to($Input_tx, $Input_ty, $Input_ax, $Input_ay)
	Local $Input_dx = $Input_ax - $Input_tx
	Local $Input_dy = $Input_ay - $Input_ty
	Local $Azimuth_to
	If $Input_dx > 0 Then
		$Azimuth_to = 90 - _Degree(ATan($Input_dy/$Input_dx))
	Else
		If $Input_dx < 0 Then
			$Azimuth_to = 270 - _Degree(ATan($Input_dy/$Input_dx))
		Else
			If $Input_dy > 0 Then
				$Azimuth_to = 0
			Else
				If $Input_dy < 0 Then $Azimuth_to = 180
			EndIf
		EndIf
	EndIf
	Return $Azimuth_to
EndFunc

Func Solution_0($Range, $Altitude, $Velocity)
	Local Const $g = 9.80665
	Local $Solution = _Degree(ATan(($Velocity^2+Sqrt($Velocity^4-$g*($g*$Range^2+2*$Altitude*$Velocity^2)))/($g*$Range)))
	Return $Solution
EndFunc

Func Solution_1($Range, $Altitude, $Velocity)
	Local Const $g = 9.80665
	Local $Solution = _Degree(ATan(($Velocity^2-Sqrt($Velocity^4-$g*($g*$Range^2+2*$Altitude*$Velocity^2)))/($g*$Range)))
	Return $Solution
EndFunc