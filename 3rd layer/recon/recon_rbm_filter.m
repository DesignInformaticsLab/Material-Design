% clear;
addpath('function_code','utils');

load('filter_3rd_layer.mat');
load('W_temp.mat')
numch = 144;

%define 3rd layer filter
W_rbm=W_temp;
%pool back 3rd layer filter
for i = 1:size(W_rbm,2)
    W_temp=reshape(W_rbm(:,i),[36*36 numch]);
    for j = 1:numch
        W_temp2=reshape(W_temp(:,j),[36 36]);
        W_temp2=imresize(W_temp2,[36*4 36*4]);
        W_temp3(:,j)=W_temp2(:);
    end
    W_Three_Pool(:,i)=W_temp3(:);
end
clear W_temp3;clear W_temp2;clear W_temp;
W_rbm=W_Three_Pool;


% define 2nd layer filter
filter_t_corr=store;

filter_t_corr=reshape(filter_t_corr,[numel(filter_t_corr)/numch,numch]);
for jj = 1:100
    j=x12(jj);
    filter_3rd_temp=W_rbm(:,j);

negdata = zeros(144, 144);
for i=1:numch
%     for ii =1:size(filter_t,2)
        filter_t_temp=filter_t_corr(:,i);
        filter_t_temp=reshape(filter_t_temp,[sqrt(size(filter_t_corr,1)),sqrt(size(filter_t_corr,1))]);
        filter_3rd = filter_3rd_temp((i-1)*size(W_rbm,1)/numch+1:i*size(W_rbm,1)/numch,:);
        filter_3rd=reshape(filter_3rd,[sqrt(size(W_rbm,1)/numch),sqrt(size(W_rbm,1)/numch)]);
%         filter_t_temp=abs(filter_t_temp-1); %flip the filter, display 0.25~1
%         temp2=conv2(filter_t_temp,filter_3rd,'same');
        temp3=conv2(filter_3rd,filter_t_temp,'same');
%         figure(18),subplot(12,12,i),imshow(temp3,[-5 5])
        negdata = temp3+negdata;
%         negdata=sigmoid(negdata);
%         figure(5+10);subplot(10,10,i),imshow(negdata);
%         figure(j+10); subplot(1,8)imshow(negdata) negdata = temp2+negdata;
%     end
end
rbm_filters(:,jj)=negdata(:);
if mod(jj,100)==0
    wait=1;
end
end
