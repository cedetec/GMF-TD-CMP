%% R effective plot for GSIRM (model 2022, opcionModel=2)
%% Usamos los valores de Inf, InfR, InfDa calculados en compute_curves_sin_vac
tg=(1:max(size(Data)));
[R,Rf,Rd] = Re1_sin_vac(p,N,x0,tg,nTau,nGammas,xd,Data,acumulada,ventana_general);
%% Plots
%figure
clf
tg=tg+I00-1;
I=find( mod(tg,2)==0 );
texp=tg(I);
%subplot(121);
plot(tg,InfR,'--k','LineWidth',1) % fr'.*y(2) <-- ajuste estimación usando el sigmoide I_MODEL
hold on
plot(tg,Inf,'r','LineWidth',0.5) %Infectados obtenidos con Framework --> y(2) I_SOLVER
%% Fit the point (remember)
plot(texp,InfDa(I),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',2); %Infectados datos de origen I_DATA
grid on
maxdata=max(InfDa);
mindata=min(InfDa);
maxInf=max(Idays);
minInfR=min(InfR);
maxInfR=max(InfR);
xlabel('Time (days)','FontSize',14)
ylabel('Case incidence','FontSize',14)
axis([tg(1)-2 tg(end)+2 0.70*min(minInfR,mindata) 1.05*max(maxdata,maxInf)])
lgd=legend('Fitted $I$','Modeled $I$','Reported $I$');
set(lgd,'Location','northeast','Interpreter','latex','FontSize',16)
hold off;
%% Automatic tick labels
% if tg(end)-tg(1)>300
%     num_ticks = round((tg(end)-tg(1))/90); % Número deseado de ticks
% else
%     num_ticks = round((tg(end)-tg(1))/30);
% end
% ticks = linspace(tg(1),tg(end), num_ticks); % Ticks adaptativos 
% xticks(ticks);
% xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks, 'UniformOutput', false));
%% New code for automatic tick labels
if tg(end)-tg(1)>300
    num_ticks = round((tg(end)-tg(1))/150); % Número deseado de ticks
else
    num_ticks = round((tg(end)-tg(1))/50);
end
dticks = (tg(end)-tg(1)-1)/num_ticks;
ticks = tg(1):dticks:tg(end); % Ticks adaptativos
ticks = ceil(ticks);
rticks=mod(ticks(2:end),10);
i1=find(rticks==1);
ticks(i1+1)=ticks(i1+1)-1;
im1=find(rticks>1);
ticks(im1+1)=ticks(im1+1)+10-rticks(im1);
xticks(ticks);
ax=gca;
ax.FontSize=16;
xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks, 'UniformOutput', false));
%subplot(122);
tc=(1:max(size(Data)));
if tau2<round(tau2)
    I2=find(tc>tau2+1);
else
    I2=find(tc>tau2);
end
tc=tc(I2);
tc=tc+I00-1;
plot(tc,R,'r','LineWidth',0.5,'DisplayName','Modeled $R_e(t)$');
hold on;
plot(tc,Rf,'--k','LineWidth',1,'DisplayName','Fitted $R_e(t)$');
%lgd=legend;
%set(lgd,'Location','northwest','Interpreter','latex','FontSize',12)
grid on;
minplot=min( min( min(R),min(Rf) ) );
maxplot=max( max( max(R),max(Rf) ) );
if minplot>0
    ylim([0.95*minplot 1.05*maxplot])
else
    ylim([1.5*minplot 1.01*maxplot])
end
xlabel('Time (days)','FontSize',14)
ylabel('$R_e(t)$','FontSize',16,'Interpreter','latex')
line([tg(1)-2,tg(end)+2],[1,1],'Color','#006400','LineStyle','-.','LineWidth',1.0,'DisplayName','$R_e(t)=1$ for left axis');
xlim([tg(1)-2 tg(end)+2])
hold off
%% For plotting Rd (computed through the dataset)
tc=(1:max(size(Data)));
I5=find(tc>35);
tc=tc(I5);
I=find( mod(tc,2)==0 );
texp=tc(I);
if texp(1)>tc(1)
    texp=[tc(1), texp];
    I=[1, I];
end
if texp(end)<tc(end)
    texp=[texp,tc(end)];
    I=[I,length(tc)];
