%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0 - Projeto de filtro média móvel
%% 
%%  
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

%%% Constantes

N   = 10;

%%% Equação temporal da média móvel

Hk = @(xk,xka,xk2a) (xk+xka+xk2a)/3;

%%% Equação em frequência da média móvel --> Z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Para 7 dias
Nz7 = [1 1 1 1 1 1 1]*(1/7);
Dz7 = [1 0 0 0 0 0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Para 15 dias

Nz15 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]*(1/15);
Dz15 = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];


% Polos e zeros
% Para 7 dias
zz7 = roots(Nz7);       % zeros
pz7 = roots(Dz7);       % pólos

disp ("PARA 7 DIAS")
disp ("Valor dos zeros: "), disp (zz7)
disp ("Valor dos pólos: "), disp (pz7)

% Para 15 dias
zz15 = roots(Nz15);       % zeros
pz15 = roots(Dz15);       % pólos

disp ("PARA 15 DIAS")
disp ("Valor dos zeros: "), disp (zz15)
disp ("Valor dos pólos: "), disp (pz15)



%%% Resposta impulsiva do filtro

figure(1)

impz(Nz7,Dz7,N); 
hold on
impz(Nz15,Dz15,N);

grid

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%% Conclusão: o filtro tem resposta impulsiva finita ! FIR

%%% Resposta em frequência do filtro

figure(2)

freqz(Nz7,Dz7)
hold on
freqz(Nz15,Dz15);

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%% Resposta em polos e zeros

FPB7 = tf(Nz7,Dz7,1);

figure(3)

pzmap(FPB7); 

FPB15 = tf(Nz15,Dz15,1);

figure(4)

pzmap(FPB15); 

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%% Está correto !!!

%%% Determinação do ganho em função da frequência

Hw = @(w,T) (1/3).*exp(-j*w*T).*(1+2*cos(w*T));

%%% Supondo uma taxa de amostragemd e 1Hz => T = 1s

T    = 1;             % taxa de amostragem
fs   = 1/T;           % frequência de amostragem
fmax = fs/2;          % frequência máxima
f    = [0:0.01:fmax];    % faixa de frequência de análise
w    = 2*pi*f;        % frequência angular

Ganho_FPB = Hw(w,T);  % ganho do filtro na faixa de investigação

%%% Visualizar o gráfico

figure(4)

subplot(2,1,1)
plot(w,20*log10(abs(Ganho_FPB)));
xlabel('Frequencia');
ylabel('Magnitude');
title('Modulo do ganho do filtro');
grid;

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


subplot(2,1,2)
plot(w,angle(Ganho_FPB)*180/pi);
xlabel('Frequencia');
ylabel('Magnitude');
title('Fase do ganho do filtro');
grid;

%%% Aprimora a aparência do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

[gk, fs] = audioread ('Gaita_Blues.wav');




