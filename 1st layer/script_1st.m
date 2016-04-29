addpath('utils','function_code','alloy_mat')
acc = {};
fname = {};
optgpu=1
if ~exist('optgpu', 'var'),
    optgpu = 0;
end

% % translation
% acc{end+1} = demo_cifar10(optgpu, 24, 2, 'trans', 1, 0, 1, 0.1, 0.1, 0.01);
% fname{end+1} = 'translation';

% rotation
acc{end+1} = demo_cifar10(optgpu, 6,24, 'rot', 1, 1, 1, 0.5, 30, 0.01);
fname{end+1} = 'rotation';

% % scale
% acc{end+1} = demo_cifar10(optgpu, 8, 1600, 'scale', 2, 0, 2, 0.1, 3, 0.01);
% fname{end+1} = 'scale';


% print results
for i = 1:length(acc),
    fprintf('%s: %g\n', fname{i}, acc{i});
end




% new_f288=zeros(28800,2304);k=0;
%% ratio 4
% for i = 1:28800
%     temp=f288rat3(i,:);
%     test = reshape(temp,[36 36]);
%     if sum(temp(:))>300 && sum(temp(:))<500 && sum(sum(test(1:3,:)))<60 &&...
%             sum(sum(test(:,1:3)))<60 && sum(sum(test(34:36,:)))<60 && sum(sum(test(:,34:36)))<60
%         k=k+1;
%         new_f288(k,:)=temp;
%     else
%         fprintf('keep finding k=%d\n',k);
%     end
% end

%% ratio 3
% for i = 1:28800
%     temp=f288rat3(i,:);
%     test = reshape(temp,[48 48]);
%     if sum(temp(:))>500 && sum(temp(:))<900 && sum(sum(test(1:3,:)))<90 &&...
%             sum(sum(test(:,1:3)))<90 && sum(sum(test(46:48,:)))<90 && sum(sum(test(:,46:48)))<90 &&...
%             sum(sum(test(45:47,:)))<90 && sum(sum(test(:,45:47)))<90
%         k=k+1;
%         new_f288(k,:)=temp;
%     else
%         fprintf('keep finding k=%d\n',k);
%     end
% end
