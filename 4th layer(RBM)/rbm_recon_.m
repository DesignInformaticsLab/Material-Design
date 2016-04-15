addpath('function_code','utils','results','hidstate_hardsphere_3rdlayer_p2p2_(24f40f288f6ws9ws9wsP10Pb01)')

fname=sprintf('rbm_hardsphere_4thlayer_(24f40f288f1000f6ws9ws9ws36wsP05Pb10)_alloy_w36_b1000_trans_ntx1_gr1_pb0.5_pl10_iter_800');
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
% Tlist = get_txmat(params.txtype, params.rs, params.ws, params.grid, params.numrot, params.numch);
params.numtx = 1;

for ii = 1:60
fname=sprintf('hidstates3nd_hardsphere_(p2p2)_(24f40f288f6ws9ws9wsP10Pb01)_%d',ii);
load([fname '.mat'],'hidstate')

image2=hidstate;
image2=permute(image2,[3 1 2]);
image2=reshape(image2,[sqrt(size(image2,1)) sqrt(size(image2,1)) size(image2,2)]);

image_reconstruct = crbm_4thlayer(image2, patch, W,weight,  params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
end

