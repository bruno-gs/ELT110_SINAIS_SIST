%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% Elaborar um código que:
%% 1. leia um arquivo de aúdio - tipo wav
%% 2. mostrar em um gráfico o sinal lido
%% 3. explorar as carcterísticas do sinal:
%% máximo, min, desvio padrão, média
%% 4. processar o sinal --> aplicar algum algorimo
%% 5. visualizar o resultado do processamento
%% AUTOR: Fritz
%% DATA: 11/08/2021
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Boas práticas
%% 
    display('Executando Boas Práticas...');
    clear all;              % Limpa todas as variáveis
    close all;              % fecha todas as figuras
    clc;                    % limpa a tela
    display('Boas Práticas executadas!!');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 - Entrada de dados
%%
%%  Leitura dos dados
%%  Extrai as informações



    display('Entrada de dados...');
    info = audioinfo ('Gaita_Blues.wav');     %Informações do arquivo de audio
    [gk,fs] = audioread('Gaita_Blues.wav');   %Lendo o arquivo de aúdio
    
    % gk -> valores do sinal de aúdio
    % fs -> taxa de amostragem em Hz
    % info -> informações do arquivo
    
    
%%%%%%%% Ouvir o som no computador

    sound(gk,fs)
    display('Etapa 2 finalizada!!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Análise do sinal de aúdiio
%%
%% Explorar as carcterísticas do sinal:
%% máximo, min, desvio padrão, média
%%

g_max   = max(gk);
g_min   = min(gk);
g_medio = mean(gk);
g_std   = sqrt(var(gk));

%%%%% Graficamente o sinal

Amostras = info.TotalSamples
Duracao  = info.Duration

%% Cria o vetor tempo
tempo = linspace(0,Duracao,Amostras)

%% Cria a figura
figure(1)

%% Cria o gráfico de gk em função do tempo
plot(tempo,gk, 'k-.')

%%Identifica os eixos
xlabel('Tempo em segundos')
ylabel('Ampliturde Normalizada')
title('Série temporal de uma gaita blues')

%%%%%%%% Cria o reticulado
grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4 - Procesamento de sinais
%%
%% Média móvel de N amostras
%%

%%%%%%%% N amostras do média móvel

N   = 100;

for n = 1: (Amostras - N)
%%%%%%%% saída do filtro média móvel    
    yk(n) = mean(gk(n:n+N));
    
end

%% Cria a figura
figure(2)

%% Cria o gráfico de gk em função do tempo
plot(yk, 'k-.')

%%Identifica os eixos
xlabel('Tempo em segundos')
ylabel('Ampliturde Normalizada')
title('Série temporal da média móvel uma gaita blues')

%%%%%%%% Cria o reticulado
grid minor 
    