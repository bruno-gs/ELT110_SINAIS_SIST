%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0 - Projeto de filtro e sintese de voz
%% 
%% a. projetar um filtro digital 
%%
%%
%%  20 de Outubro de 2021
%%
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

%%% Pacote de controle

pkg load control         %%% Polos e zeros 
pkg load signal          %%% --> Bilinear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Tempo contínuo 
%% 

N = 1;            % Numerador
D = [1 1];        % Denominador

%%% Filtro passa baixas contínuo

FPBc = tf(N,D);

%%% Criar uma senoide artificial com To = 5 segundos

To    = 0.5;              % período da senóide
omega = 2*pi/To;          % frequência angular
Np    = 1e5;              % número de pontos do gráfico
tempo = linspace(0,5,Np); % vetor de tempo
x     = sin(omega*tempo); % senóide

%%% Filtrando o sinal x(t)

x_f = lsim(FPBc,x,tempo);

%%% Visualização

subplot(1,3,1);
impulse(FPBc);

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

subplot(1,3,2);
step(FPBc);

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

subplot(1,3,3);
plot(tempo,x_f);

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Tempo discreto 
%% 
% Ap1 --> y = (1-T)*ya + T*xa
% Ap2 --> y = (1/(1+T))*ya + (T/(1+T))*x
% Ap3 --> y = -((1-2/T)/(1+2/T))*ya + (1/(1+2/T))*xa + (1/(1+2/T))*x

%%% Escolha da taxa de amostragem

Fs = 100;   % A senoide tem 2Hz, devendo ser amostrada com 4Hz (min)
T  = 1/Fs;  % Taxa de amostragem

%%% Criar o impulso

xi    = [1 zeros(1,Np-1)];

%%% Criar o degrau

xd    = ones(1,Np);

%%% Criar a senoide

td    = linspace(0,5,5/T);
xs    = sin(omega*td);

%%% Implementando a primeira aproximação

% Ap1 --> y = (1-T)*ya + T*xa
% Ap2 --> y = (1/(1+T))*ya + (T/(1+T))*x
% Ap3 --> y = -((1-2/T)/(1+2/T))*ya + (1/(1+2/T))*xa + (1/(1+2/T))*x

[yd, time, X0] = step(FPBc,tempo);
[yi, time, X0] = impulse(FPBc,tempo);

%%% Valores iniciais das variáveis

y1a  = 0;
yi1a = 0;
yd1a = 0;
y2a  = 0;
yi2a  = 0;
yd2a  = 0;
y3a  = 0;
yi3a  = 0;
yd3a  = 0;
x1a  = 0;
xi1a  = 0;
xd1a  = 0;
x2a  = 0; 
xi2a  = 0; 
xd2a  = 0;

for k = 1:length(td)
  
  y1(k) = (1-T)*y1a + T*x1a;
  yi1(k) = (1-T)*yi1a + T*xi1a;
  yd1(k) = (1-T)*yd1a + T*xd1a;
  y2(k) = (1/(1+T))*y2a + (T/(1+T))*xs(k);
  yi2(k) = (1/(1+T))*yi2a + (T/(1+T))*xi(k);
  yd2(k) = (1/(1+T))*yd2a + (T/(1+T))*xd(k);
  y3(k) = -((1-2/T)/(1+2/T))*y3a + (1/(1+2/T))*x2a + (1/(1+2/T))*xs(k);
  yi3(k) = -((1-2/T)/(1+2/T))*yi3a + (1/(1+2/T))*xi2a + (1/(1+2/T))*xi(k);
  yd3(k) = -((1-2/T)/(1+2/T))*yd3a + (1/(1+2/T))*xd2a + (1/(1+2/T))*xd(k);
  
  %%% Atualizar o valores
  
  y1a   = y1(k);
  yi1a  = yi1(k);
  yd1a  = yd1(k);
  y2a   = y2(k);
  yi2a  = yi2(k);
  yd2a  = yd2(k);
  y3a   = y3(k);
  yi3a  = yi3(k);
  yd3a  = yd3(k);
  x1a   = xs(k);
  xi1a  = xi(k);
  xd1a  = xd(k);
  x2a   = xs(k);
  xi2a  = xi(k);
  xd2a  = xd(k);
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% SENOIDE

%%% Y1

figure()

plot(td,y1,'k+'); grid; hold;plot(tempo,x_f, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


%%% Y2

figure()

plot(td,y2,'k+'); grid; hold;plot(tempo,x_f, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%% Y3
figure()

plot(td,y3,'k+'); grid; hold;plot(tempo,x_f, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% IMPULSO

%%% Y1

figure()

plot(td,yi1/T,'k+'); grid; hold;plot(tempo,yi, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


%%% Y2

figure()

plot(td,yi2/T,'k+'); grid; hold;plot(tempo,yi, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%% Y3
figure()

plot(td,yi3/T,'k+'); grid; hold;plot(tempo,yi, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% DEGRAU

%%% Y1

figure()

plot(td,yd1,'k+'); grid; hold;plot(tempo,yd, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


%%% Y2

figure()

plot(td,yd2,'k+'); grid; hold;plot(tempo,yd, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%% Y3
figure()

plot(td,yd3,'k+'); grid; hold;plot(tempo,yd, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);