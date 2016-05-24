C=2;
for ii = 1:80
    fname = sprintf('hidstates1th_circle_limit_cut_(1f12wsP30Pb01)_%d',ii);
    f1=load(sprintf('%s.mat', fname));
    temp = double([f1.hidstate;]);
    temp = permute(temp,[3,2,1]);
    for i = 1:1
        temp2=reshape(temp(:,i),[sqrt(size(temp,1)) sqrt(size(temp,1))]);
        for j = 1:floor(sqrt(size(temp,1))/C)
            for k = 1:floor(sqrt(size(temp,1))/C)
                if sum(sum(temp2(C*(j-1)+1:C*j,C*(k-1)+1:C*k)))>=1
                    pool(j,k)=1;
                else
                    pool(j,k)=0;
                end
            end
        end
        %     temp2=im2bw(imresize(temp2,[97 97]));
        temp3(:,i)=double(pool(:));
    end
%     
%     
%     fname2 = sprintf('hidstates1thC4_circle_limit_cut_(2f12ws)_%d',ii);
%     save(sprintf('%s.mat',fname2),'temp3', '-v7.3');
    xtr(ii,:) = temp3(:);
    % f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end

%% pool back
% load('reconst_rand_C4.mat');
for i = 1:200
    temp=reshape(reconst_2to1(:,i),[47 47 2]);
    for ii = 1:size(temp,3)
        temp2=temp(:,:,ii);
        temp3(:,:,ii)=imresize(temp2,[189 189]);
        
    end
    pool_back(:,i)=double(im2bw(temp3(:),0.95));
end

