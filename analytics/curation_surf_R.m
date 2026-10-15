%% Recuperados
%tmp = TotalesRecuperados;
global globalPais grafica_data ventana_general globalUCImovil flagpause

%% Ad-hoc adjustments for the first months of the pandemic
ventana = ventana_general;
diaPrimerRecs = 7; 

% i_surf_base -- data req

[f,c] = size(TotalesInfectados);
matrix_Recuperados = [];
    for i=1:f
        matrix_Recuperados = [matrix_Recuperados;  ajusteR(i_surf_base(i,:),TotalesRecuperados(i,:),diaPrimerRecs);];
    end

ventana = ventana_general;    
[salidaR] = mediamovil(matrix_Recuperados',ventana);

r_surf_base = salidaR';
%sortrows
tmp = r_surf_base;
tmp = [tmp,sum(tmp')'];
x_test_R =sortrows(tmp,c+1)'; 
x_test_R(c+1,:) = [];
figure;
mesh(x_test_R)

suma_totalR = sum(sum(TotalesRecuperados))
suma_totalRS = sum(sum(x_test_R))
error_smooth_abs = abs(suma_totalR-suma_totalRS)
error_smooth_rel = (abs(suma_totalR-suma_totalRS)/suma_totalR)*100

%Spline
[fr,cr] = size(x_test_R) %f=16, cu=942
%salt_tramo2 = fu/(cu+62) 
salt_tramo3 = (cr-1)/(fr);
x_tramo_out3 = 1:1:cr; %cuenta de 1 
%sizes de x_tramo_in2 y x_tramo_out2 son 1x942
x_tramo_in3 =1:salt_tramo3:cr; %cuenta de 1 a 942 de 0.016 en 0.016
matrix_test4 = []; 

for i=1:fr 
    %x_spline3 = pchip(x_tramo_out3,x_test_I(i,:),x_tramo_in3);
    x_spline = pchip(x_tramo_out3,x_test_R(i,:),x_tramo_in3);
    matrix_test4 = [matrix_test4;x_spline]; 

end

figure;
mesh(matrix_test4)
% of day 118 comienza trazabilidad nacional recuperados
medida_1 = sum(sum(x_test_R))/((fr)*cr)
medida_2 = sum(sum(matrix_test4))/(fr*fr)
error_smooth_pchip_1 = abs(medida_1-medida_2)
error_smooth_pchip_2 = (abs(medida_1-medida_2)/medida_1)*100
R_surf_cuadrada = matrix_test4;
%% Recordar que el sort no es igual para todos los dataset (R,I,U) - Aplicar un ordenamiento basado en indices para que se puedan usar datos coherentes (misma región)
figure;
mesh(diff(R_surf_cuadrada))