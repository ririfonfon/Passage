
;INPUT VALUES
Value1= 0
Value2 = 0
Value3 = 0
Value4 = 0
Value5 = 0
Value6 = 0
Value7 = 0
Value8 = 0
Value9 = 0
Value10 = 0
Value11 = 0
Value12 = 0
Value13 = 0
Value14 = 0
Value15 = 0
Value16 = 0
Value17 = 0
Value18 = 0
Value19 = 0
Value20 = 0
Value21 = 0
Value22 = 0

Value_last1 = 1
Value_last2 = 1
Value_last3 = 1
Value_last4 = 1
Value_last5 = 1
Value_last6 = 1
Value_last7 = 1
Value_last8 = 1
Value_last9 = 1
Value_last10 = 1
Value_last11 = 1
Value_last12 = 1
Value_last13 = 1
Value_last14 = 1
Value_last15 = 1
Value_last16 = 1
Value_last17 = 1
Value_last18 = 1
Value_last19 = 1
Value_last20 = 1
Value_last21 = 1
Value_last22 = 1


;OUTPUT VALUES
Value_send = 0

;LOCAL PROCEDURE
PrototypeC setPORTS(portIN.i, portOUT.i)
PrototypeC setSUBNET(sub.i)
PrototypeC startNODE()
PrototypeC stopNODE()
PrototypeC restartNODE()
PrototypeC getDMX(channel.i)
PrototypeC sendDMX(channel.i, value.i)

;LOAD LIBRARY
#Library = 1
If (OpenLibrary(#Library, "mgr-artnet-r512.dll")) 
  Debug "open ARTNET library"
  PrintN ("open  ARTNET library")
Else
  Debug "failed to open ARTNET library"
  PrintN ("failed to open ARNET library")
  End
EndIf

Global setPORTS.setPORTS
Global setSUBNET.setSUBNET
Global startNODE.startNODE
Global stopNODE.stopNODE
Global restartNODE.restartNODE
Global getDMX.getDMX
Global sendDMX.sendDMX 

;LOAD FUNCTION FROM DLL INTO PUREBASIC PROCEDURE
setPORTS.setPORTS = GetFunction(#Library, "setPORTS") 
setSUBNET.setSUBNET = GetFunction(#Library, "setSUBNET") 
startNODE.startNODE = GetFunction(#Library, "startNODE") 
stopNODE.stopNODE = GetFunction(#Library, "stopNODE")
restartNODE.restartNODE = GetFunction(#Library, "restartNODE")
getDMX.getDMX = GetFunction(#Library, "getDMX") 
sendDMX.sendDMX = GetFunction(#Library, "sendDMX") 

If (setPORTS > 0)
  Debug "setPORTS ok"
  PrintN ("set   PORTS  ok")
  
Else
  Debug "failed to locate setPORTS in the DLL"
  PrintN ("failed to locate setPORTS in the DLL")
  End
EndIf

If (setSUBNET > 0)
  Debug "setSUBNET ok"
  PrintN ("set   SUBNET ok")
  
Else 
  Debug "failed to locate setSUBNET"
  PrintN ("failed to locate setSUBNET")
  End
EndIf

If (startNODE > 0) 
  Debug "start NODE ok "
  PrintN ("start NODE   ok")
Else 
  Debug "failed to locate startNODE in the DLL"
  PrintN ("failed to locate startNODE in the DLL")
  End
EndIf 

If (stopNODE > 0) 
  Debug "stop NODE ok"  
  PrintN ("stop  NODE   ok")
  
Else 
  Debug "failed to locate stopINPUT in the DLL"
  PrintN ("failed to locate stopINPUT in the DLL")
  End
EndIf 

If (getDMX > 0)
  Debug "getDMX ok" 
  PrintN ("get   DMX    ok")
  
Else 
  Debug "failed to locate getDMX function in DLL"
  PrintN ("failed to locate getDMX function in DLL")
  End
EndIf

If (sendDMX > 0)
  Debug "sendDMX ok"
  PrintN ("send  DMX    ok")
  
Else 
  Debug "failed to locate sendDMX fonction in DLL"
  PrintN ("failed to locate sendDMX fonction in DLL")
  End
EndIf



;SET PORTS  (INPUT, OUTPUT)  par defaut: 0 / 1
setPORTS(6,7)

;SET SUBNET   par defaut : 0
setSUBNET(0)

;START NODE
startNODE()

    

      
 



; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 156
; FirstLine = 59
; EnableXP
; EnableUnicode