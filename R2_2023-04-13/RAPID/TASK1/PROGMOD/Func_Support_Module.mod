MODULE Func_Support_Module
    !===========================================================================
    FUNC num F_MaxValue(num Value1, num Value2, num Value3, num Value4, num Value5)
        !*********************<<<< F_MaxValue FUCNTION >>>>**************************                                    
	    !Created by   : Zaini     
        !Penjelasan   :
        !  #Fuction untuk mencari nilai maksimal dari 5 variabel num
	    !**************************************************************************
        VAR num CheckMax1;VAR num CheckMax;
        !--------------------------
        IF Value1>Value2 THEN
            IF Value1>Value3 THEN 
                CheckMax1:=Value1;
            ELSE
                CheckMax1:=Value3;
            ENDIF
        ELSE
            IF Value2>Value3 THEN
                CheckMax1:=Value2;
            ELSE
                CheckMax1:=Value3;
            ENDIF
        ENDIF
        !--------------------------
        IF Value4>Value5 THEN
            IF Value4>CheckMax1 THEN
                CheckMax:=Value4;
            ELSE
                CheckMax:=CheckMax1;
            ENDIF
        ELSE
            IF Value5>CheckMax1 THEN
                CheckMax:=Value5;
            ELSE
                CheckMax:=CheckMax1;
            ENDIF
        ENDIF
        !--------------------------
        RETURN CheckMax;
    ENDFUNC
    !===========================================================================
    FUNC byte F_PosBoxInGripper(num sensor1, num sensor2, num sensor3, num sensor4)
        !*********************<<<< F_PosBoxInGripper FUCNTION >>>>**************************                                    
	    !Created by   : Zaini     
        !Penjelasan   :
        !  #Fuction untuk membaca jumlah dan posisi box di gripper
        !  #Penjelasan hasil nilai lihat di file excel
	    !**************************************************************************
        VAR byte CheckPosBIG;
        !--------------------------
        CheckPosBIG:=0;
        IF sensor1=1 THEN BitSet CheckPosBIG, 1; ENDIF
        IF sensor2=1 THEN BitSet CheckPosBIG, 2; ENDIF
        IF sensor3=1 THEN BitSet CheckPosBIG, 3; ENDIF
        IF sensor4=1 THEN BitSet CheckPosBIG, 4; ENDIF
        RETURN CheckPosBIG;
    ENDFUNC

    !===========================================================================
    FUNC num F_Layer(num iCounter, num QuantityInLayer)
        !*********************<<<< F_oLayer FUCNTION >>>>**************************                                    
	    !Created by   : Zaini     
        !Penjelasan   :
        !  #Fuction untuk Check layer
        ! 
	    !***********************************************************************************
        VAR num CheckLayer;
        !--------------------
        IF iCounter<2 THEN
             CheckLayer:=1; 
        ELSE
            CheckLayer:=1+((iCounter-1) DIV QuantityInLayer);
        ENDIF
        RETURN CheckLayer;
    ENDFUNC
    !===========================================================================
ENDMODULE