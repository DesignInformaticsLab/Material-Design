for ii = 1:80
    fname = sprintf('hidstates1th_nonorm_circle_cut_(2f12wsP30Pb005)_%d',ii);
    f1=load(sprintf('%s.mat', fname));
    temp = double([f1.hidstate;]);
    temp = permute(temp,[3,2,1]);
    for i = 1:2
        temp2=reshape(temp(:,i),[189 189]);
        temp2=im2bw(imresize(temp2,[94 94]));
        temp3(:,i)=double(temp2(:));
    end
    fname2 = sprintf('hidstates1th_circlecut_imresize2_(2f12ws)_%d',ii);
    save(sprintf('%s.mat',fname2),'temp3', '-v7.3');
    
    
    xtr(ii,:) = temp3(:);
    % f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
