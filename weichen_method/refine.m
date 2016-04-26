%%%% refine reconstructed image

%% test on existing images

% load 2nd layer states
addpath('./hidstate2nd_24r_2f_12ws');

str = 'hidstates2nd_';

nchannel = 96; % 2nd layer filter size
image_id = 1:100; %100 images
H = 78; % image height
W = 78; % image width

vis = zeros(length(image_id),H*W);
if (~exist('allhistate','var'))
    allhistate = zeros(length(image_id), nchannel, H*W);
    for i = 1:length(image_id) 
        cstr = [str,num2str(image_id(i)),'.mat'];
        temp = load(cstr);
        temp = temp.hidstate;
        allhistate(i,:,:) = reshape(temp(:,1,:),nchannel,H*W);
        vis(i,:) = reshape(synthesis(temp),1,H*W);
    end
end


% load original images
load('Scaled_BW.mat');
original_img = Scaled_BW;
display_network(original_img(1,:),100,100);
mean_activation = mean(mean(original_img));

% postprocess of reconstruction
vis_scaled = bsxfun(@minus, vis, min(vis,[],2));
vis_scaled = bsxfun(@rdivide, vis_scaled, max(vis_scaled,[],2));
mean(mean(vis_scaled))

% compare
id = 11;
org_img = reshape(original_img(id,:),100,100);
org_img = reshape(org_img(12:89,12:89)+0.0,H*W,1);
figure(1);display_network(org_img,H*W,1);
figure(3);imagesc(reshape(vis_scaled(id,:),H,W));
% bin = vis_scaled(id,:)'>0.5+0.0;
figure(2);display_network(bin(id,:)',H*W,1);

% try a simple idea
bin = zeros(100,H*W);
for id = 1:100
    vis_sig = sigmoid((vis_scaled(id,:)'*2-1));
    [f,x] = ecdf(vis_sig);
    cut_point = find(f>(1-mean_activation),1);
    b = x(cut_point);
    bin(id,:) = vis_sig>b+0.0;
    mean(mean(bin(id,:)))
    figure(2);display_network(bin(id,:),H*W,1);
end
save('./reconstructed/reconstructed_binary.mat','bin');

%% refine
% constraints:
% - volume fraction
% - continuity (in tangent direction?)

