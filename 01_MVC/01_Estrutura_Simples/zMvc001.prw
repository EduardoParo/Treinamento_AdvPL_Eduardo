//Bibliotecas
#Include'totvs.ch'
#Include'FWMVCDEF.CH'

/*/{Protheus.doc} --------------------------*
| @Treinamento - MVC                        |
| @Aula: 01_Estrutura_Simples               |            
| @data : 16/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |        
--------------------------------------------*/
Static cNomeArq:= "zMvc001"
/*------------------------
@BROWSE - OPCIONAL
--------------------------*/
Function U_MainBrw() 
    Local oBrw:= NIL
    PRIVATE aRotina:= MenuDef()

    oBrw := FWMBrowse():New()

    oBrw:setAlias("SB1")

    oBrw:SetDescription("Meu primeiro MVC")

    oBrw:ACTIVATE()

Return
/*------------------------
@FwExecView - OPCIONAL
--------------------------*/
//function U_MainBrw() 
//    FwExecView('MENUDIRETO',"ViewDef."+cNomeArq, 3,,)
//
//Return

/*------------------------
@MENUDEF - OPCIONAL
--------------------------*/
Static function Menudef()
    Local aRotina := {}

    aRotina := FwMVCMenu(cNomeArq) 
    //	ADD OPTION aRotina TITLE 'Incluir'    ACTION cView OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
  
Return aRotina

/*------------------------
@ModelDEF **
--------------------------*/
Static function ModelDef()
    Local oModel :=NIL
    Local oStSB1:= FWFormStruct(1,"SB1")

    oModel:= MpFormModel():New("zMVCMD1",/*bPre*/, /*bPos*/,,/*bCancel*/) 

    oModel:AddFields("MASTER",,oStSB1)

    oModel:SetDescription("Model de Dados")

    oModel:getModel("MASTER"):setDescription("Model Master")

Return oModel

/*------------------------
@ViewDEF **
--------------------------*/
Static function ViewDef()
    Local oModel := FwLoadModel(cNomeArq)

    Local oStrSb1:= FWFormStruct(2,"SB1")
    Local oView :=FwFormView():New()

   oView:setModel(oModel)

    oView:addField("View",oStrSb1,"MASTER")

    oView:CreateHorizontalBox("TELA",100)

    oView:EnableTitleView("View","Dados Sb1")

Return oView



