%% Infectados
tmp = TotalesInfectados;
global globalPais grafica_data ventana_general globalUCImovil flagpause

%% Ad-hoc adjustments for the first months of the pandemic
% adjustments (initial)
iniAjuste=5;
% adjustments (end)
finAjuste=150;
ventana = 3;


[f,c] = size(TotalesInfectados);
matrix_Infectados = [];
    for i=1:f
        matrix_Infectados = [matrix_Infectados;  ajusteI(TotalesInfectados(i,:),iniAjuste,finAjuste,ventana);];
    end

ventana = ventana_general;    
[salidaI] = mediamovil(matrix_Infectados',ventana);

i_surf_base = salidaI';
%sortrows
tmp = i_surf_base;
tmp = [tmp,sum(tmp')'];
x_test_I =sortrows(tmp,c+1)'; 
x_test_I(c+1,:) = [];
% figure;
% mesh(x_test_I)

suma_totalI = sum(sum(TotalesInfectados))
suma_totalIS = sum(sum(x_test_I))
error_smooth_abs = abs(suma_totalI-suma_totalIS)
error_smooth_rel = (abs(suma_totalI-suma_totalIS)/suma_totalI)*100

%Spline
[fr,cr] = size(x_test_I) %f=16, cu=942
%salt_tramo2 = fu/(cu+62) 
salt_tramo3 = (cr-1)/(fr);
x_tramo_out3 = 1:1:cr; %cuenta de 1 
%sizes de x_tramo_in2 y x_tramo_out2 son 1x942
x_tramo_in3 =1:salt_tramo3:cr; %cuenta de 1 a 942 de 0.016 en 0.016
matrix_test4 = []; 

for i=1:fr 
    %x_spline3 = pchip(x_tramo_out3,x_test_I(i,:),x_tramo_in3);
    x_spline = pchip(x_tramo_out3,x_test_I(i,:),x_tramo_in3);
    matrix_test4 = [matrix_test4;x_spline]; 

end

% figure;
% mesh(matrix_test4)

medida_1 = sum(sum(x_test_I))/(fr*cr)
medida_2 = sum(sum(matrix_test4))/(fr*fr)
error_smooth_pchip_1 = abs(medida_1-medida_2)
error_smooth_pchip_2 = (abs(medida_1-medida_2)/medida_1)*100

I_surf_cuadrada = matrix_test4;
%% Recordar que el sort no es igual para todos los dataset (R,I,U) - Aplicar un ordenamiento basado en indices para que se puedan usar datos coherentes (misma región)

