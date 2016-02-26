for ii = 1:100
fname = sprintf('hidstates2nd_WB_nowh_(2f40f6ws18ws12rP20P10Pb01)_1_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
xtr(ii,:) = temp(:)';
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
% rearrange for max pooling
% for ii = 1:99
% fname = sprintf('hidstates_%d',ii);
% f1=load(sprintf('%s.mat', fname));   
% temp = double([f1.hidstate;]);
% for m = 1:size(temp,1)%6
%     for n = 1:size(temp,2)
%         temp2=temp(m,n,:);
%         temp2=reshape(temp2,[1,size(temp2,3)]);
%         temp3(m+(m-1)*n,:)=temp2;
%     end
% end
% % xtr{ii}=temp3;
% xtr(1+(ii-1)*36:1+(ii-1)*36+35,:) = temp3;
% % f1=load([CIFAR_DIR '/filter8_ws12.mat']);
% end
% % xtr=cell2mat(xtr);