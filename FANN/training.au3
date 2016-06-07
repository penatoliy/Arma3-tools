#include "_Fann.au3"

Global $InputsArray[6][2] = [[2100/6200, (4-17)/350], [2100/6200, (71-17)/350], [5000/6200, (59-17)/350], [5700/6200, (90-17)/350], [5975/6200, (55-17)/350], [6000/6200, (22-17)/350]]
Global $OutputsArray[6][1] = [[79.87/80], [79.71/80], [61.59/80], [53.44/80], [56.79/80], [47.44/80]]
Local $ANNLayers[4] = [2, 5, 3, 1]
_InitializeANN()
$Ann = _CreateAnn(4, $ANNLayers)
_ANNSetActivationFunctionHidden($Ann, $FANN_SIGMOID_SYMMETRIC)
_ANNSetActivationFunctionOutput($Ann, $FANN_SIGMOID_SYMMETRIC)
_ANNTrainOnData($Ann, $InputsArray, $OutputsArray, 5000, 10, 0.00001)
_ANNSaveToFile($Ann, "xor_float.net")
_DestroyANN($Ann)
_CloseANN()