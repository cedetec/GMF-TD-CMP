% set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
% set(groot, 'defaultLegendInterpreter', 'latex');
% set(groot, 'defaultTextInterpreter', 'latex');

load('Orig_data.mat');
%opcionModel=1;

% If=zeros(max(size(Data)), cantidad );
% Id=zeros(max(size(Data)), cantidad );
%% Para no ejecutar el main antes (no funciona porque se cambia el valor de diaInicio)
% diaInicio=1; diaFinEstudio=250;
% diaFin=diaFinEstudio;
% cantidad=100;
% acumulada=2;
% percentPrunning = 1;
% variante_sier = 1;
% grafica_data=0; 
% flagpause=0; % for pause on visualization
% ventana_general=60;
% ventana=ventana_general;
% region = 'Metropolitana';
% data_times_processing
% tc=diaInicio:diaFinEstudio;

close all
load('data_xd_GEM_test4.mat')
load("data_p_GEM_test4.mat");
load("data_InfR_GEM_test4.mat");
load("data_resnorm_GEM_test4.mat");
cantidad=100;
pred=1;
calc=0;
er = data_resnorm;
%nF=210;
nF=120;
%% Plot of fitted curves with random perturbation of original data
% ibest=find(er==min(er));
% Ifbest=If(:,ibest);
% figure; plot(tg,Ifbest,'--k','LineWidth',2);
% hold on
% Iff=If;
% Iff(:,ibest)=[];
% plot(tg,Iff);
%% Compute best curve, LB, and UB curves (Prediction enveloppe)
% Best curve and original data
% ib=find(er==min(er));
% pb=data_p(:,ib);
% xd=reshape(data_xd(:,ib),972,6);
% Data=xd(tc,:);
% all_blocks_params_model_analytics_hibridas
%[tp,Ifb,Ub] = computepred(pb,x0,nF,acumulada,nTau,N,opcionModel,vectorInicial);
%% CI computed with normality assumption (reasonable for the size)
Pm=mean(data_p,2);
Pstd=std(data_p,0,2);
Plb=Pm-tinv(0.975,cantidad-1)*Pstd/sqrt(cantidad);
Pub=Pm+tinv(0.975,cantidad-1)*Pstd/sqrt(cantidad);
 all_blocks_params_model_analytics_hibridas
if opcionModel==1
    vectorInicial = [N-xdor(diaInicio,1)-xdor(diaInicio,2)-xdor(diaInicio,3);Dataor(1,1);Dataor(1,2);Dataor(1,3)];
else
    vectorInicial = [N-xdor(diaInicio,1)-xdor(diaInicio,2);Dataor(1,1);Dataor(1,2)];
end
% LB curve
[tp,Iflb,Ulb] = computepred(tc,Plb,x0or,nF,acumulada,nTau,N,opcionModel,vectorInicial);
% Mean curve
[~,Ifm,Um] = computepred(tc,Pm,x0or,nF,acumulada,nTau,N,opcionModel,vectorInicial);
% UB curve
[~,Ifub,Uub] = computepred(tc,Pub,x0or,nF,acumulada,nTau,N,opcionModel,vectorInicial);
%% Statistics calculation forecasting
%Data
IDa = xdor(tp,1)';
IDa = diferenciasDiarias(IDa)';
if opcionModel==1
    UDa = xdor(tp,3)';
    UDa = diferenciasDiarias(UDa)';
end
ipred=(tc(end)+1:tc(end)+nF)';
MSEI  = mean( ( ( Ifm(ipred) - xdor(ipred,1) )./Ifm(ipred) ).^2 );
MREI = mean(  abs( Ifm(ipred) - xdor(ipred,1) )./Ifm(ipred) );

if opcionModel==1
    MSEU = mean( ( ( Um(ipred) - xdor(ipred,3) )./Um(ipred) ).^2 );
    MREU = mean( abs( Um(ipred) - xdor(ipred,3) )./Um(ipred) );
end
%% Mean Interval Score (MIS)
MISI = mean( abs(Ifub(ipred)-Iflb(ipred)) ...
           + (2/0.05)*( min(Iflb(ipred),Ifub(ipred))-IDa(ipred) ).*( IDa(ipred) < min(Iflb(ipred),Ifub(ipred)) )...
           + (2/0.05)*( IDa(ipred)-max(Iflb(ipred),Ifub(ipred)) ).*( IDa(ipred) > max(Iflb(ipred),Ifub(ipred)) ) );
% Coverage or the 95% prediction interval
cPI=round( 100*length( find(  ( IDa(ipred) >= min(Iflb(ipred),Ifub(ipred)) )  & ( IDa(ipred) <= max(Iflb(ipred),Ifub(ipred)) )  )  )/length(ipred), 2);
if opcionModel==1
    MISU = mean( abs(Uub(ipred)-Ulb(ipred)) ...
                 + (2/0.05)*( min(Ulb(ipred),Uub(ipred))-UDa(ipred) ).*( UDa(ipred) < min(Ulb(ipred),Uub(ipred)) )...
                 + (2/0.05)*( UDa(ipred)-max(Ulb(ipred),Uub(ipred)) ).*( UDa(ipred) > max(Ulb(ipred),Uub(ipred)) ) );
    cPU=round( 100*length( find( ( UDa(ipred) >= min(Ulb(ipred),Uub(ipred)) ) & ( UDa(ipred) <= max(Ulb(ipred),Uub(ipred)) )  )  )/length(ipred), 2);
