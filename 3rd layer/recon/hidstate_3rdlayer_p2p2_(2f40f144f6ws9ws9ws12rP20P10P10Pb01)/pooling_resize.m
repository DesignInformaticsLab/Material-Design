% load 2nd layer hidden state
% load('hidstate_2ndlayer(1stlayerpool2)_WB_nowh_(2f40f6ws9ws12rP20P10Pb01)');
% 1st layer hidenstate pooling 
temp=[];temp2=[];temp3=[];
%pooling ratio
C=2;
%pool part
for i = 1:100
    fname = sprintf('hidstates3nd_WB_nowh(p2p2)_imresize_(2f40f144f6ws9ws9ws12rP20P10P10Pb01)_%d',i);
    load(sprintf('%s.mat', fname)); 
    hidstate = reshape(hidstate,[144 1296])';
    for j = 1:144
        temp = reshape(hidstate(:,j),[36,36]);
        temp = imresize(temp,[18 18]);
        temp = double(im2bw(temp));

        temp2(:,j) = temp(:);
    
   
    end
%     fname = sprintf('hidstate_2ndlayer_POOL2(imresize)_(2f40f6ws9ws12rP20P10Pb01)_%d',i);
%     save(sprintf('%s.mat',fname),'hidstate', '-v7.3');

    temp3(i,:) = temp2(:);
end
pool = temp3;