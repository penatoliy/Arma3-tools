#include "_Fann.au3"

Local $myInputs[2] = [5733/6200, (212-17)/350]
_InitializeANN()
$hAnn = _ANNCreateFromFile("xor_float.net")
$calc_out = _ANNRun($hAnn, $myInputs)
MsgBox(0, "Solution", "Range: " & $myInputs[0]*6500 & ", Altitude:" & $myInputs[1]*350 & @CRLF & $calc_out[0]*80)
_DestroyANN($hAnn)
_CloseANN()