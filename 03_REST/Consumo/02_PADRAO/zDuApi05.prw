#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"
/*/{Protheus.doc} --------------------------*
| @Treinamento - REST                       |
| @Aula:  CONSUMO_API                       |
| @Verbo: POST                              |            
| @data : 18/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |        
--------------------------------------------*/
Function U_zXAPI05()
	Local cUrl      := "http://localhost:8080/rest"                    // URI DO SERVIÇO REST
	Local cResource := "/api/oauth2/v1/token"
	Local oRest     := FwRest():New(cUrl)
	Local aHeader   := {}
	Local cErro :=''
	Local cGetParam := "grant_type=password&password=1&username=Eduardo"
	Local cHeadRet:=''
	Local nTimeOut := 5

	aAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
	aAdd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aAdd(aHeader,'Content-Type: application/x-www-form-urlencoded')
	aAdd(aHeader,'grant_type: password')
	aAdd(aHeader,'username: Eduardo')
	aAdd(aHeader,'password: 1')

	oRest:SetChkStatus(.F.)
	oRest:SetPath(cResource)

	oRest:SetPostParams(cGetParam)

	cRest := HTTPPost(cUrl + cResource, "",cGetParam,nTimeOut,aHeader,@cHeadRet)

	If (oRest:POST(aHeader))
		_cResult := oRest:GetResult()
		nErro := HttpGetStatus(@cErro)
		conOut("Funcionou ! "+cValToChar(nErro) )
	Else
		_cResult := oRest:GetResult()
		nErro := HttpGetStatus(@cErro)
		conOut("ERRO: " + oRest:GetLastError())
	EndIf

Return (NIL)

