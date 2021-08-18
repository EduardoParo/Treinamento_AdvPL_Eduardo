//Bibliotecas
#Include'totvs.ch'
#Include'FWMVCDEF.CH'

/*/{Protheus.doc} --------------------------*
| @Treinamento - MVC                        |
| @Aula: 02_Comit                           |  
| @data : 16/08/2021                        |  
| @Autor: Eduardo Paro de Simoni            |  
--------------------------------------------*/
//Deinir nome do arquivo fonte
Static cNomeArq:= "zMvc002"
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
@CHAMADA DIRETO AO MENU 
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
@ModelDEF
--------------------------*/
Static function ModelDef()
    Local oModel :=NIL
    Local oStSB1:= FWFormStruct(1,"SB1")

    oModel:= MpFormModel():New("zMVCMD1",/*bPre*/, /*bPos*/,{||u_GrvSB1()},/*bCancel*/) 

    oModel:AddFields("MASTER",,oStSB1)

    oModel:SetDescription("Model de Dados")

    oModel:getModel("MASTER"):setDescription("Model Master")

Return oModel

/*------------------------
@ViewDEF
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

/*------------------------
@COMIT MANUAL
--------------------------*/
function u_GrvSB1()
    Local aArray :={}
    Local oModel := FwModelActive()
    Local nOp    := oModel:GetOperation()

    PRIVATE lMsErroAuto := .F.
    
    aAdd(aArray,{"B1_COD"    ,oModel:getValue("MASTER","B1_COD" )   ,NIL}) 
    aAdd(aArray,{"B1_DESC"   ,oModel:getValue("MASTER","B1_DESC" )  ,NIL}) 
    aAdd(aArray,{"B1_TIPO"   ,oModel:getValue("MASTER","B1_TIPO" )  ,Nil}) 
    aAdd(aArray,{"B1_UM"     ,oModel:getValue("MASTER","B1_UM" )  ,Nil}) 
    aAdd(aArray,{"B1_LOCPAD" ,oModel:getValue("MASTER","B1_LOCPAD" )  ,Nil}) 
 
    MSExecAuto({|x,y| Mata010(x,y)},aArray,nOp)

    If lMsErroAuto
     	MostraErro()
    Else
     	fwalertSuccess("Ok")
    Endif

return .T.

