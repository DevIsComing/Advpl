#include "protheus.ch"                                                       
#include "rwmake.ch"
/*
_________________________________________________________________________________
���������������������������������������������������������������������������������
��+---------------------------------------------------------------------------+��
���Programa  � EXPEXCEL  � Autor � Renan Ramos              � Data � 21.01.16 ���
���----------+----------------------------------------------------------------���
���Descri��o � Programa que exporta clientes para planilha do excel.          ���
��+---------------------------------------------------------------------------+��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
user function expExcel

private oReport
private oDlg     
private oGetDados  
private aHeader := {}
private aClientes := {}	

//exibe um di�logo onde a execu��o de um processo pode ser monitorada atrav�s da r�gua de progress�o.                               
Processa({|| oReport := ReportDef(), oReport:PrintDialog()},"Imprmindo dados...")

return                                                    
/*
_________________________________________________________________________________
���������������������������������������������������������������������������������
��+---------------------------------------------------------------------------+��
���Programa  � REPORTDEF � Autor � Renan Ramos              � Data � 25.01.16 ���
���----------+----------------------------------------------------------------���
���Descri��o � Monta a estrutura do relat�rio.                                ���
��+---------------------------------------------------------------------------+��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/               
static function reportDef

local oReport
local oSection
local oBreak

//configura o relat�rio
oReport := TReport():new("RELCLI","Lista de Clientes",,{|oReport| printReport(oReport)},"Lista de Clientes")
oReport:SetLandscape() 	//tipo de impress�o
oReport:nFontBody := 10 //tamanho da fonte padr�o
oReport:setTotalInLine(.F.)
oReport:showHeader()
//cria uma se��o   
oSection := TRSection():new(oReport,"Lista de clientes",{"SA1"})//importante descrever as tabelas utilizadas
oReport:setTotalInLine(.F.)

TRCell():new(oSection, "CLIENTE",,"")
oSection:cell("CLIENTE"):disable()

//define as colunas com o campo da tabela, tabela e cabe�alho que estar� na planilha
TRCell():new(oSection, "A1_COD" , "SA1", "C�d. cliente")
TRCell():new(oSection, "A1_NOME", "SA1", "Nome cliente")
TRCell():new(oSection, "A1_END" , "SA1", "Endere�o")
TRCell():new(oSection, "A1_MUN" , "SA1", "Cidade")
TRCell():new(oSection, "A1_EST" , "SA1", "Estado")
TRCell():new(oSection, "A1_PAIS", "SA1", "Pais")
      
return oReport
/*
___________________________________________________________________________________
�����������������������������������������������������������������������������������
��+-----------------------------------------------------------------------------+��
���Programa  � PRINTREPORT � Autor � Renan Ramos              � Data � 25.01.16 ���
���----------+------------------------------------------------------------------���
���Descri��o � Realiza a impress�o do relat�rio.                                ���
��+-----------------------------------------------------------------------------+��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
static function printReport()
    
local oSection := oReport:section(1)
local cSql := ""

oSection:init()    

//efetua a pesquisa no banco de dados. Neste caso, seleciona todos os clientes existentes
cSql := " SELECT A1_COD, A1_NOME, A1_END, A1_MUN, A1_EST, A1_PAIS "
cSql += " FROM "+RetSqlName("SA1")+"  SA1 "
cSql += " WHERE SA1.D_E_L_E_T_ = '' "   
cSql += " ORDER BY A1_COD "
    
//salva o c�digo sql na pasta TEMP para consultas no seu SGBD
memoWrite("\TEMP\RELSA1.sql",cSql)                           
//Executa a query e cria uma tabela tempor�ria (TRB)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TRB",.F.,.T.)

oReport:setMeter(TRB->(recCount()))

TRB->(dbGoTop())

//percorre a tabela tempor�ria e 'seta' os valores nas respectivas colunas
while !TRB->(eof())
	oSection:cell("A1_COD"):setValue(TRB->A1_COD)
	oSection:cell("A1_NOME"):setValue(TRB->A1_NOME)
	oSection:cell("A1_END"):setValue(TRB->A1_END)	
	oSection:cell("A1_MUN"):setValue(TRB->A1_MUN)
	oSection:cell("A1_EST"):setValue(TRB->A1_EST)
	oSection:cell("A1_PAIS"):setValue(TRB->A1_PAIS)
	oSection:printLine()
	oReport:incMeter()
	TRB->(dbSkip())
endDo
                  
oSection:finish()
TRB->(dbCloseArea())

return 