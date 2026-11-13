# Grave Danger: aderencia documental das mecanicas

Pesquisa e verificacao local: 12/11/2026. Nenhum servidor foi iniciado ou
recarregado. A comparacao considera os scripts presentes neste checkout.

## Resultado e limites

**47,5 de 55 pontos: aproximadamente 86% de aderencia documental.**

Cada linha abaixo tem cinco criterios, com peso igual: 1 para comportamento
documentado implementado, 0,5 para aproximacao, personalizacao ou parametro
incerto, e 0 para ausencia. E uma avaliacao de engenharia sobre este checklist,
nao uma medicao oficial de originalidade nem uma porcentagem de todo o Tibia.
Nao inclui equivalencia exata de loot, mapa, dano de todos os ataques, quest
completa de acesso, visual do cliente ou execucao real. A estimativa anterior de
75-80% nao tinha este checklist e nao serve como medicao comparavel de antes/depois.

| Encontro | Cinco criterios avaliados, na ordem | Pontos |
| --- | --- | --- |
| Count Vlarkorth | cinco minions; copia por vocacao incluindo Monk; restos por vocacao; protecao e duas rodadas; gatilhos exatos das rodadas | 1 + 1 + 1 + 1 + 0,5 = 4,5 |
| Lord Azaram | adds/reflexao; tres fragmentos; cura da alma conservada; Lesser Hex; numero/gatilhos das fases | 0,5 + 1 + 1 + 1 + 0,5 = 4 |
| Earl Osam | centro/nome/imunidade; quatro esferas; cura de 80 mil; afastamento cardinal; temporizacao | 1 + 1 + 1 + 1 + 0,5 = 4,5 |
| Duke Krule | elementos aleatorios; dano de proximidade; seguranca de mesmo elemento; pulsos visuais; tempos exatos | 1 + 1 + 1 + 1 + 0,5 = 4,5 |
| Baeloc/Nictros | primeira troca a 60%; segunda troca e ambos; cura de 18 mil; summons por fase; Lesser Hex | 1 + 1 + 0,5 + 0,5 + 1 = 4 |
| Rewar | imunidade com Fetters; ciclo de Fetters; retorno ao centro; vulnerabilidade sem Fetters; duracao da janela | 1 + 1 + 1 + 1 + 0,5 = 4,5 |
| Red Knight | vulnerabilidade a drowning; explosao do sangue; reposicao de adds; quantidade; cadencia/posicoes | 1 + 1 + 1 + 0,5 + 0,5 = 4 |
| Magnor | HP dos shards; quatro copias; vida compartilhada; alcance da explosao; dano life drain aproximado | 1 + 1 + 1 + 0,5 + 1 = 4,5 |
| Nargol | HP da massa; massa central imovel; prazo de 30 segundos; retorno com vida cheia; repeticoes em novas falhas | 1 + 1 + 1 + 1 + 0,5 = 4,5 |
| Zelos | acesso/grupo/tempo; raio e HP a 40%; limpeza sem curar jogador; tres soldados; fortalecimento | 1 + 1 + 1 + 0,5 + 0,5 = 4 |
| Scarlett | arena de dez minutos; espelhos; armadura/vulnerabilidade; golpe e cura fora da janela; alcance da explosao | 1 + 1 + 1 + 1 + 0,5 = 4,5 |

Os pontos completos indicam correspondencia funcional no codigo, nao validacao
ao vivo. Pequenos tempos, probabilidades e formulas nao publicados continuam
incertos mesmo quando a mecanica geral corresponde.

## Referencias e decisoes

