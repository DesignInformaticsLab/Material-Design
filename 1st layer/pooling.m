% load 1st layer hidden state
load('WB_nowh_hidstate_1layer(2f6ws12rP20Pb01)');
% 1st layer hidenstate pooling 
temp=[];temp2=[];temp3=[];
%pooling ratio
C=2;
%pool part
for i = 1:1
    for j = 1:24
    temp = xtr(i,:);
    temp = reshape(temp,[195*195,24]);
    temp = reshape(temp(:,j),[sqrt(size(temp,1)),sqrt(size(temp,1))]);
    for m = 1:(size(temp,1)-1)/C
        for n = 1:(size(temp,2)-1)/C
            block = temp(2*m-1:2*m,2*n-1:2*n);
            if sum(sum(block))>0
                temp2(m,n)= 1;
            else
                temp2(m,n)=0;
            end
        end
    end
    temp2_2(:,j) = reshape(temp2,[size(temp2,1)*size(temp2,2),1]);
    end
    temp3(i,:) = temp2_2(:);
end
pool = temp3;

% pool back part for testing reconstruction
for i = 1:1
    for j = 1:24
        temp=pool(i,:);
        temp=reshape(temp,[97*97 24]);
        temp=reshape(temp(:,j),[97 97]);
        for m = 1:97
            for n = 1:97
                if temp(m,n)==1
                    pool2(2*m-1:2*m,2*n-1:2*n)=1;
                else
                    pool2(2*m-1:2*m,2*n-1:2*n)=0;
                end
            end
        end
        pool2(195,:)=0;
        pool2(:,195)=0;
        pool2_2(:,j)=pool2(:);
    end
    pool_back(i,:)=pool2_2(:);
end
    