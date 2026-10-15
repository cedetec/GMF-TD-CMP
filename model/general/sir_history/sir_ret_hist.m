%% History function
function v=sir_ret_hist(t,p,N,x0)
v=zeros(4,1);
size_t=size(x0,1);
tramo =1:size_t;

vi = interp1(tramo,x0(:,2),t,'pchip');
vr = interp1(tramo,x0(:,3),t,'pchip');
vu = interp1(tramo,x0(:,4),t,'pchip');

v(1)=N-vi-vr-vu;
v(2)=vi;
v(3)=vr;
v(4)=vu;
