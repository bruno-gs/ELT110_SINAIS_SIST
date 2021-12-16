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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Problema no tempo
%%
%% aproximar uma onda triangular por um sinal
%% harmônico - g(t) = 0.02*pi*exp(-0.02*pi*t) --> -1 < t < 1

display('1 - Configurando o sinal...')

To = 2;     % período da onda triangular
to = 0;     % instante inicial de g(t)

%%% Parâmetros calculados

fo = 1/To;    % frequência da onda triangular
wo = 2*pi*fo; % frequência angular de g(t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  3 - calcular o valor de Dn
%% 
%%  Ambiente de cálculo integral e simbólico
%%  
%%  Symbolic pkg v2.9.0: 
%%  Python communication link active, SymPy v1.5.1.
%%

display('2 - Determinando Dn simbolicamente...')

syms n t  % t - tempo variável simbólica

%%% Numerador de Dn

%Inum    = int(exp((-5-j*n*wo)*t),t,to,To);
%% onda triangular -- sinc(w/2)^2 * exp(-jw0) -- 0 é o centro da onda
Inum    = int(sin(n*wo*0.5)*exp((0)*t),t,-1,1);

%%% Determinando Dn

Dn = Inum/To;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 -  Valores no domínio da frequência

display('3 - Determinando Dn numericamente...')

N    = 20;          % Número de harmônicas
n    = [-N:1:N];    % Harmônicas de Fourier
freq = n*fo;        % frequências de Fourier

Dn   = eval(Dn);     % valores numéricos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Sintetizar o sinal - retorno ao domínio do tempo
%%
%%
%%
%%  g(t)  = sum_{n=-N}^{n=N} Dn exp(j n wo t)
%%

display('4 - Sintetizando o sinal...')

gt    =  0;                   % inicia com um valor nulo
M     =  1000;                % resolução do meu sinal
tempo = linspace(-To,To,M);   % variável tempo 

for k = 1 : 2*N+1             % N valores negativos
                              % N valores positivos
                              % e o zero --> 2*N+1
                              
    gt =  gt + Dn(k)*exp(j*n(k)*wo*tempo);  % sinal original
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  
%%
%%
%%   Criando o sinal teórico - gt_teo
%%  
%%

t      = linspace(0,To,M/2);      % vetor tempo linear

gt_teo = @(t) exp(-5*t);        % cria a função temporal gt_teo

gt_num = [gt_teo(t) gt_teo(t)]; % cria dois períodos do sinal teórico

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  
%%
%%
%%   Visualizar o sinal no domínio do tempo e da frequência
%%  
%%

figure(1)
plot(freq,Dn,'k-','linewidth',3);
xlabel('Frequência angular');
ylabel('Amplitude');
title('Fourier exponencial')
grid

figure(2)
plot(tempo,gt,'g-','linewidth',3);
hold;
plot(tempo,gt_num,'k..','linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude');
title('Fourier exponencial')
grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Definindo filtro 
%% 
%%  H(w) = wc / (wc + j*w)
%%  H(w) = 0.02*pi / (0.02*pi + j*w)
%%  portanto, wc = 0.02*pi  
%%
%%  Y(w) = H(w) * X(w)

%% Y(w) -- saida
%% H(w) -- sistema
%% X(w) -- entrada ==> Dn: conclusão 1


display ('determinando a saida do filtro')
%%%%%%%% Definir o filtro

wc = 0.02*pi;                     %% freq de corte no filtro
w = 2*pi *freq;                   %% freq de corte no filtro

Hw = @(w, wc) wc./(wc + j*w);     %% ganho do filtro 

Gfiltro = Hw(w,wc);               %% ganho do filtro nas freq desejadas

%% determinar a saida

Yw = Gfiltro.*Dn;                 %% det a saida em Fourier


%% visualização da saida na frequencia

figure(4)

subplot(3,1,1);
plot(w,abs(Dn),'linewidth', 2);
grid;
title("Entrada")


subplot(3,1,2);
plot(w,abs(Gfiltro),'linewidth', 2);grid;
title("Sistema")



subplot(3,1,3);
plot(w,abs(Yw),'linewidth', 2);
grid;
title("Saída")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  6 - Sintetizar o sinal - retorno ao domínio do tempo
%%
%%

display('6 - Sintetizando o sinal...')

yt    =  0;                   % inicia com um valor nulo
M     =  1000;                % resolução do meu sinal
tempo = linspace(-To,To,M);   % variável tempo 

for k = 1 : 2*N+1             % N valores negativos
                              % N valores positivos
                              % e o zero --> 2*N+1
                              
    yt =  yt + Yw(k)*exp(j*n(k)*wo*tempo);  % sinal original
    
end
%% visualização da saida no tempo

figure(5)
subplot(2,1,1);
plot(tempo,gt,'linewidth', 2);
grid;
title("Entrada")


subplot(2,1,2);
plot(tempo,yt,'linewidth', 2);
grid;
title("Saída")



