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
pkg load control;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Entrada de dados
%%
%%  Leitura dos dados
%%  Extrai as informações

display('Entrada de dados...');
info = audioinfo ('Gaita_Blues.wav');     %Informações do arquivo de audio
[xt,fs] = audioread('Gaita_Blues.wav');   %Lendo o arquivo de aúdio
    
    % gk -> valores do sinal de aúdio
    % fs -> taxa de amostragem em Hz
    % info -> informações do arquivo
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - definindo o sistema
%%
%%

%%% definindo SYS
N = 1;
D = [1 1];

SYS = tf(N,D);

%% entrada
U = xt;

%% vetor tempo
%%%%% tempo entre as amostras
T         = 1/fs;
Namostras = length(xt);
Tfinal    = (Namostras -1)*T;

tempo = [0:T:Tfinal];

%%% aplicando U no sistema SYS
[Y, T, X] = lsim (SYS, U, T)
    
%% Cria a figura
figure(1)

%% Cria o gráfico de gk em função do tempo
subplot(2,1,1);plot(tempo,xt, 'linewidth',2);
subplot(2,1,2);plot(tempo,Y, 'linewidth',2);

%%Identifica os eixos
xlabel('Tempo em segundos')
ylabel('Ampliturde Normalizada')
title('Série temporal de uma gaita blues')