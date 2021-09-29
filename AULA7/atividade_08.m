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

fs  = 10;             % freq de amostragem acima do min (2 * f -- min)
T   = 1/fs;           % periodo de amostragem

a   = 1;              % cte de tempo da exponencial -- como ela atenua o sinal (!!!!!) -- amortecimento

k   = [0:1:Np*fs];    % indice de cada amostra


%% MODELO MATEMATICO DA FUNÇÃO NO DOMINIO Z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - EXERCICIOS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1
%%%%    numerador  ==> z

%%%%    denominador ==> z - 1
N1   = [1 0];
D1   = [1 -1];
Y1z = tf(N1,D1,T);
%% INSTAVEL
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2
%%%%    numerador  ==> z

%%%%    denominador ==> (Z - 1)^2 -- z^2 - 2*z + 1
N2   = [0 1 0];
D2   = [1 -2 1];
Y2z = tf(N2,D2,T);
%% ESTAVEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3
%%%%    numerador  ==> 1

%%%%    denominador ==> z^2 + 1
N3   = [0 0 1];
D3   = [1 0 1];
Y3z = tf(N3,D3,T);
%% MARGINALMENTE ESTAVEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4
%%%%    numerador  ==> 1

%%%%    denominador ==> z^2 + 2z + 10
N4   = [0 0 1];
D4   = [1 2 10];
Y4z = tf(N4,D4,T);
%% ESTÁVEL 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5
%%%%    numerador  ==> 1

%%%%    denominador ==> z^2 + 4
N5   = [0 0 1];
D5   = [1 0 4];
Y5z = tf(N5,D5,T);
%% MARGINALMENTE ESTÁVEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 -- ERRO -- Grau do polinomio
%% multiplica pelo maior grau do numerador (5)
%%% para calcular o presente, teria que saber o futuro

%%%%    numerador  ==> z^5

%%%%    denominador ==> z^2 + 1
N6   = [1 0 0 0 0 0];
D6   = [1 0 0 1 0 1];
Y6z = tf(N6,D6,T);
%% MARGINALMENTE ESTÁVEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7
%%%%    numerador  ==> z^2 + 2z + 1

%%%%    denominador ==> z^2 + 1
N7   = [1 2 1];
D7   = [1 0 1];
Y7z = tf(N7,D7,T);
%% MARGINALMENTE ESTÁVEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8
%%%%    numerador  ==> 1

%%%%    denominador ==> z^2 + 2z + 1
N8   = [0 0 1];
D8   = [1 2 1];
Y8z = tf(N8,D8,T);
%% ESTÁVEL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9
%%%%    numerador  ==> 1

%%%%    denominador ==> z^2 + 1.5
N9   = [0 0 1];
D9   = [1 0 1.5];
Y9z = tf(N9,D9,T);
%% MARGINALMENTE ESTÁVEL

%% Próxima aula serão explicados como analisar os pólos e sua influencia na estabilidade
%% do sistema

figure(1)
%% sintetizador do sinal
impz(N1,D1,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

figure(2)
%% sintetizador do sinal
impz(N2,D2,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


figure(3)
%% sintetizador do sinal
impz(N3,D3,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

figure(4)
%% sintetizador do sinal
impz(N4,D4,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


figure(5)
%% sintetizador do sinal
impz(N5,D5,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

figure(6)
%% sintetizador do sinal
impz(N6,D6,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

figure(7)
%% sintetizador do sinal
impz(N7,D7,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

figure(8)
%% sintetizador do sinal
impz(N8,D8,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


figure(9)
%% sintetizador do sinal
impz(N9,D9,length(k),fs);
%%% Qualidade do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);