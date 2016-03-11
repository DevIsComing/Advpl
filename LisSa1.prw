#include "protheus.ch"
#include "rwmake.ch"
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ LISSA1     ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 11.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Lista os clientes de acordo com a escolha do usuário.      ¦¦¦
¦¦¦          ¦ Existe a opção em selecionar clientes do tipo Jurídico ou  ¦¦¦
¦¦¦          ¦ Físico. Exemplo simples de atualização de MsNewGetDados.   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
user function lisSa1
                               
private oDlgPrincipal
private aHeader := {}                                                  
//array com as opções que estarão disponíveis no comboBox
private aItens := {"T=Todos clientes","J=Juridica","F=Física"}
private aClientes := {}
private oGetDados      
private cCombo := "T"
private cPosicao := "T"

	//aHeader possui a configuração das colunas do getDados, como: tamanho, nome, tipo, tabela, etc
	aadd(aHeader,{"Cód. Cliente","A1_COD"   ,"@!"  , 3,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})	
	aadd(aHeader,{"Nome Cliente","A1_NOME"  ,"@!"  ,15,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})
	aadd(aHeader,{"CPF/CNPJ"    ,"A1_CGC"   ,"@!"  ,10,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})	
	aadd(aHeader,{"Endereço"    ,"A1_END"   ,"@!"  ,15,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})	
	aadd(aHeader,{"Bairro"      ,"A1_BAIRRO","@!"  ,10,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})
	aadd(aHeader,{"Cidade"      ,"A1_MUN"   ,"@!"  ,15,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})
	aadd(aHeader,{"Estado"      ,"A1_EST"   ,"@!"  , 5,0,,"€€€€€€€€€€€€€€ ","C","SA1","R"})	     

	//aqui inicia a configuraçao da tela principal entitulada "Lista Clientes"
	define msDialog oDlgPrincipal title "Lista Clientes" from 250,180 to 600,900 pixel
		
		//label "Cliente" posicionado antes do comboBox	
		@012,007 say "Cliente:" size 030,010 pixel of oDlgPrincipal
		//objeto oCombo da classe tComboBox (lembra de pré carregar o array com as opções que serão apresentadas ao usuário. Neste caso usamos o array aItens.
		oCombo := tComboBox():new(010,037,{|u| if(pcount() > 0, cPosicao := u, cCombo)}, aItens,080,010,oDlgPrincipal,,{|| .T.},,,,.T.,,,,{|| .T.},,,,,cCombo)
	    //'setando' os atributos do objeto oGetDados com o nome da tela principal(oDlgPrincipal), aHeader e a lista de clientes (aClientes)
		oGetDados := MsNewGetDados():New(030,007,150,350, , , , , , ,9999, , , , oDlgPrincipal, aHeader, aClientes)			
		//botão Pesquisar. Ao clicar executará o método atTabela()	
		@152,250 button "Pesquisar" size 040,010 pixel of oDlgPrincipal action (atTabela())
		@152,300 button "Sair"      size 040,010 pixel of oDlgPrincipal action (oDlgPrincipal:end())
		//inicializa a listagem de clientes e envia para o oGetDados
		atTabela()
	//apresenta a tela ao usuário	
	activate msDialog oDlgPrincipal centered

return               
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ atTabela      ¦ Autor ¦ Renan Ramos       ¦ Data ¦ 11.03.16¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Atualiza a tabela com listagem de clientes.                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function atTabela()
//alimenta o array aClientes com a listagem de clientes          
aClientes := selClientes()                              
//atualiza/recarrega o oGetDados
oGetDados:oBrowse:Refresh()     
//atualiza/recarrega a tela                                                                                                                                
oDlgPrincipal:Refresh()    
//aqui oGetDados é novamente redefinido e agora está com a tabela mais atualizada
oGetDados := MsNewGetDados():New(030,007,150,350, , , , , , ,9999, , , , oDlgPrincipal, aHeader, aClientes)

return
/*    
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ selClientes   ¦ Autor ¦ Renan Ramos       ¦ Data ¦ 11.03.16¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Seleciona os clientes no banco de dados de acordo com o    ¦¦¦
¦¦¦			 ¦ filtro de pesquisa feita pelo usuário.               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function selClientes()
//este array terá o conteúdo que será apresentado ao usuário
private aDados := {}

//abre a tabela SA1 (Clientes)
dbSelectArea("SA1")           
//configura primeiro índice (Filial + Código Cliente)
SA1->(dbSetOrder(1))                                    
//posiciona no primeiro registro
SA1->(dbGoTop())

//enquanto houver cliente na tabela ou enquanto não chega ao final da tabela executa as condições abaixo
while !eof()                                                                                            
	//se listar todos os clientes
   	if alltrim(cPosicao) = "T"
		aadd(aDados,{allTrim(SA1->A1_COD), allTrim(SA1->A1_NOME), allTrim(SA1->A1_CGC), allTrim(SA1->A1_END),;
				     allTrim(SA1->A1_BAIRRO), allTrim(SA1->A1_MUN), allTrim(SA1->A1_EST), .F.})
    //caso seja realizado filtro por pessoa Física ou Jurídica
	elseif allTrim(SA1->A1_PESSOA) = allTrim(cPosicao)		
		//adiciona os dados ao array aDados.
		//Lembrar de adicionar os dados de acordo com a sequencia definida no array aHeader para não haver troca de posição de conteúdo com cabeçalho
		//ou erros devido a diferença de tipos. Lembrar de definir o último elemento (tipo boolean).		  				                        
		aadd(aDados,{allTrim(SA1->A1_COD), allTrim(SA1->A1_NOME), allTrim(SA1->A1_CGC), allTrim(SA1->A1_END),;
				     allTrim(SA1->A1_BAIRRO), allTrim(SA1->A1_MUN), allTrim(SA1->A1_EST), .F.})	
	endIf	                                                                                        
	//avança o registro da tabela
    SA1->(dbSkip())
endDo   
//retorna a tabela atualizada
return aDados