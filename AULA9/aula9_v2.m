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

Fourier_Grafico (gk, fs, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Perguntas
%%

%%% Qual a taxa de amostragem limite?
%%
%%% Qual a faixa de frequência que contém 95% da energia?
%%
%%% Como reduzir o número de amostras do sinal?
%%  [y, h] = resample (x, p, q)

%%% Reduzindo a amostragem em 10 vezes

Fr = 8;

%%% Nova amostragem

fs = fs/Fr;

[Y, H] = resample (gk, 1, Fr);

Nf =2;

%%% Mostra o Fourier reduzido

Fourier_Grafico (Y, fs, Nf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - FIltro digital e analógico
%%

%%% Filtro analogico
N = 2*pi;
D = [1 2*pi];
Gs = tf(N,D);

figure(3)
impulse(Gs);

%%% Ajuste do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);


%%% Filtro digital
Nz = 2*pi;
Dz = [1 -0.73];
%% taxa veio da hipótese da teoria
T = 0.05;

Gz = tf(Nz,Dz,T);

Npontos = 0.8/T;

figure(4)

impz(Nz, Dz, 1,1/T);
hold;
impulse(Gs)

%%% Ajuste do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);



%%%%%%%%%% filtro passa baixa
fc = 500;
wc = 2*pi*fc;

Nfpb = wc;
Dfpb = [1 wc];

%% polo do filtro passa baixa
Polo_s = root(Dfpb)

FPB = tf(Nfpb,Dfpb);

%% mapeando em z
T     = 1/fs;
Polo_z = exp(Polo_s*T) %% função ja retorna a raiz negativa

Nzfpb = wc;
Dzfpb = [1 -Polo_z];

FPBz = tf(Nzfpb,Dzfpb,T);

Npontos = 0.002/T;

figure(5)

impz(Nzfpb, Dzfpb, Npontos,1/T);
hold;
impulse(FPB)

%%% Ajuste do gráfico
set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);



%% aplicar o comando filter -- filtrar a gaita com esse z de cima
%% criar formas de comparar 