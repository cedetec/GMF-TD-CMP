addpath (genpath('dataCL/'))
nn=748 %en 749 se agregan 6 mil fallecidos a totales - a partir de alli hay que restar los probables
% para comparar con estudios de 2020, 2021 que no usan probables - solo
% confirmados
nf = size(FC,2)
t01_data = datetime(2022,3,21,0,0,0,'TimeZone','America/Santiago')
t02_data = datetime(2020,10,30,0,0,0,'TimeZone','America/Santiago')
size_n = nf - nn;

f_confirmed = [];
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

    rowsIndex = strcmp(T0.Region, region);
    x = T(rowsIndex,:); 
    x_pais = T(end,:); 
    t_time = t_time + days(1);
    f_confirmed = [f_confirmed,x];

    f_confirmed_pais = [f_confirmed_pais,x_pais];

end


