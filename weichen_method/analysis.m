%% load data
load WB.mat;
allhistate = reshape(WB,[100,1,40000]);

nchannel = 1; % 2nd layer filter size
nimage = 100; %100 images
H = 200; % image height
W = 200; % image width

allhistate = zeros(nimage, nchannel, H*W);
for i = 1:nimage 
    cstr = [str,num2str(i),'.mat'];
    temp = load(cstr);
    temp = temp.hidstate;
    allhistate(i,:,:) = reshape(temp(:,1,:),nchannel,H*W);
end

%% analysis
% get mean at each channel
state_mean_channel = mean(mean(allhistate, 3),1);
% get covariance of channels
state_cov_channel = cov(mean(allhistate, 3));
save('./training_data/mean_cov_channel.mat','state_mean_channel','state_cov_channel');


state_sum = sum(allhistate, 3);
state_avg = mean(allhistate, 3);
state_avg_mean = mean(state_avg, 1);
state_avg_std = std(state_avg);
imagesc(state_avg,'EraseMode','none',[0 1]);
figure;hist(state_avg(:,4));

% how do each hidden channel look like? There are still patterns...
imagesc(reshape(allhistate(1,3,:),H,W),'EraseMode','none',[0 1])
imagesc(reshape(mean(allhistate(:,5,:)),H,W),'EraseMode','none',[0 1])

% look at covariance and correlation. Some channels are highly correlated
state_avg_zeromean = bsxfun(@minus, state_avg , state_avg_mean);
covariance = state_avg_zeromean'*state_avg_zeromean;
imagesc(covariance,'EraseMode','none');

state_avg_standardscaled = bsxfun(@rdivide, state_avg_zeromean, state_avg_std);
correlation = state_avg_standardscaled'*state_avg_standardscaled/(nimage-1);
figure;imagesc(correlation,'EraseMode','none',[-1 1]);

% for each pixel location, is the state sparse across all channels?
imagesc(reshape(mean(mean(allhistate,2),1),H,W),'EraseMode','none',[0 1])
temp = reshape(mean(mean(allhistate,2),1),H*W,1);
figure;hist(temp);

% check eigenvalues of the hidden state data
X = reshape(allhistate, nimage, nchannel*H*W);
X = bsxfun(@rdivide, bsxfun(@minus, X, mean(X,1)), (std(X)+1e-3));
