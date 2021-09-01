%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparação do código 
%%
%% Limpeza
%% Comentários

%% Boas práticas

clear all;
clc;
close all;
pkg load symbolic; 

%%%%% Bibliotecas para o Octave - instalado

pkg load symbolic   % tratar as integrais simbólicas


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Integrais:  Dn
%% 
%% Symbolic pkg v2.9.0
%% Python communication link active, SymPy v1.5.1.

syms AH AL TH TL To wo n t;

%%%%% Determinação do Dn

Dn = (int(AH*exp(-j*n*wo*t),t,-TH/2,TH/2) + int(AL*exp(-j*n*wo*t),t,TH/2,TH/2+TL))/To;

%% sin(x)/x --> 0/0 --> NaN
valormedio = (1/To)*int(AH,t, -TH/2,TH/2) + (1/To)*int(AL,t,TH/2,TH/2+TL);

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
TL = To - TH;           % tempo de nível baixo do sinal
AH = 1.0;           % nível alto do sinal
AL = 0.0;           % nível baixo do sinal

fo = 1/To;          % frequência do sinal
wo = 2*pi*fo;       % frequência angular do sinal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - Substituição dos valores numéricos
%% 

%% n  = [1 2 3 4 5];   % definindo os valores de n "força bruta".

N           = 10;                % número de harmônicos
n           = [-N:1:N];           % cria o vetor n
frequencia  = n*fo;              % frequências de Fourier -


DnNum               = eval(Dn);                      % Substituição dos valores numericos
valormedioNum       = eval(valormedio);

DnNum(N+1)          = valormedioNum;                 % correção do valor medio retirando o NaN -- está quando N é 11

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Síntese
%% 
%%  p0(t) = sum_{n = -N --> N} 

M      = 1000;               % resolução temporal
tempo  = linspace(-To,To,M); % vetor tempo
pt     = valormedioNum;                 % inicio a variável com o valor médio

for k = 1 : 2*N+1
  
  pt = pt + DnNum(k)*exp(j*n(k)*wo*tempo);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 - Visualizando
%% 
%%  analisar o sinal sintetizado
%%


figure(1)

stem(frequencia,DnNum,'linewidth', 3)  % plot(x,y,azul com linha cheia)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Sinal de referência p(t)
%% 
%% Análise de um sinal p(t):
%% 
%% To = 1s - TH = 0.5s - AH = 1 - AL = 0

To = 1;             % período do sinal
TH = 4;           % tempo de nível alto do sinal
TL = To - TH;           % tempo de nível baixo do sinal
AH = 1.0;           % nível alto do sinal
AL = 0.0;           % nível baixo do sinal

P1w = eval(Dn)
valormedioNum = eval(valormedio)
P1w(N+1) =  valormedioNum