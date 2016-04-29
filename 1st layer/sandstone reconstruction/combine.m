for i = 1:60
    temp=reshape(store2(:,i),[50 50]);
    temp=double(im2bw(imresize(temp,[200 200])));
    random_recon(:,i)=temp(:);
end
    