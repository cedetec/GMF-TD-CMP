function [tp,Ip,Up] = computepred(tc,p,x0,nF,acumulada,nTau,N,opcionModel,vectorInicial)
% Compute predicted curve after applying adapted Bootstrapping
% Inputs: parameter p, time of calibration tc, days after calibration nF
tau1=p(4);
tau2=p(5);
tau3=p(6);
tau4=p(7);
tau5=p(8);
tau6=p(9);
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
tp=(tc(1):tc(end)+nF)';
if opcionModel==1
    options = ddeset('RelTol',1e-4,'AbsTol',1e-8,'InitialY',vectorInicial,'InitialStep',10);
    sol = dde23(@sir_ret_fun_vac_all,all_taus,@sir_ret_hist,[tp(1),tp(end)],options,p,N,x0);
elseif opcionModel==2
    options = ddeset('RelTol',1e-4,'AbsTol',1e-8, 'InitialY',vectorInicial,'InitialStep',10);
    sol = dde23(@sir_ret_fun_sin_vac, all_taus, @sir_ret_hist_sin_vac, [tp(1),tp(end)], options, p, N, x0); % ver. 30.07.2026
else
    options = odeset('RelTol',1e-4,'AbsTol',1e-8,'InitialStep',10);
    sol = ode15s(@(t,y)odefun(t,y,p,N,x0),[tp(1),tp(end)],vectorInicial,options);
end
y = deval(sol,tp);
if acumulada == 1 || acumulada == 0
    Inf_tmp = y(2,:);
    Idays = diferenciasDiarias(Inf_tmp);
    fr=sigmoide_all(p,Inf_tmp,nTau);
    Ip =( fr.*Idays )';
    if opcionModel==1
        UCI = y(4,:);
        Up = diferenciasDiarias(UCI)';
    else
        Up=[];
    end
else % For adjustments on daily curves
    fr=sigmoide_all(p,y(2,:),nTau);
    Ip = ( fr.*y(2,:) )';
    if opcionModel==1
        Up = y(4,:)';
    else
        Up=[];
    end
end
end