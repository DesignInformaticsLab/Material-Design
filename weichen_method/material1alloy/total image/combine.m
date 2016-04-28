addpath('../XY_plane');
addpath('../XZ_plane');
addpath('../YZ_plane');
xtr=zeros(200*200,60);
for i = 1:60    
    fname = sprintf('alloy2_%d',i);
    load(sprintf('%s.mat',fname));
    I=double(im2bw(imresize(I,[200 200])));
    xtr(:,i)=I(:);
%     save(sprintf('%s.mat', fname2), 'I', '-v7.3');
end