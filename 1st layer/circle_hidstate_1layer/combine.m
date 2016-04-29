for ii = 1:20
fname = sprintf('hidstates1th_nonorm_circle_(48f24wsP10Pb01)_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
% for i = 1:48
%     temp2=reshape(temp(:,i),[39 39]);
% %     temp2=im2bw(imresize(temp2,[97 97]));
%      temp3(:,i)=double(temp2(:));
% end



xtr(ii,:) = temp(:);
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
 fname2 = sprintf('hidstates1th_sandstone_imresize2_(24f6ws)_%d',ii);
 save(sprintf('%s.mat',fname2),'temp3', '-v7.3');