#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
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
    "produto2":"2000000        "
}
-----------------------------------------*/
/*/{Protheus.doc}----------------------------------------------------------------------
@type function VIEW
@version  12
@author Eduardo Paro de SImoni
@GitHub.com/EduardoParo
//---------------------------------------------------------------------------------------------------/*/
WSMethod POST WSRest EduWSTOTVS
//<<NAO MANIPULAR O FONTE>> APENAS CHUMBE OS VALORES NAS VARIAVEIS 
    local cDoc, cForn, cLoja, cCondPg    :=''      
    local cProd1, cProd2,  cJson         :=''      
    local aCabec, aLinha, aItens,aRatCC  := {}     
    local nX, nY                         :=1       
    private lMsErroAuto, lMsHelpAuto            

    ::SetContentType("application/json")

    //VALIDAR SE FOI POPULADO
    cJson := ::GetContent()
    oJson := JsonObject():new()
    xRet := oJson:fromJson(cJson)
    if ValType(xRet) == "U"
    	conOut("JsonObject populado com sucesso")
    else
    	conOut("Falha ao popular JsonObject. Erro: " + xRet)
        return .f.
    endif

    //MONTAGEM DAS VARIAVEIS
    cForn   := PadR(oJson:GetJsonText("fornecedor"),TamSx3("C7_FORNECE" )[1])
    cLoja   := PadR(oJson:GetJsonText("loja"),TamSx3("C7_LOJA" )[1])
    cCondPg := PadR(oJson:GetJsonText("condPag"),TamSx3("C7_COND" )[1])

    cProd1 := PadR(oJson:GetJsonText("produto1"),TamSx3("C7_PRODUTO" )[1])
    cProd2 := PadR(oJson:GetJsonText("produto2"),TamSx3("C7_PRODUTO" )[1])

    //VALIDAR FORNECEDOR
	dbSelectArea("SA2")
	dbSetOrder(1)
	If !SA2->(MsSeek(xFilial("SA2")+cForn))
		ConOut("Cadastrar fornecedor")
		return .F.
	EndIf
    
    //VALIDAR CONDICAO DE PAGAMENTO
	dbSelectArea("SE4")
	dbSetOrder(1)
	If !SE4->(MsSeek(xFilial("SE4")+cCondPg))
		ConOut("Cadastrar condicao de pagamento")
		return .F.
	EndIf

    //VALIDAR PRODUTO 1
    dbSelectArea("SB1")
	dbSetOrder(1)
	If !SB1->(MsSeek(xFilial("SB1")+cProd1))
		ConOut("Cadastrar produto ")
		return .F. 
	EndIf

    //VALIDAR PRODUTO 2
    If !SB1->(MsSeek(xFilial("SB1")+cProd2))
		ConOut("Cadastrar produto 2 ")
		return .F.
	EndIf

    /*--------------------------------------------------
    INICIO DA CONTAGEM DO TEMPO
    ---------------------------------------------------*/
    ConOut(Repl("-",80))
    ConOut(PadC("INICIANDO",80))
    ConOut(Repl("-",80))
    ConOut("Inicio: "+Time())
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

	    For nX := 1 To 2
            aLinha := {}
	        aadd(aLinha,{"C7_PRODUTO"   ,cProd1 ,nil})
	        aadd(aLinha,{"C7_QUANT"     ,1      ,nil})
	        aadd(aLinha,{"C7_PRECO"     ,50     ,nil})
	        aadd(aLinha,{"C7_TOTAL"     ,50     ,nil})
	        aadd(aItens,aLinha)
            cProd1:= cProd2 //NA SEGUNDA CHAMADA INFORMAR OUTRO PRODUTO
	    Next nX 

        MATA120(1,aCabec,aItens,3,nil,aRatCC)

        If !lMsErroAuto		
            ConOut("Incluido com sucesso! "+cDoc)	
  
        Else		
            ConOut("Erro na inclusao!")
             aLog := GetAutoGRLog()	 
        EndIf	
        ConOut("Fim  : "+Time())
    next nY
    ConOut(Repl("-",80))
    ConOut(PadC("FIM !",80))
    ConOut(Repl("-",80))
return .T.



