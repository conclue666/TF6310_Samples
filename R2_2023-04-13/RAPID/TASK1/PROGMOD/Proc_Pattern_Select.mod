MODULE Proc_Pattern_Select
    !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    PROC P_CheckGripPickProcess(num iLine, num iPattern,num iCounter,PERS num oPosGripClose,Pers num oXOffsGripPick,Pers num oEnableNumPickBox)
        
        !oEnableNumPickBox= Syarat Jumlah Box di Picking untuk Pick Box Ready Nilai 1 atau 2
        
        VAR num vPlaceNum;
        TEST iPattern
        CASE 1:
                !Pattern1
                vPlaceNum:=iCounter MOD 7;
                TEST vPlaceNum
                CASE 1,2,3: oEnableNumPickBox:=2; oXOffsGripPick:=-3*75; oPosGripClose:=3;                
                DEFAULT: oEnableNumPickBox:=4; oXOffsGripPick:=-3*75; oPosGripClose:=15;
                ENDTEST
        CASE 2:
                !Pattern2
                vPlaceNum:=iCounter MOD 7;
                TEST vPlaceNum
                CASE 1: oEnableNumPickBox:=2; oXOffsGripPick:=-1*75; oPosGripClose:=3;
                CASE 3: oEnableNumPickBox:=1; oXOffsGripPick:=-1*75; oPosGripClose:=1;
                DEFAULT: oEnableNumPickBox:=4; oXOffsGripPick:=0; oPosGripClose:=15;
                ENDTEST
                
        CASE 3:        
                !Pattern2B
                vPlaceNum:=iCounter MOD 7;
                TEST vPlaceNum
                CASE 1,4: oEnableNumPickBox:=2; oXOffsGripPick:=-1*75; oPosGripClose:=3;
                CASE 3: oEnableNumPickBox:=1; oXOffsGripPick:=-1*75; oPosGripClose:=1;
                DEFAULT: oEnableNumPickBox:=3; oXOffsGripPick:=0; oPosGripClose:=7;
                ENDTEST
                
        CASE 4:
!                !Pattern3
!                vPlaceNum:=iCounter MOD 5;
!                oXOffsGripPick:=-2*75; 
!                TEST vPlaceNum
!                CASE 4: oPosGripClose:=15; oEnableNumPickBox:=4; 
!                DEFAULT: oPosGripClose:=3; oEnableNumPickBox:=2; 
!                ENDTEST    
                
                !Pattern3B
                vPlaceNum:=iCounter MOD 5;
                oXOffsGripPick:=-2*75; 
                TEST vPlaceNum
                CASE 1:  oPosGripClose:=3; oEnableNumPickBox:=2; 
                DEFAULT: oPosGripClose:=15; oEnableNumPickBox:=4;
                ENDTEST 
                
        CASE 5:
                !Pattern4
                vPlaceNum:=iCounter MOD 4;
                TEST vPlaceNum
                CASE 1,2: oEnableNumPickBox:=2; oXOffsGripPick:=-1*75; oPosGripClose:=3;
                DEFAULT: oEnableNumPickBox:=3; oXOffsGripPick:=-3*75; oPosGripClose:=15;
                ENDTEST
               
        CASE 6:   
                !Pattern 5
                oEnableNumPickBox:= 4; 
                oXOffsGripPick:=0; 
                oPosGripClose:=15;
                
