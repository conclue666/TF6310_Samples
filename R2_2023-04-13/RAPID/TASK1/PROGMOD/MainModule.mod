MODULE MainModule
    !*******************<<<< ROBOTICS PALLETIZER >>>>*********************!
    !Program    : ROBOTICS PALLETIZER FOR SMA - ROBOT 3                   !
    !Created by : Arif                                                    !
    !Company    : IRA Robotics Indonesia                                  !
    !*********************************************************************!
    VAR num TPTest{4};
    VAR num TPCekBox;
    VAR num LoopCheckBox;
    VAR num FlagCheckPick;
    VAR num LoopCheckPick;
    
    VAR triggdata VarCheckPickDone;
    VAR triggdata VarTrigBfrClampClose;
    
    VAR clock clockCheckSpeed; VAR num timeCheckSpeed;
    VAR clock clockToHome; VAR num timeToHome;
    VAR clock clockCError; VAR num timeCError;
    VAR clock clockCheckSpeedTotal; VAR num timeCheckSpeedTotal;
    VAR clock clockCheckIdle; VAR num timeCheckIdle;
    
    
    !*********************************************************************!
	PROC main()
        Management;
    ENDPROC
    
    !*********************************************************************!
    !*********************************************************************!
    PROC Management()
        
!        Counter{1}:=1;
!        Counter{2}:=1;
        hMax:=HomePos.trans.z; 
        !___ Set Interrupt Check Box At Gripper
        IDelete CheckBoxint1; IDelete CheckBoxint2;  IDelete CheckBoxint3; IDelete CheckBoxint4;
        CONNECT CheckBoxint1 WITH T_CheckBox1;
        ISignalDI dIn_0_12, 0, CheckBoxint1; 
        CONNECT CheckBoxint2 WITH T_CheckBox2;
        ISignalDI dIn_0_13, 0, CheckBoxint2;
        CONNECT CheckBoxint3 WITH T_CheckBox3;
        ISignalDI dIn_0_14, 0, CheckBoxint3;
        CONNECT CheckBoxint4 WITH T_CheckBox4;
        ISignalDI dIn_0_15, 0, CheckBoxint4;
        ISleep CheckBoxint1; ISleep CheckBoxint2; ISleep CheckBoxint3; ISleep CheckBoxint4;
        !***Setting Initial Proses
        RefBoxL{1}:=333; RefBoxW{1}:=306; ! Line 1 : Menara
        RefBoxL{2}:=333; RefBoxW{2}:=306; ! Line 2 : Menara
        
        Reset xOut_101_0; Reset xOut_101_1; Reset xOut_101_2;
        Reset xOut_101_3; Reset xOut_101_4; Reset xOut_101_5; Reset xOut_101_6; Reset xOut_101_7;
        Reset xOut_102_0; Reset xOut_102_1; Reset xOut_102_2; Reset xOut_102_3; Reset xOut_102_4; 
        Reset xOut_102_5; Reset xOut_102_6; Reset xOut_102_7; Reset xOut_103_0;   
        IF fRunMode=1 THEN!----------------------Check Testmode--------------------------------!
            Counter:=[1,1];
            TPTest{1}:=0;                                                                      !
            TPReadFK TPTest{1}, "Test ? ", "Pick Place", "Gripper", stEmpty, stEmpty,stEmpty;  ! 
            IF TPTest{1}=2 THEN                                                                !
                L_LOOPTESTGRIP:                                                                !
                P_TesGripper;                                                                 !
                GOTO L_LOOPTESTGRIP;                                                           !
            ENDIF                                                                              !
        ENDIF!---------------------------------------------------------------------------------!
        IF fRunMode=0 THEN 
            WaitDI xIn_101_0,1; !Wait Trigger Home
        ENDIF
        WaitRob \ZeroSpeed;
        P_GoUpCurrentPosition hMax, vmax, z50,Gripper, wobj0, FALSE;              
        MoveJ HomePos, vmax, fine, Gripper \WObj:=wobj0;
        WaitRob \InPos;
        
        fInStandHome:=TRUE;
        fInStandby:=FALSE;
        fPickPlace:=0;
        CheckGripProcess;!^^^PROC Check Box di Gripper
        IF fRunMode=0 THEN
            Set xOut_101_0; !Homing Done
            WaitDI xIn_101_0,0; Reset xOut_101_0;
        ENDIF
        !***............
        IF xIn_101_1=0 THEN
            !Dummy;
            Pick_Place_Management;!^^^PROC Loop Run Pick Place
        ELSE
            AccSet 50,40;
            MoveJ HomePos, v1000, fine, Gripper \WObj:=wobj0;
            LOOPMAINDONE:
            GOTO LOOPMAINDONE;
        ENDIF 
    ENDPROC
    !*********************************************************************!
    PROC CheckGripProcess()
            L_HOMECHECKBOX:
            IF BypassCheckBoxWhenHome=0 AND fRunMode=0 THEN
                iSensorBIG{1}:=dIn_0_12; iSensorBIG{2}:=dIn_0_13;  
                iSensorBIG{3}:=dIn_0_14; iSensorBIG{4}:=dIn_0_15; 
                dCheckPosBoxInGripper:=0;
                dPosBoxInGripper:=0;
                dCheckPosBoxInGripper:=F_PosBoxInGripper(iSensorBIG{1}, iSensorBIG{2}, iSensorBIG{3}, iSensorBIG{4}); !-->fuction cek posisi box di Gripper  
            ELSE
                dCheckPosBoxInGripper:=0;
                dPosBoxInGripper:=0;
                dLineBoxInGrip:=0;
            ENDIF
            
            IF dPosBoxInGripper=0 AND dCheckPosBoxInGripper=0 THEN
                TPCekBox:=0;
                TPReadFK TPCekBox, "Gripper Empty?", "YES", "NO", stEmpty, stEmpty,stEmpty; 
                IF TPCekBox=2 THEN
                    WaitTime 1;  
                    GOTO L_HOMECHECKBOX;
                ENDIF
                dPosBoxInGripper:=0;
                dLineBoxInGrip:=0;
                !Proses Gripper Open
                P_ClawOpen 15,0,FALSE;
                P_ClampOpen 15,0,FALSE;
                
                dPosTriggerGripperOpen:=0; dPosTriggerGripperClose:=0;
                !Check Sensor Gripper Open
                P_CheckClawOpen 15,7;
                P_CheckClampOpen 15,7;
                
                GripLoad load0;
            ELSE
                WaitTime 0.25;
                IF LoopCheckBox<10 THEN
                    Incr LoopCheckBox;
                    GOTO L_HOMECHECKBOX;
                ELSE
                    IF dCheckPosBoxInGripper <> 0 THEN
                        dPosBoxInGripper:=dCheckPosBoxInGripper;
                        !Box Jammed In Gripper
                        P_TrapCheckBoxEnable dPosBoxInGripper,xIn_102_3;
                        TPWrite "Box Not Empty When Homing"; 
                        !PulseDO \High \PLength:=2, xOut_102_2;
                    ENDIF
                ENDIF
            ENDIF
            L_EndLoop:
            LoopCheckBox:=0;
            Pick_Place_Management;
            !Dummy;
    ENDPROC
    !*********************************************************************!
    PROC Pick_Place_Management()
        L_CPP: 
        !MySpeed:=xIn_119;
        !SpeedRefresh(100);        
        IF fRunMode=1 THEN!---------------------------------Check Testmode---------------------------------------
            TPTest{2}:=0;  
            TPTest{3}:=0;
            IF dPosBoxInGripper=0 THEN
                TPTest{2}:=0;                                                                      
                TPReadFK TPTest{2}, "Move To ? ","Line 1","Line 2",stEmpty,stEmpty,stEmpty; 
                TEST TPTest{2}
                CASE 1:PiLine:=1;
                CASE 2:PiLine:=2;
                ENDTEST
                TPTest{3}:=0;
                TPReadFK TPTest{3}, "With Setting Counter ? ", "YES", "NO", stEmpty, stEmpty,stEmpty;
                IF TPTest{3}=1 THEN
                    TPReadNum Counter{TPTest{2}},"Counter Box ? : ";   
                ENDIF
                Next:
            ENDIF
        ENDIF!---------------------------------------------------------------------------------------------------
       
        IF dLineBoxInGrip=0 AND dPosBoxInGripper=0 THEN 
            P_PickCheck;  
            TEST PiLine
            CASE 1,2: 
                P_PatternSelect PiLine;
                ClkReset clockToHome; 
                fInStandHome:=FALSE;
                fInStandby:=FALSE;
                Picking;
            DEFAULT:
                fPickPlace:=0; 
                IF fInStandHome=FALSE THEN ClkStart clockToHome; ENDIF
                timeToHome:=ClkRead(clockToHome);
                IF fInStandHome=FALSE AND timeToHome>30 THEN 
                    MoveJ HomePos, vmax, z200, Gripper \WObj:=wobj0; 
                    fInStandHome:=TRUE;
                    fInStandby:=FALSE;
                ENDIF
            ENDTEST
        ELSE  
            !Check Place Box
            P_PatternSelect PiLine;
            IF PcLine<>0 THEN
                fInStandHome:=FALSE;
                fInStandby:=FALSE;
                Placing;        
            ENDIF
        ENDIF
        
        GOTO L_CPP;
    ENDPROC 
    !*********************************************************************!
    PROC Picking()
        ClkReset clockCheckSpeed; ClkStart clockCheckSpeed;
        
        !Sequence Picking Box
        P_ClawOpen 15,0, FALSE;
        P_CheckClawOpen  15, 7;
        P_ClampOpen 15,0, FALSE;
        P_CheckClampOpen 15, 7;
        
        IF fRunMode=0 THEN
        TEST PiLine 
        CASE 1: Set xOut_101_1;
        CASE 2: Set xOut_101_2;
        ENDTEST   
        ENDIF 
        MoveJ Offs(PickBox,0,20,400), vmax, z20, Gripper;
        !AccSet 30,20;
        AccSet 60, 60;
        MoveL Offs(PickBox,0,20,15), vmax, z50, Gripper;
        MoveL Offs(PickBox,0,0,0), vmax, fine, Gripper;
        MoveL Offs(PickBox,0,-30,0), vmax, fine, Gripper;
        WaitRob\InPos;
        
        IF fRunMode = 0 THEN
            TEST PiLine 
            CASE 1: TimeClampClose := xIn_126/1000;
            CASE 2: TimeClampClose := xIn_132/1000;
		    DEFAULT: TimeClampClose := 1;
            ENDTEST  
        ELSE
            TimeClampClose := 1.1;
        ENDIF
        P_ClawClose dPosTriggerGripperClose, 0, FALSE;
        P_CheckClawClose dPosTriggerGripperClose, 7;
        P_ClampClose dPosTriggerGripperClose,TimeClampClose, FALSE;
        P_ClampClose dPosTriggerGripperClose,0, TRUE;
       
        
        dPosBoxInGripper:=dPosTriggerGripperClose;
        dLineBoxInGrip:=PiLine;
        fPickPlace:=10+PiLine;
        !P_TrapCheckBoxEnable dPosBoxInGripper,xIn_104_4;
        P_CheckGripLoad dPosBoxInGripper;
        IF PickBox.trans.z+400 >  PlaceBox.trans.z+OffsPlaceZMax+BoxH{PiLine} THEN!
            MoveL Offs(PickBox,0,-30,400), vmax, z200, Gripper;
        ELSE
            MoveL Offs(PickBox,0,-30,PlaceBox.trans.z+OffsPlaceZMax+BoxH{PiLine} - PickBox.trans.z), vmax, z200, Gripper;!
        ENDIF
        
        P_ClampClose dPosTriggerGripperClose,0, TRUE;
        IF fRunMode=0 THEN
            TEST PiLine 
            CASE 1: Set xOut_101_3;
            CASE 2: Set xOut_101_4;
            ENDTEST   
        ENDIF 
        
    ENDPROC
    !*********************************************************************!
    PROC Placing()
        !Sequence Placing Box
        AccSet 100,100;
        IF (fPickPlace-PiLine)=10 OR fPickPlace = 0 THEN!After Picking
            IF PickBox.trans.z+400 >  PlaceBox.trans.z+OffsPlaceZMax+BoxH{PiLine} THEN!
                MoveJ Offs(PlaceBox, OffsPlaceX, OffsPlaceY, PickBox.trans.z+400-PlaceBox.trans.z), vmax, z200, Gripper;
            ELSE
                MoveJ Offs(PlaceBox, OffsPlaceX, OffsPlaceY, OffsPlaceZMax+BoxH{PcLine}), vmax, z200, Gripper;!
            ENDIF    
        ELSE
            TEST Pattern{PcLine}
            CASE 2:     TEST Counter{PcLine} MOD 7
                        CASE 5,0:MoveL Offs(PlaceBox, 0, 0,  100), vmax, z200, Gripper;
                        DEFAULT: MoveL Offs(PlaceBox, OffsPlaceX, OffsPlaceY,  BoxH{PcLine}+100), vmax, z200, Gripper;
                        ENDTEST
            CASE 3:   MoveL Offs(PlaceBox, 0, 0,  BoxH{PcLine}+100), vmax, z200, Gripper;
            CASE 4:     TEST Counter{PcLine} MOD 5
                        CASE 0:MoveL Offs(PlaceBox, 0, 0,  100), vmax, z200, Gripper;
                        DEFAULT: MoveL Offs(PlaceBox, OffsPlaceX, OffsPlaceY,  BoxH{PcLine}+100), vmax, z200, Gripper;
                        ENDTEST
            CASE 5,6: MoveL Offs(PlaceBox, OffsPlaceX, OffsPlaceY,  BoxH{PcLine}+100), vmax, z200, Gripper;
            DEFAULT: MoveL Offs(PlaceBox, 0, 0,  100), vmax, z200, Gripper;
            ENDTEST
        ENDIF
        
        
        IF fRunMode=0 THEN
            TEST PiLine 
            CASE 1: Reset xOut_101_3;
            CASE 2: Reset xOut_101_4;
            ENDTEST   
        ENDIF 
        AccSet 60, 60;
        !MoveL Offs(PlaceBox, OffsPlaceX, OffsPlaceY,  BoxH{PcLine}+100), vmax, z200, Gripper;
        MoveL Offs(PlaceBox, OffsPlaceX, OffsPlaceY, UpPlace ), vmax, z200, Gripper;!OffsPlaceZ{PcLine} +
        !AccSet 20, 20;
        MoveL Offs(PlaceBox, 0, 0, UpPlace ), vmax, fine, Gripper;!OffsPlaceZ{PcLine} +
        WaitRob\InPos;
        P_TrapCheckBoxEnable 0,1;
        P_ClawOpen dPosTriggerGripperOpen,0, FALSE;
        P_CheckClawOpen dPosTriggerGripperOpen, 7;
        MoveL Offs(PlaceBox, 0, 0, DownPlace), vmax, fine, Gripper;
        WaitRob\InPos;
        P_ClampOpen dPosTriggerGripperOpen,0, FALSE;
        P_CheckClampOpen dPosTriggerGripperOpen, 7;
        
        
        
        IF fRunMode=0 THEN
            TEST PcLine 
            CASE 1: Set xOut_101_5; WaitDI xIn_101_4,0;
            CASE 2: Set xOut_101_6; WaitDI xIn_101_5,0;
            ENDTEST  
            !incr Counter{PcLine};
        ELSE
            incr Counter{PcLine};
        ENDIF 
        dPosBoxInGripper:=dPosBoxInGripper-dPosTriggerGripperOpen;
        fPickPlace:=20+PcLine;
         IF dPosBoxInGripper<=0 THEN
            dPosBoxInGripper:=0;
            dLineBoxInGrip:=0;
        ENDIF
        P_CheckGripLoad dPosBoxInGripper;
        
        AccSet 60,60;
        IF dPosBoxInGripper = 0 THEN
            IF PickBox.trans.z+400 >  PlaceBox.trans.z+OffsPlaceZMax+BoxH{PcLine} THEN !
                AccSet 100,100;
                MoveL Offs(PlaceBox, 0, 0, PickBox.trans.z+400-PlaceBox.trans.z), vmax, z200, Gripper;
                
