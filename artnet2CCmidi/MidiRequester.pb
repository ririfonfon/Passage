Procedure MIDIRequester(*OutDevice, *InDevice) 
  

Global InARTNET
Global OutARTNET

  ;this is the window shown to select the midi devices .
  #MOD_WAVETABLE = 6 
  #MOD_SWSYNTH = 7 
  #MIDIRequ_InSet = 2 
  #MIDIRequ_OutSet = 1 
  
  #MOD_WAVETABLE2 = 6 
  #MOD_SWSYNTH2 = 7
  #MIDIRequ_InSet2 = 3
  #MIDIRequ_OutSet2 = 4
;---- ouverture de la fenetre---------------------------------------------------------------

  #Width = 1024
   If OpenWindow(0, 0, 0, #Width , 470,"Artnet2CCMidi by Riri", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    ;If CreateGadgetList(WindowID(0)) 
      #Column = (#Width - 40) / 2
      #Offset = ((#Width - 10)/ 2) + 5 
      
;---- IN OUT MIDI -------------------------------------------------------------------------------------------------------------
      
;-------- listage midi out --------------
      TextGadget(0, 5, 5, #Column, 18, "Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(2, 5, 23, #Column, 100) 
        MaxOutDev.l = midiOutGetNumDevs_() 
        InfoOut.MIDIOUTCAPS 
        If MaxOutDev 
          For a.l = -1 To MaxOutDev - 1 
            midiOutGetDevCaps_(a, InfoOut, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(2, -1, PeekS(@InfoOut\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(2, -1, "(no output device)") 
          DisableGadget(2, 1) 
        EndIf 

;---------listage midi in -----------------
      TextGadget(1, #Offset, 5, #Column, 18, "Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(3, #Offset, 23, #Column, 100) 
        MaxInDev.l = midiInGetNumDevs_() 
        InfoIn.MIDIINCAPS 
        If MaxInDev 
          For a.l = 0 To MaxInDev - 1 
            midiInGetDevCaps_(a, InfoIn, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(3, -1, PeekS(@InfoIn\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(3, -1, "(no input device)") 
          DisableGadget(3, 1) 
        EndIf 

;------------- artnet 

TextGadget(31, 5, 250, #Column, 18, "Noeud 9 ARTNET In:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(32, 5, 270, #Column, 100) 
      For a=0 To 15
        
        AddGadgetItem(32,-1,Str(a))
      Next a
      
TextGadget(33, #Offset, 250, #Column, 18, "Noeud 15 ARTNET Out:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(34, #Offset, 270, #Column, 100) 
      For b=0 To 15
        
        AddGadgetItem(34,-1,Str(b))
      Next b
        
        
        
        
        
        
;----- definition OK Cancel et version des peripheriques -------------------------------------------------------------------------------------------



      ButtonGadget(4, 5, 440, #Column, 24, "&OK") 
      ButtonGadget(5, #Offset, 440, #Column, 24, "&Cancel") 
      
      FrameGadget(6, 5, 130, (#Width - 20) / 2, 100 , "Info of Output-Device",#PB_Frame_Double) 
       TextGadget(7, 10, 145, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(8, 10, 165, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(9, 10, 185, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(10, 10, 205, ((#Width - 20) / 3), 18, "Polyphonie:") 
     
        
      OutDev.l = 0 
      InDev.l = 0 
      
      InARTNET=0
      OutARNET=0
      
      Quit.l = #False 
      OK.l = #False 
      
      Repeat 
 
;----- active ok --------------     
        If OutDev.l > -1 And InDev.l > -1  And OutARTNET<>InARTNET And OutARTNET <> -1 And InARTNET <> -1; And GetGadgetState(12) > -1 And GetGadgetState(14) > -1
          DisableGadget(4, 0) 
        Else 
          DisableGadget(4, 1) 
        EndIf 
        

;----------- validation des peripheriques -----------      
        If InDev.l <> GetGadgetState(3) 
          InDev.l = GetGadgetState(3) 
          Debug "midi in " + InDev.l
        EndIf 
        
        If InARTNET <> GetGadgetState(32)
          InARTNET = GetGadgetState(32)
          Debug "in artnet " + InARTNET
        EndIf
        
        If OutARTNET <> GetGadgetState(34)
          OutARTNET = GetGadgetState(34)
          Debug "out artnet " + OutARTNET
        EndIf
        
        If GetGadgetState(2) <> OutDev 
          OutDev.l = GetGadgetState(2) 
          midiOutGetDevCaps_(OutDev - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(7,"Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(8, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(9, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(10, "Polyphonie: " + TmpS) 
        EndIf 
        
        
;------ inscriptions en memoire des peripheriques valider par OK --------------       
        EventID.l = WaitWindowEvent() 
        Select EventID 
          Case #PB_Event_CloseWindow 
            Quit = #True 
            OK = #False 
          Case #PB_Event_Gadget 
            Select EventGadget() 
              Case 4 
                PokeL(*OutDevice, OutDev - 1) 
                PokeL(*InDevice, InDev)
                
                Quit = #True 
                OK = 3 

;----- ???? c est quoi ca  -------------- 

              
                If (OutDev = -1 Or CountGadgetItems(2) = 0) And OK & #MIDIRequ_OutSet : OK ! #MIDIRequ_OutSet : EndIf 
                If (InDev = -1 Or CountGadgetItems(3) = 0) And OK & #MIDIRequ_InSet : OK ! #MIDIRequ_InSet : EndIf 
               ; If (InDev2 = -1 Or CountGadgetItems(11) = 0) And OK & #MIDIRequ_InSet2 : OK ! #MIDIRequ_InSet2 : EndIf
               ; If (OutDev2 = -1 Or CountGadgetItems(13) = 0) And OK & #MIDIRequ_OutSet2 : OK ! #MIDIRequ_OutSet2 : EndIf 
                 
              Case 5 
                Quit = #True 
                OK = #False 
            EndSelect 
        EndSelect 
      Until Quit 
      
      CloseWindow(0) 
      CloseConsole ()
      ProcedureReturn OK 
    ;Else 
     ; End 
    ;EndIf 
  Else 
    End 
  EndIf 
 
EndProcedure 
; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 47
; Folding = -