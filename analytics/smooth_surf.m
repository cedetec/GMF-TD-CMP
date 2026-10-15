function [cum_surf,day_surf] = smooth_surf(matrix_in,ventana)
[fr,cr] = size(matrix_in) %f=16, cu=942
cum_surf = []; 
day_surf = []; 

for i=1:fr 
cum_surf = [cum_surf; mediamovil(matrix_in(i,:),ventana)]; 
f = diferenciasDiarias(matrix_in(i,:));
day_surf = [day_surf; mediamovil(f,ventana)];
end
cum_surf=cum_surf';
day_surf=day_surf';
end