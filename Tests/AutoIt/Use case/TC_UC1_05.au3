;=== Test Cases/Test Data ===
; UseCase 1:		transmit CAN Messages
; Critical (C):		Y
; Test Cases:		Message Transmission
; Test Strategy:	Black Box
; Test Data:		-
; === Test Procedure ===
#Include <GuiListView.au3>
$sendMsg1=0
$recMsg1=0
$sendMsg2=0
$recMsg1=0

ConsoleWrite("****Start : TC_UC1_05.au3****"&@CRLF)
_launchApp()
if $app=0 Then
	_loadConfig("UseCase1")

	_associateDB("&File","AutoitTest.dbf")

	if winexists("BUSMASTER") Then
	sleep(1000)
	WinMenuSelectItem("BUSMASTER","","&Configure","&Hardware Interface","&Kvaser CAN")

	sleep(500)
		if winexists("Hardware Selection") Then
			ControlClick("Hardware Selection","&Select","[CLASS:Button; INSTANCE:2]")
			sleep(1000)

			ControlClick("Hardware Selection","&Select","[CLASS:Button; INSTANCE:2]")
			sleep(1000)

			$channelCount=ControlListView("Hardware Selection","","SysListView322","GetItemCount")
			ControlClick("Hardware Selection","&OK","[CLASS:Button; INSTANCE:4]")
			sleep(1000)
		EndIf
	EndIf
	WinMenuSelectItem("BUSMASTER","","&Configure","&Tx Messages")
	sleep(1000)

	_txMSG("Cyclic",$Count)
	sleep(1000)

	ControlClick("BUSMASTER","",1015,"left")
	sleep(1000)

	if winexists("BUSMASTER","Do you want to save changes?") Then
		ControlClick("BUSMASTER","","[CLASS:Button; INSTANCE:2]","left")
		sleep(1000)
	EndIf
Endif
if winexists("BUSMASTER") Then
	send("!FDC")					; Close the database
;~ 	WinMenuSelectItem("BUSMASTER","","&Window","&1")
	if (ControlCommand("BUSMASTER","",17000,"IsChecked")=0) Then
		ControlCommand("BUSMASTER","",17000,"Check")											; check 'Autoupdate' check box is enabled
	EndIf
	sleep(1000)
	WinMenuSelectItem("BUSMASTER","","F&unctions","&Message Window","&Overwrite")
	sleep(1000)
	$cntToolhWd=ControlGetHandle("BUSMASTER","",128)												; Get handle of tollbar
	_GUICtrlToolbar_ClickIndex($cntToolhWd,4)														; Click on 'Connect' icon
	sleep(1000)
	WinMenuSelectItem("BUSMASTER","","F&unctions","&Transmit","&Normal Blocks")
	sleep(1000)
	Send("!vm")		; Hide CAN message window
	sleep(2000)
	Send("!vm")		; Show CAN message window
	sleep(3000)
;~ 	send("{ESC}")

	; Sort message window
	$pos=ControlGetPos ("BUSMASTER", "Message Window - CAN",200 )
	MouseClick("Left",$pos[0]+50,$pos[1]+55)
	sleep(1000)
	MouseClick("Left",$pos[0]+50,$pos[1]+55)
	sleep(500)
	_GUICtrlToolbar_ClickIndex($cntToolhWd,4)														; Click on 'Disconnect' icon
	sleep(1000)
;~ 	WinMenuSelectItem("BUSMASTER","","&Configure","&Tx Messages")

EndIf
ConsoleWrite("****End : TC_UC1_05.au3****"&@CRLF)
ConsoleWrite(@CRLF)
ConsoleWrite(@CRLF)
ConsoleWrite("***********UseCase 1 Script Execution Ended************"&@CRLF)


