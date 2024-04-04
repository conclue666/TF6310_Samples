MODULE SMA_BoxPattern2
    !*******************<<<< ROBOTICS PALLETIZER >>>>*********************!
    !Program    : Box Pattern                                             !
    !Created by : Arif                                                    !
    !Company    : IRA Robotics Indonesia                                  !
    !*********************************************************************!
    PROC BoxPattern2 (robtarget iPlaceA, robtarget iPlaceB, robtarget iPlaceC, robtarget iPlaceD,
                num PlaceLine,num iCounter, num iBoxLength, num iBoxWidth, num iBoxHeight, num iPallet_X, num iPallet_Y, num iPallet_Z,
                num iRefBoxLength, num iRefBoxWidth, num iCustom_Rz, bool mirror,
                num iReferencePointNumber, num iDirectionNumber, num iOffsetValue,
                PERS robtarget oPlace, PERS num oLayer, PERS num oOfset_X, PERS num oOfset_Y,PERS num oPosBox,PERS num oPlaceNumber)
         
        VAR num p; VAR num q; VAR num r;  !------- Pattern Offset Coordinat
        VAR num Off_p;  VAR num Off_q;	   !-------Internal Variabel for Ofset X and Y before Placing
        VAR num x; VAR num y; VAR num z;  !-------Robot Coordinat 
        VAR num Cl_Thick:=6; !--- Tebal Fix Clamping
        VAR num Cl_p; VAR num Cl_q;
        VAR num iP_Pallet; VAR num iQ_Pallet;
        VAR num DPalBoxQ3L; VAR num DPalBoxQ4W; VAR num DPalBoxP2L1W;
        VAR num DBoxLength; VAR num DBox3Length; VAR num DBoxWidth; 
        VAR num DPallet_X; VAR num DPallet_Y;VAR num DPallet_Z;
        VAR num L; VAR num W; VAR num H;
        VAR num D3Lm4W; !Selisih 2L minus 3W
	    VAR num D4Wm3L;
        VAR num fCtm_x; VAR num fCtm_y;VAR num fCtm_z; VAR num fCtm_Rz;
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
        DPalBoxQ3L:=(iQ_Pallet-(3*L+D4Wm3L))/2; 
        DPalBoxQ4W:=(iQ_Pallet-(4*W+D3Lm4W))/2; 
        DPalBoxP2L1W:=(iP_Pallet-(2*L+1*W))/2; 
        
        
        !-------ReferencePoint For Pallet & Ofset Box
        TEST iReferencePointNumber
        CASE 1:
                fPlaceA:=iPlaceA;
                fPlaceB:=iPlaceB;  
                fPlaceC:=iPlaceC;
                fPlaceD:=iPlaceD; 
                L:=iBoxLength; W:=iBoxWidth; H:=iBoxHeight;
        ENDTEST
        
        !-------Setting Pattern Coordinat Offset 
        IF mirror = FALSE THEN
            TEST (iCounter MOD 7)
            CASE 1:
                    oPlace:=fPlaceA;
                	p:=DPalBoxP2L1W;
                	q:=DPalBoxQ3L+2*L+2*D4Wm3L-DBoxLength;
                	Off_p:=0; Off_q:=0;
                    oPosBox:=1;
            CASE 2:
                    oPlace:=fPlaceA;
                	p:=DPalBoxP2L1W-W;
                	q:=DPalBoxQ3L+L+D4Wm3L-DBoxLength;
                	Off_p:=0; Off_q:=-iOffsetValue; 
                    oPosBox:=2;
            CASE 3:
                    oPlace:=fPlaceA;
                	p:=DPalBoxP2L1W;
                	q:=DPalBoxQ3L-DBoxLength;
                	Off_p:=0; Off_q:=-iOffsetValue;
                    oPosBox:=1;
            CASE 4:
                    oPlace:=fPlaceD;
                	p:=DPalBoxP2L1W+W;
                	q:=DPalBoxQ3L;
                	Off_p:=iOffsetValue; Off_q:=0;  
			        oPosBox:=3;
            CASE 5:
                    oPlace:=fPlaceD;
                	p:=DPalBoxP2L1W+W;
                	q:=DPalBoxQ3L+D3Lm4W;
                	Off_p:=0; Off_q:=0;  
			        oPosBox:=12;
            CASE 6:
                    oPlace:=fPlaceD;
                	p:=DPalBoxP2L1W+W+L;
                	q:=DPalBoxQ3L;
                	Off_p:=iOffsetValue; Off_q:=0;  
			        oPosBox:=3;
            CASE 0:
                    oPlace:=fPlaceD;
                	p:=DPalBoxP2L1W+W+L;
                	q:=DPalBoxQ3L+D3Lm4W;
                	Off_p:=0; Off_q:=0;  
			        oPosBox:=12;
            ENDTEST
        ELSE
            TEST (iCounter MOD 7)
            CASE 1:
                    oPlace:=fPlaceC;
                	p:=DPalBoxP2L1W+(2*L)-DBoxWidth;
                	q:=DPalBoxQ3L;
                	Off_p:=0; Off_q:=0;
                    oPosBox:=1;
            CASE 2:
                    oPlace:=fPlaceC;
                	p:=DPalBoxP2L1W+(2*L+W)-DBoxWidth;
                	q:=DPalBoxQ3L+L+D4Wm3L;
                	Off_p:=0; Off_q:=iOffsetValue; 
                    oPosBox:=2;
            CASE 3:
                    oPlace:=fPlaceC;
                	p:=DPalBoxP2L1W+(2*L)-DBoxWidth;
                	q:=DPalBoxQ3L+2*L+D4Wm3L;
                	Off_p:=0; Off_q:=iOffsetValue;  
                    oPosBox:=1;
            CASE 4:
                    oPlace:=fPlaceB;
                	p:=DPalBoxP2L1W+L-DBoxLength;
                	q:=DPalBoxQ3L+3*W+D3Lm4W;
                	Off_p:=-iOffsetValue; Off_q:=0; 
			        oPosBox:=3;
            CASE 5:
                    oPlace:=fPlaceB;
                	p:=DPalBoxP2L1W+L-DBoxLength;
                	q:=DPalBoxQ3L+3*W;
                	Off_p:=0; Off_q:=0;  
			        oPosBox:=12;
            CASE 6:
                    oPlace:=fPlaceB;
                	p:=DPalBoxP2L1W-DBoxLength;
                	q:=DPalBoxQ3L+3*W+D3Lm4W;
                	Off_p:=-iOffsetValue; Off_q:=0;  
			        oPosBox:=3;
            CASE 0:
                    oPlace:=fPlaceB;
                	p:=DPalBoxP2L1W-DBoxLength;
                	q:=DPalBoxQ3L+3*W;
                	Off_p:=0; Off_q:=0;  
			        oPosBox:=12;
            ENDTEST
        ENDIF
        
           
      
         !----------------------------------------    
        oPlaceNumber:=iCounter MOD 7;
        oLayer:=1+((iCounter-1) DIV 7); !-------Layer
        
        !Offset Layer
        r:=(oLayer-1)*H;
        
        !-------Reference Point Number
        TEST iReferencePointNumber
        CASE 1:
            x:=p; y:=q; z:=r+fCtm_z;
            oOfset_X:=Off_p; oOfset_Y:=Off_q;
        CASE 2:
            x:=q; y:=-p; z:=r+fCtm_z;
            oOfset_X:=Off_q; oOfset_Y:=-Off_p;
        CASE 3:
            x:=p; y:=q; z:=r+fCtm_z;
            oOfset_X:=-Off_p; oOfset_Y:=-Off_q;
        CASE 4:
            x:=-q; y:=p; z:=r+fCtm_z;
            oOfset_X:=-Off_q; oOfset_Y:=Off_p;
        ENDTEST
        !-------Place Setting
        oPlace:=Offs(oPlace,x,y,z);
        oPlace:=RelTool(oPlace,0,0,0 \Rz:=fCtm_Rz);
    ENDPROC
ENDMODULE