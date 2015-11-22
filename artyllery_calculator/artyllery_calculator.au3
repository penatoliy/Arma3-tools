#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=doc_math_128px_1086911_easyicon.net.ico
#AutoIt3Wrapper_Outfile=artyllery_calculator_32.exe
#AutoIt3Wrapper_Outfile_x64=artyllery_calculator_64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Баллистический калькулятор для игры ArmA 3
#AutoIt3Wrapper_Res_Description=Баллистический калькулятор
#AutoIt3Wrapper_Res_Fileversion=1.1.2.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=CC
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.2
	Author:         Penatoliy

	Script Function:
	Arma 3 artyllery calculator

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <StringConstants.au3>
#include <EditConstants.au3>
#include <Math.au3>

Global $hGUI1, $hGUI2, $hGUI3, $Square_ax, $Square_ay, $Square_pax, $Square_pay, $Input_ax, $Input_ay, $Input_aalt = 0, $Input7, $Input8, $Input9, $Input10

Gui1()

Func Gui1()
	$hGUI1 = GUICreate("Баллистический калькулятор", 500, 400)
	$hButton1 = GUICtrlCreateButton("Рассчитать", 20, 360, 80, 30)
	$hButton2 = GUICtrlCreateButton("Позиция...", 20, 10, 80, 30)
	$hButton10 = GUICtrlCreateButton("?", 65, 65, 15, 20)

	$Slider1 = GUICtrlCreateSlider(178, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider1, 100, 0)
	$Slider2 = GUICtrlCreateSlider(148, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider2, 0, -100)

	$Input1 = GUICtrlCreateInput("", 440, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Квадрат:", 380, 13, 50, 20, $SS_LEFT)

	$Input2 = GUICtrlCreateInput("0", 300, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Высота:", 240, 13, 50, 20, $SS_LEFT)

	$Input5 = GUICtrlCreateInput("243", 80, 65, 40, 20, $ES_NUMBER)
	$Input6 = GUICtrlCreateInput("00", 125, 65, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Скорость снаряда:", 10, 60, 55, 40, $SS_LEFT)

	$Input7 = GUICtrlCreateInput("0", 80, 95, 40, 20, $ES_NUMBER)
	$Input8 = GUICtrlCreateInput("00", 125, 95, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Азимут коррекции:", 10, 90, 60, 40, $SS_LEFT)

	$Input9 = GUICtrlCreateInput("0", 80, 125, 40, 20, $ES_NUMBER)
	$Input10 = GUICtrlCreateInput("00", 125, 125, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Угол коррекции:", 10, 120, 60, 40, $SS_LEFT)


	$Graphic1 = GUICtrlCreateGraphic(190, 40)
	GUICtrlSetGraphic($Graphic1, $GUI_GR_RECT, 0, 0, 300, 300)

	$Graphic2 = GUICtrlCreateGraphic(186, 334)
	GUICtrlSetGraphic($Graphic2, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

	$Graphic5 = GUICtrlCreateGraphic(122, 80)
	GUICtrlSetGraphic($Graphic5, $GUI_GR_DOT, 0, 0)

	$Graphic6 = GUICtrlCreateGraphic(122, 110)
	GUICtrlSetGraphic($Graphic6, $GUI_GR_DOT, 0, 0)

	$Graphic7 = GUICtrlCreateGraphic(122, 140)
	GUICtrlSetGraphic($Graphic7, $GUI_GR_DOT, 0, 0)

	$Label_range = GUICtrlCreateLabel("Дальность:", 10, 170, 130, 20, $SS_LEFT)
	$Label_altitude = GUICtrlCreateLabel("Возвышение:", 10, 190, 130, 20, $SS_LEFT)
	$Label_azimut = GUICtrlCreateLabel("Азимут:", 10, 210, 120, 20, $SS_LEFT)

	$Label_solution_0 = GUICtrlCreateLabel("Навесная:", 10, 240, 130, 20, $SS_LEFT)
	$Label_solution_0_ETA = GUICtrlCreateLabel("Время:", 10, 260, 130, 20, $SS_LEFT)

	$Label_solution_1 = GUICtrlCreateLabel("Настильная:", 10, 290, 130, 20, $SS_LEFT)
	$Label_solution_1_ETA = GUICtrlCreateLabel("Время:", 10, 310, 130, 20, $SS_LEFT)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $hButton1
				If StringLen(GUICtrlRead($Input1)) = 6 And StringLen($Square_ax & $Square_ay) = 6 Then
					$Input_tx = (StringLeft(GUICtrlRead($Input1), 3) * 100) + (GUICtrlRead($Slider1))
					$Input_ty = (StringRight(GUICtrlRead($Input1), 3) * 100) + (GUICtrlRead($Slider2) * -1)
					$Altitude = GUICtrlRead($Input2) - $Input_aalt
					$Range = Range_finder($Input_ax, $Input_ay, $Input_tx, $Input_ty)
					$Azimuth = Azimuth_to($Input_ax, $Input_ay, $Input_tx, $Input_ty)
					$Solution = Solution($Range, $Altitude, GUICtrlRead($Input5) & "." & GUICtrlRead($Input6))
					$Solution_fix_0 = Solution_fix($Azimuth, $Solution[0], GUICtrlRead($Input7) & "." & GUICtrlRead($Input8), GUICtrlRead($Input9) & "." & GUICtrlRead($Input10))
					$Solution_fix_1 = Solution_fix($Azimuth, $Solution[1], GUICtrlRead($Input7) & "." & GUICtrlRead($Input8), GUICtrlRead($Input9) & "." & GUICtrlRead($Input10))
					GUICtrlSetData($Label_range, "Дальность:      " & Round($Range, 0))
					GUICtrlSetData($Label_altitude, "Возвышение:   " & Round(_Degree(ATan($Altitude / $Range)), 1))
					GUICtrlSetData($Label_azimut, "Азимут:            " & Round($Azimuth, 2))

					GUICtrlSetData($Label_solution_0, "Навесная:        " & Round($Solution_fix_0, 2))
					GUICtrlSetData($Label_solution_0_ETA, "Время:             " & Round(Time_to($Range, GUICtrlRead($Input5), $Solution[0]), 0))

					GUICtrlSetData($Label_solution_1, "Настильная:    " & Round($Solution_fix_1, 2))
					GUICtrlSetData($Label_solution_1_ETA, "Время:             " & Round(Time_to($Range, GUICtrlRead($Input5), $Solution[1]), 0))
				Else
					MsgBox("", "Ошибка", "Неверно введён квадрат цели или позиции")
				EndIf
			Case $hButton2
				GUISetState(@SW_DISABLE, $hGUI1)
				Gui2()
			Case $hButton10
				MsgBox("", "Таблица скоростей", "Калибр: Заряд 1 / Заряд 2 / Заряд 3 / Заряд 4 / Заряд 5 " & @CRLF & @CRLF & "82мм: 70.0 / 140.0 / 200.0 / --- / --- " & @CRLF & "155мм: 153.9 / 243.0 / 388.8 / 648.0 / 810.0 " & @CRLF & "230мм: 212.5 / 425.0 / 637.5 / 772.5 / --- ")
			Case $Slider1
				GUICtrlSetPos($Graphic2, 186 + GUICtrlRead($Slider1) * 2.98, 334 - GUICtrlRead($Slider2) * -2.98)
			Case $Slider2
				GUICtrlSetPos($Graphic2, 186 + GUICtrlRead($Slider1) * 2.98, 334 - GUICtrlRead($Slider2) * -2.98)
		EndSwitch
	WEnd
EndFunc   ;==>Gui1

Func Gui2()
	$hGUI2 = GUICreate("Установка позиции батареи", 400, 440)
	$hButton3 = GUICtrlCreateButton("Установить", 10, 400, 80, 30)
	$hButton4 = GUICtrlCreateButton("Угловая привязка...", 200, 400, 120, 30)

	$Slider3 = GUICtrlCreateSlider(78, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider3, 100, 0)
	$Slider4 = GUICtrlCreateSlider(48, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider4, 0, -100)

	$Input3 = GUICtrlCreateInput("", 340, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Квадрат:", 280, 13, 50, 20, $SS_LEFT)

	$Input4 = GUICtrlCreateInput("0", 200, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Высота:", 140, 13, 50, 20, $SS_LEFT)

	$Graphic3 = GUICtrlCreateGraphic(90, 40)
	GUICtrlSetGraphic($Graphic3, $GUI_GR_RECT, 0, 0, 300, 300)

	$Graphic4 = GUICtrlCreateGraphic(86, 334)
	GUICtrlSetGraphic($Graphic4, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

	GUICtrlSetData($Input3, StringLeft($Square_ax, 3) & StringLeft($Square_ay, 3))
	GUICtrlSetData($Input4, $Input_aalt)
	GUICtrlSetData($Slider3, $Square_pax)
	GUICtrlSetData($Slider4, $Square_pay)
	GUICtrlSetPos($Graphic4, 86 + GUICtrlRead($Slider3) * 2.98, 334 - GUICtrlRead($Slider4) * -2.98)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_DISABLE, $hGUI2)
				GUISetState(@SW_ENABLE, $hGUI1)
				WinActivate($hGUI1)
				GUIDelete($hGUI2)
				ExitLoop
			Case $hButton3
				If StringLen(GUICtrlRead($Input3)) = 6 Then
					$Square_ax = StringLeft(GUICtrlRead($Input3), 3)
					$Square_ay = StringRight(GUICtrlRead($Input3), 3)
					$Square_pax = GUICtrlRead($Slider3)
					$Square_pay = GUICtrlRead($Slider4)
					$Input_aalt = GUICtrlRead($Input4)
					$Input_ax = ($Square_ax * 100) + ($Square_pax)
					$Input_ay = ($Square_ay * 100) + ($Square_pay * -1)
					GUISetState(@SW_DISABLE, $hGUI2)
					GUISetState(@SW_ENABLE, $hGUI1)
					WinActivate($hGUI1)
					GUIDelete($hGUI2)
					ExitLoop
				Else
					MsgBox("", "Ошибка", "Неверно введён квадрат позиции")
				EndIf
			Case $hButton4
				If StringLen(GUICtrlRead($Input3)) = 6 Then
					$Square_ax = StringLeft(GUICtrlRead($Input3), 3)
					$Square_ay = StringRight(GUICtrlRead($Input3), 3)
					$Square_pax = GUICtrlRead($Slider3)
					$Square_pay = GUICtrlRead($Slider4)
					$Input_aalt = GUICtrlRead($Input4)
					$Input_ax = ($Square_ax * 100) + ($Square_pax)
					$Input_ay = ($Square_ay * 100) + ($Square_pay * -1)
					GUISetState(@SW_DISABLE, $hGUI2)
					Gui3()
				Else
					MsgBox("", "Ошибка", "Неверно введён квадрат позиции")
				EndIf
			Case $Slider3
				GUICtrlSetPos($Graphic4, 86 + GUICtrlRead($Slider3) * 2.98, 334 - GUICtrlRead($Slider4) * -2.98)
			Case $Slider4
				GUICtrlSetPos($Graphic4, 86 + GUICtrlRead($Slider3) * 2.98, 334 - GUICtrlRead($Slider4) * -2.98)
		EndSwitch
	WEnd
EndFunc   ;==>Gui2

Func Gui3()
	Local $Azimuth_o_0, $DAngle_o_0, $Range_o_0, $Azimuth_o_1, $DAngle_o_1, $Range_o_1, $Azimuth_o_2, $DAngle_o_2, $Range_o_2
	$hGUI3 = GUICreate("Коррекция по трём углмам", 400, 440)

	$hButton5 = GUICtrlCreateButton("Рассчитать", 10, 400, 80, 30)
	$Label_fix = GUICtrlCreateLabel("", 10, 381, 80, 20, $SS_LEFT)

	$hButton6 = GUICtrlCreateButton("Первый", 200, 400, 50, 30)
	$Label_fix_0 = GUICtrlCreateLabel("", 200, 381, 60, 20, $SS_LEFT)

	$hButton7 = GUICtrlCreateButton("Второй", 265, 400, 50, 30)
	$Label_fix_1 = GUICtrlCreateLabel("", 265, 381, 60, 20, $SS_LEFT)

	$hButton9 = GUICtrlCreateButton("Третий", 330, 400, 50, 30)
	$Label_fix_2 = GUICtrlCreateLabel("", 330, 381, 60, 20, $SS_LEFT)

	$Slider5 = GUICtrlCreateSlider(78, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider5, 100, 0)
	$Slider6 = GUICtrlCreateSlider(48, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider6, 0, -100)

	$Input11 = GUICtrlCreateInput("", 340, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Квадрат:", 290, 13, 50, 20, $SS_LEFT)

	$Input12 = GUICtrlCreateInput("0", 230, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Высота:", 180, 13, 50, 20, $SS_LEFT)

	$Input13 = GUICtrlCreateInput("0", 120, 405, 45, 20, $ES_NUMBER)
	$Input14 = GUICtrlCreateInput("00", 170, 405, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Решение:", 120, 385, 52, 20, $SS_LEFT)

	$Input15 = GUICtrlCreateInput("243", 80, 10, 45, 20, $ES_NUMBER)
	$Input16 = GUICtrlCreateInput("00", 130, 10, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Скорость снаряда:", 10, 5, 50, 30, $SS_LEFT)
	$hButton11 = GUICtrlCreateButton("?", 65, 10, 15, 20)


	$Graphic8 = GUICtrlCreateGraphic(90, 40)
	GUICtrlSetGraphic($Graphic8, $GUI_GR_RECT, 0, 0, 300, 300)

	$Graphic9 = GUICtrlCreateGraphic(86, 334)
	GUICtrlSetGraphic($Graphic9, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

	$Graphic10 = GUICtrlCreateGraphic(167, 420)
	GUICtrlSetGraphic($Graphic10, $GUI_GR_DOT, 0, 0)

    $Graphic11 = GUICtrlCreateGraphic(127, 24)
	GUICtrlSetGraphic($Graphic11, $GUI_GR_DOT, 0, 0)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_DISABLE, $hGUI3)
				GUISetState(@SW_ENABLE, $hGUI2)
				WinActivate($hGUI2)
				GUIDelete($hGUI3)
				ExitLoop
			Case $hButton5
				If $Range_o_0 And $Range_o_1 And $Range_o_2 Then
					$Fix_array = Geo_fix($Azimuth_o_0, $DAngle_o_0, $Azimuth_o_1, $DAngle_o_1, $Azimuth_o_2, $DAngle_o_2)
					GUICtrlSetData($Label_fix, Round($Fix_array[0], 0) & "@" & Round($Fix_array[1], 2))
					If StringInStr($Fix_array[0], ".") Then
						$Fix_azimuth = StringSplit($Fix_array[0], ".", $STR_NOCOUNT)
					Else
						$Fix_azimuth[0] = $Fix_array[0]
						$Fix_azimuth[1] = "00"
					EndIf
					If StringInStr($Fix_array[1], ".") Then
						$Fix_angle = StringSplit($Fix_array[1], ".", $STR_NOCOUNT)
					Else
						$Fix_angle[0] = $Fix_array[1]
						$Fix_angle[1] = "00"
					EndIf
					GUICtrlSetData($Input7, $Fix_azimuth[0])
					GUICtrlSetData($Input8, StringLeft($Fix_azimuth[1], 2))
					GUICtrlSetData($Input9, $Fix_angle[0])
					GUICtrlSetData($Input10, StringLeft($Fix_angle[1], 2))
				Else
					MsgBox("", "Ошибка", "Углы ориентиров не установлены")
				EndIf
			Case $hButton6
				If StringLen(GUICtrlRead($Input11)) = 6 Then
					$Square_ox_0 = StringLeft(GUICtrlRead($Input11), 3)
					$Square_oy_0 = StringRight(GUICtrlRead($Input11), 3)
					$Square_pox_0 = GUICtrlRead($Slider5)
					$Square_poy_0 = GUICtrlRead($Slider6)
					$Input_oalt_0 = GUICtrlRead($Input12)
					$Input_ox_0 = ($Square_ox_0 * 100) + ($Square_pox_0)
					$Input_oy_0 = ($Square_oy_0 * 100) + ($Square_poy_0 * -1)
					$Range_o_0 = Range_finder($Input_ax, $Input_ay, $Input_ox_0, $Input_oy_0)
					$Altitude_o_0 = GUICtrlRead($Input12) - $Input_aalt
					$Angle_o_0 = Solution($Range_o_0, $Altitude_o_0, GUICtrlRead($Input15) & "." & GUICtrlRead($Input16))
					$Azimuth_o_0 = Azimuth_to($Input_ax, $Input_ay, $Input_ox_0, $Input_oy_0)
					$DAngle_o_0 = $Angle_o_0[0] - (GUICtrlRead($Input13) & "." & GUICtrlRead($Input14))
					GUICtrlSetData($Label_fix_0, Round($Azimuth_o_0, 0) & "@" & Round($DAngle_o_0, 2))
				Else
					MsgBox("", "Ошибка", "Неверно введён квадрат ориентира")
				EndIf
			Case $hButton7
				If StringLen(GUICtrlRead($Input11)) = 6 Then
					$Square_ox_1 = StringLeft(GUICtrlRead($Input11), 3)
					$Square_oy_1 = StringRight(GUICtrlRead($Input11), 3)
					$Square_pox_1 = GUICtrlRead($Slider5)
					$Square_poy_1 = GUICtrlRead($Slider6)
					$Input_oalt_1 = GUICtrlRead($Input12)
					$Input_ox_1 = ($Square_ox_1 * 100) + ($Square_pox_1)
					$Input_oy_1 = ($Square_oy_1 * 100) + ($Square_poy_1 * -1)
					$Range_o_1 = Range_finder($Input_ax, $Input_ay, $Input_ox_1, $Input_oy_1)
					$Altitude_o_1 = GUICtrlRead($Input12) - $Input_aalt
					$Angle_o_1 = Solution($Range_o_1, $Altitude_o_1, GUICtrlRead($Input15) & "." & GUICtrlRead($Input16))
					$Azimuth_o_1 = Azimuth_to($Input_ax, $Input_ay, $Input_ox_1, $Input_oy_1)
					$DAngle_o_1 = $Angle_o_1[0] - (GUICtrlRead($Input13) & "." & GUICtrlRead($Input14))
					GUICtrlSetData($Label_fix_1, Round($Azimuth_o_1, 0) & "@" & Round($DAngle_o_1, 2))
				Else
					MsgBox("", "Ошибка", "Неверно введён квадрат ориентира")
				EndIf
			Case $hButton9
				If StringLen(GUICtrlRead($Input11)) = 6 Then
					$Square_ox_2 = StringLeft(GUICtrlRead($Input11), 3)
					$Square_oy_2 = StringRight(GUICtrlRead($Input11), 3)
					$Square_pox_2 = GUICtrlRead($Slider5)
					$Square_poy_2 = GUICtrlRead($Slider6)
					$Input_oalt_2 = GUICtrlRead($Input12)
					$Input_ox_2 = ($Square_ox_2 * 100) + ($Square_pox_2)
					$Input_oy_2 = ($Square_oy_2 * 100) + ($Square_poy_2 * -1)
					$Range_o_2 = Range_finder($Input_ax, $Input_ay, $Input_ox_2, $Input_oy_2)
					$Altitude_o_2 = GUICtrlRead($Input12) - $Input_aalt
					$Angle_o_2 = Solution($Range_o_0, $Altitude_o_0, GUICtrlRead($Input15) & "." & GUICtrlRead($Input16))
					$Azimuth_o_2 = Azimuth_to($Input_ax, $Input_ay, $Input_ox_2, $Input_oy_2)
					$DAngle_o_2 = $Angle_o_2[0] - (GUICtrlRead($Input13) & "." & GUICtrlRead($Input14))
					GUICtrlSetData($Label_fix_2, Round($Azimuth_o_2, 0) & "@" & Round($DAngle_o_2, 2))
				Else
					MsgBox("", "Ошибка", "Неверно введён квадрат ориентира")
				 EndIf
			Case $hButton11
				 MsgBox("", "Таблица скоростей", "Калибр: Заряд 1 / Заряд 2 / Заряд 3 / Заряд 4 / Заряд 5 " & @CRLF & @CRLF & "82мм: 70.0 / 140.0 / 200.0 / --- / --- " & @CRLF & "155мм: 153.9 / 243.0 / 388.8 / 648.0 / 810.0 " & @CRLF & "230мм: 212.5 / 425.0 / 637.5 / 772.5 / --- ")
			Case $Slider5
				GUICtrlSetPos($Graphic9, 86 + GUICtrlRead($Slider5) * 2.98, 334 - GUICtrlRead($Slider6) * -2.98)
			Case $Slider6
				GUICtrlSetPos($Graphic9, 86 + GUICtrlRead($Slider5) * 2.98, 334 - GUICtrlRead($Slider6) * -2.98)
		EndSwitch
	WEnd
EndFunc   ;==>Gui3

Func Range_finder($Input_ax, $Input_ay, $Input_tx, $Input_ty)
	$Range = Sqrt(($Input_ax - $Input_tx) ^ 2 + ($Input_ay - $Input_ty) ^ 2)
	Return $Range
EndFunc   ;==>Range_finder

Func Time_to($Range, $Velocity, $Solution)
	$ETA = ($Range / ($Velocity * Cos(_Radian($Solution))))
	Return $ETA
EndFunc   ;==>Time_to

Func Azimuth_to($Input_ax, $Input_ay, $Input_tx, $Input_ty)
	$Input_dx = $Input_tx - $Input_ax
	$Input_dy = $Input_ty - $Input_ay
	If $Input_dx > 0 Then
		$Azimuth_to = 90 - _Degree(ATan($Input_dy / $Input_dx))
	Else
		If $Input_dx < 0 Then
			$Azimuth_to = 270 - _Degree(ATan($Input_dy / $Input_dx))
		Else
			If $Input_dy > 0 Then
				$Azimuth_to = 0
			Else
				If $Input_dy < 0 Then $Azimuth_to = 180
			EndIf
		EndIf
	EndIf
	Return $Azimuth_to
EndFunc   ;==>Azimuth_to

Func Solution($Range, $Altitude, $Velocity)
    Local $Solution[2]
	Const $g = 9.80665
	$Solution[0] = _Degree(ATan(($Velocity ^ 2 + Sqrt($Velocity ^ 4 - $g * ($g * $Range ^ 2 + 2 * $Altitude * $Velocity ^ 2))) / ($g * $Range)))
	$Solution[1] = _Degree(ATan(($Velocity ^ 2 - Sqrt($Velocity ^ 4 - $g * ($g * $Range ^ 2 + 2 * $Altitude * $Velocity ^ 2))) / ($g * $Range)))
	Return $Solution
EndFunc   ;==>Solution_0

Func Solution_fix($Azimuth_to, $Solution_to, $Azimuth_fix, $Angle_fix)
    If $Azimuth_to > 180 Then $Azimuth_to = $Azimuth_to - 360
    If $Azimuth_fix > 180 Then $Azimuth_fix = $Azimuth_fix - 360
	$Solution = $Solution_to - ((-Abs($Azimuth_to - $Azimuth_fix))/90 + 1) * $Angle_fix
	Return $Solution
EndFunc   ;==>Solution_fix

Func Geo_fix($Dot_az_0, $Dot_rg_0, $Dot_az_1, $Dot_rg_1, $Dot_az_2, $Dot_rg_2)
    Local $Solution[2]
	$Dot_x_0 = ($Dot_rg_0 + 100) * Cos(_Radian($Dot_az_0))
	$Dot_y_0 = ($Dot_rg_0 + 100) * Sin(_Radian($Dot_az_0))
	$Dot_x_1 = ($Dot_rg_1 + 100) * Cos(_Radian($Dot_az_1))
	$Dot_y_1 = ($Dot_rg_1 + 100) * Sin(_Radian($Dot_az_1))
	$Dot_x_2 = ($Dot_rg_2 + 100) * Cos(_Radian($Dot_az_2))
	$Dot_y_2 = ($Dot_rg_2 + 100) * Sin(_Radian($Dot_az_2))
	$A = $Dot_x_1 - $Dot_x_0
	$B = $Dot_y_1 - $Dot_y_0
	$C = $Dot_x_2 - $Dot_x_0
	$D = $Dot_y_2 - $Dot_y_0
	$E = $A * ($Dot_x_0 + $Dot_x_1) + $B * ($Dot_y_0 + $Dot_y_1)
	$F = $C * ($Dot_x_0 + $Dot_x_2) + $D * ($Dot_y_0 + $Dot_y_2)
	$g = 2 * ($A * ($Dot_y_2 - $Dot_y_1) - $B * ($Dot_x_2 - $Dot_x_1))
	If $g = 0 Then
	   MsgBox("", "Ошибка", "Невозможно вычислить коррекцию по заданным углам")
	   $Solution[0] = 0
	   $Solution[1] = 0
	Else
	   $Cx = ($D * $E - $B * $F) / $g
	   $Cy = ($A * $F - $C * $E) / $g
	   $Corr_rg = Sqrt($Cx ^ 2 + $Cy ^ 2)
	   $Corr_az_f = _Degree(ACos($Cx / ($Corr_rg)))
	If $Corr_az_f < 180 Then
		$Corr_az = $Corr_az_f + 180
	Else
		$Corr_az = $Corr_az_f - 180
	EndIf
	$Solution[0] = $Corr_az
	$Solution[1] = $Corr_rg
    EndIf
	Return $Solution
EndFunc   ;==>Geo_fix
