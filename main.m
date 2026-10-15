
clear
% load('data_xd_GEM_period1_260_rel4b.mat')
% load("data_p_GEM_period1_260_rel4b.mat");
% load("data_InfR_GEM_period1_260_rel4b.mat");
% load("data_resnorm_GEM_period1_260_rel4b.mat");
%% vars global for test 
global globalPais grafica_data ventana_general globalUCImovil flagpause numThetas

% grafica_data = 1 for generated graphics on analisys
grafica_data=0; 
flagpause=0; % for pause on visualization

% globalPais = 1 using data national; 
% globalPais = 0 using data regional; 
globalPais =0; 

% globalUCImovil = 1 <- using  admission daily national; 
% globalUCImovil = 0 <- using  hospitalization and ICU stay; 
globalUCImovil = 0; 
auto_ajuste = 1 % 0-> non auto calibration / 1 -> auto calibration
% Research block analysis
%diaInicio = 250 % init day
%diaFinEstudio = 900 % finish day

diaInicio = 1 % init day
diaFinEstudio = 260  % finish day


%% Params of control/performance
primera_ola =0; % for localized research on first wave, default = 0
toda_la_ola = 0; % for future test, default = 0
opcion_a1 = 0; % for first optimization, default = 0
cargar_checkpoint = 0; % 1-> for case load checkpoint, default = 0
media_inicio_fin=0 % 1 for use media global, default 0

% days after the first wave  
if diaInicio > 200
media_inicio_fin = 0
end

distancia_t = diaFinEstudio - diaInicio;
%numThetas=ceil(distancia_t/30); % For automatic estimate number blocks

numThetas = 20 % 20 is recommended for all tests
%numThetas = 10 %Verificar con 20, pero igual theta para todos (mínimo un periodo c/14 días)

%numThetas=max(ceil(distancia_t/30),10);

% (ventana_general) --> As the interest is the trend of the curves, and there is a data lag between 3 to 5 days,
% at intervals of several months or a year, we increase the size of the mobile windows to a month
% in this way, we smooth the curves and minimize the abrupt jumps in the data.
% In addition, to avoid long approximation cycles in the sign changes of the derivatives, we have of the use of accumulated curves, where use larger moving window .... when there are abrupt changes in the curve
%% Important: If is used one day (ventana_general = 1), original data from the data set is used
% ventana_general=30; % windows mobile size (on days), 30 o more days on daily curve
%ventana_general=21; % windows mobile size (on days), 14 days is default
%ventana_general=14;%% Hasta 60 máximo

%ventana_general=distancioa_t/5+20;
ventana_general=70;

%ventana_general=45;
matrix_results = [];
regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};
%global_time_op=tic;

% other example
% region = 'Magallanes'
% region = 'Valparaíso'
region = 'Metropolitana'


% On case of the automatics design execution program 
size_regiones = size(regiones,2)
Region = cell(size_regiones,1);
total_days = [];
matrix_resultados = [];

%% See relevant params for execution program
% acumulada = 1 is cumulative data smooth and cumulative proccesing curves, util for the detection of anomalies on data and large datasets, and fast proccessing;
% acumulada = 2 is cumulative data smooth and daily proccesing curves, util for an exhaustive approach and definitive result; 
acumulada = 2;  

maxGlobal =0;%  For test with max of the all data, default = 0 
meanGlobal =0; % For test with mean of the all data, default = 0
mediana = 0; % For extra test, default = 0

%% One if use synthetic data - FALTA GENERAR DE MANERA SINTETICA EL N -IDEA PROPORCIONAL A UBICACION EN DATA SINTETICA
%% por ahora de manera directa
%% Chile: 19.212.362 Max: RM: 8.500.000  ----- Min Aysen: 100.000

%% New variable to select between GEM, GSIRTD, and GSIR (04/08/2026)
opcionModel = 1; % 1: GEM (2023 and 2025 model), 2: GSIRTD (2022 model), 3: GSIR (SIR model with time-varying rates)

opcionError = 5; % 1: relative UCI error, 2: Infected + UCI: 3: Inf+UCI+Rec:| 4: all, 5: solo infectados, 6: infectados + recuperados.


use_synt = 2% 0: use of pre-saved synthetic datasets, 1: Synthetic datasets generated with VAEs, 2: Parametric bootstrapping, 3: normal call (no synthetic data) 

pred = 0

cantidad = 2 % Use cantidad = 100 together with use use_synt = 2 to generate M=100 synthetic datasets and save them 

maximo=973;
%maximo = 500;

if use_synt==1
    %ini_0=400;
    ini_0=871;
    fin_0=maximo;
    pivot0 = round((fin_0-ini_0)/(cantidad+1));
    arreglo_id = [];
    for isynt=1:cantidad
        valor = ini_0 + pivot0*(isynt) + 1;
        arreglo_id = [arreglo_id,valor];
    end

    if arreglo_id(end) > maximo
        arreglo_id(end) = maximo;
    end
