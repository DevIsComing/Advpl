#include "protheus.ch"
#include "rwmake.ch"
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CHECBOX    ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 11.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Exemplo de utilização do elemento checkBox em um getDados. ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
user function exCheck
                               
private oDlgTela
private aHeader := {}  
private cEstado := space(3)
private aColsCidades := {}
private lChkSel    := .F.            
private lOkSalva   := .F.            
private lChkFiltro := .F.   
private oGetDados      
static oChk, oChkFiltro

//array de cabeçalho do GetDados
//Neste caso serão 4 colunas incluindo o campo que possui caixa de seleção ou checkBox
	aadd(aHeader,{''		  ,'CHECKBOL'     ,'@BMP', 2,0,,	             ,"C",     ,"V",,,'seleciona','V','S'})
	aadd(aHeader,{"Código"    ,"CC2_CODMUN"   ,"@!"  , 3,0,,"€€€€€€€€€€€€€€ ","C","CC2","R"})	
	aadd(aHeader,{"Município" ,"CC2_MUN"      ,"@!"  ,30,0,,"€€€€€€€€€€€€€€ ","C","CC2","R"})
	aadd(aHeader,{"Estado"    ,"CC2_EST"      ,"@!"  , 4,0,,"€€€€€€€€€€€€€€ ","C","CC2","R"})	
                                                   
	//Nosso programa irá listar todos os municípios e fazer filtros por Estado
	@003,003 to 530,1150 dialog oDlgTela title "Lista de Municípios"

	//Aqui onde o usuário informará o estado que buscará as cidades pertencentes
	@011,006 say "Estado: " pixel of oDlgTela                                   
	//este elemento get é a caixa de testo que possui a consulta padrão (opção F3).
	//esta consulta CC2EST foi configurada no Configurador somente para este uso
	@011,020 get cEstado size 30,11 F3 "CC2EST"
	                                                                            
	//botão pesquisar que, quando acionado, efetua a busca dos municípios de acordo com o Estado inserido pelo usuário
	//a variável cEstado armazena o conteúdo existente no elemento "get" acima
	@012,125 button "&Pesquisar" size 40,11 pixel of oDlgTela action buscaCc2(cEstado)

	//o objeto oGetDados (MsNewGetDados) com os atributos configurados	
	oGetDados := MsNewGetDados():New(025,006,230,570, GD_UPDATE, , , , {'CHECKBOL'}, 1, 99, , , , oDlgTela, aHeader, aColsCidades,,)
	//quando clicado duas vezes sobre o aCols[oGetDados:nAt,1], ou seja, onde ficará a coluna com o checkbox, ele irá alternar de LBOK para LBNO e vice versa
	oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(), oGetDados:aCols[oGetDados:nAt,1] := iif(oGetDados:aCols[oGetDados:nAt,1] == 'LBOK','LBNO','LBOK')}
	
	//objeto oChk de checkbox e variável lChkSel. Quando clicado, executa o método "seleciona" e possibilita 
	//que o usuário selecione todas as cidades ao mesmo tempo. Facilita também no momento da escolha em casos de listas extensas
	@240,006 checkbox oChk var lChkSel PROMPT "Selecionar todos" size 60,07 on CLICK seleciona(lChkSel)

	//botao confirmar comum, ainda daremos utilidade à ele :)	
   	@240,125 button "&Confirmar" size 40,11 pixel of oDlgTela action close(oDlgTela)
   	//botão padrão de Cancelar
    @240,190 button "&Cancelar"  size 40,11 pixel of oDlgTela action close(oDlgTela)	         
	
	//antes de ativar a tela (oDlgTela) e centralizá-la para o usuário, 
	//o método "buscaCc2" pesquisa todas as cidades e estados para pré carregar o oGetDados
    buscaCc2(cEstado)                                                                                                                     
	 
	//ativa o oDlgTela
    activate dialog oDlgTela center  
    
