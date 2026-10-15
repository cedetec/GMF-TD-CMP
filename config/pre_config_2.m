global traza nGammas globalPais globalUCImovil interpolacion cont grafica_data nCiclos
grafica_data
cont=0;




%%  Para experimentos ad-hoc / vacunas / comunales / simulación
% config

%% Graficas muestren los ejes correctamente 
%% Datos del ajuste
%% Datos de la predicción

% globalPais = 1 <- chile (suma de datos regionales & desconocido, si es null se asigna 0) 
globalPais = 0;
% globalUCImovil = 1 <- ingreso movil nacional chileno 
globalUCImovil = 0; % si se utiliza ingreso movil se ajusta mejor el final de la curva desde el inicio de optimizacion 

% AJUSTE DE CURVAS
interpolacion = 1;
% interpolacion = 1 <- se interpola y luego se aplica modelo SIER de test sobre un subconjunto pequeño de puntos esto para en fase dde experimentación, 

% for short experiment percentPrunning < 1
percentPrunning = 1 %   1 > values > 0 is percentage of data 

% Aproximacion sobre curva acumulada
acumulada =0;

% TRAZA OPTIMIZER
traza = 0;

% INTERVALO DE ESTUDIO
ventana_general=14;
diaInicio = 10;
diaFinEstudio = 230;
nF=1;
% diaInicio = 280;
% diaFinEstudio = 540;
% nF=84;
diaFin=diaFinEstudio-nF;