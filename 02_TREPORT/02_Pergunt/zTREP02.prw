#include 'totvs.ch'
/*/{Protheus.doc} --------------------------*
| @Treinamento - TREPORT                    |
| @Aula: 03_TREPORT_PERGUNTA                |            
| @data : 17/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |
| @GitHub.com/EduardoParo                   |        
--------------------------------------------*/
function U_xTRE2()
    Local cNome:="Treinamento TREPORT"
    Local cTitulo:="Treinamento TREPORT"
    Local cDesc:="Treinamento TREPORT - Edu"
    
    Private oReport     := nil
    Private oSection1   := nil

    Private cPerg       := "xPerg"

    zValPerg(cPerg)

    //Função responsável por chamar a pergunta criada na função ValidaPerg, a variável Private cPerg, é passada.
    Pergunte(cPerg,.F.)

    //CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
    ReportDef(cNome,cTitulo,cPerg,cDesc)
    oReport:PrintDialog()

    
    FreeObj(oReport)
    FreeObj(oSection1)

Return

/*---------------------------------------------------------*
@Funcao responsavel por estruturar as secoes e campos que 
@darao forma ao relatorio.
-----------------------------------------------------------*/
Static function ReportDef(cNome,cTitulo,cPerg,cDesc)
    /*1 - Etapa Instaciar o Objeto Treport
    --------------------------------------------*/
    /*TReport():New ( < cReport>, [ cTitle], [ uParam], [ bAction], [ cDescription] )
    cReport	           Nome do relatório. Exemplo: MATR010  
    cTitle	           Título do relatório	
    uParam	           Bloco de Código	Parâmetros do relatório cadastrado no Dicionário de Perguntas (SX1). Também pode ser utilizado bloco de código para parâmetros customizados	
    bAction	           será executado quando o usuário confirmar a impressão do relatório	
    cDescription	   Descrição do relatório	
    lLandscape	       Aponta a orientação de página do relatório como paisagem	
    uTotalText	       Bloco de Código	Texto do totalizador do relatório, podendo ser caracter ou bloco de código	
    lTotalInLine	   Imprime as células em linha	
    cPageTText	       Texto do totalizador da página	
    lPageTInLine	   Imprime totalizador da página em linha	
    lTPageBreak	       Quebra página após a impressão do totalizador	
    nColSpace	       Espaçamento entre as colunas
    */
    oReport := TReport():New(cNome,cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)

    oReport:SetPortrait(.T.)       //Define orientação de página do relatório como retrato
	oReport:SetTotalInLine(.F.) //Define se os totalizadores serão impressos em linha ou coluna


    /*2 Etapa Instaciar o Objeto TRSection
    TrSection contém células pré-definidas (Colunas e linhas)(Bloco)
    --------------------------------------------*/            
    /*TRSection():New( <oParent> , <cTitle> , <uTable> , <aOrder> , <lLoadCells> , <lLoadOrder> , <uTotalText> , <lTotalInLine> , <lHeaderPage> , <lHeaderBreak> , <lPageBreak> , <lLineBreak> , <nLeftMargin> , <lLineStyle> , <nColSpace> , <lAutoSize> , <cCharSeparator> , <nLinesBefore> , <nCols> , <nClrBack> , <nClrFore> , <nPercentage> )
    oParent         Objeto da classe TReport ou TRSection que será o pai da classe TRSection
    cTitle	        Caracter	Título da seção	
    uTable	        Caracter: Tabela que sera utilizada pela seção / Array: Lista de tabelas que serão utilizadas pela seção
    aOrder	        Array contendo a descrição das ordens. Elemento: 1-Descrição, como por exemplo, Filial+Código	
    lLoadCells	    Carrega os campos do Dicionário de Campos (SX3) das tabelas da seção como células	
    lLoadOrder	    Carrega os índices do Dicionário de Ýndices (SIX)	
    uTotalText	    Bloco de Código	Texto do totalizador da seção, podendo ser caracter ou bloco de código	
    lTotalInLine	Imprime as células em linha	
    lHeaderPage	    Cabeçalho da seção no topo da página	
    lHeaderBreak	Imprime cabeçalho na quebra da seção	
    lPageBreak	    Imprime cabeçalho da seção na quebra de página	
    lLineBreak	    Quebra a linha na impressão quando as informações não couberem na página	
    nLeftMargin	    Tamanho da margem à esquerda da seção	
    lLineStyle	    Imprime a seção em linha	
    nColSpace	    Espaçamento entre as colunas	
    lAutoSize	    Ajusta o tamanho das células para que caiba emu ma página	
    cCharSeparator	Define o caracter que separa as informações na impressão em linha	
    nLinesBefore	Aponta a quantidade de linhas a serem saltadas antes da impressão da seção	
    nCols	        Quantidade de colunas a serem impressas	
    nClrBack	    Cor de fundo das células da seção	
    nClrFore	    Cor da fonte das células da seção	
    nPercentage	    Tamanho da página a ser considerada na impressão em percentual
    */
    
    oSection1 := TRSection():New( oReport , "CADASTRO DE CLIENTES", {"SA1"} )

    /*3 Etapa Instanciar a Classe TrCell
     TrCell serve para inserir os campos/colunas que você quer no relatório,
     lembrando que devem ser os mesmos campos que contém na QUERIE
     Um detalhe importante, todos os campos contidos nas linhas abaixo,
     devem estar na querie, mas você pode colocar campos na querie e adcionar 
     aqui embaixo, conforme a sua necessidade.
    -----------------------------------------------------------------*/
    /*TRCell():New( <oParent> , <cName> , <cAlias> , <cTitle> , <cPicture> , <nSize> , <lPixel> , <bBlock> , <cAlign> , <lLineBreak> , <cHeaderAlign> , <lCellBreak> , <nColSpace> , <lAutoSize> , <nClrBack> , <nClrFore> , <lBold> ) ?
    oParent	            Objeto da classe TRSection que a célula pertence	
    cName	        	Nome da célula	
    cAlias	        	Tabela utilizada pela célula	
    cTitle	        	Título da célula	
    cPicture	    	Mascara da célula	
    nSize	        	Tamanho da célula	
    lPixel	            Aponta se o tamanho foi informado em pixel	
    bBlock	            Código	Bloco de código com o retorno do campo	
    cAlign	        	Alinhamento da célula. “LEFT”, “RIGHT” e “CENTER”	
    lLineBreak	        Quebra linha se o conteúdo estourar o tamanho do campo	
    cHeaderAlign		Alinhamento do cabeçalho da célula. “LEFT”, “RIGHT” e “CENTER”	
    lCellBreak	        Compatibilidade – Não utilizado	
    nColSpace	    	Espaçamento entre as células	
    lAutoSize	        Ajusta o tamanho da célula com base no tamanho da página e as informações impressas	
    nClrBack	    	Cor de fundo da célula	
    nClrFore	    	Cor da fonte da célula	
    lBold	            Imprime a fonte em negrito
    */
    TRCell():New( oSection1, "A1_COD"     , "SA1")
    TRCell():New( oSection1, "A1_LOJA"    , "SA1")
    TRCell():New( oSection1, "A1_NOME"    , "SA1")

