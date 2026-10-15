load("Orig_data.mat")
load('data_xd_GEM_period1_250_rel4s4.mat')
Inf_data=zeros(972, size(data_xd,2) ); 
for i=1:size(data_xd,2)
        xd=reshape(data_xd(:,i),972,6);
        Id=xd(:,1);
        Idd=[Id(1); diff(Id)];
        Inf_data(:,i)=Idd;
end
clf; plot(tc, Inf_data(tc,:))
Inf_dataor = [xdor(1,1); diff( xdor(tc,1) )];
hold on; plot(tc, Inf_dataor,'o','Color','black','LineWidth',2,'MarkerSize',2)
shg