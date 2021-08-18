#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"

WSRestFul desafioToalha description "SERVIÇO DESAFIO TOALHA"

	WSMethod POST description "Cria um cliente"  WSSyntax "desafioToalha" Path "/desafioToalha"

END WSRestFul

WSMethod POST WSRest desafioToalha
    local oModel    := FwLoadModel("MATA030")
    local oRequest  := JsonObject():New()
    local lPost

    private lMsErroAuto := .F.
    private lMsHelpAuto := .T.

    ::SetContentType("application/json")

    cJson := ::GetContent()
    oJson := JsonObject():new()
    xRet := oJson:fromJson(cJson)

    //VALIDAR SE FOI POPULADO
    if ValType(xRet) == "U"
    	conOut("JsonObject populado com sucesso")
    else
    	conOut("Falha ao popular JsonObject. Erro: " + xRet)
        return
    endif

    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()
    oRequest:fromJson(::GetContent())

    oModel:GetModel('MATA030_SA1'):SetValue("A1_COD"    , PadR(oJson:GetJsonText("codigo"),TamSx3("A1_COD" )[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_LOJA"   , PadR(oJson:GetJsonText("loja"),TamSx3("A1_LOJA")[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_NOME"   , PadR(oJson:GetJsonText("nome"),TamSx3("A1_NOME")[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_NREDUZ" , PadR(oJson:GetJsonText("nomereduzido"),TamSx3("A1_NREDUZ")[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_END"    , PadR(oJson:GetJsonText("endereco"),TamSx3("A1_END" )[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_TIPO"   , PadR(oJson:GetJsonText("tipo"),TamSx3("A1_TIPO" )[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_EST"    , PadR(oJson:GetJsonText("estado"),TamSx3("A1_EST" )[1]))
    oModel:GetModel('MATA030_SA1'):SetValue("A1_MUN"    ,PadR(oJson:GetJsonText("municipio"),TamSx3("A1_MUN" )[1]))

    If (oModel:VldData() .and. oModel:CommitData())
    	lPost := .T.
    	::SetResponse(oModel:GetJsonData())
    Else
    	lPost := .F.
    	aError := oModel:GetErrorMessage()
    	cRetorno := "ERRO|" + aError[5] + " | " + aError[6] + " | " + aError[7]
    	SetRestFault(400, cRetorno)
    EndIf

    oModel:DeActivate()

Return lPost