Return 

/*-----------------------------------------------------------------------
@Nesta funcao inserimos a querie utilizada para exibicao das linhas nas secoes;
-----------------------------------------------------------------------*/
Static function PrintReport(oReport)

    //VARIÝVEL responsável por armazenar o Alias que será utilizado pela querie 
    local cTable := GetNextAlias()
    
    Pergunte(cPerg,.F.)

    //INICIO DA QUERY
    oSection1:BeginQuery()
    BEGINSQL ALIAS cTable
        SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME
        FROM %TABLE:SA1% SA1
        WHERE 
        SA1.A1_COD 
        BETWEEN %exp:(MV_PAR01)% 
        AND %exp:(MV_PAR02)%  //%EXP:% é responsável por transformar a variável das perguntas em filtros do relatório
        AND SA1.%NOTDEL%
    ENDSQL

    MakeSQLExpr(cPerg) // Pergunta com o parâmetro do Tipo Range
    oSection1:EndQuery()
    oSection1:Print() //É dada a ordem de impressão, visto os filtros selecionados

    //O Alias utilizado para execução da querie é fechado.
    (cTable)->(DbCloseArea())

Return 

/*------------------------------------------------------
@FUNÇÃO RESPONSÝVEL POR CRIAR AS PERGUNTAS NA SX1 
----------------------------------------------------------*/
Static function zValPerg(cPerg)
    local aArea := SX1->(getArea())
    local aRegs := {}
    local nX, nY

    aAdd( aRegs, { cPerg,"01","Cliente de ?","Cliente de ?","Cliente de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"} )
	aAdd( aRegs, { cPerg,"02","Cliente ate ?","Cliente ate ?","Cliente ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"} )

    dbSelectArea('SX1')
    SX1->(dbsetOrder(1))

    for nX:=1 to len(aRegs)
        if !SX1->( dbSeek(avKey(cPerg,"X1_GRUPO") + aRegs[nX,2]) )
            Reclock('SX1', .T.)
			for nY:= 1 to SX1->( FCOUNT() )
				if nY<=Len(aRegs[nX])

                /*FieldPut( < nPos >, < xValue > )
                <nPos>   Posição do campo do alias/tabela atuais.
                <xValue> Valor atribuito ao campo especificado*/
					FieldPut(nY,aRegs[nX,nY])
				endIf
			next nY
			SX1->(MsUnlock())
		Endif
	Next nX 
	RestArea(aArea) 
Return(cPerg)

