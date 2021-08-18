%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AULA 2
%% Analogia de vetores e sinais
%%
%% AUTOR: Fritz
%% DATA: 18/08/2021
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Boas práticas
%% LIMPEZA
display('Executando Boas Práticas...');
clear all;              % Limpa todas as variáveis
close all;              % fecha todas as figuras
clc;                    % limpa a tela
display('Boas Práticas executadas!!');

% Carregar bibliotecas
pkg load symbolic; %Biblioteca simbólica

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Descrever a onda quadrada - g(t)
%%

Ap      = +1;        % define o nivel positivo para onda quadrada
An      = -1;        % define o nivel negativo para onda quadrada

to      = -pi/2;        % Ponto inicial de g(t)
Tp      =  pi;           %tempo positivo g(t)
Tn      =  pi;           %tempo negativo g(t)

%% Valores calculados

T       = Tp + Tn;      %periodo de g(t)
W       = 2*pi/T;       % frequencia angular
f       = 1/T;          % frequencia em hertz

%% Definindo valores de n
N = 10; %% N de sinais que desejamos decompor
n = [1:1,N]; % vlaores de n para os sinais de ref

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Determinando C1
%%
%% c1 = Nc/Dc
%%
%% Nc = int_T g(t) cos(t) det
%% Dc = int_T cos²(t) dt

syms n t          % informando ao Octave que a variavel 't' é simbólica e não numerica

%% Calculando numerador (Função, extremo inf, extremo exterior, variavel de integração)

Nc = int(Ap*cos(n*t), to, to+Tp,t) + int(An*cos(n * t),t,to+Tp,to+T);

%% Calculando denominador (Função, extremo inf, extremo exterior, variavel de integração)

Dc = int(cos^2(n * t), to, to+Tp,t);

%% Definindo valores de n
N = 10;             %% N de sinais que desejamos decompor
n = [1:1,N];        % valores de n para os sinais de ref -- vetor sequencial
freq = n*f;         % vetor frequencia
%% calculo cn numerico

cn = eval(Nc/Dc)

stem(freq, cn);
title('Espectro de amplitude')
ylabel('Amplitude')
xlabel('Frequencia em Hz')

% Analisado que com aumento da frequencia há uma diminuição na amplitude
% Ou seja, erro tendendo a 0


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - sintese
%%
M       = 1000 ; %numeor de pontos em um periodo
tempo = linspace(0,T,M); %vetor tempo
aux = 0; % valor inicial da somatoria
for n = 1:N

    %%% somatoria

    aux = aux + cn(n*cos(n*tempo));
end

gt_sintetizado = aux; %sinal sintetizado

figure(1)

plot(tempo, gt_sintetizado);
title('Sinal sintetizado')
ylabel('Amplitude')
xlabel('Tempo em segundos')
