function v = odefun(t,y,p,N,x0)
nGammas = (size(p,1)-9)/6;
posIni = 4;
nTau = 6;
all_betas   = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
all_gammas  = p(posIni+nTau:posIni+nTau+nGammas-1);
size_x=size(x0,1);
range = 1:size_x;
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
v(1,1) = - beta*y(1)*y(2)/N+0.0001;
v(2,1) = beta*y(1)*y(2)/N - gamma*y(2) +0.0001;
v(3,1) = gamma*y(2)+0.0001;