%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparação do código 
%% 
%% Boas práticas: limpeza de variáveis; variáveis globais
%% Constantes; carregar bibliotecas;...
%%
%%% Limpeza
%%% Comentários

clc;          % limpa visual da tela de comandos
close all;    % limpa as figuras
clear all;    % limpa as variáveis

%%% Carregar bibliotecas

pkg load symbolic;  % biblioteca simbólica

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Descrever a exponencial - g(t) 
%% 

%%% Valores calculados

T     = 1;        % período de g(t)
w     = 2*pi/T;   % frequência angular
f     = 1/T;      % frequência em Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Análise
%% 

%%% c1 = Nc/Dc
%%%
%%% Nc = int_T g(t) cos(t) dt
%%%
%%% Dc = int_T cos^2(t) dt

syms n w t    % informando ao Octave que a variável 
              % t é simbólica e não numérica

%%% Calculando o numerador

Nc_cos = int(exp(-t).*cos(n*w*t),t,0,T);
Nc_sin = int(exp(-t).*sin(n*w*t),t,0,T);

%%% integral(função, variável, extremo_i, extremo_s)

%%% Calculando o denominador

Dc_cos = int(cos(n*w*t).^2,t,0,T);
Dc_sin = int(sin(n*w*t).^2,t,0,T);

%%% Derminando valores numéricos

%%% Definindo os valores de n

N     = 10;       % Número de sinais que desejamos decompor
n     = [1:1:N];  % valores de n para os sinais de referência
freq  = n*f;      % vetor frequência
w     = 2*pi/T;   % frequência angular

%%% Calculo cn numericamente

an    = eval(Nc_cos./Dc_cos); % Projeção em cosseno.
bn    = eval(Nc_sin./Dc_sin); % Projeção em cosseno.

ao    = eval(inv(T)*int(exp(-t),t,0,T));

%%% Visualizar o resultado --> espectro de amplitudes

figure(1)

stem(freq,an);
title('Espectro de amplitudes - cosseno')
ylabel('Amplitude')
xlabel( 'Frequencia em Hz')

%%% Modifica parâmetros do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

figure(2)

stem(freq,bn);
title('Espectro de amplitudes - seno')
ylabel('Amplitude')
xlabel( 'Frequencia em Hz')

%%% Modifica parâmetros do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - Síntese
%% 

M     = 3000;             % número de pontos em um período;
tempo = linspace(0,3*T,M);  % vetor tempo propriamente dito
aux   = ao;               % valor inicial da somatória

for n = 1:N
  
  %%% somatória
  
  aux = aux + an(n)*cos(n*w*tempo) + bn(n)*sin(n*w*tempo);
  
end

gt_sintetizado = aux;     % sinal sintetizado

figure(3)

plot(tempo,gt_sintetizado);
hold;
% plot(tempo,exp(-tempo));
title('Sinal sintetizado')
ylabel('Amplitude')
xlabel( 'tempo em segundos')

%%% Modifica parâmetros do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Serie Exponencial de Fourier
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.1 - Definir o sinal g(t) - exponencial
%% 

g = @(t) exp(-t);

%% Dn e D0 como literais
syms t n T0 w0
Dn    = inv(T0)*int(exp(-(j*n*w0+1)*t),t,0,T0);
D0    = inv(T0)*int(exp(-t),t,0,T0); 

%%% define os valores numericos
T0 = 1;

w0 = 2*pi/T0;
f0 = 1/T0;
N = 1000;     % número de pontos em um período;
n = [1:1:N];
f = n*f0;

%% calculo do valores numericos das exp literais

% %% Potencia do sinal
Pg    = eval(inv(T)*int(exp(-t).^2,t,0,T));


%% eval das funções descritas
Dn = eval(Dn);
D0 = eval(D0);
Dn(N+1) = D0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.4 - Síntese
%% 
somatoria = 0;


for k= 0:2*N
    somatoria = somatoria + Dn(k+1)*exp(j*n(k+1)*w*tempo);
end

gt = somatoria;

%%% visualizar Dn
figure(4)
plot(tempo,abs(gt));
hold;
% Assinalar os titulos
title('Sinal Dn')
ylabel('Amplitude')
xlabel( 'tempo em segundos')