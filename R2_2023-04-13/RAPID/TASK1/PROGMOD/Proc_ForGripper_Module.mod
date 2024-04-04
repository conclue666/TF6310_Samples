MODULE Proc_ForGripper_Module
    !Untuk Gripper
  
    PERS num ChooseTesGrip;
    PERS num ChooseTesGrip2;
    PERS num ChooseTesGrip3;
    PERS bool ChooseTesGrip4;
    PERS num ChooseTesGrip5{2};
    PERS Bool ChooseTesGrip6{2};
    PERS num TimeTestGrip;
    PERS num vTrigGrip;
    PERS bool RS_Warning{2};
    !=======================================================
   
    !=======================================================
    PROC P_Clamp(num PosTrigger,num Trigger, num PTtimedelay)
        !Trigger 0 dan 3=area abu2... 1=Clamp Open... 2=Clamp Close..
        VAR num FlagClamp{4};
        
        FlagClamp{1}:=0; 
        FlagClamp{2}:=0; 
        FlagClamp{3}:=0; 
        FlagClamp{4}:=0;
        !---- Clamp 1 Open
        TEST PosTrigger 
        CASE 1,3,5,7,9,11,13,15: FlagClamp{1}:=1; ENDTEST
        
        !---- Clamp 2 Open
        TEST PosTrigger 
        CASE 2,3,6,7,10,11,14,15: FlagClamp{2}:=1; ENDTEST
        
        !---- Clamp 3 Open
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagClamp{3}:=1; ENDTEST
        
        !---- Clamp 4 Open
        TEST PosTrigger 
        CASE 8,9,10,11,12,13,14,15: FlagClamp{4}:=1; ENDTEST
        
        IF FlagClamp{1}=1 THEN  SetGO oTriggerClamp1,Trigger; ENDIF
        IF FlagClamp{2}=1 THEN  SetGO oTriggerClamp2,Trigger; ENDIF
        IF FlagClamp{3}=1 THEN  SetGO oTriggerClamp3,Trigger; ENDIF
        IF FlagClamp{4}=1 THEN  SetGO oTriggerClamp4,Trigger; ENDIF
        WaitTime PTtimedelay;
    ENDPROC
    !=======================================================
    PROC P_ClampOpen(num PosTrigger, num PTtimedelay, bool WithRelease)
        VAR num FlagClampO{4};
        
        FlagClampO{1}:=0; FlagClampO{2}:=0; FlagClampO{3}:=0; FlagClampO{4}:=0;
        !---- Clamp 1 Open
        TEST PosTrigger 
        CASE 1,3,5,7,9,11,13,15: FlagClampO{1}:=1; ENDTEST
        
        !---- Clamp 2 Open
        TEST PosTrigger 
        CASE 2,3,6,7,10,11,14,15: FlagClampO{2}:=1; ENDTEST
        
        !---- Clamp 3 Open
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagClampO{3}:=1; ENDTEST
        
        !---- Clamp 4 Open
        TEST PosTrigger 
        CASE 8,9,10,11,12,13,14,15: FlagClampO{4}:=1; ENDTEST
        
        IF FlagClampO{1}=1 THEN  SetGO oTriggerClamp1,1; ENDIF
        IF FlagClampO{2}=1 THEN  SetGO oTriggerClamp2,1; ENDIF
        IF FlagClampO{3}=1 THEN  SetGO oTriggerClamp3,1; ENDIF
        IF FlagClampO{4}=1 THEN  SetGO oTriggerClamp4,1; ENDIF
        WaitTime PTtimedelay;
        IF WithRelease=true THEN
            IF FlagClampO{1}=1 THEN  SetGO oTriggerClamp1,0; ENDIF
            IF FlagClampO{2}=1 THEN  SetGO oTriggerClamp2,0; ENDIF
            IF FlagClampO{3}=1 THEN  SetGO oTriggerClamp3,0; ENDIF
            IF FlagClampO{4}=1 THEN  SetGO oTriggerClamp4,0; ENDIF
        ENDIF
    ENDPROC
    
    !=======================================================
    PROC P_ClampClose(num PosTrigger, num PTtimedelay, bool WithRelease)
        VAR num FlagClampC{4};
        
        FlagClampC{1}:=0; FlagClampC{2}:=0; FlagClampC{3}:=0; FlagClampC{4}:=0;
        TEST PosTrigger 
        CASE 1,3,5,7,9,11,13,15: FlagClampC{1}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 2,3,6,7,10,11,14,15: FlagClampc{2}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagClampC{3}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 8,9,10,11,12,13,14,15: FlagClampC{4}:=1; ENDTEST
        
        IF FlagClampC{1}=1 THEN  SetGO oTriggerClamp1,2; ENDIF
        IF FlagClampC{2}=1 THEN  SetGO oTriggerClamp2,2; ENDIF
        IF FlagClampC{3}=1 THEN  SetGO oTriggerClamp3,2; ENDIF
        IF FlagClampC{4}=1 THEN  SetGO oTriggerClamp4,2; ENDIF
        WaitTime PTtimedelay;
        IF WithRelease=true THEN
            IF FlagClampC{1}=1 THEN  SetGO oTriggerClamp1,0; ENDIF
            IF FlagClampC{2}=1 THEN  SetGO oTriggerClamp2,0; ENDIF
            IF FlagClampC{3}=1 THEN  SetGO oTriggerClamp3,0; ENDIF
            IF FlagClampC{4}=1 THEN  SetGO oTriggerClamp4,0; ENDIF
        ENDIF
    ENDPROC
    !=======================================================
     PROC P_Claw(num PosTrigger,num Trigger, num PTtimedelay)
        VAR num FlagClaw{4};
        
        FlagClaw{1}:=0; FlagClaw{2}:=0; FlagClaw{3}:=0; FlagClaw{4}:=0;
        TEST PosTrigger 
        CASE 1,3,5,7,9,11,13,15: FlagClaw{1}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 2,3,6,7,10,11,14,15: FlagClaw{2}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagClaw{3}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 8,9,10,11,12,13,14,15: FlagClaw{4}:=1; ENDTEST
        
        IF FlagClaw{1}=1 THEN  SetGO oTriggerClaw1,Trigger; ENDIF
        IF FlagClaw{2}=1 THEN  SetGO oTriggerClaw2,Trigger; ENDIF
        IF FlagClaw{3}=1 THEN  SetGO oTriggerClaw3,Trigger; ENDIF
        IF FlagClaw{4}=1 THEN  SetGO oTriggerClaw4,Trigger; ENDIF
        WaitTime PTtimedelay;
    ENDPROC
    !=======================================================
    PROC P_ClawOpen(num PosTrigger, num PTtimedelay, bool WithRelease)
        VAR num FlagClawO{4};
        
        FlagClawO{1}:=0; FlagClawO{2}:=0; FlagClawO{3}:=0; FlagClawO{4}:=0;
        TEST PosTrigger 
        CASE 1,3,5,7,9,11,13,15: FlagClawO{1}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 2,3,6,7,10,11,14,15: FlagClawO{2}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagClawO{3}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 8,9,10,11,12,13,14,15: FlagClawO{4}:=1; ENDTEST
        
        IF FlagClawO{1}=1 THEN  SetGO oTriggerClaw1,1; ENDIF
        IF FlagClawO{2}=1 THEN  SetGO oTriggerClaw2,1; ENDIF
        IF FlagClawO{3}=1 THEN  SetGO oTriggerClaw3,1; ENDIF
        IF FlagClawO{4}=1 THEN  SetGO oTriggerClaw4,1; ENDIF
        WaitTime PTtimedelay;
        IF WithRelease=true THEN
            IF FlagClawO{1}=1 THEN  SetGO oTriggerClaw1,0; ENDIF
            IF FlagClawO{2}=1 THEN  SetGO oTriggerClaw2,0; ENDIF
            IF FlagClawO{3}=1 THEN  SetGO oTriggerClaw3,0; ENDIF
            IF FlagClawO{4}=1 THEN  SetGO oTriggerClaw4,0; ENDIF
        ENDIF
    ENDPROC
    !=======================================================
    PROC P_ClawClose(num PosTrigger, num PTtimedelay, bool WithRelease)
        VAR num FlagClawC{4};
        
        FlagClawC{1}:=0; FlagClawC{2}:=0; FlagClawC{3}:=0; FlagClawC{4}:=0;
        TEST PosTrigger
        CASE 1,3,5,7,9,11,13,15: FlagClawC{1}:=1; ENDTEST
        
        TEST PosTrigger
        CASE 2,3,6,7,10,11,14,15: FlagClawC{2}:=1; ENDTEST
        
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagClawC{3}:=1; ENDTEST
        
        TEST PosTrigger
        CASE 8,9,10,11,12,13,14,15: FlagClawC{4}:=1; ENDTEST
        
        IF FlagClawC{1}=1 THEN  SetGO oTriggerClaw1,2; ENDIF
        IF FlagClawC{2}=1 THEN  SetGO oTriggerClaw2,2; ENDIF
        IF FlagClawC{3}=1 THEN  SetGO oTriggerClaw3,2; ENDIF
        IF FlagClawC{4}=1 THEN  SetGO oTriggerClaw4,2; ENDIF
        WaitTime PTtimedelay;
        IF WithRelease=true THEN
            IF FlagClawC{1}=1 THEN  SetGO oTriggerClaw1,0; ENDIF
            IF FlagClawC{2}=1 THEN  SetGO oTriggerClaw2,0; ENDIF
            IF FlagClawC{3}=1 THEN  SetGO oTriggerClaw3,0; ENDIF
            IF FlagClawC{4}=1 THEN  SetGO oTriggerClaw4,0; ENDIF
        ENDIF
    ENDPROC
    !=======================================================
    PROC P_CheckClampOpen(num PosTrigger, num PTtimecheck)
        !*********************<<<<  >>>>**********************                                 
	    !Created by   : Arif     
	    !*****************************************************
        !-------------------------
        VAR clock clockCheck; VAR num timeCheck;
        VAR num SensorCheck{4};
        VAR num FlagCheck{4};
        !-------------------------
        ClkStop clockCheck; 
        ClkReset clockCheck; ClkStart clockCheck;
        SensorCheck{1}:=0; SensorCheck{2}:=0; SensorCheck{3}:=0; SensorCheck{4}:=0;
        FlagCheck{1}:=0; FlagCheck{2}:=0; FlagCheck{3}:=0; FlagCheck{4}:=0;
        
        TEST PosTrigger
        CASE 1,3,5,7,9,11,13,15: FlagCheck{1}:=1; ENDTEST
        TEST PosTrigger
        CASE 2,3,6,7,10,11,14,15: FlagCheck{2}:=1; ENDTEST
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagCheck{3}:=1; ENDTEST
        TEST PosTrigger
        CASE 8,9,10,11,12,13,14,15: FlagCheck{4}:=1; ENDTEST
        
         L_CHECKSENSOR:
            TEST iSensorClampOpen
            CASE 1,3,5,7,9,11,13,15: SensorCheck{1}:=1; ENDTEST
            TEST iSensorClampOpen
            CASE 2,3,6,7,10,11,14,15: SensorCheck{2}:=1; ENDTEST
            TEST iSensorClampOpen 
            CASE 4,5,6,7,12,13,14,15: SensorCheck{3}:=1; ENDTEST
            TEST iSensorClampOpen
            CASE 8,9,10,11,12,13,14,15: SensorCheck{4}:=1; ENDTEST
            
            timeCheck:=ClkRead(clockCheck);
            IF timeCheck<PTtimecheck AND FlagCheck{1}=1 AND SensorCheck{1}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{2}=1 AND SensorCheck{2}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{3}=1 AND SensorCheck{3}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{4}=1 AND SensorCheck{4}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            ClkStop clockCheck;
            IF  FlagCheck{1}=1 AND FlagCheck{1}<>SensorCheck{1} THEN 
                PulseDO \High \PLength:=2, xOut_102_2;
                TPWrite "Clamp Open 1 Error"; 
            ENDIF
            IF FlagCheck{2}=1 AND FlagCheck{2}<>SensorCheck{2} THEN 
                PulseDO \High \PLength:=2, xOut_102_2;
                TPWrite "Clamp Open 2 Error"; 
            ENDIF
            IF FlagCheck{3}=1 AND FlagCheck{3}<>SensorCheck{3} THEN 
                PulseDO \High \PLength:=2, xOut_102_2;
                TPWrite "Clamp Open 3 Error"; 
            ENDIF
            IF FlagCheck{4}=1 AND FlagCheck{4}<>SensorCheck{4} THEN 
                PulseDO \High \PLength:=2, xOut_102_2;
                TPWrite "Clamp Open 4 Error"; 
            ENDIF
    ENDPROC
    !=======================================================
    
    
    !=======================================================
     PROC P_CheckClawOpen(num PosTrigger, num PTtimecheck)
        !*********************<<<<  >>>>**********************                                 
	    !Created by   : Arif     
	    !*****************************************************
        !-------------------------
        VAR clock clockCheck; VAR num timeCheck;
        VAR num SensorCheck{4};
        VAR num FlagCheck{4};
        !-------------------------
        ClkStop clockCheck; 
        ClkReset clockCheck; ClkStart clockCheck;
        SensorCheck{1}:=0; SensorCheck{2}:=0; SensorCheck{3}:=0; SensorCheck{4}:=0;
        FlagCheck{1}:=0; FlagCheck{2}:=0; FlagCheck{3}:=0; FlagCheck{4}:=0;
        
        TEST PosTrigger
        CASE 1,3,5,7,9,11,13,15: FlagCheck{1}:=1; ENDTEST
        TEST PosTrigger
        CASE 2,3,6,7,10,11,14,15: FlagCheck{2}:=1; ENDTEST
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagCheck{3}:=1; ENDTEST
        TEST PosTrigger
        CASE 8,9,10,11,12,13,14,15: FlagCheck{4}:=1; ENDTEST
        
         L_CHECKSENSOR:
            TEST iSensorClawOpen
            CASE 1,3,5,7,9,11,13,15: SensorCheck{1}:=1; ENDTEST
            TEST iSensorClawOpen
            CASE 2,3,6,7,10,11,14,15: SensorCheck{2}:=1; ENDTEST
            TEST iSensorClawOpen 
            CASE 4,5,6,7,12,13,14,15: SensorCheck{3}:=1; ENDTEST
            TEST iSensorClawOpen
            CASE 8,9,10,11,12,13,14,15: SensorCheck{4}:=1; ENDTEST
            
            timeCheck:=ClkRead(clockCheck);
            IF timeCheck<PTtimecheck AND FlagCheck{1}=1 AND SensorCheck{1}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{2}=1 AND SensorCheck{2}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{3}=1 AND SensorCheck{3}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{4}=1 AND SensorCheck{4}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            ClkStop clockCheck;
            
            IF FlagCheck{1}=1 AND FlagCheck{1}<>SensorCheck{1} THEN 
                PulseDO \High \PLength:=2, xOut_102_3;
                TPWrite "Claw Open 1 Error"; 
            ENDIF
            IF FlagCheck{2}=1 AND FlagCheck{2}<>SensorCheck{2} THEN 
                PulseDO \High \PLength:=2, xOut_102_3;
                TPWrite "Claw Open 2 Error"; 
            ENDIF
            IF FlagCheck{3}=1 AND FlagCheck{3}<>SensorCheck{3} THEN 
                PulseDO \High \PLength:=2, xOut_102_3;
                TPWrite "Claw Open 3 Error"; 
            ENDIF
            IF FlagCheck{4}=1 AND FlagCheck{4}<>SensorCheck{4} THEN 
                PulseDO \High \PLength:=2, xOut_102_3;
                TPWrite "Claw Open 4 Error"; 
            ENDIF
            
    ENDPROC
    !=======================================================
      PROC P_CheckClawClose(num PosTrigger, num PTtimecheck)
        !*********************<<<<  >>>>**********************                                 
	    !Created by   : Arif     
	    !*****************************************************
        !-------------------------
        VAR clock clockCheck; VAR num timeCheck;
        VAR num SensorCheck{4};
        VAR num FlagCheck{4};
        !-------------------------
        ClkStop clockCheck; 
        ClkReset clockCheck; ClkStart clockCheck;
        SensorCheck{1}:=0; SensorCheck{2}:=0; SensorCheck{3}:=0; SensorCheck{4}:=0;
        FlagCheck{1}:=0; FlagCheck{2}:=0; FlagCheck{3}:=0; FlagCheck{4}:=0;
       
        TEST PosTrigger
        CASE 1,3,5,7,9,11,13,15: FlagCheck{1}:=1; ENDTEST
        TEST PosTrigger
        CASE 2,3,6,7,10,11,14,15: FlagCheck{2}:=1; ENDTEST
        TEST PosTrigger 
        CASE 4,5,6,7,12,13,14,15: FlagCheck{3}:=1; ENDTEST
        TEST PosTrigger
        CASE 8,9,10,11,12,13,14,15: FlagCheck{4}:=1; ENDTEST
        
         L_CHECKSENSOR:
            TEST iSensorClawClose
            CASE 1,3,5,7,9,11,13,15: SensorCheck{1}:=1; ENDTEST
            TEST iSensorClawClose
            CASE 2,3,6,7,10,11,14,15: SensorCheck{2}:=1; ENDTEST
            TEST iSensorClawClose 
            CASE 4,5,6,7,12,13,14,15: SensorCheck{3}:=1; ENDTEST
            TEST iSensorClawClose
            CASE 8,9,10,11,12,13,14,15: SensorCheck{4}:=1; ENDTEST
            
            timeCheck:=ClkRead(clockCheck);
            IF timeCheck<PTtimecheck AND FlagCheck{1}=1 AND SensorCheck{1}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{2}=1 AND SensorCheck{2}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{3}=1 AND SensorCheck{3}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            IF timeCheck<PTtimecheck AND FlagCheck{4}=1 AND SensorCheck{4}=0 THEN 
                GOTO L_CHECKSENSOR; 
            ENDIF
            ClkStop clockCheck;
            
            IF FlagCheck{1}=1 AND FlagCheck{1}<>SensorCheck{1} THEN 
                PulseDO \High \PLength:=2, xOut_102_4;
                TPWrite "Claw Close 1 Error"; 
            ENDIF
            IF FlagCheck{2}=1 AND FlagCheck{2}<>SensorCheck{2} THEN 
                PulseDO \High \PLength:=2, xOut_102_4;
                TPWrite "Claw Close 2 Error"; 
            ENDIF
            IF FlagCheck{3}=1 AND FlagCheck{3}<>SensorCheck{3} THEN 
                PulseDO \High \PLength:=2, xOut_102_4;
                TPWrite "Claw Close 3 Error"; 
            ENDIF
            IF FlagCheck{4}=1 AND FlagCheck{4}<>SensorCheck{4} THEN 
                PulseDO \High \PLength:=2, xOut_102_4;
                TPWrite "Claw Close 4 Error"; 
            ENDIF
            
            ClkStop clockCheck;
    ENDPROC
    !=======================================================
    !=======================================================
    PROC P_TesGripper()
        TPErase;
        ChooseTesGrip:=0;
        ChooseTesGrip6{1}:=FALSE;  
        ChooseTesGrip6{2}:=FALSE;
        ChooseTesGrip2:=0;
        ChooseTesGrip3:=0;
        ChooseTesGrip5{1}:=0; ChooseTesGrip5{2}:=0;
        TPReadFK ChooseTesGrip,"Test Gripper?","Clamp Open","Clamp Close","Claw Open","Claw Close",stEmpty; 
        TEST ChooseTesGrip
        CASE 1: !Clamp Open
            TPReadFK ChooseTesGrip2,"Test Clamp Open?","1","2","3","4","All"; 
            TEST ChooseTesGrip2
            CASE 1: vTrigGrip:=1;
            CASE 2: vTrigGrip:=2;
            CASE 3: vTrigGrip:=4;
            CASE 4: vTrigGrip:=8;
            CASE 5: vTrigGrip:=15;
            ENDTEST
            TPReadNum TimeTestGrip,"Time To Clamp Open ? : "; 
            TPReadFK ChooseTesGrip3,"With Release Trigger?","Yes","No",stEmpty,stEmpty,stEmpty; 
            IF ChooseTesGrip3=1 THEN
                ChooseTesGrip4:=TRUE;
            ELSE
                ChooseTesGrip4:=FALSE;
            ENDIF
            TPReadFK ChooseTesGrip5{1},"With Check Sensor?","Yes","No",stEmpty,stEmpty,stEmpty; 
            P_ClampOpen vTrigGrip, TimeTestGrip, ChooseTesGrip4;
            IF ChooseTesGrip5{1}=1 THEN
                P_CheckClampOpen vTrigGrip, 7; !Check Sensor Clamp Open  
            ENDIF
        CASE 2: !Clamp Close
            TPReadFK ChooseTesGrip2,"Test Clamp Close?","1","2","3","4","All"; 
            TEST ChooseTesGrip2
            CASE 1: vTrigGrip:=1;
            CASE 2: vTrigGrip:=2;
            CASE 3: vTrigGrip:=4;
            CASE 4: vTrigGrip:=8;
            CASE 5: vTrigGrip:=15;
            ENDTEST
            TPReadNum TimeTestGrip,"Time To Clamp Close ? : "; 
            TPReadFK ChooseTesGrip3,"With Release Trigger?","Yes","No",stEmpty,stEmpty,stEmpty; 
            IF ChooseTesGrip3=1 THEN
                ChooseTesGrip4:=TRUE;
            ELSE
                ChooseTesGrip4:=FALSE;
            ENDIF
            P_ClampClose vTrigGrip, TimeTestGrip, ChooseTesGrip4;
        CASE 3: !Claw Open
            TPReadFK ChooseTesGrip2,"Test Claw Open?","1","2","3","4","All"; 
            TEST ChooseTesGrip2
             CASE 1: vTrigGrip:=1;
            CASE 2: vTrigGrip:=2;
            CASE 3: vTrigGrip:=4;
            CASE 4: vTrigGrip:=8;
            CASE 5: vTrigGrip:=15;
            ENDTEST
            TPReadNum TimeTestGrip,"Time To Claw Open ? : "; 
            TPReadFK ChooseTesGrip3,"With Release Trigger?","Yes","No",stEmpty,stEmpty,stEmpty; 
            IF ChooseTesGrip3=1 THEN
                ChooseTesGrip4:=TRUE;
            ELSE
                ChooseTesGrip4:=FALSE;
            ENDIF
            TPReadFK ChooseTesGrip5{1},"With Check Sensor?","Yes","No",stEmpty,stEmpty,stEmpty; 
            
            P_ClawOpen vTrigGrip, TimeTestGrip, ChooseTesGrip4;
            IF ChooseTesGrip5{1}=1 THEN
                P_CheckClawOpen vTrigGrip, 7; !Check Sensor Claw Open  
            ENDIF
        CASE 4: !Claw Close
            TPReadFK ChooseTesGrip2,"Test Claw Close?","1","2","3","4","All";
            TEST ChooseTesGrip2
            CASE 1: vTrigGrip:=1;
            CASE 2: vTrigGrip:=2;
            CASE 3: vTrigGrip:=4;
            CASE 4: vTrigGrip:=8;
            CASE 5: vTrigGrip:=15;
            ENDTEST
            TPReadNum TimeTestGrip,"Time To Claw Close ? : "; 
            TPReadFK ChooseTesGrip3,"With Release Trigger?","Yes","No",stEmpty,stEmpty,stEmpty; 
            IF ChooseTesGrip3=1 THEN
                ChooseTesGrip4:=TRUE;
            ELSE
                ChooseTesGrip4:=FALSE;
            ENDIF
            TPReadFK ChooseTesGrip5{1},"With Check Sensor?","Yes","No",stEmpty,stEmpty,stEmpty; 
            P_ClawClose vTrigGrip, TimeTestGrip, ChooseTesGrip4;
             IF ChooseTesGrip5{1}=1 THEN
                P_CheckClawClose vTrigGrip, 7; !Check Sensor Claw Close 
            ENDIF
        ENDTEST
    ENDPROC
    !=======================================================
    !=======================================================
ENDMODULE