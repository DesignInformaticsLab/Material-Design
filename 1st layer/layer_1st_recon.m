addpath('utils','function_code','results')

% load trained weights and bias
fname=sprintf('WB_nowh_P20Pb01_rot12_2f_6ws_alloy_w6_b02_rot_nrot12_pb0.1_pl20_iter_4000');
load(sprintf('%s.mat',fname));
% load original image
load('WB.mat')
params.optgpu = 0;
spacing = 1;
% parameter settings
ws=params.ws;
rs=params.rs;
kcd=params.kcd;
txtype = params.txtype;
grid = params.grid;
numrot=params.numrot;
numch=params.numch;
% weight setting
W=gather(weight.vishid);
W=reshape(W,[size(W,1),1,size(W,2)]);
hbias_vec=weight.hidbias;
dataname='alloy';

Tlist = get_txmat(params.txtype, params.rs, params.ws, params.grid, params.numrot, params.numch);
params.numtx = length(Tlist);

    
for ii = 1:1
image = WB(ii,:);
image = reshape(image,[200,200]);
[image_reconstruct]= crbm_inference(pool_back,image, patch, weight, Tlist, params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
    
end
