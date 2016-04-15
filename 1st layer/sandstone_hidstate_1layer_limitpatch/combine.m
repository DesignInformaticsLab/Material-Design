for ii = 1:60
fname = sprintf('hidstates1th_nonormnowhite_limitpatch_sandstone_(24f6ws1r)_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
for i = 1:24
    temp2=reshape(temp(:,i),[195 195]);
    temp2=im2bw(imresize(temp2,[97 97]));
    temp3(:,i)=double(temp2(:));
end
 fname2 = sprintf('hidstates1th_sandstone_limitpatch_imresize2_(24f6ws1r)_%d',ii);
 save(sprintf('%s.mat',fname2),'temp3', '-v7.3');

xtr(ii,:) = temp3(:)';
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
