xtr=zeros(60,200*200);
for i = 1:60    
    fname = sprintf('sandstone_%d',i);
    load(sprintf('%s.mat',fname));
    I=double(im2bw(imresize(I,[200 200])));
    xtr(i,:)=I(:);
%     save(sprintf('%s.mat', fname2), 'I', '-v7.3');
end