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

% pacotes importantes
pkg load signal;  
pkg load control;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Função de transferencia em Z
%%
%%%%    numerador  ==> z^2 - z e^(-aT) cos (wT)

%%%%    denominador ==> z^2 - 2 z e^(-aT) cos (wT) + e^(-2aT)

%%%%    tempo     ==> y(t) = e^(-akT) cos(wkT)

%%%%%%%%%%%%% PARAMETROS

% 1 - T : Taxa de amostragem
% 2 - w : frequencia angular do sinal   --> 2 pi f = w
% 3 - a : expoente da exponencial       
% 4 - k : indice da amostra

%%% ATRIBUINDO VALORES

Np  = 10;             % numero de periodos

f   = 1;              % sinal tem freq de 1 Hz
w   = 2 * pi * f;     % freq angular 
To  = 1/f;            % periodo do sinal

fs  = 50;             % freq de amostragem acima do min (2 * f -- min)
T   = 1/fs;           % periodo de amostragem

a   = 1;              % cte de tempo da exponencial -- como ela atenua o sinal (!!!!!) -- amortecimento

k   = [0:1:Np*fs];    % indice de cada amostra

y   = @(w,T,k,a)  exp(-a*k*T).*cos(w*k*T);

%% gerar o sinal no tempo (discreto e amostrado)

yk = y(w,T,k,a)

%% VISUALIZAR RESULTADO

figure(1)

stem(k,yk); title('Sinal amostrado');
xlabel('amostra')
ylabel('valor da amostra')
grid


%% MODELO MATEMATICO DA FUNÇÃO NO DOMINIO Z

%%%%    numerador  ==> z^2 - z e^(-aT) cos (wT)

%%%%    denominador ==> z^2 - 2 z e^(-aT) cos (wT) + e^(-2aT)

N   = [1 exp(-a*T)*cos(w*T) 0];
D   = [1 -2*exp(-a*T)*cos(w*T) exp(-2*a*T)];


Yz = tf(N,D,T);

figure(2)

%% sintetizador do sinal
impz(N,D,length(k),fs);

%% Há uma compactação do número de pontos necessários de 501 a 6 
  %% diminui em 83x o tamnaho do arquiv0
  %% os 501 estão contidos nos 6
  





