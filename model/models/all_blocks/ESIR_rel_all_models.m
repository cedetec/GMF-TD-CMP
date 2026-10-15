%% Calculation of the error function for the GSIRTD and GSIR models (opcionModel =2 or 3)
%% ** 10-10-2025: We add the input "opcionModel" at the end **
function E = ESIR_rel_all_models(p,tc,xd,x0,N,vectorIni,opcion_a1,opcionModel)
global  contF 
nTau = 6;
taus = p(4:4+nTau-1)';
vectorInicial = vectorIni;
%% ** 10-10-2025: We add lines 9, 14-17 to calculate model solution according to opcionModel **
if opcionModel==2
    options = ddeset('RelTol',1e-2,'AbsTol',1e-4,'InitialY',vectorInicial,'InitialStep',100);
     sol = dde23(@sir_ret_fun_sin_vac,taus,@sir_ret_hist_sin_vac,[tc(1),tc(end)],options,p,N,x0);
else
    options = odeset('RelTol',1e-2,'AbsTol',1e-4,'InitialStep',100);
    sol = ode15s(@(t,y)odefun(t,y,p,N,x0),[tc(1),tc(end)],vectorInicial,options);
end
y = deval(sol,tc);
a=p(1);
k=p(2);
aC=p(3);
alfa=1-(1-a)./( 1+exp( -k*(y(2,:)-aC) ) );

%Para pre-aproximacion con alfa = 1
%For pre-approximation with alpha = 1
if opcion_a1 == 1
    alfa = 1;
end

v_t = alfa.*y(2,:);
% Solo con infectados - Un algoritmo adaptativo generico epidemiologico
E= ( v_t-xd(:,1)' )./(v_t); 

contF=contF+1;
%% uncomment if performing convergence trace graphically
% if mod(contF,10)==0 
% figure('visible','off');
% %plot(log(alfa.*y(2,:)))
% hold on
% %plot(log(y(2,:)))
% %hold on
% plot(xd(:,1:3));
% %plot(y(1,:)); % S
% plot(alfa.*y(2,:),'-'); % I
% plot(y(2,:),'--'); % I
% %plot(alfa.*y(3,:),'--'); % R
% %plot(y(3,:),'.'); % R
% plot(y(4,:),'-'); % U
% t = datetime;
% t.Format = 'yyyymmddHHMMSS';
% text_log = datestr(t,t.Format);
% sLogpng = strcat('img_trace/',text_log,'_',string(contF),'.png');
% saveas(gcf, sLogpng);
% clf
% end