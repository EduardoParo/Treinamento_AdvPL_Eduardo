#include "protheus.ch"
#include "rptdef.ch"

/*/{Protheus.doc} --------------------------*
| @Treinamento - TREPORT                    |
| @Aula: 03_TREPORT_JOB                     |            
| @data : 17/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |
| @GitHub.com/EduardoParo                   |        
--------------------------------------------*/
//-------------------------------------------------------------------
//Chama a impressão de relatório em outra thread, ficando assim um
//job sem interface
//-------------------------------------------------------------------
function u_Calt()
  StartJob("u_mySRx", getEnvServer(), .T.)
return nil

//-------------------------------------------------------------------
//Função para testes da classe TReport, exportando PDF*/
//-------------------------------------------------------------------
Function u_mySRx()
  Local oReport  as object
  Local oSection as object
  Local cAlias   as char
  Local cTitle   as char
  Local cFile    as char

  rpcSetEnv("99", "01")

  cAlias := "SED"
  cTitle := "Naturezas"
  cFile := "SED_Nat"
  oReport := TReport():New(cFile, cTitle, nil, {|oReport| oSection:print()} )
  oSection := TRSection():New(oReport, cTitle, cAlias, nil, .T.)

  oReport:setFile(cFile)
  oReport:cFile:=cFile
  oReport:nRemoteType := NO_REMOTE
  oReport:nDevice := 6 
  oReport:SetEnvironment(1)
  oReport:SetViewPDF(.F.)
  oReport:printDialog(, cAlias)

  FreeObj(oReport)
  FreeObj(oSection)

  rpcClearEnv()
Return
