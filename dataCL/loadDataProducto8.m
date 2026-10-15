function [Poblaciones,UCIRegion,UCIpais,UCIdist,T,Dstring,Dtable,Ddouble] = loadDataProducto8(regionA,grafica,pathDATA)
%addpath ./data/functions/D8
% addpath ./data/functions/D46
% addpath ./data/functions/D38
% addpath ./data/functions/D53
Poblaciones = 0;
UCIRegion  = 0;
Rt = 0;
data = 0;
T = 0;
Dstring=0;
Dtable=0;
Ddouble=0;
%if ID==1
    
%pData = pathDATA + '\producto1\Covid-19.csv'
pData = strcat(pathDATA,'\producto8\UCI.csv');
%pData = "C:\Users\Patricio Cumsille\Documents\MATLAB\code-dev\producto1\Covid-19.csv"
[Dstring,Dtable,Ddouble] = D8(pData);

%% I-Covid
     dataTable = Dtable(string(Dtable.Region)==regionA, :);
     T=dataTable;
     rowsIndex = Dtable.('Region')==regionA;
     dataDouble = Ddouble(rowsIndex,:);
     dataTest1 = dataDouble(1:end,4:end); %% Datos regionales
     Poblaciones = dataDouble(1:end,3);
     UCIRegion = dataTest1;
     UCIpais = sum(Ddouble(2:end,4:end));
     UCIdist = Ddouble(2:end,4:end);
   %  dataTest2 = sortrows(dataTest1,size(dataTest1,2));
%     test1 =   abs(dataTest1(1:end-1,2:end) - dataTest1(1:end-1,1:end-1));
%     test2 =   abs(dataTest2(1:end-1,2:end) - dataTest2(1:end-1,1:end-1));
%     iTotalesComunasRegion = sum(test1);
%     iRegion = test1;
      
%     Rt = iTotalesComunasRegion;
%     data = dataTest1;
        if grafica == 1
        createfigure(UCIdist,UCIdist)   
        title('UCIdists sort sum-',regionA)
%         figure
%         surf(sortrows(test1,size(test1,2))')
%         title('UCIdist  -',regionA)
%         figure
%         surf(sortrows(dataTest1,size(dataTest1,2)))
%         title('UCIdist sort sum-',regionA)
%         figure
%         surf(test2)
%         title('Infectados sort max-',regionA)
        end

end