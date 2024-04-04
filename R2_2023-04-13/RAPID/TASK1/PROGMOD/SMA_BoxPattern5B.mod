MODULE SMA_BoxPattern5B
    !*******************<<<< ROBOTICS PALLETIZER >>>>*********************!
    !Program    : Box Pattern                                             !
    !Created by : Arif                                                    !
    !Company    : IRA Robotics Indonesia                                  !
    !*********************************************************************!
    PROC BoxPattern5B (robtarget iPlaceA, robtarget iPlaceB, robtarget iPlaceC, robtarget iPlaceD,
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
        VAR num DPalBoxP4W; VAR num DPalBoxP3L; VAR num DPalBoxQ4W; VAR num DPalBoxQ3L;
        VAR num DBoxLength; VAR num DBoxWidth; 
        VAR num DPallet_X; VAR num DPallet_Y;VAR num DPallet_Z;
        VAR num L; VAR num W; VAR num H;
        
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
        DBoxWidth:=4*(iRefBoxWidth-W);
        !-----Delta Pallet dengan box
        DPalBoxP4W:=(iP_Pallet-(4*W))/2; 
        DPalBoxP3L:=(iP_Pallet-(3*L))/2; 
        DPalBoxQ4W:=(iQ_Pallet-(4*W))/2; 
        DPalBoxQ3L:=(iQ_Pallet-(3*L))/2; 
       
        !-------ReferencePoint For Pallet & Ofset Box
        TEST iReferencePointNumber
        CASE 1:
                fPlaceA:=iPlaceA;
                fPlaceB:=iPlaceB;  
                fPlaceC:=iPlaceC;
                fPlaceD:=iPlaceD; 
                L:=iBoxLength; W:=iBoxWidth; H:=iBoxHeight;
      
        CASE 3:
                fPlaceA:=Offs(iPlaceC,iPallet_X-iRefBoxWidth,iPallet_Y-iRefBoxLength,0);
                fPlaceB:=Offs(iPlaceD,iPallet_X-iRefBoxLength,iPallet_Y-iRefBoxWidth,0);  
                fPlaceC:=Offs(iPlaceA,iPallet_X-iRefBoxWidth,iPallet_Y-iRefBoxLength,0);
                fPlaceD:=Offs(iPlaceB,iPallet_X-iRefBoxLength,iPallet_Y-iRefBoxWidth,0);
                DPalBoxP4W:=-DPalBoxP4W; 
                DPalBoxP3L:=-DPalBoxP3L; 
                DPalBoxQ4W:=-DPalBoxQ4W; 
                DPalBoxQ3L:=-DPalBoxQ3L; 
                DBoxLength:=-DBoxLength;
                DBoxWidth:=-DBoxWidth;
                L:=-iBoxLength; W:=-iBoxWidth; H:=iBoxHeight;
        ENDTEST
        
        
        !-------Setting Pattern Coordinat Offset 
!        IF mirror = FALSE THEN
               TEST (iCounter MOD 6) 
                CASE 1:!----Normal----
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength+2*L;
                    q:=DPalBoxQ4W-DBoxWidth+3*W;
                    Off_p:=0; Off_q:=0; 
                    oPosBox:=3;
                CASE 2:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength+2*L;
                    q:=DPalBoxQ4W-DBoxWidth+W;
                    Off_p:=0; Off_q:=-iOffsetValue; 
                    oPosBox:=3;
                CASE 3:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength+L;
                    q:=DPalBoxQ4W-DBoxWidth+3*W;
                    Off_p:=-iOffsetValue; Off_q:=0; 
                    oPosBox:=3;
                CASE 4:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength+L;
                    q:=DPalBoxQ4W-DBoxWidth+W;
                    Off_p:=-iOffsetValue; Off_q:=-iOffsetValue; 
                    oPosBox:=3;
                CASE 5:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength;
                    q:=DPalBoxQ4W-DBoxWidth+3*W;
                    Off_p:=-iOffsetValue; Off_q:=0; 
                    oPosBox:=3;
                CASE 0:
                    oPlace:=fPlaceB;
                    p:=DPalBoxP3L-DBoxLength;
                    q:=DPalBoxQ4W-DBoxWidth+W;
                    Off_p:=-iOffsetValue; Off_q:=-iOffsetValue; 
                    oPosBox:=3;
            ENDTEST 
!        ELSE
!            TEST (iCounter MOD 6) 
!                CASE 1:!----Mirror----
!                    oPlace:=fPlaceA;
!                    p:=DPalBoxP4W;
!                    q:=DPalBoxQ3L-DBoxLength+2*L;
!                    Off_p:=0; Off_q:=0; 
!                    oPosBox:=3;
!                CASE 2:
!                    oPlace:=fPlaceA;
!                    p:=DPalBoxP4W+2*W;
!                    q:=DPalBoxQ3L-DBoxLength+2*L;
!                    Off_p:=iOffsetValue; Off_q:=0; 
!                    oPosBox:=3;
!                CASE 3:
!                    oPlace:=fPlaceA;
!                    p:=DPalBoxP4W;
!                    q:=DPalBoxQ3L-DBoxLength+L;
!                    Off_p:=0; Off_q:=-iOffsetValue; 
!                    oPosBox:=3;
!                CASE 4:
!                    oPlace:=fPlaceA;
!                    p:=DPalBoxP4W+2*W;
!                    q:=DPalBoxQ3L-DBoxLength+L;
!                    Off_p:=iOffsetValue; Off_q:=-iOffsetValue; 
!                    oPosBox:=3;
!                CASE 5:
!                    oPlace:=fPlaceA;
!                    p:=DPalBoxP4W;
!                    q:=DPalBoxQ3L-DBoxLength;
!                    Off_p:=0; Off_q:=-iOffsetValue; 
!                    oPosBox:=3;
!                CASE 0:
!                    oPlace:=fPlaceA;
!                    p:=DPalBoxP4W+2*W;
!                    q:=DPalBoxQ3L-DBoxLength;
!                    Off_p:=iOffsetValue; Off_q:=-iOffsetValue; 
!                    oPosBox:=3;
!            ENDTEST 
!        ENDIF
        
       
      
         !----------------------------------------    
        oPlaceNumber:=iCounter MOD 6;
        oLayer:=1+((iCounter-1) DIV 6); !-------Layer
      
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