return                          
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ BUSCACC2   ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 11.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Pesquisa as cidades de acordo com o estado escolhido. Caso ¦¦¦
¦¦¦          ¦ cEstado esteja vazio, serão apresentadas todas as cidades e¦¦¦
¦¦           ¦ estados presentes na tabela.                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
static function buscaCc2(cEstado)

private aColsCidades := {}   
//atualiza/recarrega o oGetDados e o oDlgTela antes de receber novos dados          
refresh(aColsCidades)

//abre a tabela CC2
dbSelectArea("CC2")
//'seta' primeiro índice (Filial+Estado+Município)
dbSetOrder(1)                                                      
//posiciona no topo da tabela
dbGoTop()                      
//faz a busca pelo índice informado utilizando o conteúdo da variável cEstado
dbSeek(xFilial("CC2")+allTrim(cEstado))
//enquanto não é final da tabela
while CC2->(!eof())             
	//se o conteúdo do campo CC2->CC2_EST igual ao conteúdo de cEstado                        
	if allTrim(cEstado) = allTrim(CC2->CC2_EST)
		aadd(aColsCidades,{'LBNO', allTrim(CC2->CC2_CODMUN), allTrim(CC2->CC2_MUN), allTrim(CC2->CC2_EST),.F.})
	//se cEstado estiver vazio, adiciona todos 
	elseif empty(allTrim(cEstado))
		aadd(aColsCidades,{'LBNO', allTrim(CC2->CC2_CODMUN), allTrim(CC2->CC2_MUN), allTrim(CC2->CC2_EST),.F.})
	endif                                      
	//avança registro
	CC2->(dbSkip())
endDo
//atualiza o oGetDados com o novo array
refresh(aColsCidades)

return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ REFRESH  ¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 13.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Realiza limpeza dos dados na MsGetDados e inclui novo array¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
static function refresh(aDados)

oGetDados:oBrowse:Refresh()                                                                                                                                    
oDlgTela:Refresh()

oGetDados := MsNewGetDados():New(025,006,230,570, GD_UPDATE, , , , {'CHECKBOL'}, 1, 99, , , , oDlgTela, aHeader, aColsCidades,,)
oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(), oGetDados:aCols[oGetDados:nAt,1] := iif(oGetDados:aCols[oGetDados:nAt,1] == 'LBOK','LBNO','LBOK')}

return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ seleciona¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 08.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Seleciona todas as cidades apresentadas no aCols.          ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  
static function seleciona(lChkSel)
//percorre todas as linhas do oGetDados
for i := 1 to len(oGetDados:aCols)
	//verifica o valor da variável lChkSel
	//se verdadeiro, define a primeira coluna do aCols como LBOK ou marcado (checked)
	if lChkSel
		oGetDados:aCOLS[i,1] := 'LBOK'                                               
	//se falso, marca como LBNO ou desmarcado (unchecked)
	else
		oGetDados:aCOLS[i,1] := 'LBNO'
	endif	
next     
//executa refresh no getDados e na tela
//esses métodos Refresh() são próprio da classe MsNewGetDados e do dialog
//totalmente diferentes do método estático definido no corpo deste fonte
oGetDados:oBrowse:Refresh() 
oDlgTela:Refresh()

return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ selFiltro¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 03.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Executa o filtro de cidades selecionadas.                  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  
static function selFiltro(lChkFiltro)

buscaCc2(lChkFiltro)//atualiza o grid de dados

oGetDados:oBrowse:Refresh() 
oDlgTela:Refresh()

return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ VERIFLIN ¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 09.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Verifica se existem cidades selecionadas.                  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
static function verifLin()

local lRet := .F.
           
for i := 1 to len(oGetDados:aCols)
    if oGetDados:aCols[i,1] == 'LBOK'		
		aadd(aCidades,{oGetDados:aCols[i,2],oGetDados:aCOLS[i,3],oGetDados:aCOLS[i,4]})
		lRet := .T.                  				
	endIf   
next 
       
return lRet