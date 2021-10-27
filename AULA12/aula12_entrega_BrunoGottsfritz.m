%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0 - sistema dinâmico
%% 
%%
%%
%%  27 de Outubro de 2021
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

%% numerador e denominador da aula 11
% N = 1;            % Numerador
% D = [1 1];        % Denominador

%% nova função H - Aula 12
N = 200*pi;
D = [1 0 (200*pi)^2];

%            628.3     
%  y1:  ---------------
%       s^2 + 3.948e+05

%%% Hs

Hs = tf(N,D);

%%% Criar uma senoide artificial com To = 5/100 segundos

To    = 1/100;                % período da senóide
omega = 2*pi/To;              % frequência angular
Np    = 1e5;                  % número de pontos do gráfico
tempo = linspace(0,0.1,Np);   % vetor de tempo
x     = sin(omega*tempo);     % senóide

%%% Filtrando o sinal x(t)

x_f = lsim(Hs,x,tempo);

%%% Visualização

subplot(1,1,1);
%plot();hold;
impulse(Hs,0.05);

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

% subplot(1,3,2);
% step(Hs,0.05);

% %%% Aprimora a aparência do gráfico

% set(findall(gcf,'Type','line'),'LineWidth',3);
% set(gca,'FontSize',14,'LineWidth',2);

% subplot(1,3,3);
% plot(tempo,x_f);

% %%% Aprimora a aparência do gráfico

% set(findall(gcf,'Type','line'),'LineWidth',3);
% set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Tempo discreto 
%% 
% Ap1 --> y = (1-((200*pi)^2*T))*ya + 200*pi*T*xa
% Ap2 --> y =  (1/(1+((200*pi)^2)T))*ya + (200*pi*T/(1+((200*pi)^2)T))*x
% Ap3 --> y =  (1/k1)*(-ya*k2 - y2a*k3 + x*a + 2*a*xa + a*x2a);

% Resposta impulsiva - mapeamento

%%% Escolha da taxa de amostragem

Fs = 4000;   % A senoide tem 2Hz, devendo ser amostrada com 4Hz (min)
T  = 1/Fs;  % Taxa de amostragem

%%% Criar o impulso

xi    = [1 zeros(1,Np-1)];
td    = linspace(0,5,5/T);

[yi, time, X0] = impulse(Hs,0.05);

%%% Valores iniciais das variáveis

% para aprox 1
y11a  =0;
y12a  =0;
x11a  =0;
x12a  =0;

% para aprox 2
y21a  =0;
y12a  =0;
x11a  =0;
x12a  =0;

% para aprox 3
y31a  =0;
y32a  =0;
x31a  =0;
x32a  =0;


%% calcular Constantes

% para aprox 3
a = 200*pi;
k1 = (2/T)^2+a^2;
k2 = (2*a)^2 - 2*(2/T)^2;
k3 = (2/T)^2+a^2;

for k = 1:length(td)

  % equação da aproximação 1
  y1(k) =  2*y11a - (1+a^2*T^2)*y12a + a*(T^2)*y22a;
  % equação da aproximação 2
  y2(k) = a*T^2*x22a + 2*y21a - (1 + a^2*T^2)x;
  % equação da aproximação 3
  y3(k) =  (1/k1)*(-y31a*k2 - y32a*k3 + x3*a + 2*a*x31a + a*x32a);
  

  %%% Atualizar o valores pela 1 forma
  y12a = y11a;
  y11a = y1(k);
  x12a = x11a;
  x11a = xi(k);

  %%% Atualizar o valores pela 2 forma
  y32a = y31a;
  y31a = y3(k);
  x32a = x31a;
  x31a = xi(k);

  %%% Atualizar o valores pela 3 forma
  y32a = y31a;
  y31a = y3(k);
  x32a = x31a;
  x31a = xi(k);

  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% IMPULSO

ymax1 = max(abs(y1));     % determina o valor maximo do modulo de y
y1 = y1/ymax1;             % normaliza o valor max
ymax3 = max(abs(y3));     % determina o valor maximo do modulo de y
y3 = y3/ymax3;             % normaliza o valor max


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Y1 -- 1 forma de aproximação

figure()

plot(td,y1,'k+'); grid; hold;plot(tempo,yi, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Y3 -- 3 forma de aproximação

figure()

plot(td,y3,'k+'); grid; hold;plot(tempo,yi, 'y');

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 - Analisando os resultados 
%% 

clc;
%%% AP1: FT
N1= a*T^2;
D1= [1 -2 1+a^2*T^2];

G1 = tf(N1,D1,T)

%%% AP1: FT
N2= [a*T^2 0 0];
D2= [1+a^2*T^2 -2 1];

G2 = tf(N2,D2,T)

%%% AP3: FT
N3= a*[1 2 1];
D3= [(2/T)^2+a^2 (2*a^2 - 2*(2/T)^2) (2/T)^2];

G3 = tf(N3,D3,T)

display('Polos de cada aproximação...')

p1 = roots(D1);
p2 = roots(D2);
p3 = roots(D3);

abs(p1)
abs(p2)
abs(p3)
