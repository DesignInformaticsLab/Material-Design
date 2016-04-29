clear
%%%% 2nd layer filter visualization %%%%
numhid=96;numtx=1;
addpath('utils','function_code');

load('circle_nonor_ws12_f96_alloy_w12_b96_rot_nrot1_pb0.1_pl10_iter_3000.mat');
sigma=gather(weight.sigma);
filters_t=gather(weight.vishid);
% load('Tlist_6ws_1r.mat');
% 
load('circle_2nd_imresize2_hidstate_(96f96f6ws9wsPb03)_alloy_w18_b96_trans_ntx1_gr1_pb0.1_pl10_iter_2000.mat')
filter_2nd=gather(weight.vishid);
%% filter pooling back
for i = 1:size(filter_2nd,2)
    W_temp=reshape(filter_2nd(:,i),[18*18 96]);
    for j = 1:96
        W_temp2=reshape(W_temp(:,j),[18 18]);
        W_temp2=imresize(W_temp2,[18*2 18*2]);
        W_temp3(:,j)=W_temp2(:);
    end
    W_two(:,i)=W_temp3(:);
end
    filter_2nd=W_two;
    vishid_up = filters_t;
    vishid_down = filters_t;
%% filter visualization
    num2nd_filter=96;
for i=1:num2nd_filter
        filter_2nd_temp=filter_2nd(:,i);
        negdata = zeros(12+36-1, 12+36-1);
    for nf = 1:numhid
        for nt = 1:numtx
%             filter_t = full(Tlist{nt})'*vishid_down(:,nf);
            filter_t = vishid_down(:,nf);
            filter_t = reshape(filter_t,[sqrt(size(filter_t,1)),sqrt(size(filter_t,1)),1]);
            filter_2nd_test=reshape(filter_2nd_temp,[size(filter_2nd_temp,1)/numtx/numhid,numtx,numhid]);
            S = reshape(filter_2nd_test(:,nt,nf),sqrt(size(filter_2nd_test,1)),sqrt(size(filter_2nd_test,1)));

            temp = conv2(S, filter_t, 'full');
            negdata = negdata + temp;
        end
    end
    figure(305),subplot(10,10,i),display_network(reshape(negdata,size(negdata,1)*size(negdata,2),1));
    filter_2nd_layer(i,:)=negdata(:);
end