!                P_ClampOpen dPosTriggerGripperOpen,0, FALSE;
!                P_CheckClampOpen dPosTriggerGripperOpen, 7;
                MoveJ Offs(PickBox,0,20,400), vmax, z200, Gripper;
                
            ELSE
                MoveL Offs(PlaceBox, 0, 0, OffsPlaceZMax+BoxH{PcLine}), vmax, z200, Gripper;! 
                
!                P_ClampOpen dPosTriggerGripperOpen,0, FALSE;
!                P_CheckClampOpen dPosTriggerGripperOpen, 7;
                MoveJ Offs(PickBox,0,20,(PlaceBox.trans.z+OffsPlaceZMax+BoxH{PcLine})-PickBox.trans.z), vmax, z150, Gripper;!
            ENDIF
            IF fRunMode=0 THEN
            TEST PcLine 
            CASE 1: Reset xOut_101_1;
            CASE 2: Reset xOut_101_2;
            ENDTEST   
            ENDIF
            
            ClkStop clockCheckSpeed;
            timeCheckSpeed:=ClkRead(clockCheckSpeed);
            TPWrite "Cycle Time: "\Num:=timeCheckSpeed;
        ELSE
            TEST Pattern{PcLine}
            CASE 2: TEST Counter{PcLine} MOD 7
                    CASE 4,6:MoveL Offs(PlaceBox, 0, 0,  100), vmax, z200, Gripper;
                    DEFAULT: MoveL Offs(PlaceBox, 0, 0,  BoxH{PcLine}+100), vmax, z200, Gripper;
                    ENDTEST
            CASE 3: MoveL Offs(PlaceBox, 0, 0,  BoxH{PcLine}+100), vmax, z200, Gripper;
            CASE 4: TEST Counter{PcLine} MOD 5
                    CASE 4:MoveL Offs(PlaceBox, 0, 0,  100), vmax, z200, Gripper;
                    DEFAULT: MoveL Offs(PlaceBox, 0, 0,  BoxH{PcLine}+100), vmax, z200, Gripper;
                    ENDTEST
            CASE 5,6: MoveL Offs(PlaceBox, 0, 0,  BoxH{PcLine}+100), vmax, z200, Gripper;
            DEFAULT: MoveL Offs(PlaceBox, 0, 0,  100), vmax, z200, Gripper;
            ENDTEST
        ENDIF
        
        IF fRunMode=0 THEN
            TEST PcLine 
            CASE 1: Reset xOut_101_5; 
            CASE 2: Reset xOut_101_6; 
            ENDTEST   
        ENDIF
        
        
        
        
    ENDPROC
    !*********************************************************************!
    PROC Homing()
        P_GoUpCurrentPosition HomePos.trans.z, v2500, fine,Gripper, wobj0, FALSE;
        WaitRob\InPos;
        MoveJ HomePos, v4000, z200, Gripper;
        tHoming:=TRUE;
        PP_Pallet:=TRUE;
	ENDPROC
  
   !*********************************************************************!
     
    !*********************************************************************!
    !------------------------------------------------
    ! ===============INTERRUPT PROGRAM===============
    !------------------------------------------------
    !---Trap Check Box At Gripper
    TRAP T_CheckBox1
        StopMove;
        StorePath;
        PulseDO \High \PLength:=2, xOut_102_1;
        TPWrite "Box 1 Jammed In Module Gripper";
        RestoPath;
        StartMove;
	ENDTRAP
    TRAP T_CheckBox2
        StopMove;
        StorePath;
        PulseDO \High \PLength:=2, xOut_102_1;
        TPWrite "Box 2 Jammed In Module Gripper";
        RestoPath;
        StartMove;
	ENDTRAP
    TRAP T_CheckBox3
        StopMove;
        StorePath;
        PulseDO \High \PLength:=2, xOut_102_1;
        TPWrite "Box 3 Jammed In Module Gripper";
        RestoPath;
        StartMove;
	ENDTRAP
    TRAP T_CheckBox4
        StopMove;
        StorePath;
        PulseDO \High \PLength:=2, xOut_102_1;
        TPWrite "Box 4 Jammed In Module Gripper";
        RestoPath;
        StartMove;
	ENDTRAP
   
ENDMODULE