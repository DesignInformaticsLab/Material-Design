addpath('function_code','utils','hidstate_2ndlayer_alloy2_(24f40f6ws9ws)')

fname=sprintf('3rd_(alloy2)_(24f40f144f6w9ws9ws)_alloy_w9_b144_trans_ntx1_gr1_pb0.1_pl10_iter_1000');
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

for ii = 1:80
fname=sprintf('hidstate_2ndlayer_(p2p2)_alloy2_(24f40f6ws9ws)_%d',ii);
load([fname '.mat'],'hidstate')

image2=hidstate;
image2=reshape(image2,[sqrt(size(image2,1)) sqrt(size(image2,1)) size(image2,2)]);

image_reconstruct = crbm_3rdlayer(image2, patch, W,weight, Tlist, params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
end

