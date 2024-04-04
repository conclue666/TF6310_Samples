MODULE SMA_BoxPattern4
    !*******************<<<< ROBOTICS PALLETIZER >>>>*********************!
    !Program    : Box Pattern                                             !
    !Created by : Arif                                                    !
    !Company    : IRA Robotics Indonesia                                  !
    !*********************************************************************!
    PROC BoxPattern4 (robtarget iPlaceA, robtarget iPlaceB, robtarget iPlaceC, robtarget iPlaceD,
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
        VAR num DPalBoxQ2LW; VAR num DPalBoxP3W; VAR num DPalBoxP2L;
        VAR num DBoxLength; VAR num DBoxWidth; 
        VAR num DPallet_X; VAR num DPallet_Y;VAR num DPallet_Z;
        VAR num L; VAR num W; VAR num H;
        VAR num D3Wm2L; !Selisih 3W minus 2L
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
        !-----Delta Box Reference(Box yang di teaching) dengan input box
        DBoxLength:=iRefBoxLength-L;
        DBoxWidth:=iRefBoxWidth-W;
        
        IF 3*W > 2*L THEN
		    D3Wm2L:=(3*W-2*L);
        ELSE
            D3Wm2L:=0;
        ENDIF
        
        !-----Delta Pallet dengan box
        DPalBoxP3W:=(iP_Pallet-(3*W))/2; 
        DPalBoxP2L:=(iP_Pallet-(2*L+D3Wm2L))/2; 
        DPalBoxQ2LW:=(iQ_Pallet-(2*L+W))/2;
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
                DPalBoxP3W:=-DPalBoxP3W; 
                DPalBoxP2L:=-DPalBoxP2L; 
                DPalBoxQ2LW:=-DPalBoxQ2LW;
                DBoxLength:=-DBoxLength;
                DBoxWidth:=-DBoxWidth;
                L:=-iBoxLength; W:=-iBoxWidth; H:=iBoxHeight;
        ENDTEST
        
        
        !-------Setting Pattern Coordinat Offset 
        IF mirror = FALSE THEN
               TEST (iCounter MOD 4) 
                CASE 1:!----Normal----
                    oPlace:=fPlaceB;
                    p:=DPalBoxP2L-DBoxLength+L+D3Wm2L;
                    q:=DPalBoxQ2LW-DBoxWidth+2*L;
                    Off_p:=0; Off_q:=0; 
                    oPosBox:=1;
                CASE 2:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP2L-DBoxLength;
                    q:=DPalBoxQ2LW-DBoxWidth+2*L+W;
                    Off_p:=-iOffsetValue; Off_q:=0;
                    oPosBox:=2;
                CASE 3:
                    oPlace:=fPlaceA;
                    p:=DPalBoxP3W;
                    q:=DPalBoxQ2LW-DBoxLength+L;
                    Off_p:=0; Off_q:=-iOffsetValue; 
                    oPosBox:=15;
                CASE 0:
                     oPlace:=fPlaceA;
                    p:=DPalBoxP3W;
                    q:=DPalBoxQ2LW-DBoxLength;
                    Off_p:=0; Off_q:=-iOffsetValue;
                    oPosBox:=15;
            ENDTEST 
        ELSE
            TEST (iCounter MOD 4) 
                CASE 1:!----Mirror----
                    oPlace:=fPlaceD;
                    p:=DPalBoxP2L;
                    q:=DPalBoxQ2LW;
                    Off_p:=0; Off_q:=0; 
                    oPosBox:=1;
                CASE 2:
                    oPlace:=fPlaceD;
                    p:=DPalBoxP2L+L+D3Wm2L;
                    q:=DPalBoxQ2LW-W;
                    Off_p:=iOffsetValue; Off_q:=0;
                    oPosBox:=2;
                CASE 3:
                    oPlace:=fPlaceC;
                    p:=DPalBoxP3W-DBoxWidth+2*W;
                    q:=DPalBoxQ2LW+W;
                    Off_p:=0; Off_q:=iOffsetValue; 
                    oPosBox:=15;
                CASE 0:
                    oPlace:=fPlaceC;
                    p:=DPalBoxP3W-DBoxWidth+2*W;
                    q:=DPalBoxQ2LW+W+L;
                    Off_p:=0; Off_q:=iOffsetValue;
                    oPosBox:=15;
            ENDTEST 
        ENDIF
        
       
      
         !----------------------------------------    
        oPlaceNumber:=iCounter MOD 8;
        oLayer:=1+((iCounter-1) DIV 4); !-------Layer
      
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