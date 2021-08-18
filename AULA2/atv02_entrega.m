%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AULA 2 -- Atividade 02
%% Analogia de vetores e sinais
%%
%% AUTOR: Fritz
%% DATA: 18/08/2021
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Boas práticas
%% LIMPEZA

clc;                    % limpa visual da tela de comandos
close all;              % limpa as figuras
clear all;              % limpa as variáveis

%%% Carregar bibliotecas

pkg load symbolic;      % biblioteca simbólica

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Descrevendo o tipo da onda g(t) -- exponencial 1/e^t = e⁻t
%%

Ti    = 0;              % tempo inicial de g(t)
Tf    = 1;              % tempo final de g(t)

%%% Valores calculados

T     = 1;              % período de g(t)
w     = 2*pi/T;         % frequência angular
f     = 1/T;            % frequência em Hz

%%% Definindo os valores de n

N     = 100;            % Número de sinais que desejamos decompor
n     = [1:1:N];        % valores de n para os sinais de referência

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Análise
%% 

%%% c1 = Nc/Dc
%%%
%%% Nc = int_T g(t) cos(t) dt
%%%
%%% Dc = int_T cos^2(t) dt

syms n t                % informando ao Octave que a variável 
                        % t é simbólica e não numérica

%%% Calculando o numerador

%%% integral(função, variável, extremo_i, extremo_s)

Nc = int(exp(-t)*cos(n*t),t,Ti,Tf);


%%% Calculando o denominador

Dc = int(cos(n*t)^2,t,Ti,Ti+T);

%%% Derminando valores numéricos

%%% Definindo os valores de n

N     = 100;                % Número de sinais que desejamos decompor
n     = [1:1:N];            % valores de n para os sinais de referência
freq  = n*f;                % vetor frequência

%%% Calculo cn numericamente

cn    = eval(Nc/Dc)         % transforma a expressão literal em numérica.

%%% Visualizar o resultado --> espectro de amplitudes

figure(1)

stem(freq,cn);
title('Espectro de amplitudes')
ylabel('Amplitude')
xlabel( 'Frequencia em Hz')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - Síntese
%% 

M     = 1000;               % número de pontos em um período;
tempo = linspace(0,T,M);    % vetor tempo propriamente dito
aux   = 0;                  % valor inicial da somatória

for n = 1:N
  
  %%% somatória
  
    aux = aux + cn(n)*cos(n*tempo);
end

gt_sintetizado = aux;       % sinal sintetizado


figure(2)


plot(tempo,gt_sintetizado);
hold on;
%% Função Hold para solucionar o desafio de plotar os dois sinais no mesmo gráfico
plot(tempo, exp(-tempo));
title('Sinal sintetizado')
ylabel('Amplitude')
xlabel( 'tempo em segundos')

%% Analise final
%% Plotando o sinal de e⁻t junto para analisar o comportamento
%% Não chegou ao resultado esperado e analisado na onda quadrada
%% Isso pois precisamos de mais funções ortogonais (na aula começamos a ver o seno)