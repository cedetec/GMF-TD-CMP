%% Right side of GSIRTD (2022 model, opcionModel=2)
function v = sir_ret_fun_sin_vac(t,y,Z,p,N,x0)
traza=0;
nTau = 6;
nGammas = (size(p,1)-9)/6;
%% decomment for trace possible errors at time t
% t = ceil(t)

ylag1 = Z(:,1);
ylag2 = Z(:,2);
posIni = 4; 
size_x=size(x0,1);
range = 1:size_x;

all_gammas  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_betas   = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
tr = linspace(min(range),max(range),numel(all_betas));
if t<=range(end)
    beta   = interp1(tr,all_betas,t,'pchip');
    gamma  = interp1(tr,all_gammas,t,'pchip');
 else
    beta   = interp1(tr,all_betas,range(end),'pchip');
    gamma  = interp1(tr,all_gammas,range(end),'pchip');
end
v = zeros(3,1);
%% Diferential Equation and add tol=0.0001 for control stability
%% Model 2022 GSIRM
v(1,1) = - beta*y(1)*ylag1(2)/N+0.0001;
v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) +0.0001;
v(3,1) = gamma*ylag2(2)+0.0001;
%% decomment for trace all values model for this paper
%% useful for thesis students or researcher
% % if( isnan(v) || v(1,1)==inf )
% %     format shortg
% %     [beta,gamma,deltaS,alfaS,gammasUCI,gammasR]
% %     if isempty(count)
% %       count = 0;
% %     end
% %     count = count + 1
% %     if mod(count,10000) == 0
% %       count = 0;
% %       t
% %       disp('en persistencia')
% %       count
% %      % pause
% %     end
% % end
% % %pause
% % if isnan(v(1,1)) || isnan(v(2,1))|| isnan(v(3,1))|| isnan(v(4,1))
% %     
% %     N
% %     v(1,1)
% %     v(2,1)
% %     v(3,1)
% %     v(4,1)
% %     t
% %     beta
% %     deltaS
% %     alfaS
% %     gamma
% %     gammasUCI
% %     gammasR
% %     ylag3(1)
% %     %pause 
% %     y(1)
% %     pause
% % end

if isnan(Z) & traza == 1
    salida = 'aparece NAN en v'
    v
    pause
end


