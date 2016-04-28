%%%% generate new 2nd layer hidden states
addpath('../../../../Code/Tools/libsvm/matlab');

%% use gibbs sampling based on the conditional probabilities
num_randomimage = 60;
nchannel = 1; % 2nd layer filter size
nimage = 60; %100 images
H = 200; % image height
W = 200; % image width
patch_size = 15;
margin_size = (patch_size-1)/2;
batch_size = 100; % from each channel of each image, sample $batch_size$ patches

load(['./training_data/channel_conditional_model',num2str(patch_size),...
    '_batch',num2str(batch_size),'_0426.mat']);


gibbs_iter = 1;
max_gibbs_iter = 100;
error_tol = 0.05;
error = 1;

% input original image pixel id, output pixel id for the image with margins
image2margin = (1:H*W)'+...
    kron((H*margin_size+((2*margin_size)+(1:2:(2*W-1)))'*margin_size),ones(H,1));

patch_mesh_h = repmat((-margin_size:1:margin_size)',patch_size*H*W,1)+...
    repmat(kron((1:H)'+margin_size,ones(patch_size^2,1)),W,1);
patch_mesh_w = repmat(kron((-margin_size:1:margin_size)',ones(patch_size,1)),H*W,1)+...
    kron((1:W)'+margin_size,ones(patch_size^2*H,1));

all_pic = zeros(num_randomimage, H*W*nchannel);
for idx = 1:num_randomimage
    hidstate = ones(H,W,nchannel);
    for c = 1:nchannel
        fprintf('%%%%%%%%%%%%%%%%%%%% channel %%%%%%%%%%%%%%%%%%%%%');
        pic = rand(H+2*margin_size,W+2*margin_size);
        pic((1:H)+margin_size,(1:W)+margin_size) = hidstate(:,:,c);
        
        count = 1;
        for w = 1:W
            for h = 1:H
                patch_sampled_h = patch_mesh_h((count-1)*patch_size^2+(1:patch_size^2));
                patch_sampled_w = patch_mesh_w((count-1)*patch_size^2+(1:patch_size^2));
                count = count + 1;

                id = sub2ind(size(pic),patch_sampled_h,patch_sampled_w);
                hx = pic(id);
                hx((patch_size^2+1)/2:end) = [];
                
                vx = reshape(hidstate(h,w,[1:c-1,c+1:end]),nchannel-1,1);
                
                x = [hx;vx];
                
                [predicted_label, accuracy, prob] = ...
                    svmpredict(sparse(hidstate(h,w,c)),sparse(x'),models{c}, sprintf('-b 1'));
                id = models{c}.Label==1; % for white
                if rand < prob(id)
                    hidstate(h,w,c) = 1;
                else
                    hidstate(h,w,c) = -1;
                end
                pic((1:H)+margin_size,(1:W)+margin_size) = hidstate(:,:,c);
            end
        end
    end
    all_pic(idx,:) = hidstate(:);
end
save(['all_pic_material1alloy_patch_size',num2str(patch_size),'.mat'],'all_pic','-v7.3');