!                !Pattern 5B
!                oEnableNumPickBox:= 2; 
!                oXOffsGripPick:=0; 
!                oPosGripClose:=3;
                
    
        ENDTEST  
        
    ENDPROC
    
    !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    PROC P_PatternSelect(num iLine) 
        VAR robtarget ivpPlaceA; VAR robtarget ivpPlaceB; VAR robtarget ivpPlaceC; VAR robtarget ivpPlaceD; 
        VAR num RefPointNum; VAR num DirectNum; VAR num inCounterBox{2}; VAR num iLayer;
        VAR num ixOfBoxPi; VAR num  ixOfGripPi; 
        VAR bool vGapBox; VAR bool vMirror;
        
        P_VarCopy;
        !Check Place Ready
        PcLine:=0;
        IF fRunMode=1 THEN
            PcLine:=iLine;   
        ELSE
            TEST iLine
            CASE 1:
                IF xIn_101_4 = 1 AND Counter{1}>0 THEN
                    PcLine:=1;
                ELSE  
                    GOTO EndSelect;
                ENDIF
            CASE 2:
                IF xIn_101_5 = 1 AND Counter{2}>0 THEN
                    PcLine:=2;
                ELSE
                    GOTO EndSelect;
                ENDIF
            ENDTEST
        ENDIF
        LBox:=BoxL{iLine};  WBox:=BoxW{iLine};  HBox:=BoxH{iLine};
        ixOfBoxPi:=iSetOfBoxAtPick{iLine}*50;
        ixOfGripPi:=xofGripAtPick{iLine};
       
        TEST iLine
            CASE 1:
                ivpPlaceA:= Offs(PlaceBox1A,CustomOffset.x+ixOfGripPi-ixOfBoxPi, CustomOffset.y-(PalletY-RefBoxL{1}), 0);
                ivpPlaceB:= Offs(PlaceBox1B,CustomOffset.x, CustomOffset.y-ixOfGripPi+ixOfBoxPi-(3*RefBoxW{1})-(PalletY-4*RefBoxW{1}),0);
                ivpPlaceC:= Offs(PlaceBox1C,CustomOffset.x-ixOfGripPi+ixOfBoxPi-(3*RefBoxW{1}), CustomOffset.y-(PalletY-RefBoxL{1}), 0);
                ivpPlaceD:= Offs(PlaceBox1D,CustomOffset.x, CustomOffset.y+ixOfGripPi-ixOfBoxPi-(PalletY-4*RefBoxW{1}), 0);

                iRefPoint:=1;
                vMirror := Mirror{1};
            CASE 2:
               
                ivpPlaceA:= Offs(PlaceBox2A,CustomOffset.x+ixOfGripPi-ixOfBoxPi, (1219-PalletY)+CustomOffset.y+offsYPick, 0);
                ivpPlaceB:= Offs(PlaceBox2B,CustomOffset.x+offsYPick, (1219-PalletY)+CustomOffset.y-ixOfGripPi+ixOfBoxPi-(3*RefBoxW{1}),0);
                ivpPlaceC:= Offs(PlaceBox2C,CustomOffset.x-ixOfGripPi+ixOfBoxPi-(3*RefBoxW{1}), (1219-PalletY)+CustomOffset.y-offsYPick, 0);
                ivpPlaceD:= Offs(PlaceBox2D,CustomOffset.x-offsYPick, (1219-PalletY)+CustomOffset.y+ixOfGripPi-ixOfBoxPi, 0);
                
                iRefPoint:=1;
                vMirror := Mirror{2};
        ENDTEST 
            
            TEST Pattern{iLine}
            CASE 1:
                IF fRunMode = 1 THEN
                iLayer:=1+((Counter{iLine}-1) DIV 7);
                IF iLayer MOD 2 = 0 THEN
                    vMirror := TRUE;
                ELSE
                    vMirror := FALSE;
                ENDIF
                ENDIF
                BoxPattern1 ivpPlaceA, ivpPlaceB, ivpPlaceC, ivpPlaceD, iLine, Counter{iLine},LBox,WBox,HBox,PalletX,PalletY,120,RefBoxL{iLine},RefBoxW{iLine},
                CustomRz, vMirror, iRefPoint, 1, 50, PlaceBox, Layer{iLine}, OffsPlaceX, OffsPlaceY, dPosTriggerGripperOpen, dPlaceNumber;
                
                
             CASE 2:
                IF fRunMode = 1 THEN
                iLayer:=1+((Counter{iLine}-1) DIV 7);
                IF iLayer MOD 2 = 0 THEN
                    vMirror := TRUE;
                ELSE
                    vMirror := FALSE;
                ENDIF
                ENDIF
                BoxPattern2 ivpPlaceA, ivpPlaceB, ivpPlaceC, ivpPlaceD, iLine, Counter{iLine},LBox,WBox,HBox,PalletX,PalletY,120,RefBoxL{iLine},RefBoxW{iLine},
                CustomRz, vMirror, iRefPoint, 1, 50, PlaceBox, Layer{iLine}, OffsPlaceX, OffsPlaceY, dPosTriggerGripperOpen, dPlaceNumber;   
                
             CASE 3:
                IF fRunMode = 1 THEN
                iLayer:=1+((Counter{iLine}-1) DIV 7);
                IF iLayer MOD 2 = 0 THEN
                    vMirror := TRUE;
                ELSE
                    vMirror := FALSE;
                ENDIF
                ENDIF
                BoxPattern2B ivpPlaceA, ivpPlaceB, ivpPlaceC, ivpPlaceD, iLine, Counter{iLine},LBox,WBox,HBox,PalletX,PalletY,120,RefBoxL{iLine},RefBoxW{iLine},
                CustomRz, vMirror, iRefPoint, 1, 50, PlaceBox, Layer{iLine}, OffsPlaceX, OffsPlaceY, dPosTriggerGripperOpen, dPlaceNumber;
                
                
             CASE 4:
                IF fRunMode = 1 THEN
                iLayer:=1+((Counter{iLine}-1) DIV 5);
                TEST iLayer
                CASE 3: vMirror := TRUE;
                DEFAULT: vMirror := FALSE;
                ENDTEST
                ENDIF
                
                BoxPattern3B ivpPlaceA, ivpPlaceB, ivpPlaceC, ivpPlaceD, iLine, Counter{iLine},LBox,WBox,HBox,PalletX,PalletY,120,RefBoxL{iLine},RefBoxW{iLine},
                CustomRz, vMirror, iRefPoint, 1, 50, PlaceBox, Layer{iLine}, OffsPlaceX, OffsPlaceY, dPosTriggerGripperOpen, dPlaceNumber;
            
            CASE 5:
                IF fRunMode = 1 THEN
                iLayer:=1+((Counter{iLine}-1) DIV 4);
                IF iLayer MOD 2 = 0 THEN
                    vMirror := TRUE;
                ELSE
                    vMirror := FALSE;
                ENDIF
                ENDIF
                BoxPattern4 ivpPlaceA, ivpPlaceB, ivpPlaceC, ivpPlaceD, iLine, Counter{iLine},LBox,WBox,HBox,PalletX,PalletY,120,RefBoxL{iLine},RefBoxW{iLine},
                CustomRz, vMirror, iRefPoint, 1, 50, PlaceBox, Layer{iLine}, OffsPlaceX, OffsPlaceY, dPosTriggerGripperOpen, dPlaceNumber;
                
            
            CASE 6:
                IF fRunMode = 1 THEN
                iLayer:=1 + ((Counter{iLine} - 1) DIV 6);
                IF iLayer MOD 2 = 0 THEN
                    vMirror := TRUE;
                ELSE
                    vMirror := FALSE;
                ENDIF
                ENDIF
                BoxPattern5 ivpPlaceA, ivpPlaceB, ivpPlaceC, ivpPlaceD, iLine, Counter{iLine},LBox,WBox,HBox,PalletX,PalletY,120,RefBoxL{iLine},RefBoxW{iLine},
                CustomRz, vMirror, iRefPoint, 1, 50, PlaceBox, Layer{iLine}, OffsPlaceX, OffsPlaceY, dPosTriggerGripperOpen, dPlaceNumber;
            
            ENDTEST
            
        
        EndSelect:
    ENDPROC
    !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ENDMODULE