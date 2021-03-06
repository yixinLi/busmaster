;=== Test Cases/Test Data ===
; Module			:		Database Editor
; Critical (C)		:		Y
; TestCase No.		:		1
; TestCases			:		Delete Signal
; Test Strategy		:		Black Box
; Test Data			:		-
; === Test Procedure ===

ConsoleWrite(@CRLF)
ConsoleWrite(@CRLF)
ConsoleWrite("****Start : TS_DBE_11.au3****"&@CRLF)

_launchApp()
if $app=0 Then
	_openCANDB("testDBE_01")
	$sigDetlvhwd=controlgethandle($WIN_BUSMASTER,"",$LVC_SigDet_DBeditor)								; Get handle of signal details list view
	_GUICtrlListView_ClickItem($sigDetlvhwd,0)											; Click on the first item in the Signal details list view
	sleep(500)
	$DelSignalDescRes=_DelSignalDesc()													; Delete signal desc
	$sigDesclvhwd=controlgethandle($WIN_BUSMASTER,"",$LVC_SigDesc_SigDesc)							; Get handle of signal details list view
	$signalDescCount=_GUICtrlListView_GetItemCount($sigDesclvhwd)						; Fetch the count of signal desc items
EndIf

WinActivate($WIN_BUSMASTER,3)
if winexists($WIN_BUSMASTER) then
	$sigDetlvhwd=controlgethandle($WIN_BUSMASTER,"",$LVC_SigDet_DBeditor)								; Get handle of signal details list view
	_GUICtrlListView_ClickItem($sigDetlvhwd,0)											; Click on the first item in the Signal details list view
	controlclick($WIN_BUSMASTER,"",$BTN_DeleteSig_DBEditor)												; Click Yes button
	sleep(1000)
	if winexists($DLG_Busmaster,$sigDelmsgtxt) Then
		ControlClick($DLG_Busmaster,"",$BTN_Yes_BM)									; Click on 'Yes' button
	EndIf
	$signalCount=_GUICtrlListView_GetItemCount($sigDetlvhwd)							; Fetch the signal count
	consolewrite("$signalCount : " & $signalCount & @Crlf)
EndIf
if $signalCount=0 Then
	_ExcelWriteCell($oExcel, "Pass", 16, 2)
Else
	_ExcelWriteCell($oExcel, "Fail", 16, 2)
EndIf

ConsoleWrite("****End : TS_DBE_11.au3****"&@CRLF)
ConsoleWrite(@CRLF)