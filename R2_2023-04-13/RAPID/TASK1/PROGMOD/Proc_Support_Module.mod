MODULE Proc_Support_Module  
    !===========================================================================
    PROC P_GoUpCurrentPosition( num valuegoup, speeddata speedup, zonedata zoneup, PERS tooldata toolup,PERS wobjdata wobjup, bool WithMoveToDown)
        !*********************<<<< GoUpCurrentPosition PROCEDURE >>>>**********************                                    
	    !Created by   :      
        !Penjelasan   :
        !     #Program untuk menggerakkan robot LINEAR keatas atau ke bawah ke posisi Z=valuegoup
        !     #WithMoveToDown=FALSE-->tanpa gerak ke bawah jika current.trans.z>valuegoup
        !     #WithMoveToDown=TRUE-->dengan gerak ke bawah jika current.trans.z>valuegoup
	    !**********************************************************************************
        VAR robtarget poscurrent;
        !WaitRob \ZeroSpeed;
        poscurrent := CRobT(\Tool:=toolup\WObj:=wobjup);
        IF poscurrent.trans.z<valuegoup OR WithMoveToDown=TRUE THEN
            poscurrent.trans.z:=valuegoup;
            MoveL poscurrent,speedup,zoneup,toolup \WObj:=wobjup;
        ENDIF
    ENDPROC
    !===========================================================================
    PROC P_CheckLayer(num iPattern,num iCounter,Pers num oLayer)
        TEST iPattern
        CASE 1: oLayer:=F_Layer(iCounter,7);
        CASE 2: oLayer:=F_Layer(iCounter,7);
        CASE 3: oLayer:=F_Layer(iCounter,7);
        CASE 4: oLayer:=F_Layer(iCounter,5);
        CASE 5: oLayer:=F_Layer(iCounter,4);
        CASE 6: oLayer:=F_Layer(iCounter,3);
        ENDTEST
    ENDPROC
   
   !===========================================================================
    PROC P_PickCheck()
        StartCheck:
        
        P_VarCopy;
        IF LoopCheckPick < 7 THEN
            Incr LoopCheckPick;
        ELSE
            LoopCheckPick:=0;
            PiLine:=0;
            GOTO  EndCheck;
        ENDIF
        
        IF FlagCheckPick = 1 THEN
            GOTO PickL2;    
        ELSEIF FlagCheckPick = 2 THEN
            GOTO PickL1;  
        ENDIF
        
        PickL1: !------------------ Line 1
        FlagCheckPick := 1;
        P_CheckGripPickProcess 1,Pattern{1},Counter{1},dPosTriggerGripperClose,xofGripAtPick{1},dEnableNumPickBox;
        
        IF (fRunMode=0 AND (xIn_101_4=1 AND xIn_101_2=1)) 
        OR (fRunMode=1 AND PiLine=1) THEN
            PiLine:=1;
            LBox:=BoxL{1};  WBox:=BoxW{1};  HBox:=BoxH{1};  
            PickBox:=offs(PickBox1,xofGripAtPick{1},offsYPick,0); 
            
            GOTO  EndCheck;    
        ELSE
            GOTO StartCheck;
        ENDIF
        
        PickL2: !------------------ Line 2
        FlagCheckPick := 2;
        P_CheckGripPickProcess 2,Pattern{2},Counter{2},dPosTriggerGripperClose,xofGripAtPick{2},dEnableNumPickBox;
        
        IF (fRunMode=0 AND (xIn_101_5=1 AND xIn_101_3=1))
        OR (fRunMode=1 AND PiLine=2) THEN
            PiLine:=2;
            LBox:=BoxL{2};  WBox:=BoxW{2};  HBox:=BoxH{2}; 
            PickBox:=offs(PickBox2,xofGripAtPick{2},offsYPick,0); 
            
            GOTO  EndCheck;    
        ELSE
            GOTO StartCheck;
        ENDIF
        
        
        EndCheck:
        LoopCheckPick:=0;
        
    ENDPROC
    !===========================================================================
    PROC P_VarCopy()
        VAR num InCounter;VAR num ModPattern{13};
        IF fRunMode=0 THEN
            Counter{1}:=xIn_106; 
            Counter{2}:=xIn_107;
            Pattern{1}:=xIn_108;
            Pattern{2}:=xIn_109;
            BoxL{1}:=xIn_110; BoxW{1}:=xIn_112; BoxH{1}:=xIn_114;
            BoxL{2}:=xIn_116; BoxW{2}:=xIn_118; BoxH{2}:=xIn_120;
            iSetOfBoxAtPick{1}:=0;
            iSetOfBoxAtPick{2}:=0;
            IF xIn_105_5 = 0 THEN
                Mirror{1}:=FALSE;
            ELSE
                Mirror{1}:=TRUE;
            ENDIF
            IF xIn_105_6 = 0 THEN
                Mirror{2}:=FALSE;
            ELSE
                Mirror{2}:=TRUE;
            ENDIF
            
            TEST PiLine
            CASE 1: CustomOffset.x:=xIn_122; CustomOffset.y:=xIn_124; CustomOffset.z:=xIn_126; 
                    IF CustomOffset.x > 32768 THEN CustomOffset.x:=(xIn_122-65536); ENDIF 
                    IF CustomOffset.y > 32768 THEN CustomOffset.y:=(xIn_124-65536); ENDIF
                    IF CustomOffset.z > 32768 THEN CustomOffset.z:=(xIn_126-65536); ENDIF
            CASE 2: CustomOffset.x:=xIn_128; CustomOffset.y:=xIn_130; CustomOffset.z:=xIn_132;
                    IF CustomOffset.x > 32768 THEN CustomOffset.x:=(xIn_128-65536); ENDIF 
                    IF CustomOffset.y > 32768 THEN CustomOffset.y:=(xIn_130-65536); ENDIF
                    IF CustomOffset.z > 32768 THEN CustomOffset.z:=(xIn_132-65536); ENDIF
            ENDTEST
            
            IF xIn_103_6 = 1 THEN
                PalletX:=1000; PalletY:=1200;
            ELSEIF xIn_103_7 = 1 THEN
                PalletX:=1016; PalletY:=1219;
            ELSEIF xIn_104_0 = 1 THEN
                PalletX:=1140; PalletY:=1140;
            ENDIF
            
            
        ELSE
            PalletX:=1000; PalletY:=1200;
