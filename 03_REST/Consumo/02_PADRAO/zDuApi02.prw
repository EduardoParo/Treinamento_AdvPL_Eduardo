// BIBLIOTECAS NECESSÝRIAS
#Include "TOTVS.ch"
/*/{Protheus.doc} --------------------------*
| @Treinamento - REST                       |
| @Aula:  CONSUMO_API                       |
| @Verbo: POST                              |            
| @data : 17/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |        
--------------------------------------------*/
Function U_zXAPI02()
	local cURI      := "http://localhost:8080/rest"               // URI DO SERVIÇO REST
	local cResource := "/api/crm/v1/customerVendor"                  // RECURSO A SER CONSUMIDO
	Local oRest     := FwRest():New(cURI)                         // CLIENTE PARA CONSUMO REST
	Local aHeader   := {}                                         // CABEÇALHO DA REQUISIÇÃO

	// PREENCHE CABEÇALHO DA REQUISIÇÃO
	AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
	AAdd(aHeader, "Accept: application/json")
	AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
	Aadd(aHeader, "Authorization: Basic " + Encode64("ADMIN" + ":" + ""))

	// INFORMA O RECURSO E INSERE O JSON NO CORPO (BODY) DA REQUISIÇÃO
	oRest:SetPath(cResource)
	oRest:SetPostParams(GetJson())

	// REALIZA O MÉTODO POST E VALIDA O RETORNO
	If (oRest:POST(aHeader))
		ConOut("POST: " + oRest:GetResult())
	Else
		ConOut("POST: " + oRest:GetLastError())
	EndIf
Return

// CRIA O JSON QUE SERÝ ENVIADO NO CORPO (BODY) DA REQUISIÇÃO
Static Function GetJson()
	Local cJson:=''
	Local cCodCli:="xTest01"

	cJson+='    {'
	cJson+='    "customerVendorId":"",'
	cJson+='    "companyId":"99",'
	cJson+='    "branchId":"01",'
	cJson+='    "code":"'+cCodCli+'",'
	cJson+='    "storeId":"01",'
	cJson+='    "internalId":"",'
	cJson+='    "shortName":"JOHN M. CO",'
	cJson+='    "name":"JOHN & MARY CO",'
	cJson+='    "type":1,'
	cJson+='    "entityType":"F",'
	cJson+='    "strategicCustomerType":"F",'
	cJson+=''
	cJson+='    "GovernmentalInformation": ['
	cJson+=''
	cJson+='        {'
	cJson+='            "scope": "CPF|CNPJ",'
	cJson+='            "issueOn": "CPF|CNPJ",'
	cJson+='            "id": "43875267850",'
	cJson+='            "name": "CNPJ|CPF",'
	cJson+='            "expireOn": "CPF|CNPJ"'
	cJson+='        }'
	cJson+='    ],'
	cJson+=' '
	cJson+='    "address":{'
	cJson+='        "address":"Rua, Avenida, Rodovia, etc. Ex.: Avenida Braz Leme",'
	cJson+='        "number":"1000",'
	cJson+='         "complement":"string",'
	cJson+='        "city":{'
	cJson+='            "cityCode":"",'
	cJson+='            "cityInternalId":"",'
	cJson+='            "cityDescription":"SAO PAULO"'
	cJson+='        },'
	cJson+='        "district":"Casa Verde",'
	cJson+='        "state":{'
	cJson+='            "stateId":"SP",'
	cJson+='            "stateInternalId":"SP",'
	cJson+='            "stateDescription":""'
	cJson+='        },'
	cJson+='  "country": '
	cJson+='  {'
	cJson+='        "countryInternalId": "105",'
	cJson+='        "countryDescription": "",'
	cJson+='        "countryCode": "105"'
	cJson+='  }'
	cJson+='    }'
	cJson+=' '
	cJson+='}'

Return cJson
