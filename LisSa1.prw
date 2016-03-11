#include "protheus.ch"
#include "rwmake.ch"
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � LISSA1     � Autor � Renan R. Ramos      � Data � 11.03.16 ���
���----------+------------------------------------------------------------���
���Descri��o � Lista os clientes de acordo com a escolha do usu�rio.      ���
���          � Existe a op��o em selecionar clientes do tipo Jur�dico ou  ���
���          � F�sico. Exemplo simples de atualiza��o de MsNewGetDados.   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user function lisSa1
                               
private oDlgPrincipal
private aHeader := {}                                                  
//array com as op��es que estar�o dispon�veis no comboBox
private aItens := {"T=Todos clientes","J=Juridica","F=F�sica"}
private aClientes := {}
private oGetDados      
private cCombo := "T"
private cPosicao := "T"

	//aHeader possui a configura��o das colunas do getDados, como: tamanho, nome, tipo, tabela, etc
	aadd(aHeader,{"C�d. Cliente","A1_COD"   ,"@!"  , 3,0,,"���������������","C","SA1","R"})	
	aadd(aHeader,{"Nome Cliente","A1_NOME"  ,"@!"  ,15,0,,"���������������","C","SA1","R"})
	aadd(aHeader,{"CPF/CNPJ"    ,"A1_CGC"   ,"@!"  ,10,0,,"���������������","C","SA1","R"})	
	aadd(aHeader,{"Endere�o"    ,"A1_END"   ,"@!"  ,15,0,,"���������������","C","SA1","R"})	
	aadd(aHeader,{"Bairro"      ,"A1_BAIRRO","@!"  ,10,0,,"���������������","C","SA1","R"})
	aadd(aHeader,{"Cidade"      ,"A1_MUN"   ,"@!"  ,15,0,,"���������������","C","SA1","R"})
	aadd(aHeader,{"Estado"      ,"A1_EST"   ,"@!"  , 5,0,,"���������������","C","SA1","R"})	     

	//aqui inicia a configura�ao da tela principal entitulada "Lista Clientes"
	define msDialog oDlgPrincipal title "Lista Clientes" from 250,180 to 600,900 pixel
		
		//label "Cliente" posicionado antes do comboBox	
		@012,007 say "Cliente:" size 030,010 pixel of oDlgPrincipal
		//objeto oCombo da classe tComboBox (lembra de pr� carregar o array com as op��es que ser�o apresentadas ao usu�rio. Neste caso usamos o array aItens.
		oCombo := tComboBox():new(010,037,{|u| if(pcount() > 0, cPosicao := u, cCombo)}, aItens,080,010,oDlgPrincipal,,{|| .T.},,,,.T.,,,,{|| .T.},,,,,cCombo)
	    //'setando' os atributos do objeto oGetDados com o nome da tela principal(oDlgPrincipal), aHeader e a lista de clientes (aClientes)
		oGetDados := MsNewGetDados():New(030,007,150,350, , , , , , ,9999, , , , oDlgPrincipal, aHeader, aClientes)			
		//bot�o Pesquisar. Ao clicar executar� o m�todo atTabela()	
		@152,250 button "Pesquisar" size 040,010 pixel of oDlgPrincipal action (atTabela())
		@152,300 button "Sair"      size 040,010 pixel of oDlgPrincipal action (oDlgPrincipal:end())
		//inicializa a listagem de clientes e envia para o oGetDados
		atTabela()
	//apresenta a tela ao usu�rio	
	activate msDialog oDlgPrincipal centered

return               
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � atTabela      � Autor � Renan Ramos       � Data � 11.03.16���
���----------+------------------------------------------------------------���
���Descri��o � Atualiza a tabela com listagem de clientes.                ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function atTabela()
//alimenta o array aClientes com a listagem de clientes          
aClientes := selClientes()                              
//atualiza/recarrega o oGetDados
oGetDados:oBrowse:Refresh()     
//atualiza/recarrega a tela                                                                                                                                
oDlgPrincipal:Refresh()    
//aqui oGetDados � novamente redefinido e agora est� com a tabela mais atualizada
oGetDados := MsNewGetDados():New(030,007,150,350, , , , , , ,9999, , , , oDlgPrincipal, aHeader, aClientes)

return
/*    
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � selClientes   � Autor � Renan Ramos       � Data � 11.03.16���
���----------+------------------------------------------------------------���
���Descri��o � Seleciona os clientes no banco de dados de acordo com o    ���
���			 � filtro de pesquisa feita pelo usu�rio.               	  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function selClientes()
//este array ter� o conte�do que ser� apresentado ao usu�rio
private aDados := {}

//abre a tabela SA1 (Clientes)
dbSelectArea("SA1")           
//configura primeiro �ndice (Filial + C�digo Cliente)
SA1->(dbSetOrder(1))                                    
//posiciona no primeiro registro
SA1->(dbGoTop())

//enquanto houver cliente na tabela ou enquanto n�o chega ao final da tabela executa as condi��es abaixo
while !eof()                                                                                            
	//se listar todos os clientes
   	if alltrim(cPosicao) = "T"
		aadd(aDados,{allTrim(SA1->A1_COD), allTrim(SA1->A1_NOME), allTrim(SA1->A1_CGC), allTrim(SA1->A1_END),;
				     allTrim(SA1->A1_BAIRRO), allTrim(SA1->A1_MUN), allTrim(SA1->A1_EST), .F.})
    //caso seja realizado filtro por pessoa F�sica ou Jur�dica
	elseif allTrim(SA1->A1_PESSOA) = allTrim(cPosicao)		
		//adiciona os dados ao array aDados.
		//Lembrar de adicionar os dados de acordo com a sequencia definida no array aHeader para n�o haver troca de posi��o de conte�do com cabe�alho
		//ou erros devido a diferen�a de tipos. Lembrar de definir o �ltimo elemento (tipo boolean).		  				                        
		aadd(aDados,{allTrim(SA1->A1_COD), allTrim(SA1->A1_NOME), allTrim(SA1->A1_CGC), allTrim(SA1->A1_END),;
				     allTrim(SA1->A1_BAIRRO), allTrim(SA1->A1_MUN), allTrim(SA1->A1_EST), .F.})	
	endIf	                                                                                        
	//avan�a o registro da tabela
    SA1->(dbSkip())
endDo   
//retorna a tabela atualizada
return aDados