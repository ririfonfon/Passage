;=========================================================================================================================
;=========================================================================================================================

;OsDetect=0
Global OsDetect

OpenConsole ()

ConsoleColor(15,9)
PrintN ("                                   ")
PrintN ("-----------------------------------")
PrintN ("I     Artnet2CCMidi BY RIRI      I")
PrintN ("-----------------------------------")
PrintN ("                                   ")
ConsoleColor(7,0)

Select OSVersion()
    
  Case #PB_OS_Windows_95
      PrintN("OS Detect : Windows 95")
        OsDetect=1  
      
  Case #PB_OS_Windows_98
      PrintN("OS Detect : Windows 98")
        OsDetect=1
    
    Case #PB_OS_Windows_2000
      PrintN("OS Detect : Windows 2000")
        OsDetect=2  
    
    Case #PB_OS_Windows_XP
      PrintN("OS Detect : Windows XP")
         OsDetect=3   
    
    Case #PB_OS_Windows_Server_2003
      PrintN("OS Detect : Windows Server 2003")
      OsDetect=4 
      
    Case #PB_OS_Windows_Vista
      PrintN("OS Detect : Windows Vista")
      OsDetect=4
      
    Case #PB_OS_Windows_Server_2008
      PrintN("OS Detect : Windows Server 2008")
      OsDetect=4
      
    Case #PB_OS_Windows_Server_2008_R2
      PrintN("OS Detect : Windows Server 2008 R2")
      OsDetect=4
      
    Case #PB_OS_Windows_Server_2012
      PrintN("OS Detect : Windows Server 2012")
      OsDetect=4
      
    Case #PB_OS_Windows_7
      PrintN("OS Detect : Windows 7")
        OsDetect=5
        
    Case #PB_OS_Windows_8
      PrintN("OSDetect : Windows 8")
        OsDetect=5  
        
      Default
      PrintN("OS Detect : NO detect a Default")    
        OsDetect=5
   
     
          
  EndSelect


;=========================================================================================================================
;=========================================================================================================================



; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=2297&highlight=
; Author: Richard Fontaine
; Date: 6. Fevrier 2024
; OS: Windows


  IncludeFile   "MIDI_MyVariables.pb"
  IncludeFile   "MidiRequester.pb"
  IncludeFile   "artnet.pb"


;--- MAINPROGRAM 

Global OutDevice.l 
Global InDevice.l 

MIDIResult.l = MIDIRequester(@OutDevice, @InDevice)
 

