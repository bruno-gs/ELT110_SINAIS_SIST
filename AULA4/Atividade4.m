%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparação do código 
%% 
%% Boas práticas: limpeza de variáveis; variáveis globais
%% Constantes; carregar bibliotecas;...
%%

clear all;                  % limpa as variáveis
close all;                  % fecha todas as figuras ativas
clc;                        % limpa a tela visível

%%%%% Bibliotecas para o Octave - instalado

pkg load symbolic           % tratar as integrais simbólicas


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Integrais: Dn
%% 
%% Symbolic pkg v2.9.0
%% Python communication link active, SymPy v1.5.1.

%% Primeiro uma declaração dos simbolos
syms AH AL TH TL To n t wo;

%%%%% Determinar o termo Dn da série exponencial
%%% Integral de Fourier
%%%
%%% Dn = 1/To int(-tau/2 --> tau/2) Nivel Alto * e^(-j n wo t) dt + 
%%
%%% + 1/To int(tau/2 --> tau/2+TL) Nivel Baixo * e^(-j n wo t) dt

%% declaração de Dn com simbolos já declarados
Dn = (int(AH*exp(-j*n*wo*t),t,-TH/2,TH/2) + int(AL*exp(-j*n*wo*t),t,TH/2,TH/2+TL))/To;

%%% O valor médio ==> n = 0 ==> D0 = valor médio
%% valor médio também com simbolos
ValorMedio = (int(AH*exp(0),t,-TH/2,TH/2) + int(AL*exp(0),t,TH/2,TH/2+TL))/To;

%%% Resposta: Obtida com os simbolos criados la em cima

%% ValorMedio = (sym)
%%
%%          AL⋅TH      ⎛TH     ⎞
%%  AH⋅TH - ───── + AL⋅⎜── + TL⎟
%%            2        ⎝2      ⎠
%%  ────────────────────────────
%%               To

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Sinal de referência p(t)
%% 
%% Análise de um sinal p(t):
%% 
%% To = 10s - TH = 0.5s - AH = 1 - AL = 0
%%
%% sinal gerado para depois usarmos na nossa aplicação
%% g(t) = p(t-2)[tau=4] + p(t-2)[tau=2]
%% (t-2)  -- deslocamento do pulso
%% tau    -- comprimento da onda

%% Aqui começamos a declarar os valores dos simbolos adotados
%% Isso é um boa prática para modularizar o código

To = 10;                          % período do sinal
TH = 0.5;                         % tempo de nível alto do sinal
TL = To - TH;                     % tempo de nível baixo do sinal
AH = 1.0;                         % nível alto do sinal
AL = 0.0;                         % nível baixo do sinal

%%%%% Determinar parâmetros

fo = 1/To;          % frequência do sinal
wo = 2*pi*fo;       % frequência angular do sinal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - Substituição dos valores numéricos
%% 
%% calculando n para finalizar todos os parametros necessários para subst em Dn

N           = 100;                % número de harmônicos
n           = [-N:1:N];           % cria o vetor n
frequencia  = n*fo;               % frequências de Fourier

% subsituição dos valores numéricos -- utiliza eval e armazena em uma variavel dif
%% isso é bom para ter as duas representações e não perder o valor simbolico

DnNum = eval(Dn);                              

%%% sin(x)/x ==> x = 0 ==> 0/0 ! ==> NaN
%%
%%% Identifiquei NaN quando n = 0 ==> D0 ==> valor médio
%%
%%% Preciso calcular o valor médio para poder continuar...
ValorMedioNum = eval(ValorMedio);           % subsituição dos valores numéricos

%%% Substituindo o NaN -- corrige o erro observado na posição 11
DnNum(N+1) = ValorMedioNum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Síntese
%% 
%%  p(t) =sum_{n = -N --> N} [ Dn e^(j n wo tempo) ]
%%

M      = 1000;                          % resolução temporal
tempo  = linspace(-To,To,M);            % vetor tempo
pt     = ValorMedioNum;                 % inicio a variável com o valor médio

for k = 1 : 2*N+1
  
  pt = pt + DnNum(k)*exp(j*n(k)*wo*tempo);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 - Visualizando
%% 
%%  analisar o sinal sintetizado
%%


figure(1)

stem(frequencia,DnNum,'linewidth', 3)   % plot(x,y,azul com linha cheia)
xlabel('Frequência em Hz')              % eixo x
ylabel('Amplitude em volts')            % eixo y
title('Análise de Fourier')             % título
grid

