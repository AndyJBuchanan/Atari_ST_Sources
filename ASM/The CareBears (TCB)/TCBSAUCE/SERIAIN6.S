MAIN :  MOVE.L  D0,SPAR2
    CLR.L  -(SP)
    MOVE.W  #32,-(SP)
    TRAP    #1
    ADDQ    #6,SP
    MOVE.L  D0,SAVESTK
    
    MOVE.W  #-1,-(SP)
    MOVE.W  #-1,-(SP)
    MOVE.W  #-1,-(SP)
    MOVE.W  #-1,-(SP)
    MOVE.W  #0,-(SP)
    MOVE.W  #1,-(SP)
    MOVE.W  #15,-(SP)
    TRAP    #14
    ADDA    #14,SP
    
    
    MOVE.L  #BUFFER,A0
    MOVE.L  #0,D1
    MOVE.L  SPAR2,D2
    
OM :    
    MOVE.W  #3,-(SP)
    TRAP    #1
    ADDQ    #2,SP
      MOVE.B  D0,(A0)+
    
    ADDQ.L  #1,D1
    CMP.L  D2,D1
    BCS    OM
    
    MOVE.L  A0,SPAR1
    
    
    MOVE.L  SAVESTK,-(SP)
    MOVE.W  #32,-(SP)
    TRAP    #1
    ADDQ    #6,SP
    
    MOVE.L  SPAR1,A0
    MOVE.L  #BUFFER,A1
    MOVE.L     A1,D5
               SUB.L    A0,D5

    RTS
    
    
    
SAVESTK :  DS.L    1
SPAR1 :  DS.L    1
SPAR2 :  DS.L    1
BUFFER :  DS.L    50000

               END
 