!            Pattern{1}:=1; iSetOfBoxAtPick{1}:=0; BoxL{1}:=319; BoxW{1}:=217; BoxH{1}:=200; !Box 1
!            Pattern{2}:=1; iSetOfBoxAtPick{2}:=0; BoxL{2}:=319; BoxW{2}:=217; BoxH{2}:=200; !Box 1
            
!            Pattern{1}:=2; iSetOfBoxAtPick{1}:=0; BoxL{1}:=355; BoxW{1}:=265; BoxH{1}:=240; !Box 4
!            Pattern{2}:=2; iSetOfBoxAtPick{2}:=0; BoxL{2}:=355; BoxW{2}:=265; BoxH{2}:=240; !Box 4            

!            Pattern{1}:=3; iSetOfBoxAtPick{1}:=0; BoxL{1}:=319; BoxW{1}:=217; BoxH{1}:=290; !Box 11
!            Pattern{2}:=3; iSetOfBoxAtPick{2}:=0; BoxL{2}:=319; BoxW{2}:=217; BoxH{2}:=290; !Box 11
            
            Pattern{1}:=4; iSetOfBoxAtPick{1}:=0; BoxL{1}:=368; BoxW{1}:=245; BoxH{1}:=242; !Box 19
            Pattern{2}:=4; iSetOfBoxAtPick{2}:=0; BoxL{2}:=368; BoxW{2}:=245; BoxH{2}:=242; !Box 19
            
!            Pattern{1}:=5; iSetOfBoxAtPick{1}:=0; BoxL{1}:=362; BoxW{1}:=267; BoxH{1}:=320; !Box 21
!            Pattern{2}:=5; iSetOfBoxAtPick{2}:=0; BoxL{2}:=362; BoxW{2}:=267; BoxH{2}:=320; !Box 21
            
        ENDIF
    ENDPROC
    !===========================================================================
    PROC P_CheckGripLoad(num idPosBox)
        TEST idPosBox
        CASE 1,2,4,8: Gripload load1;
        CASE 3,5,6,9,10,12: Gripload load2; 
        CASE 7,11,13,14: Gripload load3;
        CASE 15: Gripload load4;
        DEFAULT: Gripload load0;
        ENDTEST
    ENDPROC
    !===========================================================================
    PROC P_TrapCheckBoxEnable(num FlagCheck, num BypassCheck)
       IF BypassCheck=0 THEN
            IF BitCheck(FlagCheck,1)=TRUE THEN
                IWatch CheckBoxint1; 
            ENDIF
            IF BitCheck(FlagCheck,2)=TRUE THEN
                IWatch CheckBoxint2;
            ENDIF
            IF BitCheck(FlagCheck,3)=TRUE THEN
                IWatch CheckBoxint3;
            ENDIF
            IF BitCheck(FlagCheck,4)=TRUE THEN
                IWatch CheckBoxint4;
            ENDIF
        ELSE
            ISleep CheckBoxint1;
            ISleep CheckBoxint2;
            ISleep CheckBoxint3;
            ISleep CheckBoxint4;
        ENDIF
    ENDPROC
    

    !===========================================================================
ENDMODULE