figure(2)

plot(tempo,pt,'b-','linewidth', 3)      % plot(x,y,azul com linha cheia)
xlabel('Tempo em segundos')             % eixo x
ylabel('Amplitude em volts')            % eixo y
title('Sintese de Fourier')             % título
grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7 - Sintetizar pulsos deslocados e com larguras diferentes
%% 
%% Análise de um sinal p(t):
%% 
%% To = 10s [ja definido] - TH = 0.5s - AH = 1 - AL = 0


%% Para o pulso P1 que forma a ond
TH = 4;                 % tempo de nível alto do sinal
TL = To - TH;           % tempo de nível baixo do sinal
AH = 1.0;               % nível alto do sinal
AL = 0.0;               % nível baixo do sinal


%% fazendo novamente a substituição, agr com os valores adotados nas linhas de cima
P1w           = eval(Dn);   
ValorMedioNum = eval(ValorMedio);       % subsituição dos novos valores numéricos para o valor médio
P1w(N+1)      = ValorMedioNum;          % colocando valor medio no valor do meio (NaN)


%% Para o pulso P2 que forma a onda
TH = 2;                                 % tempo de nível alto do sinal
TL = To - TH;                           % tempo de nível baixo do sinal
AH = 1.0;                               % nível alto do sinal
AL = 0.0;                               % nível baixo do sinal


%% fazendo novamente a substituição, agr com os valores adotados nas linhas de cima
P2w           = eval(Dn);   
ValorMedioNum = eval(ValorMedio);       % subsituição dos novos valores numéricos para o valor médio
P2w(N+1)      = ValorMedioNum;          % colocando valor medio no valor do meio (NaN)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8 - Síntese
%% 
%%  g(t) --> composto por 2 pulsos deslocados
%%  g(t) = P1w e^(-2*j*w) + P2w e^(-2*j*w)
%%

M             = 1000;                     % resolução temporal
tempo         = linspace(-To,To,M);       % vetor tempo
gt            = 0;                        % valor médio inicial
deslocamento  = 2;                        % deslocamento temporal

for k = 1 : 2*N+1
  
  gt = gt + P1w(k)*exp(j*n(k)*wo*tempo)*exp(-j*n(k)*wo*deslocamento) + P2w(k)*exp(j*n(k)*wo*tempo)*exp(-j*n(k)*wo*deslocamento);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9 - Visualizando
%% 
%%  Analise do sinal gerado na parte 1 da atv 4 -- Analisando P1, P2 e g(t) gerados
%%


figure(3)

stem(frequencia,P1w,'linewidth', 3)                     % plot(x,y,azul com linha cheia)
xlabel('Frequência em Hz')                              % eixo x
ylabel('Amplitude em volts')                            % eixo y
title('Análise de Fourier - P1')                        % título
grid

figure(4)

stem(frequencia,P2w,'linewidth', 3)                     % plot(x,y,azul com linha cheia)
xlabel('Frequência em Hz')                              % eixo x
ylabel('Amplitude em volts')                            % eixo y
title('Análise de Fourier - P2')                        % título
grid


figure(5)

plot(tempo,gt,'b-','linewidth', 3)                      % plot(x,y,azul com linha cheia)
xlabel('Tempo em segundos')                             % eixo x
ylabel('Amplitude em volts')                            % eixo y
title('Sintese de Fourier - g(t)')                      % título
grid

%% Visualização completa e coerente com oq foi pedido na primeira parte



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Esboçando a parte 2 da atividade
%%
%% é pedido para esboçar a p(t), a partir do que foi dado, com o valor da fase também
%% como ja tinhamos um pulso, lá na primeira parte do ex, decidi utiliza-lo e pelo menos 
%% entender como seria a visualização dessa fase no gráfico - visto que ja temos p(t) e P(W)
%% Tentei pesquisar e achei a questão módulo, para sair no gráfico
%% Porém a fase não consegui chegar em algo coerente - comentei no ultimo bloco 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 10 - Integrais: Dn -- Recolocando os valores, pois foram mudados nas seções anteriores
%% Os topicos 10, 11, 12, 13 e 14 são iguais as 2, 3, 4, 5 e 6
%% com alterações leves para inserção de valores para extrair a fase
%%
%% Symbolic pkg v2.9.0
%% Python communication link active, SymPy v1.5.1.

%% Primeiro uma declaração dos simbolos
syms AH AL TH TL To n t wo;

