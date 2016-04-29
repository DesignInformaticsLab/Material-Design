for i = 1:200
    temp=reshape(reconst_rand(:,i),[17672/2 2 ]);
    for ii = 1:2
        temp2=reshape(temp(:,ii),[94 94]);
        temp2=double(im2bw(imresize(temp2,[377 377]),0.5));
        temp3(:,ii)=temp2(:);
    end
        
       
    random_recon(:,i)=temp3(:);
end
    