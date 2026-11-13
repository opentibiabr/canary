# Grave Danger: calibracao por videos

Revisao em 12/11/2026. Foram examinadas legendas e sequencias de quadros dos
videos abaixo. Nao houve execucao, reload ou validacao no servidor de jogo.

## Evidencia consultada

- [Adumor: Earl Osam](https://www.youtube.com/watch?v=jy-qVcwd94Q):
  canalizacoes aparecem aproximadamente em 0:43 e 1:41; o combate inicia perto
  de 0:04. As esferas e a troca de forma sao visiveis. Edicao e a resolucao dos
  quadros impedem afirmar um intervalo oficial exato.
- [TibiaLevelUp: Earl Osam](https://www.youtube.com/watch?v=V2oJjs5oov8):
  a explicacao entre 2:18 e 3:15 descreve a canalizacao e as quatro esferas;
  nao fornece numeros exatos para o gatilho ou deslocamento.
- [Tutorial de King Zelos](https://www.youtube.com/watch?v=VPHMDWD8IWU):
  entre 0:48 e 1:15 relaciona o tempo do ritual a dificuldade do Zelos e
  compara tentativas de aproximadamente 17 e 7,5 minutos. Entre 2:54 e 3:12,
  quadros da sala do Red Knight mostram tres soldados e dois sangues.
- [Xaral: King Zelos](https://www.youtube.com/watch?v=jhBkwZwtgjg):
  as legendas perto de 1:35 reforcam a importancia da velocidade do ritual;
  entre 2:48 e 3:40 explicam aproximar e matar o sangue junto ao Red Knight.
- [TibiaWiki: Grave Danger](https://tibia.fandom.com/wiki/Grave_Danger_Quest):
  trechos indexados do spoiler relacionam cerca de 12 minutos de ritual a um
  Zelos forte demais. Nao foi recuperada uma formula numerica oficial.

## Parametros aplicados e limites

| Componente | Comportamento aplicado | Grau de confirmacao |
| --- | --- | --- |
| Osam | Primeira fase em 40 s; seguintes a cada 60 s desde o inicio anterior | Calibracao compativel com os quadros; nao cronometragem oficial |
| Osam | Gatilho por tempo, quatro esferas, repeticao sem limite artificial de quatro fases | Modelo implementado a partir do ciclo observado; gatilho interno nao publicado |
| Esferas | Um passo a cada 4 s e cura de 80.000 ao chegar | Cadencia mantida, ainda sem prova de velocidade oficial |
| Red Knight | Tres Risen Soldiers e dois Vampiric Blood | Composicao observada no video |
| Reposicao | 10 s por criatura morta; tentativa falha repete em 1 s | Ajuste provisorio; os videos nao permitem medir a reposicao com seguranca |
| Posicoes do Red Knight | Ancoras locais com alternativa segura se ocupadas | Coordenadas oficiais nao confirmadas |
| Zelos | Resistencia definida pelo tempo ate concluir todo o ritual | Modelo escolhido conforme os tutoriais; formula interna desconhecida |
| Curva do Zelos | Dano recebido = dano base * max(0, 1 - segundos_do_ritual / 720) | Interpolacao local; 12 minutos como horizonte aproximado |

Exemplos da curva implementada: ritual de 4 minutos permite 66,67% do dano;
7,5 minutos, 37,5%; 10 minutos, 16,67%; 12 minutos ou mais, zero.
O tempo da luta final nao reduz novamente esses valores. Esses exemplos descrevem
o script e nao constituem uma tabela oficial do Tibia.

As coordenadas fornecidas para os Fetters e soldados do Rewar foram preservadas.
O vortex remove o Greater Hex ativo sem curar ou cortar o HP atual.

## Validacao local e roteiro no jogo

Passaram os fluxos Lua isolados de Grave Danger e Duke Krule. Cobrem o ciclo
temporal do Osam sem dependencia de dano, repeticoes, cura das esferas, contagens
e reposicao individual, falha de colocacao, morte do Red Knight, isolamento de
mundo/sessao e resistencia do Zelos fixa para diferentes duracoes do ritual.

Na validacao no jogo:

1. Cronometrar a primeira fase do Osam e o intervalo entre inicios das fases.
2. Conferir a velocidade das esferas e os pontos seguros de aparecimento.
3. Matar um sangue e um soldado em momentos diferentes: cada um deve retornar
   dez segundos depois da propria morte, mantendo os limites de dois e tres.
4. Comparar dano contra Zelos apos rituais curtos e longos; repetir o mesmo ataque
   mais tarde na luta final para verificar que a resistencia nao cresce novamente.
5. Confirmar que o vortex remove a condicao e preserva exatamente o HP atual.

As incertezas de cadencia, ancoras e curva impedem afirmar equivalencia integral
ao original. Nenhuma porcentagem de compatibilidade ao vivo foi medida.
