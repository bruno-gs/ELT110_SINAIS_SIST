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

%% FFT / IFFT - (Inverse) Fast Fourier Transform

## -- fft (X)
## -- fft (X, N)
## -- fft (X, N, DIM)
##     Compute the discrete Fourier transform of X using a Fast Fourier
##     Transform (FFT) algorithm.
##
##     The FFT is calculated along the first non-singleton dimension of
##     the array.  Thus if X is a matrix, 'fft (X)' computes the FFT for
##     each column of X.
##
##     If called with two arguments, N is expected to be an integer
##     specifying the number of elements of X to use, or an empty matrix
##     to specify that its value should be ignored.  If N is larger than
##     the dimension along which the FFT is calculated, then X is resized
##     and padded with zeros.  Otherwise, if N is smaller than the
##     dimension along which the FFT is calculated, then X is truncated.
##
##     If called with three arguments, DIM is an integer specifying the
##     dimension of the matrix along which the FFT is performed.

%%% Determinar a transformada discreta de Fourier

Gw = fft(gk);

%%% Para mostrar o espectro bilateral -fs/2 (-pi) <--> fs/2 (+pi)
%%
%%% O comando fftshift desloca de 0Hz (0) --> fs (2pi)

%%% Criar o eixo frequência

Np   = length(gk);
ws   = 2*pi*fs;
w    = linspace(-ws/2,+ws/2, Np);
freq = w/(2*pi);

%%% Determina o módulo

Gw_m = fftshift(abs(Gw));

%%% Determina a fase

Gw_f = fftshift(angle(Gw))*180/pi;

%%% Visualizando os resultados

subplot(2,1,1)
plot(freq,Gw_m);
title('Resposta em frequencia')
xlabel('Frequencia em Hz');
ylabel('Magnitude');

%%% Zoom em uma região de interesse

axis ([-5000 +5000])

%%% Ajuste do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);
 

subplot(2,1,2)
plot(freq,Gw_f);
title('Resposta em frequencia')
xlabel('Frequencia em Hz');
ylabel('Fase em graus');

%%% Zoom em uma região de interesse

axis ([-5000 +5000])

%%% Ajuste do gráfico

set(findall(gcf,'Type','line'),'LineWidth',3);
set(gca,'FontSize',14,'LineWidth',2);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Perguntas
%%

%% Qual a Taxa de amostragem limite?

%% Qual a faixa da frequencia que contém 95% da energia

%% Como reduzir o número de amostras do sinal

%%%% [y,h] = resample(gk,1 , 10) -- reduz as amostras

%% reduzindo em 10x a amostragem

Fr = 10;

%% NOva amostragem

fs = fs/Fr;

[Y,H] = resample(gk,1 , Fr);

Nf = 2 ;

Fourier_Grafico (gk, fs, Nf)
 
 
 
 
 