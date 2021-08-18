// BIBLIOTECAS NECESSÝRIAS
#Include "TOTVS.ch"
/*/{Protheus.doc} --------------------------*
| @Treinamento - REST                       |
| @Aula:  API_SIMPLES                       |
| @Verbo: POST                              |            
| @data : 18/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |        
--------------------------------------------*/
Function U_zXAPI04()
    local cURI      := "http://localhost:8080/rest" // URI DO SERVIÇO REST
    local cResource := "/api/framework/v1/users"                  // RECURSO A SER CONSUMIDO
    Local oRest     := FwRest():New(cURI)                            // CLIENTE PARA CONSUMO REST
    Local aHeader   := {}                                            // CABEÇALHO DA REQUISIÇÃO

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
    Local cCodId:="str01"
    Local bObject := {|| JsonObject():New()}
    Local oJson   := Eval(bObject)

    oJson["id"]                                     := cCodId
    oJson["meta"]                                   := Eval(bObject)
    oJson["meta"]["resourceType"]                   := "User"
    oJson["meta"]["created"]                        := "2020-05-27T14:39:32Z"
    oJson["meta"]["lastModified"]                   := "2020-05-27T14:39:32Z"

    oJson["externalId"]                             := "string"
    oJson["name"]                                   := Eval(bObject)
    oJson["name"]["formatted"]                      := "string"
    oJson["name"]["givenName"]                      := "string"
    oJson["name"]["familyName"]                     := "string"

    oJson["userName"]                               := "string"
    oJson["preferredLanguage"]                      := "string"

    oJson["phoneNumbers"]                           := {Eval(bObject)}
    oJson["phoneNumbers"][1]["value"]                  := "string"
    oJson["phoneNumbers"][1]["type"]                   := "string"

    oJson["emails"]                                 := {JsonObject():New()}
    oJson["emails"][1]["value"]                     := "string"
    oJson["emails"][1]["type"]                      := "string"
    oJson["emails"][1]["primary"]                   := .T.

    oJson["active"]                                 := .T.
    oJson["groups"]                                 := {Eval(bObject)}
    oJson["groups"][1]["value"]                     := "string"
    oJson["groups"][1]["display"]                   := "string"

    oJson["roules"]                                 := {Eval(bObject)}
    oJson["roules"][1]["value"]                     := "string"
    oJson["roules"][1]["company"]                   := "string"
    oJson["roules"][1]["action"]                    := "UpSert"

    oJson["title"]                                 := "string"
    oJson["manager"]                               := {Eval(bObject)}
    oJson["manager"][1]["managerId"]               := "string"
    oJson["manager"][1]["displayName"]             := "string"
    oJson["password"]                              := "string"

    
Return (oJson:ToJson())

/*
{
	"id": "string",
	"meta": {
		"resourceType": "User",
		"created": "2020-05-27T14:39:32Z",
		"lastModified": "2020-05-27T14:39:32Z"
	},
	"externalId": "string",
	"name": {
		"formatted": "string",
		"givenName": "string",
		"familyName": "string"
	},
	"userName": "string",
	"preferredLanguage": "string",
	"phoneNumbers": [
		{
			"value": "string",
			"type": "string"
		}
	],
	"emails": [
		{
			"value": "string",
			"type": "string",
			"primary": true
		}
	],
	"active": true,
	"groups": [
		{
			"value": "string",
			"display": "string"
		}
	],
	"roles": [
		{
			"value": "string",
			"company": "string",
			"action": "UpSert"
		}
	],
	"title": "string",
	"manager": [
		{
			"managerId": "string",
			"displayName": "string"
		}
	],
	"password": "string"
}
*/