end
if use_synt == 0 || use_synt == 2
    data_p = [];
    data_InfR = [];
    data_resnorm = [];
    if use_synt ==2
        data_xd = [];
    end
end

if use_synt == 1
    for isynt = 1:cantidad
        data_selection = arreglo_id(1,isynt); % between 1 and 972 %% One if use synthetic data
        nMin = 100000;
        %nMin = 1e6;
        nMax = 8500000;
        difN = (nMax - nMin)/973;
        % N = difN*data_selection + nMin;
        difNrand=difN*data_selection*rand;
        N = round(difNrand+nMin);
        region = 'Sintetica'
        test_paper_build_tables
        data_p = [data_p,p];
        data_InfR = [data_InfR,InfR];
        data_resnorm = [data_resnorm,resnorm];
    end
elseif  use_synt == 2
    %%To generate and calibrate synthetic datasets
    for isynt = 1:cantidad
        tic;
        test_paper_build_tables
        data_p = [data_p,p];
        data_InfR = [data_InfR,InfR];
        data_resnorm = [data_resnorm,resnorm];
        data_xd =[data_xd,ds];
        tiempos(isynt)=toc;
    end
elseif use_synt==0 %Para uso con datos sint. ya grabados
    N=8125072; % para la RM
    load('./data-in/Orig_data.mat') % Original dataset
    load('./data-in/data_xd_GEM_period1_260_rel4f.mat')
    for id=1:size(data_xd,2)
        tic;
        xd = reshape(data_xd(:,id),972,6);
        if opcionModel ~= 1
            Fd = xd(:,5)-xd(:,1)-xd(:,2);
            xd(:,2) = xd(:,2) + Fd;
            xd(:,4) = xd(:,4) + xd(:,3) - Fd;
        end
        test_paper_build_tables
        data_p = [data_p,p];
        data_InfR = [data_InfR,InfR];
        data_resnorm = [data_resnorm,resnorm];
        tiempos(id)=toc;
    end
else
    test_paper_build_tables
    createTablas
end

if opcionModel==1
    compute_curves
else
    compute_curves_all_models
end

if use_synt==3
    compute_infected_Re
    %% Calibration results
    m=length(residual);
    lp=length(p);
    ftspec='%.4e';
    if opcionModel==1
        disp([' & $ ', num2str(resnorm/resnorm0,ftspec), '$ & $', num2str(norm(residual(1:m/2))/norm(residual0(1:m/2)),ftspec),...
            '$ & $', num2str(norm(residual(m/2+1:m))/norm(residual0(m/2+1:m)),ftspec), '$ & $' , num2str(output.stepsize,ftspec),...
            '$ & $',num2str(errores(2,1)/errores0(2,1),ftspec),'$ & $', num2str(errores(4,1)/errores0(4,1),ftspec), '$ & $' ,...
            num2str( norm( ( Rf-Rd )./Rf, inf)/RE_re0, ftspec),'$ &',num2str(iteraciones),' \\ \hline']);
    else
        disp([' & $', num2str(resnorm/resnorm0,ftspec), '$ & $', num2str(norm(residual)/norm(residual0),ftspec),...
            '$ ','& -- & $', num2str(output.stepsize,ftspec), '$ & $',num2str(errores(2,1)/errores0(2,1),ftspec), '$ ' ,...
            '& -- & $', num2str( norm( ( Rf-Rd )./Rf, inf)/RE_re0, ftspec),'$ &',num2str(iteraciones),' \\ \hline']);
    end
end
% if  use_synt == 1
%     nombre_archivo = sprintf('curva_sintetica_%d.mat', data_selection);
%
%     % (Alternativa para MATLAB R2017a o superior usando strings):
%     % nombre_archivo = "datos_" + i + ".mat";
%
%     % 3. Guardar la matriz
%     % Guarda la variable 'matriz_datos' dentro del archivo .mat generado
%     save(nombre_archivo, 'p');
%
%     % Mostrar un mensaje en la consola para verificar el progreso
%     fprintf('Archivo guardado exitosamente: %s\n', nombre_archivo);
% else
%     nombre_archivo = sprintf('curva_12_sintetica_%d.mat', isynt);
%     save(nombre_archivo, 'p');
% end
toc
if use_synt == 0 || use_synt == 2
    save("./data-out/data_p_GEM_period1_260_rel4.mat", 'data_p');
    if use_synt == 2
        save("./data-out/data_xd_GEM_period1_260_rel4.mat", 'data_xd');
        %tiempo_total = sum(tiempos)
    end
    save("./data-out/data_InfR_GEM_period1_260_rel4.mat", 'data_InfR');
    save("./data-out/data_resnorm_GEM_period1_260_rel4.mat", 'data_resnorm');
     tiempo_total = sum(tiempos)
end