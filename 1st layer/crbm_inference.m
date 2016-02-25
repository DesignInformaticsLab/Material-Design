%% crbm_inference
function [poshidexp2] = crbm_inference(pool_back, image, patch, weight, Tlist, params,ii)
    rng(0);
    numchannels = 1; % weight.vishid assumes a single channel
    W = gather(weight.vishid);
    ws = sqrt(size(W,1));
%     ws = 24;
    numhid = size(W,2); % number of filters
    numtx = size(Tlist,1);
    batchsize = (size(image,1)-ws+1)*(size(image,2)-ws+1);
%     batchsize = 1;
    numvis = params.numvis;
   

    hidprob = zeros(numhid, numtx+1, batchsize, 'single');
    % reshape for speedup
    vishid_up = W;
    vishid_down = W;
    if strcmp(params.intype, 'real'),
        vishid_up = 1/weight.sigma*vishid_up;
        vishid_down = weight.sigma*vishid_down;
    end
    hbiasmat = reshape(repmat(weight.hidbias(:,1:numtx), [1, 1, batchsize]), numhid, numtx*batchsize);
    vbiasmat = repmat(weight.visbias, [1, batchsize]);
    
    % get batches from a single image
%     xb = 
    
%     im2 = trim_image_for_spacing_fixconv(imdata, ws, spacing);
    [H,L] = size(image);
    
%     xb = reshape(image(10:ws+9,10:ws+9),[1,ws*ws]);
%     xb = patch.patch(1,:);
    num_patch = (L-ws+1)*(H-ws+1);
    xb = zeros(num_patch, ws^2);
    for i = 1 : (L-ws+1)
        for j = 1 : (H-ws+1)       
            temp = image(j:ws+j-1,i:ws+i-1);
            xb(j+(L-ws+1)*(i-1),:) = reshape(temp,[1,ws*ws]);       
        end    
    end
    
    A = zeros(size(Tlist{1}, 1)*params.numtx, size(Tlist{1}, 2), 'single');
    if params.optgpu,
        A = gpuArray(A);
    end

    for i = 1:params.numtx,
        if params.optgpu,
            A((i-1)*size(Tlist{1}, 1)+1:i*size(Tlist{1}, 1), :) = gpuArray(single(full(Tlist{i})));
        else
            A((i-1)*size(Tlist{1}, 1)+1:i*size(Tlist{1}, 1), :) = full(Tlist{i});
        end
    end
    Tlist_matrix = A; clear A;

    % positive phase       
    Tx = reshape(Tlist_matrix*xb', numvis, numtx*batchsize);
    hidprob = reshape(hidprob, numhid, numtx+1, batchsize);

    hidprob(:, 1:numtx, :) = gather(reshape(vishid_up'*Tx + hbiasmat, numhid, numtx, batchsize));
    hidprob(:, numtx+1, :) = 0;
    hidprob = exp(bsxfun(@minus, hidprob, max(hidprob, [], 2)));
    hidprob = bsxfun(@rdivide, hidprob, sum(hidprob, 2));
    
    % negative phase
    % hidden sampling
    hidprob = reshape(permute(hidprob, [2 1 3]), numtx+1, numhid*batchsize);
    [hidstate, ~] = sample_multinomial(hidprob, params.optgpu);
    hidstate = reshape(hidstate(1:numtx, :), numtx, numhid, batchsize);
    
%     xtr=reshape(hidstate,[24 38025])';
%     C=2;
%     for j = 1:24
%     temp = reshape(xtr(:,j),[sqrt(size(xtr,1)),sqrt(size(xtr,1))]);
%     for m = 1:(size(temp,1)-1)/C
%         for n = 1:(size(temp,2)-1)/C
%             block = temp(2*m-1:2*m,2*n-1:2*n);
%             if sum(sum(block))>0
%                 temp2(m,n)= 1;
%             else
%                 temp2(m,n)=0;
%             end
%         end
%     end
%     temp2_2(:,j) = reshape(temp2,[size(temp2,1)*size(temp2,2),1]);
%     end
%     temp3(ii,:) = temp2_2(:);
%     
%     pool = temp3;
% 
%     for i = 1:1
%     for j = 1:24
%         temp=pool(i,:);
%         temp=reshape(temp,[97*97 24]);
%         temp=reshape(temp(:,j),[97 97]);
%         for m = 1:97
%             for n = 1:97
%                 if temp(m,n)==1
%                     pool2(2*m-1:2*m,2*n-1:2*n)=1;
%                 else
%                     pool2(2*m-1:2*m,2*n-1:2*n)=0;
%                 end
%             end
%         end
%         pool2(195,:)=0;
%         pool2(:,195)=0;
%         pool2_2(:,j)=pool2(:);
%     end
%     pool_back(i,:)=pool2_2(:);
%     end

%%%% testing pool_back %%%%   
    hidstate = reshape(pool_back,[195*195 24])';
    hidstate = reshape(hidstate,[12 2 195*195]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    negdata = zeros(L, H, numchannels);
    for nf = 1:numhid
        for nt = 1:numtx
            filter_t = gather(full(Tlist{nt})'*vishid_down(:,nf));
            filter_t = reshape(filter_t,[ws,ws,numchannels]);
            S = reshape(hidstate(nt,nf,:),L-ws+1,H-ws+1);

            temp = conv2_mult(S, filter_t, 'full');
            negdata = negdata + temp;
        end
        if strcmp(params.intype, 'binary'),
            negdata = sigmoid(negdata);
        end
    end

        
    poshidexp2 = negdata;
    fprintf('Loading negdata %d...\n',ii);
    figure(1);
    display_network(reshape(negdata,size(negdata,1)*size(negdata,2),1));
    return
end