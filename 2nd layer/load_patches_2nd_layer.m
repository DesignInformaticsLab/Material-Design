% -----------------------------------------------------------------------
%   load small patch of (ws x ws) from CIFAR-10 dataset
% -----------------------------------------------------------------------

function [xtr, patch, M, P] = load_patches_2nd_layer(npatch, ws)

prepare_2nd_layer;

% Load CIFAR training data
fprintf('Loading training data...\n');
% for ii = 1:99
% fname = sprintf('hidstates_%d',ii);
% f1=load(sprintf(CIFAR_DIR '/%s.mat', fname));   
% temp = double([f1.hidstate;]);
% xtr(ii,:) = temp(:)';
% % f1=load([CIFAR_DIR '/filter8_ws12.mat']);
% end
f1=load([CIFAR_DIR '/hidstate_1st_pool2.mat']);
xtr = double([f1.pool;]);
% xtr = gpuArray(xtr);

% xtr = double([f1.poshidstates;]);
% xtr = double([f1.hidstate;]);
% ytr = double([f1.labels;]) + 1; % add 1 to labels!
% xtr = permute(xtr,[1,2,3]);
% with rotation (data get from max's method)
% xtr = reshape(xtr,[size(xtr,1),size(xtr,2)*size(xtr,3)]);
% no rotation (data get from ruijin's method)
% xtr = reshape(xtr,[size(xtr,1),size(xtr,2)*size(xtr,3)]);


 clear f1;
fname = sprintf('hidstate_1st_pool2_f40_ws%d',ws);

if ~exist('patch','dir'),
    mkdir('patch');
end

try
    load(sprintf('patch/%s.mat', fname));
catch
    if npatch > 0,
        % extract random patch
        patch = zeros(npatch, ws*ws*CIFAR_DIM(3)); 
        for i=1:npatch
            if (mod(i,1000) == 0),
                fprintf('Extracting patch: %d / %d\n', i, npatch);
            end
            r = random('unid', CIFAR_DIM(1) - ws + 1);
            c = random('unid', CIFAR_DIM(2) - ws + 1);
            cpatch = reshape(xtr(mod(i-1,size(xtr,1))+1, :), CIFAR_DIM);
%             figure(1),display_network(reshape(cpatch,[361,8]));
%             for ii = 1:8
%                 figure(2),subplot(2,4,ii),imshow(cpatch(:,:,ii));
%             end
            cpatch = cpatch(r:r+ws-1,c:c+ws-1,:); 
            
%%            
%                         k=1;
%             sum(sum(cpatch))
%             while sum(sum(cpatch))<24 % less than 1%               
%                 r = random('unid', CIFAR_DIM(1) - ws + 1);
%                 c = random('unid', CIFAR_DIM(2) - ws + 1);
%                 cpatch = reshape(xtr(mod(i-1,size(xtr,1))+1, :), CIFAR_DIM);
%                 cpatch = cpatch(r:r+ws-1,c:c+ws-1,:);
%                 k=k+1;
%                 if k > 20
%                     break
%                 end
% 
%             end
%%            
            
            patch(i,:) = cpatch(:)';
        end
%%        
        % normalize for contrast
%         patch = bsxfun(@rdivide, bsxfun(@minus, patch, mean(patch,2)), sqrt(var(patch,[],2)+10));
        
        % whiten
%         C = cov(patch);
%         M = mean(patch);
%         [V,D] = eig(C);
%         P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
%         patch = bsxfun(@minus, patch, M) * P;
%%                 
    else
        patch = [];
        M = [];
        P = [];
    end
    patch = single(patch);
    save(sprintf('patch/%s.mat', fname), 'patch', '-v7.3');
end

patch = double(patch);

return