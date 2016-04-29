%%%% training proposed models
% all training data are stored under ./training_data


%% train channel-wise conditional probability models
% data: channel_conditional
% - X, y are pixels sampled from each channel
% - X (batch_size*nimage*nchannel,patch_size^2-2+nchannel)
% - y (batch_size*nimage*nchannel,1)
% - batch_list contains pixel indices from each channel and image

% load data
patch_size = 45;
batch_size = 100;
file = ['./training_data/channel_conditional_patch',num2str(patch_size),...
    '_batch',num2str(batch_size),'_0426.mat'];
load(file);

% try logistic regression

% add liblinear
addpath('../libsvm/');

nchannel = 1; % 2nd layer filter size
nimage = 60; %100 images
H = 200; % image height
W = 200; % image width
margin_size = (patch_size-1)/2;

% train channel-wise models
models = cell(nchannel,1);
cset = [1];
cverror = zeros(length(cset),1);
for i = 1:nchannel
    yy = y((i-1)*(nimage*batch_size)+(1:batch_size*nimage),:);
    XX = X((i-1)*(nimage*batch_size)+(1:batch_size*nimage),:);
    for cid = 1:length(cset)
        cverror(cid) = svmtrain(sparse(yy), sparse(XX), sprintf(['-v 3 -s 0 -e 1e-6 -b 1 -q -c ', num2str(cset(cid))]));
    end
    models{i,1} = svmtrain(sparse(yy), sparse(XX), sprintf(['-s 0 -e 1e-6 -b 1 -q -c ',num2str(cset(find(cverror==max(cverror),1)))]));
end


% test training error
for i = 1:nchannel
    yy = y((i-1)*(nimage*batch_size)+(1:batch_size*nimage),:);
    XX = X((i-1)*(nimage*batch_size)+(1:batch_size*nimage),:);
    [predicted_label, accuracy] = svmpredict(sparse(yy),sparse(XX),models{i});
end

save(['./training_data/channel_conditional_model',num2str(patch_size),...
    '_batch',num2str(batch_size),'_0426.mat'],...
    'models','-v7.3');
