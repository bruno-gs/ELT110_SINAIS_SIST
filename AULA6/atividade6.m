%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparação do código 
%% 
%% Boas práticas: limpeza de variáveis; variáveis globais
%% Constantes; carregar bibliotecas;...
%%
%%% Limpeza

clc;          % limpa visual da tela de comandos
close all;    % limpa as figuras
clear all;    % limpa as variáveis

warning('off', 'all'); % omite os warnings

%%% Carregar bibliotecas

pkg load symbolic;  % biblioteca simbólica


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Problema no tempo
%%
%% aproximar uma onda quadrada por um sinal
%% harmônico - g(t) = exp(-at) --> 0 < t < 1
%% 
%% Definir a onda exponencial com expoente variável

display('1 - Configurando o sinal...')

To = 1;     % período da onda quadrada
to = 0;     % instante inicial de g(t)

%%% Parâmetros calculados

fo = 1/To;    % frequência da onda quadrada
wo = 2*pi*fo; % frequência angular de g(t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  3 - calcular o valor de Dn
%% 
%%  Ambiente de cálculo integral e simbólico
%%  
%%  Symbolic pkg v2.9.0: 
%%  Python communication link active, SymPy v1.5.1.
%%

display('2 - Determinando Dn simbolicamente...')

syms n t  % t - tempo variável simbólica

%%% Numerador de Dn

Inum    = int(exp((-5-j*n*wo)*t),t,to,To);

%%% Determinando Dn

Dn = Inum/To;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 -  Valores no domínio da frequência

display('3 - Determinando Dn numericamente...')

N    = 20;          % Número de harmônicas
n    = [-N:1:N];    % Harmônicas de Fourier
freq = n*fo;        % frequências de Fourier

Dn   = eval(Dn)     % valores numéricos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Sintetizar o sinal - retorno ao domínio do tempo
%%
%%
%%
%%  g(t)  = sum_{n=-N}^{n=N} Dn exp(j n wo t)
%%

display('4 - Sintetizando o sinal...')

gt    =  0;                   % inicia com um valor nulo
M     =  1000;                % resolução do meu sinal
tempo = linspace(-To,To,M);   % variável tempo 

for k = 1 : 2*N+1             % N valores negativos
                              % N valores positivos
                              % e o zero --> 2*N+1
                              
    gt =  gt + Dn(k)*exp(j*n(k)*wo*tempo);  % sinal original
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - definindo o sistema
%%
%%

%%% definindo SYS
N = 1;
D = [1 1];

SYS = tf(N,D);

%% entrada
U = gt;

%%% aplicando U no sistema SYS
[Y, T, X] = lsim (SYS, U, tempo)

%% Cria a figura
figure(1)

%% Cria o gráfico de gk em função do tempo
subplot(2,1,1);plot(tempo,Dn, 'linewidth',2);
subplot(2,1,2);plot(tempo,Y, 'linewidth',2);

%%Identifica os eixos
xlabel('Tempo em segundos')
ylabel('Ampliturde Normalizada')
title('Série temporal de uma gaita blues')