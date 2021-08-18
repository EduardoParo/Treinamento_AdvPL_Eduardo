//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

 /*/{Protheus.doc} ------------------------*
| @Treinamento - MVC                       |             
| @Aula: 05_Cabecalho_Grid_Grid_e_Grid     |             
| @data : 16/08/2021                       |             
| @Autor: Eduardo Paro de Simoni           |                         
-------------------------------------------*/
#DEFINE cNomeArq "zMVC005" 
Static cTitulo := "MVC"
/*--------------------------------------------------------
@BROWSE
//----------------------------------------------------------*/
Function u_zModEdu()
	Local aArea   := GetArea()
	Local cFunBkp := FunName()
	Local aRotAnt :=  If( Type('aRotina') <> 'A', {}, aClone(aRotina) )
	Local oBrowse :=NIL
	
	Private aRotina := MenuDef() 
	
    SetFunName(cNomeArq)
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SB1")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
	aRotina := aRotAnt
return nil

/*--------------------------------------------------------
@MENU
//----------------------------------------------------------*/
Static Function MenuDef()
	Local cView:= 'VIEWDEF.'+cNomeArq
	
	aRotina	:= {}
	//Adicionando opções
	ADD OPTION aRotina TITLE 'Incluir'    ACTION cView OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
return aRotina

/*--------------------------------------------------------
@MODEL
//----------------------------------------------------------*/
Static Function MODELDEF()
	Local oModel
	Local oStrCab    := FWFormStruct(1, "SA2",{|X| AllTrim(X)   $ "A2_COD;A2_LOJA;A2_NOME;A2_NREDUZ;A2_TIPO;A2_END;A2_EST;A2_COD_MUN;A2_MUN;A2_CGC" })
	Local oStrDet1   := FWFormStruct(1, "SA2",{|X| !AllTrim(X)  $ "A2_COD;A2_LOJA;A2_NOME;A2_NREDUZ;A2_TIPO;A2_END;A2_EST;A2_COD_MUN;A2_MUN;A2_CGC" })
	Local oStrDet2   := FWFormStruct(1, "SB1",{|X|  AllTrim(X)  $ "B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO" })
    Local oStrDet3   := FWFormStruct(1, "SB1",{|X| !AllTrim(X)  $ "B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO" })

	oModel := MPFormModel():New(cNomeArq)
	oModel:SetDescription("TREINAMENTO_EDU")

	oModel:AddFields('MASTER',,oStrCab)
	oModel:AddGrid("DETAIL1", "MASTER", oStrDet1)
	oModel:AddGrid("DETAIL2", "DETAIL1", oStrDet2)
    oModel:AddGrid("DETAIL3", "DETAIL2", oStrDet3)

	oModel:GetModel("DETAIL1"):SetOptional(.T.)
	oModel:GetModel("DETAIL2"):SetOptional(.T.)
    oModel:GetModel("DETAIL3"):SetOptional(.T.)

	oModel:SetRelation("DETAIL1", {{"A2_FILIAL", "xFilial('SA2')"}, {"A2_COD", "A2_COD"}}, SA2->(IndexKey(1)))
	oModel:SetRelation("DETAIL2", {{"B1_FILIAL", "xFilial('SB1')"}, {"B1_FILIAL", "B1_FILIAL"}}, SB1->(IndexKey(1)))
    oModel:SetRelation("DETAIL3", {{"B1_FILIAL", "xFilial('SB1')"}, {"B1_FILIAL", "B1_FILIAL"}}, SB1->(IndexKey(1)))

    oModel:SetPrimaryKey({})

Return oModel

/*--------------------------------------------------------
@VIEW
//----------------------------------------------------------*/
Static Function VIEWDEF()
	Local oView
	Local oModel     := ModelDef()
	Local oStrCab    := FWFormStruct(2, "SA2" ,{|X|  AllTrim(X)  $ "A2_COD;A2_LOJA;A2_NOME;A2_NREDUZ;A2_TIPO;A2_END;A2_EST;A2_COD_MUN;A2_MUN;A2_CGC" })
	Local oStrDet1   := FWFormStruct(2, "SA2" ,{|X| !AllTrim(X)  $ "A2_COD;A2_LOJA;A2_NOME;A2_NREDUZ;A2_TIPO;A2_END;A2_EST;A2_COD_MUN;A2_MUN;A2_CGC" })
	Local oStrDet2   := FWFormStruct(2, "SB1" ,{|X|  AllTrim(X)  $ "B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO" })
    Local oStrDet3   := FWFormStruct(2, "SB1" ,{|X| !AllTrim(X)  $ "B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO" })

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('VIEW_CAB', oStrCab, 'MASTER')
	oView:AddGrid("VIEW_DET1", oStrDet1, "DETAIL1")

	oView:AddGrid("VIEW_DET2", oStrDet2, "DETAIL2")
    oView:AddGrid("VIEW_DET3", oStrDet3, "DETAIL3")

	oView:CreateHorizontalBox("CABECALHO", 40)
	oView:CreateHorizontalBox("MEIO", 30)
    oView:CreateHorizontalBox("RODAPE", 30)

	oView:CreateVerticalBox( 'RODESQ', 50, 'RODAPE')
	oView:CreateVerticalBox( 'RODDIR', 50, 'RODAPE')

	oView:SetOwnerView("VIEW_CAB", "CABECALHO")
	oView:SetOwnerView("VIEW_DET1", "MEIO")

    oView:SetOwnerView("VIEW_DET2", "RODESQ")
	oView:SetOwnerView("VIEW_DET3", "RODDIR")


	oView:EnableTitleView("VIEW_CAB", OemToAnsi("Cabeçalho"))
	oView:EnableTitleView("VIEW_DET1", OemToAnsi("Detail 1"))

	oView:EnableTitleView("VIEW_DET2", OemToAnsi("Detail 2"))
    oView:EnableTitleView("VIEW_DET3", OemToAnsi("Detail 3"))

Return oView





