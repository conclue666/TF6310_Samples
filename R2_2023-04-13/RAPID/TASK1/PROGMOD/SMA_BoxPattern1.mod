MODULE SMA_BoxPattern1
    !*******************<<<< ROBOTICS PALLETIZER >>>>*********************!
    !Program    : Box Pattern                                             !
    !Created by : Arif                                                    !
    !Company    : IRA Robotics Indonesia                                  !
    !*********************************************************************!
    PROC BoxPattern1 (robtarget iPlaceA, robtarget iPlaceB, robtarget iPlaceC, robtarget iPlaceD,
                num PlaceLine,num iCounter, num iBoxLength, num iBoxWidth, num iBoxHeight, num iPallet_X, num iPallet_Y, num iPallet_Z,
                num iRefBoxLength, num iRefBoxWidth, num iCustom_Rz, bool mirror,
                num iReferencePointNumber, num iDirectionNumber, num iOffsetValue, 
                PERS robtarget oPlace, PERS num oLayer, PERS num oOfset_X, PERS num oOfset_Y,PERS num oPosBox,PERS num oPlaceNumber)
         
        VAR num p; VAR num q; VAR num r;   !------- Pattern Offset Coordinat
        VAR num Off_p;  VAR num Off_q;	   !-------Internal Variabel for Ofset X and Y before Placing
        VAR num x; VAR num y; VAR num z;  !-------Robot Coordinat 
        VAR num Cl_Thick:=6; !--- Tebal Fix Clamping
        VAR num Cl_p; VAR num Cl_q;
        VAR num iP_Pallet; VAR num iQ_Pallet;
        VAR num DPalBoxP4W; VAR num DPalBoxP3L; VAR num DPalBoxQ2L2W;
        VAR num DBoxLength; VAR num DBoxWidth; 
        VAR num DPallet_X; VAR num DPallet_Y;VAR num DPallet_Z;
        VAR num L; VAR num W; VAR num H;
        VAR num D4Wm3L; !Selisih 4W minus 3L
        VAR num D3Lm4W; !Selisih 4W minus 3L
        VAR num fCtm_Rz;
        VAR robtarget fPlaceA; VAR robtarget fPlaceB; VAR robtarget fPlaceC; VAR robtarget fPlaceD; 
        !------- Check Warning
        CheckWarning:
        IF iCounter<=0 THEN
            TPWrite "PROCEDURE BoxPattern ERROR (Value iCounter <= 0) ";
            WaitTime 2;
            GOTO CheckWarning;
        ENDIF
        L:=iBoxLength; W:=iBoxWidth; H:=iBoxHeight;
        fCtm_Rz:=iCustom_Rz;
        iP_Pallet:=iPallet_X; iQ_Pallet:=iPallet_Y;   
        !-----Gap Box
        IF 3*L > 4*W THEN
            D3Lm4W:=3*L-4*W;
	    ELSEIF 4*W > 3*L THEN
		    D4Wm3L:=(4*W-3*L)/2;
        ELSE
            D3Lm4W:=0;
		    D4Wm3L:=0;
        ENDIF
        !-----Delta Box Reference(Box yang di teaching) dengan input box
        DBoxLength:=iRefBoxLength-L;
        DBoxWidth:=iRefBoxWidth-W;
        !-----Delta Pallet dengan box
        DPalBoxP4W:=(iP_Pallet-(4*W))/2; 
        DPalBoxP3L:=(iP_Pallet-(3*L))/2; 
        DPalBoxQ2L2W:=(iQ_Pallet-(2*L+2*W))/2;
        !-------ReferencePoint For Pallet & Ofset Box
        TEST iReferencePointNumber
        CASE 1:
                fPlaceA:=iPlaceA;
                fPlaceB:=iPlaceB;  
                fPlaceC:=iPlaceC;
                fPlaceD:=iPlaceD; 
                L:=iBoxLength; W:=iBoxWidth; H:=iBoxHeight;
        CASE 3:
                fPlaceA:=Offs(iPlaceC,iPallet_X-2*iRefBoxLength,iPallet_Y-iRefBoxWidth,0);
                fPlaceB:=Offs(iPlaceD,iPallet_X-iRefBoxWidth,iPallet_Y-2*iRefBoxLength,0);  
                fPlaceC:=Offs(iPlaceA,iPallet_X-2*iRefBoxLength,iPallet_Y-iRefBoxWidth,0);
                fPlaceD:=Offs(iPlaceB,iPallet_X-iRefBoxWidth,iPallet_Y-2*iRefBoxLength,0);
                DPalBoxP4W:=-DPalBoxP4W; 
                DPalBoxP3L:=-DPalBoxP3L; 
                DPalBoxQ2L2W:=-DPalBoxQ2L2W;
                DBoxLength:=-DBoxLength;
                DBoxWidth:=-DBoxWidth;
                L:=-iBoxLength; W:=-iBoxWidth; H:=iBoxHeight;
        ENDTEST
        
        
        !-------Setting Pattern Coordinat Offset 
        IF mirror = FALSE THEN
               TEST (iCounter MOD 7) 
                CASE 1:!----Normal----
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength+2*L+D4Wm3L;
                    q:=DPalBoxQ2L2W-DBoxWidth+2*L+W;
                    Off_p:=0; Off_q:=0; 
                    oPosBox:=3;
                CASE 2:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength+L;
                    q:=DPalBoxQ2L2W-DBoxWidth+2*L+W;
                    Off_p:=-iOffsetValue; Off_q:=0; 
                    oPosBox:=3;
                CASE 3:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength-D4Wm3L;
                    q:=DPalBoxQ2L2W-DBoxWidth+2*L+W;
                    Off_p:=-iOffsetValue; Off_q:=0; 
                    oPosBox:=3;
                CASE 4:
                    oPlace:=fPlaceA;
                    p:=DPalBoxP4W-D3Lm4W/2;
                    q:=DPalBoxQ2L2W-DBoxLength+L;
                    Off_p:=0; Off_q:=-iOffsetValue;
                    oPosBox:=3;
                CASE 5:
                    oPlace:=fPlaceA;
                    p:=DPalBoxP4W+D3Lm4W/2;
                    q:=DPalBoxQ2L2W-DBoxLength+L;
                    Off_p:=0; Off_q:=0;
                    oPosBox:=12;
                CASE 6:
                    oPlace:=fPlaceA;
                    p:=DPalBoxP4W-D3Lm4W/2;
                    q:=DPalBoxQ2L2W-DBoxLength;
                    Off_p:=0; Off_q:=-iOffsetValue;
                    oPosBox:=3;
                CASE 0:
                    oPlace:=fPlaceA;
                    p:=DPalBoxP4W+D3Lm4W/2;
                    q:=DPalBoxQ2L2W-DBoxLength;
                    Off_p:=0; Off_q:=0;
                    oPosBox:=12;
            ENDTEST 
        ELSE
            TEST (iCounter MOD 7) 
                CASE 1:!----Mirror----
                    oPlace:=fPlaceD;
                    p:=DPalBoxP3L-D4Wm3L;
                    q:=DPalBoxQ2L2W;
                    Off_p:=0; Off_q:=0; 
                    oPosBox:=3;
                CASE 2:
                    oPlace:=fPlaceD;
                    p:=DPalBoxP3L+L;
                    q:=DPalBoxQ2L2W;
                    Off_p:=iOffsetValue; Off_q:=0; 
                    oPosBox:=3;
                CASE 3:
                    oPlace:=fPlaceD;
                    p:=DPalBoxP3L+2*L+D4Wm3L;
                    q:=DPalBoxQ2L2W;
                    Off_p:=iOffsetValue; Off_q:=0; 
                    oPosBox:=3;
                CASE 4:
                    oPlace:=fPlaceC;
                    p:=DPalBoxP4W-DBoxWidth+3*W+D3Lm4W/2;
                    q:=DPalBoxQ2L2W+2*W;
                    Off_p:=0; Off_q:=iOffsetValue;
                    oPosBox:=3;
                CASE 5:
                    oPlace:=fPlaceC;
                    p:=DPalBoxP4W-DBoxWidth+3*W-D3Lm4W/2;
                    q:=DPalBoxQ2L2W+2*W;
                    Off_p:=0; Off_q:=0;
                    oPosBox:=12;
                CASE 6:
                    oPlace:=fPlaceC;
                    p:=DPalBoxP4W-DBoxWidth+3*W+D3Lm4W/2;
                    q:=DPalBoxQ2L2W+2*W+L;
                    Off_p:=0; Off_q:=iOffsetValue;
                    oPosBox:=3;
                CASE 0:
                    oPlace:=fPlaceC;
                    p:=DPalBoxP4W-DBoxWidth+3*W-D3Lm4W/2;
                    q:=DPalBoxQ2L2W+2*W+L;
                    Off_p:=0; Off_q:=0;
                    oPosBox:=12;
            ENDTEST 
        ENDIF
        
       
      
         !----------------------------------------    
        oPlaceNumber:=iCounter MOD 7;
        oLayer:=1+((iCounter-1) DIV 7); !-------Layer
      
        !Offset Layer
        r:=((oLayer-1)*H);
        
        !-------Direction Number
        TEST iReferencePointNumber
        CASE 1:
            x:=p; y:=q; z:=r;
            oOfset_X:=Off_p; oOfset_Y:=Off_q;
        CASE 2:
            x:=q; y:=-p; z:=r;
            oOfset_X:=Off_q; oOfset_Y:=-Off_p;
        CASE 3:
            x:=p; y:=q; z:=r;
            oOfset_X:=-Off_p; oOfset_Y:=-Off_q;
        CASE 4:
            x:=-q; y:=p; z:=r;
            oOfset_X:=-Off_q; oOfset_Y:=Off_p;
        ENDTEST
        !-------Place Setting
        oPlace:=Offs(oPlace,x,y,z);
        oPlace:=RelTool(oPlace,0,0,0 \Rz:=fCtm_Rz);
    ENDPROC
ENDMODULE