end
texp=texp+I00-1;
%% Plot of Rd on the right vertical axis
yyaxis right;
plot(texp,Rd(I),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',2,'DisplayName','Observed $R_e(t)$');
if min(Rd)<0
    ylim([1.5*min(Rd) 1.05*max(Rd)])
else
    ylim([0.95*min(Rd) 1.01*max(Rd)])
end
ylabel('Observed $R_e(t)$','FontSize',16,'Interpreter','latex')
%lgd=legend('Observed R');
%set(lgd,'Location','north','Interpreter','latex','FontSize',12)
hold on
line([tg(1)-2,tg(end)+2],[1,1],'Color','magenta','LineStyle',':','LineWidth',1.5,'DisplayName','$R_e(t)=1$ for right axis');
%xlim([tg(1)-2 tg(end)+2])
lgd=legend;
set(lgd,'Location','northeast','Interpreter','latex','FontSize',16)
hold off
% %% Automatic tick labels
% if tg(end)-tg(1)>300
%     num_ticks = round((tg(end)-tg(1))/90); % Número deseado de ticks
% else
%     num_ticks = round((tg(end)-tg(1))/30);
% end
% ticks = linspace(tg(1),tg(end), num_ticks); % Ticks adaptativos
% xticks(ticks);
% xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks, 'UniformOutput', false));
%% New code for automatic tick labels
if tg(end)-tg(1)>300
    num_ticks = round((tg(end)-tg(1))/150); % Número deseado de ticks
else
    num_ticks = round((tg(end)-tg(1))/50);
end
dticks = (tg(end)-tg(1)-1)/num_ticks;
ticks = tg(1):dticks:tg(end); % Ticks adaptativos
ticks = ceil(ticks);
rticks=mod(ticks(2:end),10);
i1=find(rticks==1);
ticks(i1+1)=ticks(i1+1)-1;
im1=find(rticks>1);
ticks(im1+1)=ticks(im1+1)+10-rticks(im1);
xticks(ticks);
ax=gca;
ax.FontSize=16;
xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks, 'UniformOutput', false));
axis square
shg
%% Plot of Rd in the same subplot only if scales allow it
% if (max(Rf)-max(Rd))/max(Rd) < 1
%     plot(texp,Rd(I),'sb','MarkerEdgeColor','b',...
%         'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',2); %Infectados datos de origen I_DATA
%     lgd=legend('Modeled R','Fitted R','Observed R');
%     minplot=min( min( min(R),min(Rf) ), min(Rd) );
%     maxplot=max( max( max(R),max(Rf) ), max(Rd) );
%     line([tg(1)-2,tg(end)+2],[1,1],'Color','black','LineStyle','-.','LineWidth',1.0);
%     xlim([tg(1)-2 tg(end)+2])
%     if minplot>0
%         ylim([0.95*minplot 1.05*maxplot])
%     else
%         ylim([1.5*minplot 1.05*maxplot])
%     end
%     xlabel('Time (days)','FontSize',14)
%     ylabel('$R_e(t)$','FontSize',16,'Interpreter','latex')
%     set(lgd,'Location','northwest','Interpreter','latex','FontSize',12)
%     hold off
%     %% Automatic tick labels
%     if tg(end)-tg(1)>300
%         num_ticks = round((tg(end)-tg(1))/90); % Número deseado de ticks
%     else
%         num_ticks = round((tg(end)-tg(1))/30);
%     end
%     ticks = linspace(tg(1),tg(end), num_ticks); % Ticks adaptativos
%     xticks(ticks);
%     xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks, 'UniformOutput', false));
%     shg
% else %If scales do not allow, plot of Rd is in another figure
    % minplot=min( min( min(R),min(Rf) ) );
    % maxplot=max( max( max(R),max(Rf) ) );
    % line([tg(1)-2,tg(end)+2],[1,1],'Color','black','LineStyle','-.','LineWidth',1.0);
    % xlim([tg(1)-2 tg(end)+2])
    % %lgd=legend('Modeled R','Fitted R');
    % if minplot>0
    %     ylim([0.95*minplot 1.05*maxplot])
    % else
    %     ylim([1.5*minplot 1.05*maxplot])
    % end
    % xlabel('Time (days)','FontSize',14)
    % ylabel('$R_e(t)$','FontSize',16,'Interpreter','latex')
    % set(lgd,'Location','northwest','Interpreter','latex','FontSize',12)
    % figure
    % plot(texp,Rd(I),'sb','MarkerEdgeColor','b',...
    %     'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',2);
    % xlabel('Time (days)','FontSize',14)
    % ylabel('Observed $R_e(t)$','FontSize',16,'Interpreter','latex')
    % grid on
    % hold on
    % line([tg(1)-2,tg(end)+2],[1,1],'Color','black','LineStyle','-.','LineWidth',1.0);
    % xlim([tg(1)-2 tg(end)+2])
    % if min(Rd)<0
    %     ylim([1.5*min(Rd) 1.05*max(Rd)])
    % else
    %     ylim([0.99*min(Rd) 1.05*max(Rd)])
    % end
    % %% Automatic tick labels
    % if tg(end)-tg(1)>300
    %     num_ticks = round((tg(end)-tg(1))/90); % Número deseado de ticks
    % else
    %     num_ticks = round((tg(end)-tg(1))/30);
    % end
    % ticks = linspace(tg(1),tg(end), num_ticks); % Ticks adaptativos
    % xticks(ticks);
    % xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks, 'UniformOutput', false));
    % hold off
    % shg
%end