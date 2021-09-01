%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparação do código 
%% 
%% Boas práticas: limpeza de variáveis; variáveis globais
%% Constantes; carregar bibliotecas;...
%%

clear all;          % limpa as variáveis
close all;          % fecha todas as figuras ativas
clc;                % limpa a tela visível

%%%%% Bibliotecas para o Octave - instalado

pkg load symbolic   % tratar as integrais simbólicas

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Sinais 
%% 
%% Análise de um sinal g(t):
%% 
%% To = 1s - TH = 0.5s - AH = 1 - AL = 0

To = 1;             % período do sinal
TH = 0.5;           % tempo de nível alto do sinal
TL = 0.5;           % tempo de nível baixo do sinal
AH = 1.0;           % nível alto do sinal
AL = 0.0;           % nível baixo do sinal

%%%%% Determinar parâmetros

fo = 1/To;          % frequência do sinal
wo = 2*pi*fo;       % frequência angular do sinal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Integrais: cn, an, bn, ao, Dn
%% 
%% Symbolic pkg v2.9.0
%% Python communication link active, SymPy v1.5.1.

syms n t;

%%%%% Determinar o cn para a família dos cossenos

Num = int(AH*cos(n*wo*t),t,-TH/2,TH/2) + int(AL*cos(n*wo*t),t,TH/2,TH/2+TL);
Den = int(cos(n*wo*t)*cos(n*wo*t),t,0,To);

an  = Num/Den

%%%%% Determinar o cn para a família dos senos

Num = int(AH*sin(n*wo*t),t,-TH/2,TH/2) + int(AL*sin(n*wo*t),t,TH/2,TH/2+TL);
Den = int(sin(n*wo*t)*sin(n*wo*t),t,0,To);

bn  = Num/Den  

%%%%% Determinar o valor médio

ao  = int(AH,t,-TH/2,TH/2)/To + int(AL,t,TH/2,TH/2+TL)/To

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - Substituição dos valores de n
%% 

%% n  = [1 2 3 4 5];   % definindo os valores de n "força bruta".

N           = 10;                % número de harmônicos
n           = [1:1:N];           % cria o vetor n
frequencia  = n*fo;              % frequências de Fourier -

%%%%%
%%%%% múltiplas inteiras da frequência fundamental

%%%%% Valores de "n" e resultados numéricos

ao = eval(ao);      % determina o valor numérico da variável
an = eval(an);      % substituindo os valores de n
bn = eval(bn);      % substituindo os valores de n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Síntese
%% 
%%  g(t) = ao + sum_{n=1}^N [ an cos(nwot) + bn sin (nwot) ]
%%

M      = 1000;               % resolução temporal
tempo  = linspace(-To,To,M); % vetor tempo
gt     = ao;                 % inicio a variável com o valor médio

for k = 1 : N
  
  gt = gt + an(k)*cos(k*wo*tempo);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 - Visualizando
%% 
%%  analisar o sinal sintetizado
%%


figure(1)

stem(frequencia,an,'linewidth', 3)  % plot(x,y,azul com linha cheia)                               % memória
xlabel('Frequência em Hz')          % eixo x
ylabel('Amplitude em volts')        % eixo y
title('Análise de Fourier')         % título
grid

figure(2)

plot(tempo,gt,'b-','linewidth', 3)  % plot(x,y,azul com linha cheia)
xlabel('Tempo em segundos')         % eixo x
ylabel('Amplitude em volts')        % eixo y
title('Sintese de Fourier')         % título
grid
