for i = 1:20
    
    fname = sprintf('%d',i);
    xtr=imread(sprintf('%s.png', fname));
    xtr=rgb2gray(xtr);
    I=double(im2bw(xtr,0.3));
    fname2=sprintf('sandstone_%d',i);
    save(sprintf('%s.mat', fname2), 'I', '-v7.3');
end