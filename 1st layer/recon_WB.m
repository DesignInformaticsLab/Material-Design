addpath('results','alloy_mat','function_code','utils')
fname=sprintf('circle_cut_nonor_ws12_f2_alloy_w12_b02_rot_nrot1_pb0.01_pl30_iter_1000');
load(sprintf('%s.mat',fname));
% addpath('../structure/');
load('circle_cut.mat')
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
% params.numch=36;
% numchannels=params.numch;
% weight=gpu2cpu_struct(weight);

W=gather(weight.vishid);
W=reshape(W,[size(W,1),1,size(W,2)]);
W=W(:,1,:);
hbias_vec=weight.hidbias;
dataname='alloy';
% dataname='image';
Tlist = get_txmat(params.txtype, params.rs, params.ws, params.grid, params.numrot, params.numch);
params.numtx = length(Tlist);




% sample the hidden layer
% get an image

% images_all = sample_images_all(dataname);
error_bound_dima=[];
error_mid_dima=[];
poolrat2f40_2ndlayer = zeros(40,89*89);
% average_act=zeros(4000,48);
% load('sample_x2.mat');
% sample_x=sample_x2;

%     H = randi(200,1,200);
%     H(H<100)=1;
%     H(H>1)=0;
%     Vr = h2v( rbm, H );
    
for ii = 1:80
% images_all = sample_images_all(dataname);

image = xtr(ii,:);
image = reshape(image,[200,200]);
    
    [image_reconstruct]= crbm_inference(image, patch, weight, Tlist, params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
    figure(7),display_network(reshape(image_reconstruct,size(image_reconstruct,1)*size(image_reconstruct,2),1));
    store2(:,ii)=image_reconstruct(:);
end