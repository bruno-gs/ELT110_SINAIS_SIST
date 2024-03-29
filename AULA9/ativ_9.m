%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 0 - Boas práticas

clc;
clear all;
close all;

%%% carregando o pacote de controle e sinais

pkg load control;
pkg load signal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Sinal: calibração e sinal real
%%
%% trabalhar com um sinal amostrado
%% 
%% trabalhar com um sinal real - gaita - hamônica

 [gk,fs] = audioread ('gaita.wav');
 
%% O arquivo foi criado com fs = 44.100 Hz
%% f_max (Gaita) = 44.100Hz/2 = 22.050Hz (áudio)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Sinal: estudo do espectro de energia do sinal
%%

%%% Mostra o Fourier completo

% Fourier_Grafico (gk, fs, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Perguntas
%%

%%% Qual a taxa de amostragem limite? +/- 2kHz
%%
%%% Qual a faixa de frequência que contém 95% da energia? exercício
%%
%%% Como reduzir o número de amostras do sinal?
%%  [y, h] = resample (x, p, q)

%%% Reduzindo a amostragem em 10 vezes

Fr = 10;

%%% Nova amostragem

fs = fs/Fr;

[Y, H] = resample (gk, 1, Fr);

Nf =2;

%%% Mostra o Fourier reduzido

% Fourier_Grafico (Y, fs, Nf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Filtro digital e analógico
%%

%%% Filtro analógico

N  = 2*pi;
D  = [1 2*pi];

Gs = tf(N,D);

figure(3)

impulse(Gs) 

%%% Ajuste do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%% Taxa veio da hipótese da teoria

T  = 0.05;

%%% Filtro digital

Nz  = 2*pi;
Dz  = [1 -exp(roots(D)*T)];

Gz = tf(Nz,Dz,T);

Npontos = 0.8/T;

figure(4)

%%% Resposta impulsiva do sistema no domínio discreto

impz(Nz,Dz,Npontos,1/T); 

hold; % cria uma persistência para sobrepor os gráficos

%%% Resposta impulsiva do sistema no domínio continuo

impulse(Gs) 


%%% Ajuste do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Perguntas
%%
%%% Projetar um RC digital com fcorte = 500Hz
%%
%%% Aplicar o filtro digital no som da gaita amostrado com a taxa máxima
%%

fc = 500;
wc = 2*pi*fc;

Nfpb = wc;
Dfpb = [1 wc];

%%% Determina o polo do filtro passa baixas.

Polo_s = roots(Dfpb);

FPB = tf(Nfpb,Dfpb);

%%% Mapeando em Z

T      = 1/fs;

Polo_z = exp(Polo_s*T)

Nzfpb = wc;
Dzfpb = [1 -Polo_z];

FPBz  = tf(Nzfpb,Dzfpb,T);

Npontos = 0.002/T;

figure(5)

%%% Resposta impulsiva do sistema no domínio continuo

impulse(FPB);

hold; % cria uma persistência para sobrepor os gráficos

%%% Resposta impulsiva do sistema no domínio discreto

impz(Nzfpb,Dzfpb,ceil(Npontos),fs); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ATIVIDADE
%%
%%% Aplicar o comando filter 
%%          -- filtrar a gaita com esse z de cima
%% pensar em formas formas de comparar 

%% https://www.mathworks.com/help/matlab/ref/filter.html
%% comando filter segundo o site
%% y = filter(b,a,x) filters the input data x using a rational transfer function defined by the 
                                        %% numerator and denominator coefficients b and a.

%% b = Nzfpb
%% a = Dzfpb
%% Y = x            %% entrada da gaita


y = filter(Nzfpb, Dzfpb, Y);

Np   = length(Y);
ws   = 2*pi*fs;
w    = linspace(-ws/2,+ws/2, Np);
freq = w/(2*pi);

%%% Visualizando os resultados

figure(4)

subplot(2,1,1)
plot(freq,Y)
title('Gaita')
xlabel('Frequencia em Hz');
ylabel('Magnitude');

subplot(2,1,2)
plot(freq,y)
title('Gaita filtrada')
xlabel('Frequencia em Hz');
ylabel('Magnitude');

%%%%%%%%%%%%%%%
%% Outra tentativa -- plote em conjunto e analisar alguma diferenca
%% plot(freq,Y);
%% hold on
%% plot(freq,y)
%% title('Gaita e Gaita filtrada')
%% xlabel('Frequencia em Hz');
%% ylabel('Magnitude');