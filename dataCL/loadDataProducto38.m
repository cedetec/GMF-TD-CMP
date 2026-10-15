function [Poblaciones,FRegion,Fpais,Fdist,T,Dstring,Dtable,Ddouble] = loadDataProducto38(regionA,grafica,pathDATA)
%addpath ./data/functions/D38
% addpath ./data/functions/D46
% addpath ./data/functions/D38
% addpath ./data/functions/D53
Poblaciones = 0;
Fpais  = 0;
FRegion = 0;
data = 0;
T = 0;
Dstring=0;
Dtable=0;
Ddouble=0;
%if ID==1


regionB = regionA;

if strcmp(regionA,'Tarapacá')
    regionB = 'Tarapaca'    
end

if strcmp(regionA,'Valparaíso')
    regionB = 'Valparaiso'    
end

if strcmp(regionA,'O’Higgins')
    regionB = 'Del Libertador General Bernardo O’Higgins'    
end

if strcmp(regionA,'Ñuble')
    regionB = 'Nuble'    
end

if strcmp(regionA,'Biobío')
    regionB = 'Biobio'    
end

if strcmp(regionA,'Araucanía')
    regionB = 'La Araucania'    
end

if strcmp(regionA,'Los Ríos')
    regionB = 'Los Rios'    
end

if strcmp(regionA,'Aysén')
    regionB = 'Aysen'    
end

if strcmp(regionA,'Magallanes')
    regionB = 'Magallanes y la Antartica'    
end

%regionB
%pData = pathDATA + '\producto1\Covid-19.csv'
pData = strcat(pathDATA,'/producto38/CasosFallecidosPorComuna.csv');

[Dstring,Dtable,Ddouble] = D38(pData);
    %% F-Covid
    
    dataTable = Dtable(string(Dtable.Region)==regionB, :);
    T=dataTable;
    rowsIndex = Dtable.('Region')==regionB;
    dataDouble = Ddouble(rowsIndex,:);
    Poblaciones = dataDouble(1:end-2,5);
    dataTest1 = dataDouble(1:end-2,6:end);
    dataTest2 = sortrows(dataTest1,size(dataTest1,2));
    test1 =   abs(dataTest1(1:end,2:end) - dataTest1(1:end,1:end-1));
    test2 =   abs(dataTest2(1:end,2:end) - dataTest2(1:end,1:end-1));
    
    Fdist = [dataDouble(1:end-2,6),test1];
    fTotalesComunasRegion = sum(test1);
    Ddouble(isnan( Ddouble(:,:))) = 0;
    %Ddouble(isnan( Ddouble(:,:))) = 0
    %pause
    %tmp   = [Ddouble(ls,2),Ddouble(ls,4:)]
    Fpais = Ddouble;
    %Fpais = sortrows(Ddouble,2);
    Fpais(Fpais(:,4)==0,:)=[];
    FpaisDiff = diff(Fpais(:,6:end)');
    %Fpais = 
    FRegion = [ dataDouble(end,6),fTotalesComunasRegion];
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
        figure
        surf(Fpais(:,6:end)')
        title('Fallecidos acumulados Fpais -')
        figure
        surf(FpaisDiff)
        title('Fallecidos FpaisDiff Fpais -')
        
        end
regionB
end