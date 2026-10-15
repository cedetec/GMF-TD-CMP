function [Poblaciones,R,Rt,data,T,Dstring,Dtable,Ddouble] = cargadataFormat(regionA,regionB,grafica,ID,pathDATA)
addpath ./data/functions/D1
addpath ./data/functions/D46
addpath ./data/functions/D38
addpath ./data/functions/D53
Poblaciones = 0;
R  = 0;
Rt = 0;
data = 0;
T = 0;
Dstring=0;
Dtable=0;
Ddouble=0;
if ID==1
% pData = pathDATA + '\producto1\Covid-19.csv'
pData = "C:\Users\Patricio Cumsille\Documents\MATLAB\code-dev\producto1\Covid-19.csv"
[Dstring,Dtable,Ddouble] = D1(pData);

%% I-Covid
    dataTable = Dtable(string(Dtable.Region)==regionA, :);
    T=dataTable;
    rowsIndex = Dtable.('Region')==regionA;
    dataDouble = Ddouble(rowsIndex,:);
    dataTest1 = dataDouble(1:end-1,6:end-1); %% Datos regionales
    Poblaciones = dataDouble(1:end-1,5);
    dataTest2 = sortrows(dataTest1,size(dataTest1,2));
    test1 =   abs(dataTest1(1:end-1,2:end) - dataTest1(1:end-1,1:end-1));
    test2 =   abs(dataTest2(1:end-1,2:end) - dataTest2(1:end-1,1:end-1));
    iTotalesComunasRegion = sum(test1);
    iRegion = test1;
    R = iRegion;
    Rt = iTotalesComunasRegion;
    data = dataTest1;
        if grafica == 1
        createfigure(dataTest1,dataTest1)   
        title('Infectados acumulados sort sum-',regionA)
        figure
        surf(sortrows(test1,size(test1,2))')
        title('Infectados  -',regionA)
        figure
        surf(sortrows(dataTest1,size(dataTest1,2)))
        title('Infectados sort sum-',regionA)
        figure
        surf(test2)
        title('Infectados sort max-',regionA)
        end

end

if ID==38
pData = pathDATA + '/producto38/CasosFallecidosPorComuna.csv'
[Dstring,Dtable,Ddouble] = D38(pData);
    %% F-Covid
    dataTable = Dtable(string(Dtable.Region)==regionB, :);
    T=dataTable;
    rowsIndex = Dtable.('Region')==regionB;
    dataDouble = Ddouble(rowsIndex,:);
    dataTest1 = dataDouble(1:end-2,6:end-1);
    dataTest2 = sortrows(dataTest1,size(dataTest1,2));
    test1 =   abs(dataTest1(1:end-1,2:end) - dataTest1(1:end-1,1:end-1));
    test2 =   abs(dataTest2(1:end-1,2:end) - dataTest2(1:end-1,1:end-1));
    fTotalesComunasRegion = sum(test1);
    fRegion = test1;
    R = fRegion;
    Rt = fTotalesComunasRegion;
    data = dataTest1;
        if grafica == 1
        createfigure(dataTest1,dataTest1)  
        title('Fallecidos acumulados - sort sum-',regionB)
        figure
        surf(sortrows(test1,size(test1,2))')
        title('Fallecidos-',regionB)
        figure
        surf(sortrows(dataTest1,size(dataTest1,2)))
        title('Fallecidos sort sum-',regionB)
        figure
        surf(test2)
        title('Fallecidos sort max -',regionB)
        end
end

if ID==53
pData = pathDATA + '/producto53/confirmados_provinciales.csv'
[Dstring,Dtable,Ddouble] = D53(pData);
 dataTable = Dtable(string(Dtable.Provincia)==regionB, :);
    T=dataTable;
    regionB
    rowsIndex = string(Dtable.Provincia)==regionB;
    %rowsIndex = Dtable.('Provincia')==regionB;
    dataDouble = Ddouble(rowsIndex,:);

    
    
    dataTest1 = dataDouble(1:end,6:end);
    %dataTest2 = sortrows(dataTest1,size(dataTest1,2));
    %test1 =   abs(dataTest1(1:end-1,2:end) - dataTest1(1:end-1,1:end-1));
    %test2 =   abs(dataTest2(1:end-1,2:end) - dataTest2(1:end-1,1:end-1));
    %fTotalesComunasRegion = sum(test1);
    %fRegion = test1;
    %R = fRegion;
    %Rt = fTotalesComunasRegion;
    data = dataTest1;
end
if ID==46
pData = pathDATA + '\producto46\activos_vs_recuperados.csv'    
%R = importfile46("\output\producto46\activos_vs_recuperados.csv", [2, Inf]);

R = importfile46(pData, [2, Inf]);
data=R;
T=abs(R(2:end,2) - R(1:end-1,2));
Rt=abs(R(2:end,3) - R(1:end-1,3));
R = R(1:end,2);
Rt=[0;Rt];
T=[1;T];
end

%[D81string,D81table,D81double] = D81(nTimeRF);


%% Data Product 38 - Casos fallecidos por comuna: Este producto da cuenta del número de casos fallecidos en cada una de las comunas de Chile según su residencia, y concatena la historia de los informes epidemiológicos publicados por el Ministerio de Salud del país. Ver más
%% Data Product 50 - Defunciones notificadas por el Departamento de Estadísticas e Información Sanitaria (DEIS) por comuna: Data product que da cuenta de los datos correspondientes a los fallecidos en cada una de las comunas de Chile, según residencia y fecha Ver más
%% Data Product 57 - Casos Fallecidos y estado de Hospitalización por región: Archivo que da cuenta de los casos fallecidos confirmados y probables por COVID-19 notificados en la plataforma EPIVIGILA o informados por los laboratorios al Ministero de Salud y que se encuentran dentro del conteo oficial de casos, por fecha de defunción, región de ocurrencia, y si el caso se hospitalizó o no. Ver más
%% Data Product 61 - Fallecidos confirmados por comuna (U07.1): Fallecidos confirmados por DEIS, desagregados por comuna Ver más
%% Data Product 62 - Curva de casos nuevos desagregados por día: Curva completa de los casos nuevos confirmados (incluye probables) y acumulados de COVID-19 según fecha de confirmación por laboratorio a nivel nacional, desagregado por día Ver más
%% Relevantes %%
%% Data Product 76 - Avance regional en Campaña de Vacunación COVID-19: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 a nivel regional. Ver más
%% Data Product 77 - Avance por rango etario y región en Campaña de Vacunación COVID-19: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 por rango etario y región. Ver más
%% Data Product 78 - Avance por sexo y edad en Campaña de Vacunación COVID-19: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 por edad (en años) y sexo. Ver más
%% Data Product 79 - Avance por grupo prioritario en Campaña de Vacunación COVID-19: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 por criterio y sub criterio de prioridad. Ver más
%% Data Product 80 - Avance comunal en Campaña de Vacunación COVID-19: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 a nivel comunal. Ver más
%% Data Product 81 - Avance comunal por edad en Campaña de Vacunación COVID-19: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 a nivel comunal por edad. Ver más
%% Data Product 83 - Avance en Campaña de Vacunación COVID-19 por fabricante y tipo de establecimiento de vacunación: Avance en Campaña de Vacunación COVID-19 por fabricante y tipo de establecimiento: Este producto da cuenta del avance en la campaña de vacunación contra Sars-Cov-2 a nivel de tipo de establecimiento y fabricante de la vacuna. Ver más
%% Data Product 84 - Fallecidos por comuna/edad

%% ----------------- %%
%% Data Product 88 - Vacunación por fabricante Total de vacunas por fabricante Ver más
%% Data Product 89 - Incidencia de casos según estado de vacunación, grupo de edad, y semana epidemiológica El producto contiene información sobre los casos confirmados, ingresos a UCI y defunciones, según estado de vacunación, agrupado por tramo etario Ver más
%% Data Product 90 - Distribución de casos según antecedentes de vacunación y semana epidemiológica. El producto contiene información sobre los casos confirmados, ingresos a UCI y defunciones, según estado de vacunación, agrupado por semana epidemiológica Ver más
%% ----------------- %%






%% D53 Consolidación experimental PUC/UChile/UDEC
%dataTable = D53table(string(D53table.Region)==regionB, :);
% TF=dataTable;
% rowsIndex = D53table.('Region')==regionB;
% dataDouble = D53double(rowsIndex,:);
% dataTest1 = dataDouble(1:end-2,6:end-1);
% dataTest2 = sortrows(dataTest1,size(dataTest1,2));
% test1 =   abs(dataTest1(1:end-1,2:end) - dataTest1(1:end-1,1:end-1));
% test2 =   abs(dataTest2(1:end-1,2:end) - dataTest2(1:end-1,1:end-1));
% fTotalesComunasRegion = sum(test1);
% fRegion = test1;
% fR = fRegion;
% fRt = fTotalesComunasRegion;
% F = dataTest1;
% if grafica == 1
% createfigure(dataTest1,dataTest1)  
% title('Fallecidos acumulados - sort sum-',regionB)
% figure
% 
% surf(sortrows(test1,size(test1,2))')
% title('Fallecidos-',regionB)
% figure
% surf(sortrows(dataTest1,size(dataTest1,2)))
% title('Fallecidos sort sum-',regionB)
% figure
% surf(test2)
% title('Fallecidos sort max -',regionB)
% end





end