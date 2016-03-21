clear;
addpath('function_code','utils');

load('Tlist_12r_6ws_pi12.mat');
load('3rd_POOL2(imresize)_(real_bibi)_(2f40f144f6ws9ws9ws12rP20P10P10Pb01)_alloy_w9_b144_trans_ntx1_gr1_pb0.1_pl10_iter_1000.mat')
Two=load('WB_2nd_pool2_hidstate_(2f40f6ws9ws12rP20P20Pb01)_alloy_w9_b40_trans_ntx1_gr1_pb0.1_pl20_iter_2000.mat');
One=load('WB_nowh_P20Pb01_rot12_2f_6ws_alloy_w6_b02_rot_nrot12_pb0.1_pl20_iter_4000.mat');
numch = 40;

%% define 3rd layer filter
W_Three=gather(weight.vishid);
%% pool back 3rd layer filter by 2
for i = 1:size(W_Three,2)
    W_temp=reshape(W_Three(:,i),[9*9 40]);
    for j = 1:40
        W_temp2=reshape(W_temp(:,j),[9 9]);
        W_temp2=imresize(W_temp2,[9*2 9*2]);
        W_temp3(:,j)=W_temp2(:);
    end
    W_Three_Pool(:,i)=W_temp3(:);
end
clear W_temp3;clear W_temp2;clear W_temp;
W_Three=W_Three_Pool;

%% convolve with 2nd layer filter
W_two=Two.weight;
W_two=gather(W_two.vishid);

for i = 1:size(W_Three,2)
    negdata = zeros(18,18,24);
    W_Three_temp=reshape(W_Three(:,i),[18 18 40]);
    for j = 1:size(W_two,2)
        W_two_temp=reshape(W_two(:,j),[9 9 24]);        
        temp=conv2_mult(W_Three_temp(:,:,j),W_two_temp,'same');
        negdata = negdata + temp;
    end
    filter_2nd(i,:)=negdata(:);
end


%% pool back filter_2nd by 2
filter_2nd=filter_2nd';

for i = 1:size(filter_2nd,2)
    W_temp=reshape(filter_2nd(:,i),[18*18 24]);
    for j = 1:24
        W_temp2=reshape(W_temp(:,j),[18 18]);
        W_temp2=imresize(W_temp2,[18*2 18*2]);
        W_temp3(:,j)=W_temp2(:);
    end
    filter_2nd_Pool(:,i)=W_temp3(:);
end
clear W_temp3;clear W_temp2;clear W_temp;
W_Two=filter_2nd_Pool;



%% convolve with 1st layer filters
filter_t = One.weight;
filter_t = gather(filter_t.vishid);
vishid_down=filter_t;
numtx=12;numhid=2;
    num2nd_filter=144;
for i=1:num2nd_filter
        filter_2nd_temp=W_Two(:,i);
        negdata = zeros(36, 36);
    for nf = 1:numhid
        for nt = 1:numtx
            filter_t = full(Tlist{nt})'*vishid_down(:,nf);
            filter_t = reshape(filter_t,[sqrt(size(filter_t,1)),sqrt(size(filter_t,1)),1]);
            filter_2nd_test=reshape(filter_2nd_temp,[size(filter_2nd_temp,1)/numtx/numhid,numtx,numhid]);
            S = reshape(filter_2nd_test(:,nt,nf),sqrt(size(filter_2nd_test,1)),sqrt(size(filter_2nd_test,1)));

            temp = conv2(S, filter_t, 'same');
            negdata = negdata + temp;
        end
    end
%     figure(304),subplot(4,10,i),display_network(reshape(negdata,size(negdata,1)*size(negdata,2),1));
    filter_3rd_layer(:,i)=negdata(:);
end
