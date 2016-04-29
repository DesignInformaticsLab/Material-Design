xtr=zeros(60,50*50);
for i = 1:60    
    fname = sprintf('hardsphere_%d',i);
    load(sprintf('%s.mat',fname));
    I=double(im2bw(imresize(I,[50 50])));
    xtr(i,:)=I(:);
%     save(sprintf('%s.mat', fname2), 'I', '-v7.3');
end