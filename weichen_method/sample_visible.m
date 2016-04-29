clear;
%%%%% generate all X-y training data based on 2nd hidden layer states

%% load raw data
nchannel = 1; % 2nd layer filter size
nimage = 100; %100 images
H = 200; % image height
W = 200; % image width

% test images
% a = imread('sample3.png');
% allhistate = reshape(a(:,:,1),1,1,H*W)>200;

load WB.mat;
allhistate = reshape(WB,[100,1,40000]);

if (~exist('allhistate','var'))
    allhistate = zeros(nimage, nchannel, H*W);
    for i = 1:nimage 
        cstr = [str,num2str(i),'.mat'];
        temp = load(cstr);
        temp = temp.hidstate;
        allhistate(i,:,:) = reshape(temp(:,1,:),nchannel,H*W);
    end
end
display_network(reshape(allhistate(1,1,:),H*W,1));

%% test the idea of CAR model


%% get data for the supervised learning idea from Wei Chen's paper
% Try the following first: Treat each image, each channel as the same
% The X is all the pixels around the current one, with width W, and height
% H. The y is the current pixel value.

% there are in total W*H*nchannel*nimage training X, each with patch_size^2+nchannel-2 values
% treat out-of-image pixels as 0, and all pixel values as -1 and 1
% patch_size = floor((W-1)/2)*2+1;

patch_size = 5;
margin_size = (patch_size-1)/2;
batch_size = 100; % from each channel of each image, sample $batch_size$ patches
% for each channel, the total amount of samples is batch_size*nimage

% input original image pixel id, output pixel id for the image with margins
image2margin = (1:H*W)'+...
    kron((H*margin_size+((2*margin_size)+(1:2:(2*W-1)))'*margin_size),ones(H,1));

if (~exist('batch_list','var'))
    batch_list = zeros(nchannel*nimage,batch_size);
    for i = 1:nchannel*nimage
        batch_list(i,:) = randperm(H*W,batch_size);
    end
end
batch_list = reshape(batch_list',batch_size*nimage,nchannel)';

% patch_mesh_h = repmat((-margin_size:1:margin_size)',patch_size*(H-2*margin_size)*(W-2*margin_size),1)+...
%     repmat(kron((1:(H-2*margin_size))'+margin_size,ones(patch_size^2,1)),(W-2*margin_size),1);
% patch_mesh_w = repmat(kron((-margin_size:1:margin_size)',ones(patch_size,1)),(H-2*margin_size)*(W-2*margin_size),1)+...
%     kron((1:(W-2*margin_size))'+margin_size,ones(patch_size^2*(H-2*margin_size),1));

patch_mesh_h = repmat((-margin_size:1:margin_size)',patch_size*H*W,1)+...
    repmat(kron((1:H)'+margin_size,ones(patch_size^2,1)),W,1);
patch_mesh_w = repmat(kron((-margin_size:1:margin_size)',ones(patch_size,1)),H*W,1)+...
    kron((1:W)'+margin_size,ones(patch_size^2*H,1));

X = zeros(batch_size*nchannel*nimage,(patch_size^2-1)/2+nchannel-1);
y = zeros(batch_size*nchannel*nimage,1);
count = 1;
for channel_id = 1:nchannel
    fprintf('channel_id = %d \n',channel_id);
    for image_id = 1:nimage
        fprintf('>');
        
        % load 2d image from channel_id and image_id, and add margin of
        % zeros
        pic = -ones(H+2*margin_size,W+2*margin_size);
        pic((1:H)+margin_size,(1:W)+margin_size) = ...
            reshape(allhistate(image_id,channel_id,:),H,W)*2-1;
        
        sampled_id = batch_list(channel_id,(image_id-1)*batch_size+(1:batch_size))';
        sampled_id = kron((sampled_id-1)*(patch_size^2),...
            ones(patch_size^2,1))+repmat((1:patch_size^2)',batch_size,1);
        
        patch_sampled_h = patch_mesh_h(sampled_id);
        patch_sampled_w = patch_mesh_w(sampled_id);
        
        % patch from the same channel
%         id = image2margin(sub2ind([H,W],patch_sampled_h,patch_sampled_w));
        id = sub2ind(size(pic),patch_sampled_h,patch_sampled_w);
        hpatch = pic(id); % patch from the same channel
        hpatch = reshape(hpatch,patch_size^2,batch_size)'; % convert to H*W patches of size (patch_size^2)
        y((channel_id-1)*(nimage*batch_size)+(image_id-1)*batch_size+(1:batch_size)) = hpatch(:,(patch_size^2+1)/2);
        if any(y((channel_id-1)*(nimage*batch_size)+(image_id-1)*batch_size+(1:batch_size))==0)
            wait = 1;
        end
        
        hpatch(:,(patch_size^2+1)/2:end) = [];
        

        
        % patch from the same location accross channels
        pic = allhistate(image_id,[1:(channel_id-1),(channel_id+1):end],:)*2-1;
        vpatch = reshape(pic,nchannel-1,H*W)';
        vpatch = vpatch(batch_list(channel_id,(image_id-1)*batch_size+(1:batch_size)),:);
        
        X((channel_id-1)*(nimage*batch_size)+(image_id-1)*batch_size+(1:batch_size),:) = [hpatch,vpatch];
    end
end

save(['./training_data/channel_conditional_patch',num2str(patch_size),...
    '_batch',num2str(batch_size),'_0310.mat'],...
    'X','y','batch_list','-v7.3');