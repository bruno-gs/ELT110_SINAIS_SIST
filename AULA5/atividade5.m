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
%% aproximar uma onda quadrada por um sinal
%% harmônico - g(t) = exp(-at) --> 0 < t < 1
%% 
%% Definir a onda exponencial com expoente variável

display('1 - Configurando o sinal...')

To = 1;     % período da onda quadrada
to = 0;     % instante inicial de g(t)

%%% Parâmetros calculados

fo = 1/To;    % frequência da onda quadrada
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

Inum    = int(exp((-5-j*n*wo)*t),t,to,To);

%%% Determinando Dn

Dn = Inum/To;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 -  Valores no domínio da frequência

display('3 - Determinando Dn numericamente...')

N    = 20;          % Número de harmônicas
n    = [-N:1:N];    % Harmônicas de Fourier
freq = n*fo;        % frequências de Fourier

Dn   = eval(Dn)     % valores numéricos

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
%%  Cálculo de potência do sinal
%%
%%
%%
%%  g(t)  = sum_{n=-N}^{n=N} Dn exp(j n wo t)
%%

display('5 - Calculando a potência do sinal...')

syms a t  % t - tempo variável simbólica

%%% Determinando a potência

Pg    = (1/To)*int(exp(-a*t).^2,t,to,To);

%%% Cria o vetor a

a     = [1:0.1:10];     % vetor de expoentes a

%%%% Determina o valor de Pg(a)

Pg    = eval(Pg);        % valores numéricos de Pg


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
stem(freq,Dn,'k-','linewidth',3);
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

figure(3)
plot(a,Pg,'g-','linewidth',3);
xlabel('Expoente a');
ylabel('Potencia total');
title('Potencia das exponenciais')
grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 - Definindo filtro 
%% 
%%  H(w) = wc / (wc + j*w)
%%  
%%
%%  Y(w) = H(w) * X(w)

%% Y(w) -- saida
%% H(w) -- sistema
%% X(w) -- entrada ==> Dn: conclusão 1


display ('determinando a saida do filtro')
%%%%%%%% Definir o filtro

wc = 1;                           %% freq de corte no filtro
w = 2*pi *freq;                   %% freq de corte no filtro

Hw = @(w, wc) wc./(wc + j*w);     %% ganho do filtro 

Gfiltro = Hw(w,wc);               %% ganho do filtro nas freq desejadas

%% determinar a saida

Yw = Gfiltro.*Dn;                 %% det a saida em Fourier


%% visualização da saida na frequencia

figure(4)

subplot(3,1,1);
stem(w,abs(Dn));
grid;
title("Entrada")


subplot(3,1,2);
plot(w,abs(Gfiltro),'linewidth', 2);grid;
title("Sistema")



subplot(3,1,3);
stem(w,abs(Yw));
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
stem(tempo,gt,'linewidth', 2);
grid;
title("Entrada")


subplot(2,1,2);
plot(tempo,yt,'linewidth', 2);
grid;
title("Saída")