If MIDIResult & #MIDIRequ_InSet 
  hMidiIn.l 
  ;If midiInOpen_(@hMidiIn, InDevice, @MidiInProc(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
  ;  Debug "OPEN: MidiIn" 
  ;  If midiInStart_(hMidiIn) = #MMSYSERR_NOERROR 
  ;    Debug "START: MidiIn= "  + Str(hMidiIn) 
  ;  EndIf 
  ;EndIf 
EndIf 


  
If MIDIResult & #MIDIRequ_OutSet 
  hMidiOut.l 
  If midiOutOpen_(@hMidiOut, OutDevice, 0, 0, 0) = 0 
    my_hMidiOut = hMidiOut
    Debug "OPEN: MidiOut= "  + Hex(hMidiOut)
  EndIf 
EndIf
  

If hMidiIn <> 0 And hMidiOut <> 0 
  my_hMidiOut = hMidiOut
 Debug "midi out"+Hex(hMidiOut)+"  my ou"+Hex(my_hMidiOut) 
EndIf

;Create if any midi out 
If my_hMidiOut = 0 :Debug "my_h out": Goto EndProgram : EndIf

AuxIndex.b
Salir.b
AuxVal.w  ;We need this dummie value cause byte is signed when we store it into another variable.

Salir = #False 

        
        ;SET PORTS  (INPUT, OUTPUT)  par defaut: 0 / 1
setPORTS(InARTNET,OutARTNET)

;Debug "artnet ok set"

;---------- MAIN LOOP              
Repeat

;---------- artnet in
  
  
  Value1 = getDMX(1)
  If (Value1 <> Value_last1)
    Debug "value " + Value1
    Value_last1 = Value1
    midi1= $B0 + ($1 * $100) + ((Value1/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi1)
  Debug "midi 1 " + Hex(midi1)+" Le Message artnet-Midi est  " + Hex(midi1) + " expédié vers handle " + Hex(my_hMidiOut)  
  EndIf

 Value2 = getDMX(2)
  If (Value2 <> Value_last2)
    Value_last2 = Value2
    midi2= $B0 + ($1 * $100) + ((Value2/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi2)
  Debug "midi 1 " + Hex(midi1)+" Le Message artnet-Midi est  " + Hex(midi1) + " expédié vers handle " + Hex(my_hMidiOut)  
  EndIf
  
  Value16 = getDMX(16)
  If (Value16 <> Value_last16)
    Value_last16 = Value16
    midi16= $B0 + ($2 * $100) + ((Value16/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi16)
  ;Debug "midi 16 " + Hex(midi16)+" Le Message artnet-Midi est  " + Hex(midi16) + " expédié vers handle " + Hex(my_hMidiOut2)    
  EndIf
  
  Value17 = getDMX(17)
  If (Value17 <> Value_last17)
    Value_last17 = Value17
    midi17= $B0 + ($3 * $100) + ((Value17/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi17)
  EndIf
  
  Value18 = getDMX(18)
  If (Value18 <> Value_last18)
    Value_last18 = Value18
    midi18= $B0 + ($4 * $100) + ((Value18/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi18)
  EndIf
  
  Value19 = getDMX(19)
  If (Value19 <> Value_last19)
    Value_last19 = Value19
    midi19= $B0 + ($5 * $100) + ((Value19/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi19)
  EndIf
  
  Value20 = getDMX(20)
  If (Value20 <> Value_last20)
    Value_last20 = Value20
    midi20= $B0 + ($6 * $100) + ((Value20/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi20)
  EndIf
 
 Value21 = getDMX(21)
  If (Value21 <> Value_last21)
    Value_last21 = Value21
    midi21= $B0 + ($7 * $100) + ((Value21/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi21)
  EndIf
 
 Value22 = getDMX(22)
  If (Value22 <> Value_last22)
    Value_last22 = Value22
    midi22= $B0 + ($8 * $100) + ((Value22/2)* $10000) + #channel1 
    midiOutShortMsg_(my_hMidiOut, midi22)
  EndIf
 
 
 ;-----------      --------------   ------------- 
    
Delay(#Interval)
Until Salir = #True


;----- FIN MAIN LOOP
MessageRequester ("OSC for MAonPC  by Riri", "Sorry, but now we quit")
EndProgram:

;--------- STOP NODE
stopNODE()

CloseLibrary(#Library)
    


midiDisconnect_(hMidiIn, hMidiOut, 0)

While midiInClose_(hMidiIn) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut) = #MIDIERR_STILLPLAYING : Wend 

EndProgram2:
;WE MUST TO CLOSE PROCESS HANDLE!!
If pHandle <> 0 : CloseHandle_(pHandle) :EndIf
Debug "end ici normal c'est la fin "+pHandle
End
;--- data section
DataSection 
  ControllerNames: 
    Data.s "Bank Select", "Modulation", "Breath Controller", "", "4 (0x04) Foot Controller"                   ;0 - 4 
    Data.s "Portamento time", "Data Entry (MSB)", "Main Volume", "Balance", "", "Pan"                         ;5 - 10 
    Data.s "Expression Controller", "Effect Control 1", "Effect Control 2", "", ""                            ;11 - 15 
    Data.s "General-Purpose Controllers 1", "General-Purpose Controllers 2", "General-Purpose Controllers 3"  ;16 - 18 
    Data.s "General-Purpose Controllers 4", "", "", "", "", "", "", "", "", "", "", "", ""                    ;19 - 31 
    Data.s "LSB for Controller 0", "LSB for Controller 1", "LSB for Controller 2", "LSB for Controller 3"     ;32 - 35 
    Data.s "LSB for Controller 4", "LSB for Controller 5", "LSB for Controller 6", "LSB for Controller 7"     ;36 - 39 
    Data.s "LSB for Controller 8", "LSB for Controller 9", "LSB for Controller 10", "LSB for Controller 11"   ;40 - 43 
    Data.s "LSB for Controller 12", "LSB for Controller 13", "LSB for Controller 14", "LSB for Controller 15" ;44 - 47 
    Data.s "LSB for Controller 16", "LSB for Controller 17", "LSB for Controller 18", "LSB for Controller 19" ;48 - 51 
    Data.s "LSB for Controller 20", "LSB for Controller 21", "LSB for Controller 22", "LSB for Controller 23" ;52 - 55 
    Data.s "LSB for Controller 24", "LSB for Controller 25", "LSB for Controller 26", "LSB for Controller 27" ;56 - 59 
    Data.s "LSB for Controller 28", "LSB for Controller 29", "LSB for Controller 30", "LSB for Controller 31" ;60 - 63 
    Data.s "Damper pedal (sustain)", "Portamento", "Sostenuto", "Soft Pedal", "Legato Footswitch"             ;64 - 68 
    Data.s "Hold 2", "Sound Controller 1 (Default: Timber Variation)"                                         ;69 - 70 
    Data.s "Sound Controller 2 (Default: Timber/Harmonic Content)"                                            ;71 - 71 
    Data.s "Sound Controller 3 (Default: Release time)", "Sound Controller 4 (Default: Attack time)"          ;72 - 73 
    Data.s "Sound Controller 6", "Sound Controller 7", "Sound Controller 8", "Sound Controller 9"             ;74 - 77 
    Data.s "Sound Controller 10", "", "General-Purpose Controllers 5", "General-Purpose Controllers 6"        ;78 - 81 
    Data.s "General-Purpose Controllers 7", "General-Purpose Controllers 8", "Portamento Control"             ;82 - 84 
    Data.s "", "", "", "", "", "", "Effects 1 Depth (formerly External Effects Depth)"                        ;85 - 91 
    Data.s "Effects 2 Depth (formerly Tremolo Depth)", "Effects 3 Depth (formerly Chorus Depth)"              ;92 - 93 
    Data.s "Effects 4 Depth (formerly Celeste Detune)", "Effects 5 Depth (formerly Phaser Depth)"             ;94 - 95 
    Data.s "Data Increment", "Data Decrement", "Non-Registered Parameter Number (LSB)"                        ;96 - 98 
    Data.s "Non-Registered Parameter Number (MSB)", "Registered Parameter Number (LSB)"                       ;99 - 100 
    Data.s "Registered Parameter Number (MSB)", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""    ;101 - 116 
    Data.s "", "", "", "", "Mode Messages", "Mode Messages", "Mode Messages", "Mode Messages"                 ;117 - 124 
    Data.s "Mode Messages", "Mode Messages", "Mode Messages"                                                  ;125 - 127 
EndDataSection
;--- fin de data section 

; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 11
; Markers = 105
; UseIcon = icon.ico
; Executable = ..\V6\812 V9 2.exe