end
%% Beginning of calculation for ploting
%% Shaded prediction interval
ipred=(tc(end):tc(end)+nF)';
Iflb_ip=Iflb(ipred);
Ifm_ip  = Ifm(ipred);
Ifub_ip = Ifub(ipred);
Iflb_ip = Iflb_ip(:);
Ifm_ip  = Ifm_ip(:);
Ifub_ip = Ifub_ip(:);
ipred   = ipred(:);
X = [ipred; flipud(ipred)];
Y1 = [Iflb_ip; flipud(Ifm_ip)];   % inferior -> media
Y2 = [Ifm_ip;  flipud(Ifub_ip)];  % media -> superior
%% Definitions for good exportation into pdf files
% 1. Definir un tamaño físico controlado para la ventana de la figura
% Esto evita que al exportar a EPS el texto se desproporcione.
%fig = figure('Position', [100, 100, 600, 450]); 
fig=figure; hold on;

% 2. Crear tu gráfico usando 'tiledlayout' (herramienta nativa moderna)
% Aquí es donde se aplica el "TileSpacing" de forma correcta.
t = tiledlayout(1, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
ax = nexttile;

%% I Plot 
fill(ax,X, Y1, [0.502,0.749,1], 'EdgeColor','none', 'FaceAlpha',0.35,'DisplayName','Pred. Int.');
fill(ax,X, Y2, [0.502,0.749,1], 'EdgeColor','none', 'FaceAlpha',0.35);

plot(ax,tp, Ifm, 'b', 'LineWidth', 2,'DisplayName','Mean curve');
plot(ax,tp, Iflb, '--g', 'LineWidth', 1.5,'DisplayName','LB curve');
plot(ax,tp, Ifub, '-.k', 'LineWidth', 1.5,'DisplayName','UB curve');

set(gca,'Layer','top') 
% Original data
ii=find( mod(tp,4)==0 );
ii=[1; ii; length(tp)];
texp = tp(ii);
plot(ax,texp,IDa(ii),'ro','LineWidth',1.5,'MarkerSize',2,'DisplayName','Data');
%
maxInf=max(Ifub(tc));
maxInf=max( maxInf, max(Iflb(tc)) );
minInf=min(Iflb(tc));
minInf=min(minInf,min(Ifub(tc)));
mindata=min(diferenciasDiarias(xdor(tp,1)'));
maxdata=max(diferenciasDiarias(xdor(tp,1)'));
line(ax,[tc(end), tc(end)], [0.01*min(minInf,mindata) 1.05*max(maxdata,maxInf)],...
    'LineStyle',':','LineWidth',1,'Color','black','DisplayName','End of calibration');
xlabel('Time (days)','FontSize',12)
ylabel('Cases incidence','FontSize',12)
axis([tp(1)-2 tp(end)+2 0.01*min(minInf,mindata) 1.01*max(maxdata,maxInf)]);
ax=gca;
ax.FontSize=16;
%h = [h1 h2 h3 h4 h5 h6 h7];      % incluir sólo los handles que quieres en leyenda
%h = h(isgraphics(h));            % filtrar inválidos
lgd = legend(ax, 'Location','northwest');
%set(lgd,'Location','northwest','FontSize',12);
%lgd = legend([h1 h2 h4 h3], {'Modeled','Fitted','Observed','$R_e(t)=1$ (left)'}, 'Interpreter','latex','Location','southeast');
%lgd.AutoUpdate = 'off';
% lgd.AutoUpdate = 'off';

% 3. Configurar la fuente GLOBAL de los ejes (Labels y números crecerán juntos)
set(ax, 'FontSize', 12);

% 4. Insertar la leyenda de forma externa pero vinculada al Layout
%lgd = legend(ax, 'Seno de X', 'Location', 'eastoutside');
%set(lgd,'Location','northwest','Interpreter','latex','FontSize',12)
%lgd.String = strcat(lgd.String, '    '); 
%lgd.String = strcat(lgd.String, '\;\;\;'); 
drawnow;

% 5. Truco para estirar la caja vectorialmente si el texto sigue al límite
% (Multiplica el ancho actual por un 10% adicional de seguridad)
pos = lgd.Position;
pos(3) = pos(3) * 1.05; 
lgd.Position = pos;

% 6. Forzar el renderizado vectorial limpio (Painters)
fig.Renderer = 'opengl';
findobj(gcf,'Type','line')    % lista handles de líneas
% 6. Exportar a formato EPS de forma ajustada y recortada
exportgraphics(fig, 'Fig4.pdf', 'ContentType', 'vector','BackgroundColor','none');
hold off
shg

cla(ax)
fill(ax,X,Y1,[.5 .75 1],'EdgeColor','none','FaceAlpha',0.35);
fill(ax,X,Y2,[.5 .75 1],'EdgeColor','none','FaceAlpha',0.35);
plot(ax,tp,Ifm,'b','LineWidth',2);
plot(ax,tp,Iflb,'--g','LineWidth',1.5);
plot(ax,tp,Ifub,'-.k','LineWidth',1.5);
scatter(ax,texp,IDa(ii),'ro','LineWidth',1.5);
xlim(ax,[min([tp;X]) max([tp;X])]);
ylim(ax,[min([0; Iflb; IDa]) 1.05*max([Ifub; IDa])]);
drawnow
shg