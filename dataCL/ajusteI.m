function [aIC,y0,y1,error_aIC] = ajusteI(IC,iniAjuste,finAjuste,ventana)
%% Ajustes ad-hoc para primeros meses de pandemia
% Caso infectados
IC(1,1) = 1; %Agregamos 1 infectado el día 1 - ya que se considera dia 0 como 0 caso en data original
x = IC(1,iniAjuste:finAjuste);
y = mediamovil(x,ventana);
aIC = IC;
aIC(1,iniAjuste:finAjuste) = y;
% error on humans
[y0] = diferenciasDiarias(IC);
[y1] = diferenciasDiarias(aIC);
error_aIC=abs(sum(y0)-sum(y1))
end