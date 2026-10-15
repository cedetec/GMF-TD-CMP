%% Infectados
%tmp = UCIdist;
global globalPais grafica_data ventana_general globalUCImovil flagpause
[fr,cr] = size(UCIdist)
ventana = ventana_general;
UCI_surf = [zeros(16,dist_pivot_days),UCIdist];
[salidaU] = mediamovil(UCI_surf',ventana);
% figure;mesh(UCI_surf);
% figure;mesh(UCI_surf_s);

[fr,cr] = size(UCI_surf) 
UCI_surf_base = salidaU';
% sortrows
tmp = UCI_surf_base;
tmp = [tmp,sum(tmp')'];
x_test_U =sortrows(tmp,cr+1)'; 
x_test_U(cr+1,:) = [];
% figure;
% mesh(x_test_F)
% % 
suma_totalU = sum(sum(UCIdist))
suma_totalUS = sum(sum(x_test_U))
error_smooth_abs = abs(suma_totalU-suma_totalUS)
error_smooth_rel = (abs(suma_totalU-suma_totalUS)/suma_totalU)*100

%Spline
[fr,cr] = size(x_test_U) %f=16, cu=942
%salt_tramo2 = fu/(cu+62) 
salt_tramo3 = (cr-1)/(fr);
x_tramo_out3 = 1:1:cr; %cuenta de 1 
%sizes de x_tramo_in2 y x_tramo_out2 son 1x942
x_tramo_in3 =1:salt_tramo3:cr; %cuenta de 1 a 942 de 0.016 en 0.016
matrix_test4 = []; 
% % 
for i=1:fr 
    %x_spline3 = pchip(x_tramo_out3,x_test_I(i,:),x_tramo_in3);
    x_spline = pchip(x_tramo_out3,x_test_U(i,:),x_tramo_in3);
    matrix_test4 = [matrix_test4;x_spline]; 
end
medida_1 = sum(sum(x_test_U))/((fr)*cr)
medida_2 = sum(sum(matrix_test4))/(fr*fr)
error_smooth_pchip_1 = abs(medida_1-medida_2)
error_smooth_pchip_2 = (abs(medida_1-medida_2)/medida_1)*100
U_surf_cuadrada = cumsum(matrix_test4);
% figure;
% mesh(U_surf_cuadrada)
% figure;
% mesh(cumsum(U_surf_cuadrada))
