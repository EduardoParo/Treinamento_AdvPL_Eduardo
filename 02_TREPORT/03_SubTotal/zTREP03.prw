#include "protheus.ch"

/*/{Protheus.doc} --------------------------*
| @Treinamento - TREPORT                    |
| @Aula: 03_TREPORT_SUBTOTAL                |            
| @data : 17/08/2021                        |            
| @Autor: Eduardo Paro de Simoni            |
| @GitHub.com/EduardoParo                   |        
--------------------------------------------*/
Function U_xTRep03()
	Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak

	oReport := TReport():New("MYREPORT","Relatorio de Visitas",NIL,{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")
	oSection := TRSection():New(oReport,"Clientes",{"SA1"})
	
	TRCell():New(oSection,"A1_COD","SA1","Cliente")
	TRCell():New(oSection,"A1_LOJA","SA1")
	TRCell():New(oSection,"A1_NOME","SA1")
	TRCell():New(oSection,"A1_ULTVIS","SA1")
	TRCell():New(oSection,"A1_TEMVIS","SA1")
	TRCell():New(oSection,"A1_CONTATO","SA1")
	TRCell():New(oSection,"A1_TEL","SA1")
	TRCell():New(oSection,"A1_PESSOA","SA1")

	oBreak := TRBreak():New(oSection,oSection:Cell("A1_PESSOA"),"Sub Total de CODIGO POR PESSOA JURIDICA OU FISICA")

	TRFunction():New(oSection:Cell("A1_COD"),NIL,"COUNT",oBreak)
	TRFunction():New(oSection:Cell("A1_TEMVIS"),NIL,"SUM",oBreak)

Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)

	oSection:BeginQuery()

	BeginSql alias "QRYSA1"
        SELECT A1_COD,A1_LOJA,A1_NOME,A1_ULTVIS,A1_TEMVIS,A1_TEL,A1_CONTATO,A1_PESSOA
	    FROM %table:SA1% SA1        		
        	
        ORDER BY SA1.A1_COD	
	EndSql
	
	oSection:EndQuery()
	
	oSection:Print()
Return