- [TibiaWiki BR: Grave Danger](https://www.tibiawiki.com.br/index.php?stable=1&title=Grave_Danger_Quest):
  clones, restos por vocacao, duas rodadas do Count; canalizacao e esferas do Osam;
  etapas gerais dos encontros. A pagina consultada e a versao publicada de 2025.
- [TibiaWiki: Grave Danger](https://tibia.fandom.com/wiki/Grave_Danger_Quest):
  imunidade do Count; trocas dos irmaos em torno de 60%; Regenerating Mass em
  30 segundos; quatro guardioes e tres soldados da sala final; Greater Hex.
  O acesso direto foi bloqueado em algumas tentativas, mas os trechos indexados
  do spoiler foram recuperados. Nao foi usado codigo de outro OT como prova.
- [Tibia Life: primeira parte](https://www.tibialife.com.br/grave-danger-parte-1-12-tumulos-su19/):
  a alma conserva a cura entre transformacoes; quando ja esta cheia, o grupo
  precisa passar pelos fragmentos. Mantidas duas rodadas locais, pois o numero
  e os limiares exatos nao foram confirmados independentemente.
- [Tibia Life: luta final](https://www.tibialife.com.br/grave-danger-parte-3-boss-final-king-zelos-su19/):
  Rewar fica vulneravel depois da morte de todos os Fetters, por aproximadamente
  tres turnos; sangue perto do Red Knight; quatro shards com vida unica e
  explosoes na faixa de 2.500; massa e retorno do Nargol. Tres turnos foram
  aproximados como seis segundos, sem alegar cronometragem do servidor oficial.
- [Earl Osam](https://www.tibiawiki.com.br/wiki/Earl_Osam): 300.000 HP,
  cura por morte/gelo e tabela elemental. [Sir Baeloc](https://www.tibiawiki.com.br/index.php?stableid=351109&title=Sir_Baeloc):
  150.000 HP. As tabelas de resistencias incluem alertas de incerteza.
- [Shard of Magnor](https://www.tibiawiki.com.br/wiki/Shard_of_Magnor):
  205.000 HP compartilhados. [Isle of the Kings](https://www.tibiawiki.com.br/wiki/Isle_of_the_Kings):
  Regenerating Mass com 110.000 HP.
- [Guia de Scarlett](https://www.tibiaduality.com/quest-cobra): dez minutos
  de arena. Espelhos, vulnerabilidade de oito segundos, golpe de 7.500 e retorno
  da armadura em 30 segundos foram cruzados com o spoiler da TibiaWiki.

Foram descartados como prova do original os changelogs de OT, guias que declaram
balanceamento proprio e resultados com localizacoes/mecanicas contraditorias.

## Ajustes aplicados nesta revisao

- Count agora bloqueia todo dano ofensivo durante a fase dos restos, em vez de
  aceitar 10% e permitir ignorar a mecanica com dano alto.
- Azaram conserva a vida da alma entre transformacoes. Uma alma que ja surge
  cheia exige os tres fragmentos; a cura direta continua util quando incompleta.
  Condensed Sin e Condensed Sins usam reflexao nativa de morte. O valor configurado
  de 100% continua uma aproximacao, limitada pelas regras globais do servidor;
  a taxa exata do original e o comportamento nativo ao vivo ainda precisam de prova.
- Rewar fica imune enquanto qualquer Fetter da sessao estiver vivo, inclusive
  fora de seu campo de visao. Ao morrer o ultimo, retorna ao centro e abre a
  janela aproximada de seis segundos antes do proximo par.
  Coordenadas informadas pelo usuario: Fetters em (33463,31558,13) e
  (33463,31566,13), tanto na entrada quanto nos novos ciclos; dois Risen Soldiers
  em (33459,31562,13) e (33467,31562,13). Sao evidencias locais fornecidas pelo
  usuario, nao coordenadas confirmadas independentemente nas fontes da web.
- Cada morte de Nargol volta a produzir a massa: o time tem 30 segundos para
  mata-la. Falha faz Nargol retornar cheio. O callback valida mundo, sessao e
  identidade da massa; massa morta e sessao substituida invalidam a tentativa.
- Zelos recebe tres soldados em sua propria sala. Sua resistencia e fixada na
  conclusao do ritual, conforme o tempo gasto nos guardioes e suas etapas finais.
  O dano recebido usa max(0, 1 - duracao_do_ritual / 720), sem decair durante a
  luta final. O horizonte de 12 minutos e a interpolacao linear sao calibracao,
  nao uma formula oficial recuperada.
- Osam, Baeloc, shards e massa receberam os HP documentados. Osam cura com morte
  e gelo; Baeloc, Rewar e Zelos curam com morte. Parametros elementais incertos
  nao foram extrapolados para todos os monstros.
- Scarlett tem limite explicito de dez minutos.

A revisao por videos substituiu a personalizacao anterior do Osam e do Red Knight:
Osam inicia a primeira canalizacao em 40 segundos e as seguintes a cada 60 segundos
contados desde o inicio da fase anterior, sem gatilho por dano nem limite de quatro
fases. Red Knight mantem tres soldados e dois sangues, com reposicao individual
10 segundos depois da morte. Os pontos iniciais sao ancoras locais com alternativa
segura quando ocupados; nao sao coordenadas oficiais verificadas. O vortex continua
preservando o HP atual do jogador. Veja [evidencias e limites](grave-danger-video-calibration.md).

A nota de 86% acima permanece como checklist conservador da revisao documental
anterior; nao foi recalculada nem convertida em compatibilidade ao vivo com esta
calibracao. Quantidades agora possuem apoio visual, mas tempos e formulas exatos
continuam pendentes de confirmacao.

## Validacao

Passaram os testes isolados com a biblioteca LuaJIT mantida pelo projeto:

Os scripts de teste foram executados localmente e nao fazem parte deste PR.

Cobertura acrescentada: imunidade do Count sob dano letal; retorno/janela dos
Fetters; soldados da arena final e reposicao; repeticao/timeout/cancelamento da
massa; resistencia fixada pelo ritual e limitada; HP nativos e registro elemental/reflexao;
tempo configurado da Scarlett. Continuam os testes de mundo/sessao, restos de
Monk, alma, Osam, Duke, Hex e preservacao de HP atual.

Ainda requer lutas reais nos dois mundos: colocacao dos soldados no mapa,
reflexao/cura elemental nativas, dano composto de explosoes, creditos e loot,
interface das condicoes e cronometragem comparada com gravacao do Tibia oficial.
Nao ha base para prometer 100% de fidelidade ou equivalencia ao vivo.
