#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=doc_math_128px_1086911_easyicon.net.ico
#AutoIt3Wrapper_Outfile=release\32\artyllery_calculator_32.exe
#AutoIt3Wrapper_Outfile_x64=release\64\artyllery_calculator_64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Баллистический калькулятор для игры ArmA 3
#AutoIt3Wrapper_Res_Description=Баллистический калькулятор
#AutoIt3Wrapper_Res_Fileversion=1.5.1.0
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
#include <MsgBoxConstants.au3>
#include <Math.au3>

Global Const $g = 9.81
Global $hGUI_main, $hGUI_position, $hGUI_angle, $Square_ax, $Square_ay, $Square_pax, $Square_pay, $Input_ax, $Input_ay, $Input_aalt, $Input7, $Input8, $Input9, $Input10, $Plat_h, $Plat_l
Global $Hit_Array[64][4], $Hit_Counter = 0, $Angle_Array[64][3], $Angle_Counter = 0, $Solution_delta, $iAzimuth_fix, $iAngle_fix, $LockPos = 4, $HitLock = True, $Interupt = False

GUI_main()

Func GUI_main()
	$hGUI_main = GUICreate("Баллистический калькулятор", 500, 400)
	$hButton1 = GUICtrlCreateButton("Рассчитать", 20, 360, 80, 30)
	$hButton2 = GUICtrlCreateButton("Позиция", 10, 10, 60, 30)
	$hButton10 = GUICtrlCreateButton("?", 65, 65, 15, 20)
	$hButton11 = GUICtrlCreateButton("Попадание", 70, 10, 70, 30)

	$Slider1 = GUICtrlCreateSlider(178, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider1, 100, 0)
	GUICtrlSetData($Slider1, 50)

	$Slider2 = GUICtrlCreateSlider(148, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider2, 0, -100)
	GUICtrlSetData($Slider2, -50)

	$Input1 = GUICtrlCreateInput("", 440, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Квадрат:", 380, 13, 50, 20, $SS_LEFT)

	$Input2 = GUICtrlCreateInput("", 300, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Высота:", 240, 13, 50, 20, $SS_LEFT)

	$Input5 = GUICtrlCreateInput("", 80, 65, 30, 20, $ES_NUMBER)
	$Input6 = GUICtrlCreateInput("", 115, 65, 25, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Скорость снаряда:", 10, 60, 55, 40, $SS_LEFT)

	$Input7 = GUICtrlCreateInput("", 80, 95, 30, 20, $ES_NUMBER)
	$Input8 = GUICtrlCreateInput("", 115, 95, 25, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Азимут коррекции:", 10, 90, 60, 40, $SS_LEFT)

	$Input9 = GUICtrlCreateInput("", 80, 125, 30, 20, $ES_NUMBER)
	$Input10 = GUICtrlCreateInput("", 115, 125, 25, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Угол коррекции:", 10, 120, 60, 40, $SS_LEFT)

	$Graphic1 = GUICtrlCreateGraphic(190, 40)
	GUICtrlSetGraphic($Graphic1, $GUI_GR_RECT, 0, 0, 300, 300)

	$Graphic2 = GUICtrlCreateGraphic(186, 334)
	GUICtrlSetGraphic($Graphic2, $GUI_GR_ELLIPSE, 0, 0, 10, 10)
	GUICtrlSetPos($Graphic2, 186 + GUICtrlRead($Slider1) * 2.98, 334 - GUICtrlRead($Slider2) * -2.98)

	$Graphic5 = GUICtrlCreateGraphic(112, 80)
	GUICtrlSetGraphic($Graphic5, $GUI_GR_DOT, 0, 0)

	$Graphic6 = GUICtrlCreateGraphic(112, 110)
	GUICtrlSetGraphic($Graphic6, $GUI_GR_DOT, 0, 0)

	$Graphic7 = GUICtrlCreateGraphic(112, 140)
	GUICtrlSetGraphic($Graphic7, $GUI_GR_DOT, 0, 0)

	$Label_range = GUICtrlCreateLabel("Дальность:", 10, 170, 130, 20, $SS_LEFT)
	$Label_altitude = GUICtrlCreateLabel("Угломер:", 10, 190, 130, 20, $SS_LEFT)
	$Label_azimut = GUICtrlCreateLabel("Азимут:", 10, 210, 120, 20, $SS_LEFT)

	$Label_solution_0 = GUICtrlCreateLabel("Навесная:", 10, 240, 130, 20, $SS_LEFT)
	$Label_solution_0_ETA = GUICtrlCreateLabel("Время:", 10, 260, 130, 20, $SS_LEFT)

	$Label_solution_1 = GUICtrlCreateLabel("Настильная:", 10, 290, 130, 20, $SS_LEFT)
	$Label_solution_1_ETA = GUICtrlCreateLabel("Время:", 10, 310, 130, 20, $SS_LEFT)

	$HitLock = True

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $hButton1
				If StringLen(GUICtrlRead($Input1)) = 6 And StringLen($Square_ax & $Square_ay) = 6 Then
					$iAzimuth_fix = GUICtrlRead($Input7) & "." & GUICtrlRead($Input8)
					$iAngle_fix = GUICtrlRead($Input9) & "." & GUICtrlRead($Input10)
					$iSpeed = GUICtrlRead($Input5) & "." & GUICtrlRead($Input6)
					$Square_tx = StringLeft(GUICtrlRead($Input1), 3)
					$Square_ty = StringRight(GUICtrlRead($Input1), 3)
					$Square_ptx = GUICtrlRead($Slider1)
					$Square_pty = GUICtrlRead($Slider2)
					$Input_tx = ($Square_tx * 100) + ($Square_ptx)
					$Input_ty = ($Square_ty * 100) + ($Square_pty * -1)
					$Input_talt = GUICtrlRead($Input2)
					$Altitude = $Input_talt - $Input_aalt - Cos(_Radian($iAngle_fix)) * $Plat_h
					$Range = Range_finder($Input_ax + Sin(_Radian($iAngle_fix)) * Sin(_Radian($iAzimuth_fix)) * $Plat_h, $Input_ay + Sin(_Radian($iAngle_fix)) * Cos(_Radian($iAzimuth_fix)) * $Plat_h, $Input_tx, $Input_ty)
					$Elevation = _Degree(ATan($Altitude / $Range))
					$Solution = Solution($Range, $Altitude, $iSpeed)

					If $Range = 0 Then
						$Azimuth = ""
						$oAzimuth = "Ошибка"
					Else
						$Azimuth = Azimuth_to($Input_ax + Sin(_Radian($iAngle_fix)) * Sin(_Radian($iAzimuth_fix)) * $Plat_h, $Input_ay + Sin(_Radian($iAngle_fix)) * Cos(_Radian($iAzimuth_fix)) * $Plat_h, $Input_tx, $Input_ty)
						$oAzimuth = StringFormat("%.1f", $Azimuth)
					EndIf

					$Solution_fix_0 = Angle_fix($Azimuth, $Elevation, $iAzimuth_fix, $iAngle_fix, $Solution[0])
					$Solution_fix_1 = Angle_fix($Azimuth, $Elevation, $iAzimuth_fix, $iAngle_fix, $Solution[1])

					$oAltitude = StringFormat("%.2f", Elevation($Azimuth, $Elevation, $iAzimuth_fix, $iAngle_fix))
					If Not StringIsFloat($oAltitude) Or $oAltitude > 90 Or $oAltitude < -90 Then $oAltitude = "Ошибка"

					$oSolution_0 = StringFormat("%.2f", $Solution_fix_0)
					If Not StringIsFloat($oSolution_0) Then $oSolution_0 = "Ошибка"
					$oTime_0 = Round(Time_to($Range, $iSpeed, $Solution[0]), 0)
					If Not StringIsDigit($oTime_0) Then $oTime_0 = "Ошибка"

					$oSolution_1 = StringFormat("%.2f", $Solution_fix_1)
					If Not StringIsFloat($oSolution_1) Then $oSolution_1 = "Ошибка"
					$oTime_1 = Round(Time_to($Range, $iSpeed, $Solution[1]), 0)
					If Not StringIsDigit($oTime_1) Then $oTime_1 = "Ошибка"

					GUICtrlSetData($Label_range, "Дальность:      " & Round($Range, 0))
					GUICtrlSetData($Label_altitude, "Угломер:          " & $oAltitude)
					GUICtrlSetData($Label_azimut, "Азимут:            " & $oAzimuth)

					GUICtrlSetData($Label_solution_0, "Навесная:        " & $oSolution_0)
					GUICtrlSetData($Label_solution_0_ETA, "Время:             " & $oTime_0)

					GUICtrlSetData($Label_solution_1, "Настильная:    " & $oSolution_1)
					GUICtrlSetData($Label_solution_1_ETA, "Время:             " & $oTime_1)
					If $Hit_Counter < 64 Then $HitLock = False
				Else
					MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Неверно введён квадрат цели или позиции")
					WinActivate($hGUI_main)
				EndIf
			Case $hButton2
				$iAzimuth_fix = GUICtrlRead($Input7) & "." & GUICtrlRead($Input8)
				$iAngle_fix = GUICtrlRead($Input9) & "." & GUICtrlRead($Input10)
				GUISetState(@SW_DISABLE, $hGUI_main)
				GUI_position()
			Case $hButton10
				GUICtrlSetState($hButton1, $GUI_DISABLE)
				GUICtrlSetState($hButton2, $GUI_DISABLE)
				GUICtrlSetState($hButton10, $GUI_DISABLE)
				GUICtrlSetState($hButton11, $GUI_DISABLE)
				GUICtrlSetState($Slider1, $GUI_DISABLE)
				GUICtrlSetState($Slider2, $GUI_DISABLE)
				GUICtrlSetState($Input1, $GUI_DISABLE)
				GUICtrlSetState($Input2, $GUI_DISABLE)
				GUICtrlSetState($Input7, $GUI_DISABLE)
				GUICtrlSetState($Input8, $GUI_DISABLE)
				GUICtrlSetState($Input9, $GUI_DISABLE)
				GUICtrlSetState($Input10, $GUI_DISABLE)
				MsgBox(BitOR($MB_ICONINFORMATION, $MB_TOPMOST), "Таблица скоростей", "Калибр: Заряд 1 / Заряд 2 / Заряд 3 / Заряд 4 / Заряд 5 " & @CRLF & @CRLF & "82мм: 70.000 / 140.000 / 200.000 / --- / --- " & @CRLF & "155мм: 153.900 / 243.000 / 388.800 / 648.000 / 810.000 " & @CRLF & "230мм: 212.500 / 425.000 / 637.500 / 772.500 / --- ")
				GUICtrlSetState($hButton1, $GUI_ENABLE)
				GUICtrlSetState($hButton2, $GUI_ENABLE)
				GUICtrlSetState($hButton10, $GUI_ENABLE)
				GUICtrlSetState($hButton11, $GUI_ENABLE)
				GUICtrlSetState($Slider1, $GUI_ENABLE)
				GUICtrlSetState($Slider2, $GUI_ENABLE)
				GUICtrlSetState($Input1, $GUI_ENABLE)
				GUICtrlSetState($Input2, $GUI_ENABLE)
				GUICtrlSetState($Input7, $GUI_ENABLE)
				GUICtrlSetState($Input8, $GUI_ENABLE)
				GUICtrlSetState($Input9, $GUI_ENABLE)
				GUICtrlSetState($Input10, $GUI_ENABLE)
				WinActivate($hGUI_main)
			Case $Slider1
				GUICtrlSetPos($Graphic2, 186 + GUICtrlRead($Slider1) * 2.98, 334 - GUICtrlRead($Slider2) * -2.98)
			Case $Slider2
				GUICtrlSetPos($Graphic2, 186 + GUICtrlRead($Slider1) * 2.98, 334 - GUICtrlRead($Slider2) * -2.98)
			Case $hButton11
				If $HitLock = False Then
					$tInput_tx = (StringLeft(GUICtrlRead($Input1), 3) * 100) + (GUICtrlRead($Slider1))
					$tInput_ty = (StringRight(GUICtrlRead($Input1), 3) * 100) + (GUICtrlRead($Slider2) * -1)
					$tAltitude = GUICtrlRead($Input2) - $Input_aalt - Cos(_Radian($iAngle_fix)) * $Plat_h
					$tRange = Range_finder($Input_ax + Sin(_Radian($iAngle_fix)) * Sin(_Radian($iAzimuth_fix)) * $Plat_h, $Input_ay + Sin(_Radian($iAngle_fix)) * Cos(_Radian($iAzimuth_fix)) * $Plat_h, $tInput_tx, $tInput_ty)
					If $tRange = 0 Then
						$tAzimuth = ""
						$tElevation = ""
					Else
						$tAzimuth = Azimuth_to($Input_ax + Sin(_Radian($iAngle_fix)) * Sin(_Radian($iAzimuth_fix)) * $Plat_h, $Input_ay + Sin(_Radian($iAngle_fix)) * Cos(_Radian($iAzimuth_fix)) * $Plat_h, $tInput_tx, $tInput_ty)
						$tElevation = _Degree(ATan($tAltitude / $tRange))
					EndIf
					$tSolution = Solution($tRange, $tAltitude, $iSpeed)

					If (StringIsFloat($Solution[0]) Or StringIsDigit($Solution[0])) And ((StringIsFloat($tSolution[0]) Or StringIsDigit($tSolution[0])) Or (StringIsFloat($tSolution[1]) Or StringIsDigit($tSolution[1]))) And ($Range > 0 Or $tRange > 0) Then
						$mbresult = MsgBox(BitOR($MB_YESNOCANCEL, $MB_ICONQUESTION, $MB_DEFBUTTON3, $MB_TASKMODAL, $MB_TOPMOST), "Внимание", "Произведён навесной выстрел?")
						Select
							Case $mbresult = $IDYES
								If (StringIsFloat($Solution[0]) Or StringIsDigit($Solution[0])) And (StringIsFloat($tSolution[0]) Or StringIsDigit($tSolution[0])) Then
									$Hit_Array[$Hit_Counter][0] = $tAzimuth
									$Hit_Array[$Hit_Counter][1] = $tElevation
									$Hit_Array[$Hit_Counter][2] = $tSolution[0]
									$Hit_Array[$Hit_Counter][3] = $Solution_fix_0
									$Hit_Counter += 1
									$HitLock = True
								Else
									MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Рассчитан невозможный навесной выстрел")
								EndIf
							Case $mbresult = $IDNO
								If (StringIsFloat($Solution[1]) Or StringIsDigit($Solution[1])) And (StringIsFloat($tSolution[1]) Or StringIsDigit($tSolution[1])) Then
									$Hit_Array[$Hit_Counter][0] = $tAzimuth
									$Hit_Array[$Hit_Counter][1] = $tElevation
									$Hit_Array[$Hit_Counter][2] = $tSolution[1]
									$Hit_Array[$Hit_Counter][3] = $Solution_fix_1
									$Hit_Counter += 1
									$HitLock = True
								Else
									MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Рассчитан невозможный настильный выстрел")
								EndIf
						EndSelect
						GUICtrlSetData($Input1, $Square_tx & $Square_ty)
						GUICtrlSetData($Input2, $Input_talt)
						GUICtrlSetData($Slider1, $Square_ptx)
						GUICtrlSetData($Slider2, $Square_pty)
						GUICtrlSetPos($Graphic2, 186 + GUICtrlRead($Slider1) * 2.98, 334 - GUICtrlRead($Slider2) * -2.98)
					Else
						MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Рассчитаны невозможные выстрелы")
					EndIf
				Else
					If $Hit_Counter < 64 Then
						MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Блокировка", "Не произвёден рассчёт выстрела")
					Else
						MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Достигнут предел массива коррекции, максимум 64")
					EndIf
				EndIf
				WinActivate($hGUI_main)
		EndSwitch
	WEnd
EndFunc   ;==>GUI_main

Func GUI_position()
	Local Const $cfg_fAzimuthStep = 16, $cfg_precision_az = 4
	Local Const $cfg_fAngleStep = 1, $cfg_precision_an = 0.25
	Local $iter = 1, $fAzimuth, $fAngle, $Solution_delta_old, $fUp_az, $fUp_an, $fAngle_a[2], $fAzimuth_a[2], $Old_square
	Local $fAzimuthStep, $precision_az, $fAngleStep, $precision_an

	$hGUI_position = GUICreate("Установка позиции батареи", 400, 440)
	$hButton3 = GUICtrlCreateButton("Установить", 10, 400, 80, 30)
	$hButton4 = GUICtrlCreateButton("Угловая привязка", 100, 400, 100, 30)
	$hButton12 = GUICtrlCreateButton("Сбросить массив", 205, 400, 100, 30)
	$hButton13 = GUICtrlCreateButton("Коррекция", 310, 400, 80, 30)
	$hLockPos = GUICtrlCreateCheckbox("Блок.", 10, 380, 60, 20)
	$Label_error = GUICtrlCreateLabel("Среднеквадратическое отклонение: Нет данных", 135, 381, 300, 20, $SS_LEFT)

	$Input15 = GUICtrlCreateInput($Plat_h * 100, 20, 10, 30, 20, $ES_NUMBER)
	GUICtrlCreateLabel("H:", 10, 13, 10, 20, $SS_LEFT)
	$Input16 = GUICtrlCreateInput($Plat_l * 100, 60, 10, 30, 20, $ES_NUMBER)
	GUICtrlCreateLabel("L:", 50, 13, 10, 20, $SS_LEFT)

	$Slider3 = GUICtrlCreateSlider(78, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider3, 100, 0)

	$Slider4 = GUICtrlCreateSlider(48, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider4, 0, -100)

	$Input3 = GUICtrlCreateInput("", 340, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Квадрат:", 280, 13, 50, 20, $SS_LEFT)

	$Input4 = GUICtrlCreateInput("", 200, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Высота:", 140, 13, 50, 20, $SS_LEFT)

	$Graphic3 = GUICtrlCreateGraphic(90, 40)
	GUICtrlSetGraphic($Graphic3, $GUI_GR_RECT, 0, 0, 300, 300)

	$Graphic4 = GUICtrlCreateGraphic(86, 334)
	GUICtrlSetGraphic($Graphic4, $GUI_GR_ELLIPSE, 0, 0, 10, 10)

	GUICtrlSetData($Input3, StringLeft($Square_ax, 3) & StringLeft($Square_ay, 3))
	GUICtrlSetData($Input4, $Input_aalt)
	If $Square_pax Then
		GUICtrlSetData($Slider3, $Square_pax)
	Else
		GUICtrlSetData($Slider3, 50)
	EndIf
	If $Square_pay Then
		GUICtrlSetData($Slider4, $Square_pay)
	Else
		GUICtrlSetData($Slider4, -50)
	EndIf
	GUICtrlSetPos($Graphic4, 86 + GUICtrlRead($Slider3) * 2.98, 334 - GUICtrlRead($Slider4) * -2.98)

	If Not $Solution_delta Then
		GUICtrlSetData($Label_error, "Среднеквадратическое отклонение: Нет данных")
	Else
		GUICtrlSetData($Label_error, "Среднеквадратическое отклонение: " & StringFormat("%.4f", $Solution_delta))
	EndIf

	If $LockPos = 1 Then
		GUICtrlSetState($Slider3, $GUI_DISABLE)
		GUICtrlSetState($Slider4, $GUI_DISABLE)
		GUICtrlSetState($Input3, $GUI_DISABLE)
		GUICtrlSetState($Input4, $GUI_DISABLE)
		GUICtrlSetState($hButton3, $GUI_DISABLE)
		GUICtrlSetState($Input15, $GUI_DISABLE)
		GUICtrlSetState($Input16, $GUI_DISABLE)
		GUICtrlSetState($hLockPos, $LockPos)
	Else
		GUICtrlSetState($Slider3, $GUI_ENABLE)
		GUICtrlSetState($Slider4, $GUI_ENABLE)
		GUICtrlSetState($Input3, $GUI_ENABLE)
		GUICtrlSetState($Input4, $GUI_ENABLE)
		GUICtrlSetState($Input4, $GUI_ENABLE)
		GUICtrlSetState($hButton3, $GUI_ENABLE)
		GUICtrlSetState($Input15, $GUI_ENABLE)
		GUICtrlSetState($Input16, $GUI_ENABLE)
		GUICtrlSetState($hLockPos, $LockPos)
	EndIf

	If $Hit_Counter > 2 Then
		GUICtrlSetState($hButton4, $GUI_DISABLE)
	Else
		GUICtrlSetState($hButton4, $GUI_ENABLE)
	EndIf

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_DISABLE, $hGUI_position)
				GUISetState(@SW_ENABLE, $hGUI_main)
				WinActivate($hGUI_main)
				GUIDelete($hGUI_position)
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
				Else
					MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Неверно введён квадрат позиции")
					WinActivate($hGUI_position)
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
					$Plat_h = GUICtrlRead($Input15) / 100
					$Plat_l = GUICtrlRead($Input16) / 100
					GUISetState(@SW_DISABLE, $hGUI_position)
					GUI_angle()
				Else
					MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Неверно введён квадрат позиции")
					WinActivate($hGUI_position)
				EndIf
			Case $Input15
				$Plat_h = GUICtrlRead($Input15) / 100
			Case $Input16
				$Plat_l = GUICtrlRead($Input16) / 100
			Case $Slider3
				GUICtrlSetPos($Graphic4, 86 + GUICtrlRead($Slider3) * 2.98, 334 - GUICtrlRead($Slider4) * -2.98)
			Case $Slider4
				GUICtrlSetPos($Graphic4, 86 + GUICtrlRead($Slider3) * 2.98, 334 - GUICtrlRead($Slider4) * -2.98)
			Case $hButton12
				$mbresult = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION, $MB_DEFBUTTON2, $MB_TASKMODAL, $MB_TOPMOST), "Внимание", "Сбросить массив коррекции?")
				If $mbresult = $IDYES Then
					$Hit_Counter = 0
					$Solution_delta = ""
					GUICtrlSetData($Label_error, "Среднеквадратическое отклонение: Нет данных")
					GUICtrlSetState($hButton4, $GUI_ENABLE)
				EndIf
				WinActivate($hGUI_position)
			Case $hButton13
				HotKeySet("{ESC}", "Interupter_pos")
				GUISetState(@SW_DISABLE, $hGUI_position)
				$fAzimuthStep = $cfg_fAzimuthStep
				$precision_az = $cfg_precision_az
				$fAngleStep = $cfg_fAngleStep
				$precision_an = $cfg_precision_an
				$fUp_az = True
				$fUp_an = True
				If $Hit_Counter > 2 Then
					$fAzimuth = GUICtrlRead($Input7) & "." & GUICtrlRead($Input8)
					If $fAzimuth = "." Then $fAzimuth = 180
					$fAngle = GUICtrlRead($Input9) & "." & GUICtrlRead($Input10)
					If $fAngle = "." Or $fAngle = 0 Then $fAngle = 0.125
					$Solution_delta = 0
					For $i = 0 To $Hit_Counter - 1
						$Solution_delta += ($Hit_Array[$i][2] - $Hit_Array[$i][1]) ^ 2
					Next
					$Solution_delta = Sqrt($Solution_delta / $Hit_Counter)
					Do
						Do
							Do
								If $Interupt = True Then
									$Interupt = False
									ExitLoop 3
								EndIf
								$Solution_delta_old = $Solution_delta
								If $fUp_az = True Then
									$fAzimuth += $fAzimuthStep
								Else
									$fAzimuth -= $fAzimuthStep
								EndIf
								Select
									Case $fAzimuth < 0
										$fAzimuth += 360
									Case $fAzimuth >= 360
										$fAzimuth -= 360
								EndSelect
								$Solution_delta = 0
								For $i = 0 To $Hit_Counter - 1
									$Solution_delta += ($Hit_Array[$i][3] - Angle_fix($Hit_Array[$i][0], $Hit_Array[$i][1], $fAzimuth, $fAngle, $Hit_Array[$i][2])) ^ 2
								Next
								$Solution_delta = Sqrt($Solution_delta / $Hit_Counter)
							Until $Solution_delta > $Solution_delta_old
							$fAzimuthStep /= 2
							If $fUp_az = True Then
								$fUp_az = False
							Else
								$fUp_az = True
							EndIf
						Until $fAzimuthStep < $precision_az
						Do
							Do
								If $Interupt = True Then
									$Interupt = False
									ExitLoop 3
								EndIf
								$Solution_delta_old = $Solution_delta
								If $fUp_an = True Then
									$fAngle += $fAngleStep
								Else
									$fAngle -= $fAngleStep
								EndIf
								If $fAngle < 0 Then
									$fAngle *= -1
									$fUp_an = True
									If $fAzimuth < 180 Then
										$fAzimuth += 180
									Else
										$fAzimuth -= 180
									EndIf
								EndIf
								If $fAngle >= 90 Then
									$fAngle -= 90
									If $fAzimuth < 180 Then
										$fAzimuth += 180
									Else
										$fAzimuth -= 180
									EndIf
								EndIf
								$Solution_delta = 0
								For $i = 0 To $Hit_Counter - 1
									$Solution_delta += ($Hit_Array[$i][3] - Angle_fix($Hit_Array[$i][0], $Hit_Array[$i][1], $fAzimuth, $fAngle, $Hit_Array[$i][2])) ^ 2
								Next
								$Solution_delta = Sqrt($Solution_delta / $Hit_Counter)
							Until $Solution_delta > $Solution_delta_old
							$fAngleStep /= 2
							If $fUp_an = True Then
								$fUp_an = False
							Else
								$fUp_an = True
							EndIf
						Until $fAngleStep < $precision_an
						$fAzimuthStep = $cfg_fAzimuthStep / $iter
						$precision_az = $cfg_precision_az / $iter
						$fAngleStep = $cfg_fAngleStep / $iter
						$precision_an = $cfg_precision_an / $iter
						$iter *= 2
					Until $precision_az < 0.00001
					HotKeySet("{ESC}")
					$mbresult = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION, $MB_DEFBUTTON2, $MB_TASKMODAL, $MB_TOPMOST), "Внимание", "Внести коррекцию?" & @CRLF & @CRLF & @CRLF & "Азимут: " & Round($fAzimuth, 3) & @CRLF & "Угол: " & Round($fAngle, 3) & @CRLF & @CRLF & "Ошибка: " & Round($Solution_delta, 3))
					If $mbresult = $IDYES Then
						$iAzimuth_fix = Round($fAzimuth, 3)
						$iAngle_fix = Round($fAngle, 3)
						If StringIsFloat($iAzimuth_fix) Then
							$for_iAz = StringSplit($iAzimuth_fix, ".")
							GUICtrlSetData($Input7, $for_iAz[1])
							GUICtrlSetData($Input8, $for_iAz[2])
						Else
							GUICtrlSetData($Input7, $iAzimuth_fix)
							GUICtrlSetData($Input8, "")
						EndIf
						If StringIsFloat($iAngle_fix) Then
							$for_iAn = StringSplit($iAngle_fix, ".")
							GUICtrlSetData($Input9, $for_iAn[1])
							GUICtrlSetData($Input10, $for_iAn[2])
						Else
							GUICtrlSetData($Input9, $iAngle_fix)
							GUICtrlSetData($Input10, "")
						EndIf
						GUICtrlSetData($Label_error, "Среднеквадратическое отклонение: " & StringFormat("%.4f", $Solution_delta))
					EndIf
				Else
					MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Недостаточно данных, минимально 3")
				EndIf
				GUISetState(@SW_ENABLE, $hGUI_position)
				WinActivate($hGUI_position)
			Case $hLockPos
				$LockPos = GUICtrlRead($hLockPos)
				If $LockPos = 1 Then
					GUICtrlSetState($Slider3, $GUI_DISABLE)
					GUICtrlSetState($Slider4, $GUI_DISABLE)
					GUICtrlSetState($Input3, $GUI_DISABLE)
					GUICtrlSetState($Input4, $GUI_DISABLE)
					GUICtrlSetState($hButton3, $GUI_DISABLE)
					GUICtrlSetState($Input15, $GUI_DISABLE)
					GUICtrlSetState($Input16, $GUI_DISABLE)
				Else
					GUICtrlSetState($Slider3, $GUI_ENABLE)
					GUICtrlSetState($Slider4, $GUI_ENABLE)
					GUICtrlSetState($Input3, $GUI_ENABLE)
					GUICtrlSetState($Input4, $GUI_ENABLE)
					GUICtrlSetState($Input4, $GUI_ENABLE)
					GUICtrlSetState($hButton3, $GUI_ENABLE)
					GUICtrlSetState($Input15, $GUI_ENABLE)
					GUICtrlSetState($Input16, $GUI_ENABLE)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>GUI_position

Func GUI_angle()
	Local Const $cfg_fAzimuthStep = 16, $cfg_precision_az = 4
	Local Const $cfg_fAngleStep = 1, $cfg_precision_an = 0.25
	Local $iter = 1, $fAzimuth, $fAngle, $Solution_delta_old, $fUp_az, $fUp_an, $fAngle_a[2], $fAzimuth_a[2], $Old_square
	Local $fAzimuthStep, $precision_az, $fAngleStep, $precision_an

	$Angle_Counter = 0

	$hGUI_angle = GUICreate("Коррекция по углам", 400, 440)

	$hButton5 = GUICtrlCreateButton("Рассчитать", 10, 400, 80, 30)

	$hButton6 = GUICtrlCreateButton("Ввод", 200, 400, 60, 30)

	$Slider5 = GUICtrlCreateSlider(78, 350, 324, 30, BitOR($TBS_TOP, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider5, 100, 0)
	GUICtrlSetData($Slider5, 50)

	$Slider6 = GUICtrlCreateSlider(48, 28, 30, 324, BitOR($TBS_VERT, $TBS_AUTOTICKS))
	GUICtrlSetLimit($Slider6, 0, -100)
	GUICtrlSetData($Slider6, -50)

	$Input11 = GUICtrlCreateInput("", 340, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Квадрат:", 280, 13, 50, 20, $SS_LEFT)

	$Input12 = GUICtrlCreateInput("", 200, 10, 45, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Высота:", 140, 13, 50, 20, $SS_LEFT)

	$Input13 = GUICtrlCreateInput("", 120, 405, 45, 20, $ES_NUMBER)
	$Input14 = GUICtrlCreateInput("", 170, 405, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Угол:", 120, 385, 52, 20, $SS_LEFT)
	$hButton8 = GUICtrlCreateButton("-", 100, 405, 20, 20)

	$Graphic8 = GUICtrlCreateGraphic(90, 40)
	GUICtrlSetGraphic($Graphic8, $GUI_GR_RECT, 0, 0, 300, 300)

	$Graphic9 = GUICtrlCreateGraphic(86, 334)
	GUICtrlSetGraphic($Graphic9, $GUI_GR_ELLIPSE, 0, 0, 10, 10)
	GUICtrlSetPos($Graphic9, 86 + GUICtrlRead($Slider5) * 2.98, 334 - GUICtrlRead($Slider6) * -2.98)

	$Graphic10 = GUICtrlCreateGraphic(167, 420)
	GUICtrlSetGraphic($Graphic10, $GUI_GR_DOT, 0, 0)

	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_DISABLE, $hGUI_angle)
				GUISetState(@SW_ENABLE, $hGUI_position)
				WinActivate($hGUI_position)
				GUIDelete($hGUI_angle)
				ExitLoop
			Case $hButton5
				HotKeySet("{ESC}", "Interupter_ang")
				GUISetState(@SW_DISABLE, $hGUI_angle)
				$fAzimuthStep = $cfg_fAzimuthStep
				$precision_az = $cfg_precision_az
				$fAngleStep = $cfg_fAngleStep
				$precision_an = $cfg_precision_an
				$fUp_az = True
				$fUp_an = True
				If $Angle_Counter > 2 Then
					$fAzimuth = GUICtrlRead($Input7) & "." & GUICtrlRead($Input8)
					If $fAzimuth = "." Then $fAzimuth = 180
					$fAngle = GUICtrlRead($Input9) & "." & GUICtrlRead($Input10)
					If $fAngle = "." Or $fAngle = 0 Then $fAngle = 0.125
					$Solution_delta = 0
					For $i = 0 To $Angle_Counter - 1
						$Solution_delta += ($Angle_Array[$i][2] - Elevation($Angle_Array[$i][0], $Angle_Array[$i][1], $fAzimuth, $fAngle)) ^ 2
					Next
					$Solution_delta = Sqrt($Solution_delta / $Angle_Counter)
					Do
						Do
							Do
								If $Interupt = True Then
									$Interupt = False
									ExitLoop 3
								EndIf
								$Solution_delta_old = $Solution_delta
								If $fUp_az = True Then
									$fAzimuth += $fAzimuthStep
								Else
									$fAzimuth -= $fAzimuthStep
								EndIf
								Select
									Case $fAzimuth < 0
										$fAzimuth += 360
									Case $fAzimuth >= 360
										$fAzimuth -= 360
								EndSelect
								$Solution_delta = 0
								For $i = 0 To $Angle_Counter - 1
									$Solution_delta += ($Angle_Array[$i][2] - Elevation($Angle_Array[$i][0], $Angle_Array[$i][1], $fAzimuth, $fAngle)) ^ 2
								Next
								$Solution_delta = Sqrt($Solution_delta / $Angle_Counter)
							Until $Solution_delta > $Solution_delta_old
							$fAzimuthStep /= 2
							If $fUp_az = True Then
								$fUp_az = False
							Else
								$fUp_az = True
							EndIf
						Until $fAzimuthStep < $precision_az
						Do
							Do
								If $Interupt = True Then
									$Interupt = False
									ExitLoop 3
								EndIf
								$Solution_delta_old = $Solution_delta
								If $fUp_an = True Then
									$fAngle += $fAngleStep
								Else
									$fAngle -= $fAngleStep
								EndIf
								If $fAngle < 0 Then
									$fAngle *= -1
									$fUp_an = True
									If $fAzimuth < 180 Then
										$fAzimuth += 180
									Else
										$fAzimuth -= 180
									EndIf
								EndIf
								If $fAngle >= 90 Then
									$fAngle -= 90
									If $fAzimuth < 180 Then
										$fAzimuth += 180
									Else
										$fAzimuth -= 180
									EndIf
								EndIf
								$Solution_delta = 0
								For $i = 0 To $Angle_Counter - 1
									$Solution_delta += ($Angle_Array[$i][2] - Elevation($Angle_Array[$i][0], $Angle_Array[$i][1], $fAzimuth, $fAngle)) ^ 2
								Next
								$Solution_delta = Sqrt($Solution_delta / $Angle_Counter)
							Until $Solution_delta > $Solution_delta_old
							$fAngleStep /= 2
							If $fUp_an = True Then
								$fUp_an = False
							Else
								$fUp_an = True
							EndIf
						Until $fAngleStep < $precision_an
						$fAzimuthStep = $cfg_fAzimuthStep / $iter
						$precision_az = $cfg_precision_az / $iter
						$fAngleStep = $cfg_fAngleStep / $iter
						$precision_an = $cfg_precision_an / $iter
						$iter *= 2
					Until $precision_az < 0.00001
					HotKeySet("{ESC}")
					$mbresult = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION, $MB_DEFBUTTON2, $MB_TASKMODAL, $MB_TOPMOST), "Внимание", "Внести коррекцию?" & @CRLF & @CRLF & @CRLF & "Азимут: " & Round($fAzimuth, 3) & @CRLF & "Угол: " & Round($fAngle, 3) & @CRLF & @CRLF & "Ошибка: " & Round($Solution_delta, 3))
					If $mbresult = $IDYES Then
						$iAzimuth_fix = Round($fAzimuth, 3)
						$iAngle_fix = Round($fAngle, 3)
						If StringIsFloat($iAzimuth_fix) Then
							$for_iAz = StringSplit($iAzimuth_fix, ".")
							GUICtrlSetData($Input7, $for_iAz[1])
							GUICtrlSetData($Input8, $for_iAz[2])
						Else
							GUICtrlSetData($Input7, $iAzimuth_fix)
							GUICtrlSetData($Input8, "")
						EndIf
						If StringIsFloat($iAngle_fix) Then
							$for_iAn = StringSplit($iAngle_fix, ".")
							GUICtrlSetData($Input9, $for_iAn[1])
							GUICtrlSetData($Input10, $for_iAn[2])
						Else
							GUICtrlSetData($Input9, $iAngle_fix)
							GUICtrlSetData($Input10, "")
						EndIf
					EndIf
				Else
					MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Недостаточно данных, минимально 3")
				EndIf
				GUISetState(@SW_ENABLE, $hGUI_angle)
				WinActivate($hGUI_angle)
			Case $hButton6
				If StringLen(GUICtrlRead($Input11)) = 6 And $Angle_Counter < 64 And GUICtrlRead($Input11) <> $Old_square Then
					$aSquare_x = StringLeft(GUICtrlRead($Input11), 3)
					$aSquare_y = StringRight(GUICtrlRead($Input11), 3)
					$aSquare_px = GUICtrlRead($Slider5)
					$aSquare_py = GUICtrlRead($Slider6)
					$aInput_x = ($aSquare_x * 100) + ($aSquare_px)
					$aInput_y = ($aSquare_y * 100) + ($aSquare_py * -1)
					$aAltitude = GUICtrlRead($Input12) - $Input_aalt - Cos(_Radian($iAngle_fix)) * $Plat_h
					$aRange = Range_finder($Input_ax + Sin(_Radian($iAngle_fix)) * Sin(_Radian($iAzimuth_fix)) * $Plat_h, $Input_ay + Sin(_Radian($iAngle_fix)) * Cos(_Radian($iAzimuth_fix)) * $Plat_h, $aInput_x, $aInput_y)
					$aAzimuth = Azimuth_to($Input_ax + Sin(_Radian($iAngle_fix)) * Sin(_Radian($iAzimuth_fix)) * $Plat_h, $Input_ay + Sin(_Radian($iAngle_fix)) * Cos(_Radian($iAzimuth_fix)) * $Plat_h, $aInput_x, $aInput_y)
					$aElevation = _Degree(ATan($aAltitude / $aRange))
					$Angle_Array[$Angle_Counter][0] = $aAzimuth
					$Angle_Array[$Angle_Counter][1] = $aElevation
					$Angle_Array[$Angle_Counter][2] = GUICtrlRead($Input13) & "." & GUICtrlRead($Input14)
					$Old_square = GUICtrlRead($Input11)
					$Angle_Counter += 1
				Else
					MsgBox(BitOR($MB_ICONERROR, $MB_TASKMODAL, $MB_TOPMOST), "Ошибка", "Неверно введён квадрат ориентира")
				EndIf
				WinActivate($hGUI_angle)
			Case $hButton8
				GUICtrlSetData($Input13, GUICtrlRead($Input13) * -1)
			Case $Slider5
				GUICtrlSetPos($Graphic9, 86 + GUICtrlRead($Slider5) * 2.98, 334 - GUICtrlRead($Slider6) * -2.98)
			Case $Slider6
				GUICtrlSetPos($Graphic9, 86 + GUICtrlRead($Slider5) * 2.98, 334 - GUICtrlRead($Slider6) * -2.98)
		EndSwitch
	WEnd
EndFunc   ;==>GUI_angle

Func Range_finder($Input_ax, $Input_ay, $Input_tx, $Input_ty)
	Local $Range
	$Range = Sqrt(($Input_ax - $Input_tx) ^ 2 + ($Input_ay - $Input_ty) ^ 2)
	Return $Range
EndFunc   ;==>Range_finder

Func Time_to($Range, $Velocity, $Solution)
	Local $ETA
	If $Range = 0 And (StringIsFloat($Solution) Or StringIsDigit($Solution)) Then
		$ETA = ($Velocity / $g) * 2
	Else
		$ETA = ($Range / ($Velocity * Cos(_Radian($Solution))))
	EndIf
	Return $ETA
EndFunc   ;==>Time_to

Func Azimuth_to($Input_ax, $Input_ay, $Input_tx, $Input_ty)
	Local $Input_dx, $Input_dy, $Azimuth_to
	$Input_dx = $Input_tx - $Input_ax
	$Input_dy = $Input_ty - $Input_ay
	$Azimuth_to = _Degree(ATan($Input_dy / $Input_dx))
	If $Input_dx > 0 Then
		$Azimuth_to = 90 - $Azimuth_to
	Else
		If $Input_dx < 0 Then
			$Azimuth_to = 270 - $Azimuth_to
		Else
			If $Input_dy > 0 Then
				$Azimuth_to = 0
			Else
				$Azimuth_to = 180
			EndIf
		EndIf
	EndIf
	Return $Azimuth_to
EndFunc   ;==>Azimuth_to

Func Solution($Range, $Altitude, $Velocity)
	Local $gx, $v2, $rt, $Solution[2]
	$gx = $g * $Range
	$v2 = $Velocity ^ 2
	$rt = Sqrt($v2 ^ 2 - $g * ($g * $Range ^ 2 + 2 * $Altitude * $v2))
	$Solution[0] = _Degree(ATan(($v2 + $rt) / $gx))
	$Solution[1] = _Degree(ATan(($v2 - $rt) / $gx))
	If $Plat_l = 0 Then
		Return $Solution
	Else
		$gx = $g * ($Range - Cos(_Radian($Solution[0])) * $Plat_l)
		$rt = Sqrt($v2 ^ 2 - $g * ($g * ($Range - Cos(_Radian($Solution[0])) * $Plat_l) ^ 2 + 2 * ($Altitude - Sin(_Radian($Solution[0])) * $Plat_l) * $v2))
		$Solution[0] = _Degree(ATan(($v2 + $rt) / $gx))
		$gx = $g * ($Range - Cos(_Radian($Solution[1])) * $Plat_l)
		$rt = Sqrt($v2 ^ 2 - $g * ($g * ($Range - Cos(_Radian($Solution[1])) * $Plat_l) ^ 2 + 2 * ($Altitude - Sin(_Radian($Solution[1])) * $Plat_l) * $v2))
		$Solution[1] = _Degree(ATan(($v2 - $rt) / $gx))
		Return $Solution
	EndIf
EndFunc   ;==>Solution

Func Elevation($Azimuth_to, $Angle_to, $Azimuth_fix, $Angle_fix)
	Local $gv[3], $tv[3], $Solution
	$gv[0] = 0
	$gv[1] = Sin(_Radian($Angle_fix))
	$gv[2] = Cos(_Radian($Angle_fix))

	$tv[0] = Sin(_Radian(90 - $Angle_to)) * Sin(_Radian($Azimuth_to - $Azimuth_fix))
	$tv[1] = Sin(_Radian(90 - $Angle_to)) * Cos(_Radian($Azimuth_to - $Azimuth_fix))
	$tv[2] = Cos(_Radian(90 - $Angle_to))

	$Solution = 90 - _Degree(ACos($gv[1] * $tv[1] + $gv[2] * $tv[2]))
	Return $Solution
EndFunc   ;==>Elevation

Func Angle_fix($Azimuth_to, $Angle_to, $Azimuth_fix, $Angle_fix, $Solution_to)
	Local $gv[3], $tv[3], $orv[3], $mrv, $rv[3], $rm[3][3], $rgv[3], $sv[3], $Solution, $z, $zz, $D, $Div, $daz

	$daz = $Azimuth_to - $Azimuth_fix
	While $daz < 0
		$daz += 360
	WEnd

	If Abs($Solution_to) < 0.01 Or Abs($Solution_to) > 89.99 Or $daz = 0 Or $daz = 180 Then
		$Solution = $Solution_to + Cos(_Radian($daz)) * $Angle_fix
	Else
		$gv[0] = 0
		$gv[1] = Sin(_Radian($Angle_fix))
		$gv[2] = Cos(_Radian($Angle_fix))

		$tv[0] = Sin(_Radian(90 - $Angle_to)) * Sin(_Radian($daz))
		$tv[1] = Sin(_Radian(90 - $Angle_to)) * Cos(_Radian($daz))
		$tv[2] = Cos(_Radian(90 - $Angle_to))

		$orv[0] = $gv[1] * $tv[2] - $gv[2] * $tv[1]
		$orv[1] = $gv[2] * $tv[0] - $gv[0] * $tv[2]
		$orv[2] = $gv[0] * $tv[1] - $gv[1] * $tv[0]
		$mrv = Sqrt($orv[0] ^ 2 + $orv[1] ^ 2 + $orv[2] ^ 2)
		$rv[0] = $orv[0] / $mrv
		$rv[1] = $orv[1] / $mrv
		$rv[2] = $orv[2] / $mrv

		$rm[0][0] = $rv[0] ^ 2
		$rm[0][1] = $rv[0] * $rv[1] - $rv[2]
		$rm[0][2] = $rv[0] * $rv[2] + $rv[1]
		$rm[1][0] = $rv[0] * $rv[1] + $rv[2]
		$rm[1][1] = $rv[1] ^ 2
		$rm[1][2] = $rv[1] * $rv[2] - $rv[0]
		$rm[2][0] = $rv[0] * $rv[2] - $rv[1]
		$rm[2][1] = $rv[1] * $rv[2] + $rv[0]
		$rm[2][2] = $rv[2] ^ 2

		$rgv[0] = $gv[0] * $rm[0][0] + $gv[1] * $rm[0][1] + $gv[2] * $rm[0][2]
		$rgv[1] = $gv[0] * $rm[1][0] + $gv[1] * $rm[1][1] + $gv[2] * $rm[1][2]
		$rgv[2] = $gv[0] * $rm[2][0] + $gv[1] * $rm[2][1] + $gv[2] * $rm[2][2]

		$sv[2] = Cos(_Radian(90 - $Solution_to))
		$zz = Tan(_Radian($Solution_to))

		$D = Sqrt(-$zz ^ 2 * $rv[2] ^ 2 + $rv[0] ^ 2 + $rv[1] ^ 2)
		$Div = $zz * ($rv[0] ^ 2 + $rv[1] ^ 2)

		$sv[0] = $sv[2] * ($rv[1] * $D - $zz * $rv[0] * $rv[2]) / $Div
		$sv[1] = -$sv[2] * ($rv[0] * $D + $zz * $rv[1] * $rv[2]) / $Div

		$Solution = _Degree(ACos($rgv[0] * $sv[0] + $rgv[1] * $sv[1] + $rgv[2] * $sv[2]))
		If $sv[2] < $rgv[2] Then $Solution *= -1
	EndIf
	Return $Solution
EndFunc   ;==>Angle_fix

Func Interupter_pos()
	$mbresult = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION, $MB_DEFBUTTON2, $MB_TASKMODAL, $MB_TOPMOST), "Внимание", "Прервать итерации?")
	If $mbresult = $IDYES Then $Interupt = True
	WinActivate($hGUI_position)
EndFunc   ;==>Interupter_pos

Func Interupter_ang()
	$mbresult = MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION, $MB_DEFBUTTON2, $MB_TASKMODAL, $MB_TOPMOST), "Внимание", "Прервать итерации?")
	If $mbresult = $IDYES Then $Interupt = True
	WinActivate($hGUI_angle)
EndFunc   ;==>Interupter_ang

