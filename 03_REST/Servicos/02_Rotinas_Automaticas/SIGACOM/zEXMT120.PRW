#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} --------------------------*
| @Treinamento - REST                       |
| @Aula:  API_SIMPLES                       |            
| @data : 19/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |        
--------------------------------------------*/
WSRestFul EduWSTOTVS description "SERVIÇOS"

	WSMethod POST description "TESTE EXMATA120"  WSSyntax "EXMATA120" Path "/EXMATA120"

END WSRestFul
/*------------------------------------------
SELECT * FROM SC7990 ORDER BY R_E_C_N_O_ DESC 

JSON PARA UTILIZAÇÃO DO TESTE
{
    "fornecedor":"000002",
    "loja":"01",
    "produto1":"1000000        ",
}
-----------------------------------------*/
WSMethod POST WSRest EduWSTOTVS
    Local cDoc, cForn, cLoja, cCondPg    :=''      
    Local cProd1, cProd2,  cJson         :=''      
    Local aCabec, aLinha, aItens,aRatCC  := {}     
    Local nX, nY                         :=1    
    Local lOK:=.T.  
    Local bError   := ErrorBlock({|oError| cError := oError:Description}) 
    Private lMsErroAuto, lMsHelpAuto            

    ::SetContentType("application/json")

    //VALIDAR SE FOI POPULADO
    cJson := ENCODEUTF8( ::GetContent())
    oJson := JsonObject():new()
    xRet := oJson:fromJson(cJson)
    
    if ValType(xRet) == "U"
    	conOut("JsonObject populado com sucesso")
    else
    	::SetResponse("Falha no JSON")
        SetRestFault(400, "ERRO")
        return .f.
    endif

    //MONTAGEM DAS VARIAVEIS
    cForn   := PadR(oJson:GetJsonText("fornecedor"),TamSx3("C7_FORNECE" )[1])
    cLoja   := PadR(oJson:GetJsonText("loja"),TamSx3("C7_LOJA" )[1])
    cCondPg := PadR(oJson:GetJsonText("condPag"),TamSx3("C7_COND" )[1])

    cProd1 := PadR(oJson:GetJsonText("produto1"),TamSx3("C7_PRODUTO" )[1])

    //VALIDAR FORNECEDOR
	dbSelectArea("SA2")
	dbSetOrder(1)
	If !SA2->(MsSeek(xFilial("SA2")+cForn))
		::SetResponse("Fornecedor não encontrado")
        SetRestFault(400, "ERRO")
		return .F.
	EndIf
    
    //VALIDAR CONDICAO DE PAGAMENTO
	dbSelectArea("SE4")
	dbSetOrder(1)
	If !SE4->(MsSeek(xFilial("SE4")+cCondPg))
		::SetResponse("Condicao de pagamento não encontrado")
        SetRestFault(400, "ERRO")
		return .F.
	EndIf

    //VALIDAR PRODUTO 1
    dbSelectArea("SB1")
	dbSetOrder(1)
	If !SB1->(MsSeek(xFilial("SB1")+cProd1))
		::SetResponse("Produto não encontrado")
        SetRestFault(400, "ERRO")
		return .F. 
	EndIf

    For nY := 1 To 1
	    aItens := {}
        lMsErroAuto := .F.
        lMsHelpAuto := .T.

	    cDoc := NextNumero("SC7",1,"C7_NUM")
	    
        aCabec := {}
	    aadd(aCabec,{"C7_NUM"     ,cDoc})
	    aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
	    aadd(aCabec,{"C7_FORNECE" ,cForn})
	    aadd(aCabec,{"C7_LOJA"    ,cLoja})
	    aadd(aCabec,{"C7_COND"    ,cCondPg})
	    aadd(aCabec,{"C7_FILENT"  ,XFILIAL("SC7") })

	    For nX := 1 To 1
            aLinha := {}
	        aadd(aLinha,{"C7_PRODUTO"   ,cProd1 ,nil})
	        aadd(aLinha,{"C7_QUANT"     ,1      ,nil})
	        aadd(aLinha,{"C7_PRECO"     ,50     ,nil})
	        aadd(aLinha,{"C7_TOTAL"     ,50     ,nil})
	        aadd(aItens,aLinha)
	    Next nX 

         BEGIN SEQUENCE
            MATA120(1,aCabec,aItens,3,nil,aRatCC)
        END SEQUENCE

        ErrorBlock(bError)

        If !lMsErroAuto		
            :SetRestFault(200, "OK")
            ::SetResponse('{"message": "success"}')
        Else	
            lOK:=.F.	
            ::SetResponse("{Falha na inclusao }")
            SetRestFault(400, "ERRO")
             aLog := GetAutoGRLog()	 
        EndIf	
        ConOut("Fim  : "+Time())
    Next nY

Return lOK
