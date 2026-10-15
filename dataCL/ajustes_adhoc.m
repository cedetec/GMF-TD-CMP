%global grafica_data 
%close all
%% Ajustes ad-hoc para primeros meses de pandemia
% Inicio periodo de ajuste
iniAjuste=30;
% Fin periodo de ajuste
finAjuste=150;
ventana = 3;
% Ajuste básico con media movil sobre funcion acumulada
% para suavizar distribución donde se presenta salto discreto grande
[aIC,IC_day,aIC_day,error_aIC] = ajusteI(IC,iniAjuste,finAjuste,ventana);
%close all
% figure
% v0 = [IC;aIC];
% plot(v0')
% legend('IC','aIC')
% title('Ajuste básico con media movil sobre funcion acumulada')

% Ajuste heurístico con uso de tasas promedio + media movil + sobre funcion acumulada
% para (a) suavizar distribución donde se presenta salto discreto "aparicion en un dia de más de 100K recuperados"
% (b) para 
diaPrimerRecs = 14; % dia en que se presenta primer recuperado
[aRC,RC_day,aRC_day,error_aRC] = ajusteR(aIC,RC,diaPrimerRecs);
% figure
% v1 = [RC;aRC];
% plot(v1')
% legend('RC','aRC')
% title('Ajuste heurístico con uso de tasas promedio + media movil + sobre funcion acumulada')
% 
% figure
% v2 = [v0;v1];
% plot(v2')
% legend('IC','aIC','RC','aRC')
% title('Ajustes básicos y heurísticos')

% Ajuste y suavizamiento de curvas acumuladas de fallecidos
ventana = ventana_general;
[aFC] = mediamovil(FC,ventana);
F = diferenciasDiarias(FC);
[aFC_day] = diferenciasDiarias(aFC);
%U(1,end) = U(1,end-1);

%U(end)=U(end-1);
%U=U';
% table of ajustes heurísticos y básicos
%T = table(aIC,aRC,IC_day,RC_day,aIC_day,aRC_day,error_aIC,error_aRC)
v_ajuste_outlers = [IC',IC_day',RC',RC_day',FC',F',aIC',aIC_day',aRC',aRC_day',aFC',aFC_day',U'];
sumas = sum(v_ajuste_outlers);
Tdays = array2table(v_ajuste_outlers);
Tdays.Properties.VariableNames = {'IC','IC_day','RC','RC_day','FC','F','aIC','aIC_day','aRC','aRC_day','aFC','aFC_day','U'};
%Tdays.Properties.RowNames = {'RC','aRC','IC','aIC'};
Tdays.Properties.Description = 'Tasas de recuperación y acumulación de casos';
figure
stackedplot(Tdays)

% Ajustes a todos con media movil

[aI_day_movil] = mediamovil(aIC_day,ventana_general);
[aR_day_movil] = mediamovil(aRC_day,ventana_general);
[aF_day_movil] = mediamovil(aFC_day,ventana_general);
%[aF_day_movil] = mediamovil(F,ventana);

[aU_day_movil] = mediamovil(U(:,1:size(aFC_day,2)),ventana_general);

v_ajuste_movil = [aI_day_movil',aR_day_movil',aF_day_movil',aU_day_movil'];
Tmovil = array2table(v_ajuste_movil);
Tmovil.Properties.VariableNames = {'I','R','F','U'};
Tmovil.Properties.Description = 'Casos diarios con media movil';
if grafica_data == 1
figure
stackedplot(Tmovil)
end




