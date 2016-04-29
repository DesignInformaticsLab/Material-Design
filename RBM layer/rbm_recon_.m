addpath('function_code','utils','circle_cut_hidstate_1layer','results')

fname=sprintf('rbm_2ndlayer_circlecut_(2f1000f12ws94wsP10Pb01)_alloy_w94_b1000_trans_ntx1_gr1_pb0.1_pl10_iter_200');
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

for ii = 1:80
fname=sprintf('hidstates1th_circlecut_imresize2_(2f12ws)_%d',ii);
load([fname '.mat'],'temp3')

image2=temp3;
image2=permute(image2,[3 1 2]);
image2=reshape(image2,[sqrt(size(image2,2)) sqrt(size(image2,2)) size(image2,3)]);


image_reconstruct = crbm_4thlayer(image2, patch, W,weight,  params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
% store_rbm(:,ii)=image_reconstruct(:);
end

