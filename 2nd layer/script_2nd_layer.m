acc = {};
fname = {};
optgpu = 1;
if ~exist('optgpu', 'var'),
    optgpu = 0;
end

% % translation
% acc{end+1} = demo_cifar10(optgpu, 8, 1600, 'trans', 2, 0, 2, 0.1, 3, 0.01);
% fname{end+1} = 'translation';

% rotation
% acc{end+1} = demo_cifar10_2nd_layer(optgpu, 24, 8, 'rot', 1, 5, 1, 0.5, 0.1, 0.01);
% fname{end+1} = 'rotation';
acc{end+1} = demo_cifar10_2nd_layer(optgpu, 24, 40, 0.5, 10, 0.01);


% % scale
% acc{end+1} = demo_cifar10(optgpu, 8, 1600, 'scale', 2, 0, 2, 0.1, 3, 0.01);
% fname{end+1} = 'scale';


% print results
% for i = 1:length(acc),
%     fprintf('%s: %g\n', fname{i}, acc{i});
% end

% temp=[];temp2=[];temp3=[];
% for i = 1:size(xtr,1)
%     temp = xtr(i,:);
%     temp = reshape(temp,[1,size(xtr,2)]);
%     temp = reshape(temp,[sqrt(size(xtr,2)),sqrt(size(xtr,2))]);
%     for m = 1:(size(temp,1)-1)/C
%         for n = 1:(size(temp,2)-1)/C
%             block = temp(2*m-1:2*m+1,2*n-1:2*n+1);
%             if sum(sum(block))>0
%                 temp2(m,n)= 1;
%             else
%                 temp2(m,n)=0;
%             end
%         end
%     end
%     temp3(i,:) = reshape(temp2,[1,size(temp2,1)*size(temp2,2)]);
% end
% pool = temp3;
