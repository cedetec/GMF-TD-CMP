%% Recuperados
%tmp = TotalesRecuperados;
global globalPais grafica_data ventana_general globalUCImovil flagpause
%% Important: in case of having consistent data at the beginning of the pandemic, it is not necessary to make this adjustment
% pre-analysis: It greatly affects 10 thousand aggregates of deceased, heuristics could be applied to distribute all those deceased
ventana = ventana_general;
addpath (genpath('dataCL/'))

% in the entire pandemic, indicating that it is done for numerical and non-epidemiological experimental terms
% the rate/percentage of deaths to be added is calculated (approx. 10000 of totals)
% as of October 30, 11,660 suspects added, confirmed 50,017, total 61,677
% as of March 21, 2022, 11349 suspects added, confirmed 44616, total 55965
nn=748; %on day 749 the new government adds 6 thousand deaths - from there you have to subtract the possible cases
%% Here, the probable cases will be discarded from the data on deceased in order to maintain a trend of data
% reported since March 2020
% extractDefeatsConfirmed % Data is processed to only use confirmed covid deceased (possible cases are not added)

%% ____________ Extract defeats confirmed _____________________
tmp = TotalesFallecidos
nf = size(TotalesFallecidos,2)
t01_data = datetime(2022,3,21,0,0,0,'TimeZone','America/Santiago')
t02_data = datetime(2020,10,30,0,0,0,'TimeZone','America/Santiago')
size_n = nf - nn;

f_confirmed_surf = [];
%formatSpec = '2022-03-21-CasosConfirmados-totalRegional.csv';
formatSpec = '/producto4/%s-%s-%s-CasosConfirmados-totalRegional.csv';
f_confirmed_pais = [];
figure;
str='';
t_time=t01_data;
for i=nn:nf-1
    dia = string(day(t_time));
    mes = string(month(t_time));

    if day(t_time) < 10
       dia = '0'+dia; 
    end
    if month(t_time) < 10
       mes = '0'+mes; 
    end

    anio = string(year(t_time));
    str = sprintf(formatSpec,anio,mes,dia);
    T0 = readtable(str);

    T = readtable(str).FallecidosConfirmadosTotales;

   % rowsIndex = strcmp(T0.Region, region);
    rowsIndex =boolean([ones(16,1);0;0]);
    x = T(rowsIndex,:); 
   % x_pais = T(end,:); 
    t_time = t_time + days(1);
    f_confirmed_surf = [f_confirmed_surf,x];

    %f_confirmed_pais = [f_confirmed_pais,x_pais];

end
%% End extract defeat confirmed %%
f_surf = f_confirmed_surf;
f_surf_test = [TotalesFallecidos(:,1:nn),f_confirmed_surf(:,:)];

%[cum_surf,day_surf] = smooth_surf(f_surf_test,ventana);

[salidaF] = mediamovil(f_surf_test',ventana);

[fr,cr] = size(f_surf_test) 
f_surf_base = salidaF';
%sortrows
tmp = f_surf_base;
tmp = [tmp,sum(tmp')'];
x_test_F =sortrows(tmp,cr+1)'; 
x_test_F(cr+1,:) = [];
% figure;
% mesh(x_test_F)
% % 
suma_totalF = sum(sum(TotalesFallecidos))
suma_totalFS = sum(sum(x_test_F))
error_smooth_abs = abs(suma_totalF-suma_totalFS)
error_smooth_rel = (abs(suma_totalF-suma_totalFS)/suma_totalF)*100

%Spline
[fr,cr] = size(x_test_F) %f=16, cu=942
%salt_tramo2 = fu/(cu+62) 
salt_tramo3 = (cr-1)/(fr);
x_tramo_out3 = 1:1:cr; %cuenta de 1 
%sizes de x_tramo_in2 y x_tramo_out2 son 1x942
x_tramo_in3 =1:salt_tramo3:cr; %cuenta de 1 a 942 de 0.016 en 0.016
matrix_test4 = []; 
% % 
for i=1:fr 
    %x_spline3 = pchip(x_tramo_out3,x_test_I(i,:),x_tramo_in3);
    x_spline = pchip(x_tramo_out3,x_test_F(i,:),x_tramo_in3);
    matrix_test4 = [matrix_test4;x_spline]; 

end
% % 

% % 
medida_1 = sum(sum(x_test_F))/((fr)*cr)
medida_2 = sum(sum(matrix_test4))/(fr*fr)
error_smooth_pchip_1 = abs(medida_1-medida_2)
error_smooth_pchip_2 = (abs(medida_1-medida_2)/medida_1)*100

F_surf_cuadrada = matrix_test4;
% % %% Recordar que el sort no es igual para todos los dataset (R,I,U) - Aplicar un ordenamiento basado en indices para que se puedan usar datos coherentes (misma región)
%% Replace values < 0 to 0
[fil,col,val] = find(F_surf_cuadrada<0);
n0 = size(col,1);
for i=1:n0
    F_surf_cuadrada(fil(i,1),col(i,1)) = 0;
end

figure;
mesh(diff(F_surf_cuadrada))
