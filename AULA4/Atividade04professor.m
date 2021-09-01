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
%% 2 - Integrais: Dn
%% 
%% Symbolic pkg v2.9.0
%% Python communication link active, SymPy v1.5.1.

syms AH AL TH TL To n t wo;

%%%%% Determinar o termo Dn da série exponencial
%%% Integral de Fourier
%%%
%%% Dn = 1/To int(-tau/2 --> tau/2) Nivel Alto * e^(-j n wo t) dt + 
%%
%%% + 1/To int(tau/2 --> tau/2+TL) Nivel Baixo * e^(-j n wo t) dt

Dn = (int(AH*exp(-j*n*wo*t),t,-TH/2,TH/2) + int(AL*exp(-j*n*wo*t),t,TH/2,TH/2+TL))/To;

%%% O valor médio ==> n = 0 ==> D0 = valor médio

ValorMedio = (int(AH*exp(0),t,-TH/2,TH/2) + int(AL*exp(0),t,TH/2,TH/2+TL))/To;

%%% Resposta:

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
%% 4 - Substituição dos valores numéricos
%% 

%% n  = [1 2 3 4 5];   % definindo os valores de n "força bruta".

N           = 10;                % número de harmônicos
n           = [-N:1:N];           % cria o vetor n
frequencia  = n*fo;              % frequências de Fourier -

%%%%%
%%%%% múltiplas inteiras da frequência fundamental

%%%%% Valores de "n" e resultados numéricos

DnNum = eval(Dn);                               % subsituição dos valores numéricos

%%% sin(x)/x ==> x = 0 ==> 0/0 ! ==> NaN
%%
%%% Identifiquei NaN quando n = 0 ==> D0 ==> valor médio
%%
%%% Preciso calcular o valor médio para poder continuar...

ValorMedioNum = eval(ValorMedio);                % subsituição dos valores numéricos

%%% Substituindo o NaN

DnNum(N+1) = ValorMedioNum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Síntese
%% 
%%  p(t) =sum_{n = -N --> N} [ Dn e^(j n wo tempo) ]
%%

M      = 1000;               % resolução temporal
tempo  = linspace(-To,To,M); % vetor tempo
pt     = ValorMedioNum;      % inicio a variável com o valor médio

for k = 1 : 2*N+1
  
  pt = pt + DnNum(k)*exp(j*n(k)*wo*tempo);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 - Visualizando
%% 
%%  analisar o sinal sintetizado
%%


figure(1)

stem(frequencia,DnNum,'linewidth', 3)  % plot(x,y,azul com linha cheia)                               % memória
xlabel('Frequência em Hz')          % eixo x
ylabel('Amplitude em volts')        % eixo y
title('Análise de Fourier')         % título
grid

figure(2)

plot(tempo,pt,'b-','linewidth', 3)  % plot(x,y,azul com linha cheia)
xlabel('Tempo em segundos')         % eixo x
ylabel('Amplitude em volts')        % eixo y
title('Sintese de Fourier')         % título
grid

