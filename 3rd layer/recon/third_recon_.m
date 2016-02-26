addpath('function_code','utils','hidstate_2ndlayer_POOL2_(2f40f6ws9ws12rP20P10Pb01)')

fname=sprintf('3rd_POOL2_(real_bibi)_(2f40f24f6ws9ws18ws12rP20P10P40Pb01)_alloy_w18_b24_trans_ntx1_gr1_pb0.1_pl10_iter_1000');
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
% temp=zeros(24^2,8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:size(W,2)
%     temp(:,i)=W(1:24^2,i);
% end
% W=temp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% W=reshape(W,[size(W,1),1,size(W,2)]);
% W=W(:,1,:);
hbias_vec=weight.hidbias;
dataname='alloy_scale';
% dataname='image';
Tlist = get_txmat(params.txtype, params.rs, params.ws, params.grid, params.numrot, params.numch);
params.numtx = length(Tlist);




% sample the hidden layer
% get an image
% images_all = sample_images_all(dataname);
% for ii = 1:99
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% images_all = sample_images_all(dataname);
% image = images_all{1};
% image = image - mean(image(:));
% image = trim_image_for_spacing_fixconv(image, ws, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% temp=permute(hidstate,[3,1,2]);
% image=reshape(temp(:,1,3),[89,89]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUIJIN
% temp=permute(hidstate,[3,1,2]);
% temp1_hidstate=reshape(temp,[89,89,36]);
% temp2_W=reshape(W,[24,24,36,8]);
% 
% combine=zeros(24,24,8);
% for i = 1:8
%     temp2_t=temp2_W(:,:,:,i);
%     temp2_t=reshape(temp2_t,[24,24,36]);
%     for j = 1:36
%         temp1=temp1_hidstate(:,:,j);
%         temp1=reshape(temp1,[89,89]);
%         temp2=temp2_t(:,:,j);
%         temp2=reshape(temp2,[24,24]);
% %         for i
%             temp2=temp2(end:-1:1,end:-1:1);
% %         end
%         combine(:,:,i)=conv2(temp1,temp2,'same')+combine(:,:,i);
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('recon_from2to1');
% image2=negdata;
for ii = 1:100
fname=sprintf('hidstate_2ndlayer_POOL2_(2f40f6ws9ws12rP20P10Pb01)_%d',ii);
load([fname '.mat'],'hidstate')

image2=hidstate;
image2=reshape(image2,[sqrt(size(image2,1)) sqrt(size(image2,1)) size(image2,2)]);

% image2=image2(:,:,1);
% load('2ndlayer_hidstate.mat');
% hidstate=permute(hidstate,[3,2,1]);
% image2=reshape(hidstate,[54,54,8]);
% image2=image2(:,:,7);
% fname = sprintf('Scaled_Gray_alloy_ws_%d',ws);
% patch=load(sprintf('%s.mat', fname));
% detection = hidden_layer_detection(image, patch, weight, Tlist, params);
% display_network(reshape(detection,size(detection,1)*size(detection,2),1))
% if 1
%     % MAX way
    image_reconstruct = crbm_3rdlayer(image2, patch, W,weight, Tlist, params,ii); % remove rbm1.pars and set the value0.2 inside the function 10/15/2015
end

