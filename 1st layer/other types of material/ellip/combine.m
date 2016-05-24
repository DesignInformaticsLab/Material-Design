% xtr=zeros(80,40000);
for i = 1:20
    
    fname = sprintf('%d',i);
    xtr=imread(sprintf('%s.tiff', fname));
    xtr=rgb2gray(xtr);
    I=abs(1-double(im2bw(xtr)));
    
    I=double(im2bw(imresize(I,[400 400])));
%     fname2=sprintf('circle_%d',i);
%     save(sprintf('%s.mat', fname2), 'I', '-v7.3');
    xtr_ellp(i,:)=I(:);
end
xtr=zeros(80,40000);
for i = 1:20
    temp=xtr_ellp(i,:);
    temp=reshape(temp,[400 400]);
    temp1=temp(1:200,1:200);
    temp2=temp(1:200,201:400);
    temp3=temp(201:400,201:400);
    temp4=temp(201:400,1:200);
%     for k = 1+4*(i-1):4*i
    xtr(1+4*(i-1),:)=temp1(:);
    xtr(2+4*(i-1),:)=temp2(:);
    xtr(3+4*(i-1),:)=temp3(:);
    xtr(4+4*(i-1),:)=temp4(:);
%     end
end
    