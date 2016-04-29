addpath('function_code','utils','hidstate_2ndlayer_circle_(96f96f12ws18ws)')

fname=sprintf('3rd_POOL2(circle)_(96f96f144f12ws18ws18ws1rP10Pb01)_alloy_w18_b144_trans_ntx1_gr1_pb0.1_pl10_iter_2000');
load(sprintf('%s.mat',fname));


params.optgpu = 0;
spacing = 1;
ws=params.ws;
rs=params.rs;
kcd=params.kcd;
txtype = params.txtype;
grid = params.grid;
numrot=params.numrot;
% params.numrot = 1;
numch=params.numch;
% numch=1;
% numchannels=params.numch;
weight=gpu2cpu_struct(weight);


W=weight.vishid;

hbias_vec=weight.hidbias;
dataname='alloy_scale';
% dataname='image';
Tlist = get_txmat(params.txtype, params.rs, params.ws, params.grid, params.numrot, params.numch);
params.numtx = length(Tlist);

for ii = 1:60
fname=sprintf('hidstate_2ndlayer(1stp2)_POOL2(circle)_(96f96f12ws18wsP10Pb01)_%d',ii);
load([fname '.mat'],'hidstate')

image2=hidstate;
image2=reshape(image2,[sqrt(size(image2,1)) sqrt(size(image2,1)) size(image2,2)]);

image_reconstruct = crbm_3rdlayer(image2, patch, W,weight, Tlist, params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
end

