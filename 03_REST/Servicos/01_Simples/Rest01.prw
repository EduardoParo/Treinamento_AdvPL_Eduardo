#include 'totvs.ch'
#include'RestFul.ch'

//Definindo serviço Advpl01
WsRestful Advpl01 description 'Rest do Teste'

	//Variaveis
	wsdata nome as string optional
    wsdata idade as number optional

	//Metodo Hellow Word
	WsMethod GET description 'Hellow Word' wssyntax '/get01' Path '/get01'

	//Metodo zpost01
	WsMethod POST zpost01 description 'zPost01'  wssyntax  '/zPost01/{nome}' path '/zpost01/{nome}'

End WsRestful

//Metodo Hellow Word
WsMethod GET WsService Advpl01

	SetRestFault(200, "OK")
	::SetResponse('[{"status": "hellow word" }]')

return .T.

// Metodo zPost01 COM PARAMETROS       
WsMethod POST zPost01 PathParam nome,idade WsService Advpl01
	Local cNome := ::nome
	Local nIdade := ::idade
	Local cRet:=''

	cRet:="{ Olá Mundo, meu nome e : "+cNome +" e tenho : "+ cValToChar(nIdade)+"anos de idade}"

	SetRestFault(200, "OK")
	::SetResponse(cRet)


return .T.




