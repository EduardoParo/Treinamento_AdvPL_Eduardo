#Include "TOTVS.ch"
#INCLUDE'TBICONN.CH'

/*/{Protheus.doc} --------------------------*
| @Treinamento - REST                       |
| @Aula:  API_SIMPLES                       |            
| @data : 17/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |        
--------------------------------------------*/
Function U_zget() as undefined
	Local cURl      :="https://viacep.com.br" as string
    Local oRest     := FwRest():New(cURl) as object
	Local cCep      :='09846000'
	Local cResource := "/ws/"+ALLTRIM(cCep)+"/json/unicode/" as string
	Local aHeader   := {} as array
    Local cErro, nErro, cRest  as character

	//HEADER
	AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
	aAdd(aHeader,"Accept-Encoding: UTF-8")
	AAdd(aHeader, "Accept: application/json")
	AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")

    //TESTE HTTPGET
    cRest  := HTTPGet( cURL+cResource, "", 10, aHeader )
    If !empty(cRest )
		conOut("VERBO: GET ", EncodeUTF8(cRest) )
		nErro := HttpGetStatus(@cErro)
    EndIf

    //TESTE COM FWREST
    oRest:NTIMEOUT:=10
	oRest:SetPath(cResource)

	If (oRest:Get(aHeader))
		ConOut("GET: " + oRest:GetResult())
        nStatus:= HttpGetStatus(@cErro)

	Else
		nStatus:= HttpGetStatus(@cErro)
		ConOut("GET: " + oRest:GetLastError())
	EndIf

Return