%%%%% Determinar o termo Dn da série exponencial
%%% Integral de Fourier
%%%
%%% Dn = 1/To int(-tau/2 --> tau/2) Nivel Alto * e^(-j n wo t) dt + 
%%
%%% + 1/To int(tau/2 --> tau/2+TL) Nivel Baixo * e^(-j n wo t) dt

%% declaração de Dn com simbolos já declarados
Dn = (int(AH*exp(-j*n*wo*t),t,-TH/2,TH/2) + int(AL*exp(-j*n*wo*t),t,TH/2,TH/2+TL))/To;

%%% O valor médio ==> n = 0 ==> D0 = valor médio
%% valor médio também com simbolos
ValorMedio = (int(AH*exp(0),t,-TH/2,TH/2) + int(AL*exp(0),t,TH/2,TH/2+TL))/To;

%%% Resposta: Obtida com os simbolos criados la em cima

%% ValorMedio = (sym)
%%
%%          AL⋅TH      ⎛TH     ⎞
%%  AH⋅TH - ───── + AL⋅⎜── + TL⎟
%%            2        ⎝2      ⎠
%%  ────────────────────────────
%%               To

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 11 - Sinal de referência p(t)
%% 
%% Análise de um sinal p(t):
%% 
%% To = 10s - TH = 0.5s - AH = 1 - AL = 0
%%
%% sinal gerado para depois usarmos na nossa aplicação
%% g(t) = p(t-2)[tau=4] + p(t-2)[tau=2]
%% (t-2)  -- deslocamento do pulso
%% tau    -- comprimento da onda

%% Aqui começamos a declarar os valores dos simbolos adotados
%% Isso é um boa prática para modularizar o código

To = 10;                          % período do sinal
TH = 0.5;                         % tempo de nível alto do sinal
TL = To - TH;                     % tempo de nível baixo do sinal
AH = 1.0;                         % nível alto do sinal
AL = 0.0;                         % nível baixo do sinal

%%%%% Determinar parâmetros

fo = 1/To;          % frequência do sinal
wo = 2*pi*fo;       % frequência angular do sinal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 12 - Substituição dos valores numéricos
%% 
%% calculando n para finalizar todos os parametros necessários para subst em Dn

N           = 100;                % número de harmônicos
n           = [-N:1:N];           % cria o vetor n
frequencia  = n*fo;               % frequências de Fourier

% subsituição dos valores numéricos -- utiliza eval e armazena em uma variavel dif
%% isso é bom para ter as duas representações e não perder o valor simbolico

DnNum = eval(Dn);                              

%%% sin(x)/x ==> x = 0 ==> 0/0 ! ==> NaN
%%
%%% Identifiquei NaN quando n = 0 ==> D0 ==> valor médio
%%
%%% Preciso calcular o valor médio para poder continuar...
ValorMedioNum = eval(ValorMedio);           % subsituição dos valores numéricos

%%% Substituindo o NaN -- corrige o erro observado na posição 11
DnNum(N+1) = ValorMedioNum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 13 - Síntese
%% 
%%  p(t) =sum_{n = -N --> N} [ Dn e^(j n wo tempo) ]
%%

M      = 1000;                          % resolução temporal
tempo  = linspace(-To,To,M);            % vetor tempo
pt     = ValorMedioNum;                 % inicio a variável com o valor médio

for k = 1 : 2*N+1
  
  pt = pt + DnNum(k)*exp(j*n(k)*wo*tempo);
  
end


%% achei isso quando pesquisei, ele zera os valores pequenos, ai conseguimos ter
%% a forma de onda do módulo

zera_peq =  find(abs(DnNum)<1e-4);
DnNum(zera_peq) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 14 - Visualizando
%% 
%%  analisar o sinal sintetizado
%%

%% figura da mudança

figure(6)

stem(frequencia, abs(DnNum),'linewidth', 3)       % plot(x,y,azul com linha cheia)
xlabel('Frequência em Hz')                        % eixo x
ylabel('Amplitude em volts')                      % eixo y
title('P(w) - modulo')                            % título
grid


% Figura do para angulo de Dn -- não deu certo :(
% figure(7)

% stem(frequencia, angle(DnNum)*(180/pi),'k-')      % plot(x,y,azul com linha cheia)
% xlabel('Frequência em Hz')                        % eixo x
% ylabel('Amplitude em volts')                      % eixo y
% title('Fase da transformada ')                    % título
% grid
