for i = 1:60
    temp=reshape(store(:,i),[50 50]);
    temp=double(im2bw(imresize(temp,[200 200]),0.1));
    random_recon(:,i)=temp(:);
end
    