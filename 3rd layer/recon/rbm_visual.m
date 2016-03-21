addpath('function_code','utils','hidstate_3rdlayer_p2p2_(2f40f144f6ws9ws9ws12rP20P10P10Pb01)')

% fname=sprintf('rbm');
% load(sprintf('%s.mat',fname));


params.optgpu = 0;
spacing = 1;
params.ws=36;
params.rs=36;
params.kcd=1;
params.txtype = 'trans';
params.grid = 1;
params.numrot=1;
params.numch=144;
params.intype='binary';
W=rbm.W;

hbias_vec=rbm.c;
dataname='alloy_scale';
% dataname='image';
params.numtx = 1;

for ii = 1:100
fname=sprintf('hidstates3nd_WB_nowh(p2p2)_imresize_(2f40f144f6ws9ws9ws12rP20P10P10Pb01)_%d',ii);
load([fname '.mat'],'hidstate')

image2=hidstate;
image2=reshape(image2,[144 1296])';
image2=reshape(image2,[sqrt(size(image2,1)) sqrt(size(image2,1)) size(image2,2)]);

image_reconstruct = rbm_3rdlayer(image2, patch, W, hbias_vec, params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
end

