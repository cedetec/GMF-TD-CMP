%% Right side of SIR model with taus delays
function v = sir_ret_fun_vac_all(t,y,Z,p,N,x0)
persistent count
traza=0;
nTau = 6;
nGammas = (size(p,1)-9)/6;
%% decomment for trace possible errors at time t
% t = ceil(t)

ylag1 = Z(:,1);
ylag2 = Z(:,2);
ylag3 = Z(:,3);
ylag4 = Z(:,4);
ylag5 = Z(:,5);
ylag6 = Z(:,6);
posIni = 4; 
size_x=size(x0,1);
range = 1:size_x;

all_gammas  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_alfaS   = p(posIni+nTau+nGammas:posIni+nTau+nGammas*2-1);
all_deltaS  = p(posIni+nTau+nGammas*2:posIni+nTau+nGammas*3-1);
all_gammasU = p(posIni+nTau+nGammas*3:posIni+nTau+nGammas*4-1);
all_betas   = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
all_gammasR = p(posIni+nTau+nGammas*5:posIni+nTau+nGammas*6-1);

tr = linspace(min(range),max(range),numel(all_betas));
if t<=range(end)
    beta   = interp1(tr,all_betas,t,'pchip');
    alfaS  = interp1(tr,all_alfaS,t,'pchip');
    deltaS = interp1(tr,all_deltaS,t,'pchip');
    gamma  = interp1(tr,all_gammas,t,'pchip'); 
 else
    beta   = interp1(tr,all_betas,range(end),'pchip');
    alfaS  = interp1(tr,all_alfaS,range(end),'pchip');
    deltaS = interp1(tr,all_deltaS,range(end),'pchip');
    gamma  = interp1(tr,all_gammas,range(end),'pchip');
end
tr2 = linspace(min(range),max(range),numel(all_gammasU));

 if t<=range(end)
   gammasUCI = interp1(tr2,all_gammasU,t,'pchip');
 else
      gammasUCI = interp1(tr2,all_gammasU,range(end),'pchip');
 end
tr3 = linspace(min(range),max(range),numel(all_gammasR));
 if t<=range(end)
   gammasR   = interp1(tr3,all_gammasR,t,'pchip');
 else
    gammasR   = interp1(tr3,all_gammasR,range(end),'pchip');
 end

%% decomment for trace all values model for this paper
%% useful for thesis students or researcher
% % if isnan(sum(sum(Z))) & traza == 1
% %     salida = 'aparece NAN en Z sis_ter_fun_vac_all'
% %     Z
% %     beta
% %     gamma   
% %     deltaS
% %     alfaS    
% %     gammasUCI
% %     gammasR
% %     tr
% %     figure;plot(Z,'DisplayName','Z')
% %     hold on
% %     xline(tr)
% %     xline(t,'color','red')
% %     figure;
% %     plot(x0)
% %     hold on
% %     xline(t,'color','red')
% %     %x0
% %     - beta
% %     y(1)
% %     y(2)
% %     y(3)
% %     y(4)
% %     y
% %     ylag1
% %     N
% %     t
% %     range(end)
% %     pause
% % end

v = zeros(4,1);
%% Diferential Equation and add tol=0.0001 for control stability 
v(1,1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1) +0.0001;
v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2)  +0.0001;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
v(3,1) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1)+gammasR*ylag6(4)  +0.0001 ;%dr
v(4,1) = gammasUCI*ylag5(2)-gammasR*ylag6(4) +0.0001 ; %du

% if opcion_model==10
% 
%     salida = 'en opcion model'
% end



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


