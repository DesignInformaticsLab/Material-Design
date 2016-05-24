for ii = 1:100
fname = sprintf('hidstates5th_WB_nowh(p2p2)_imresize_(2f40f288f1000f30f12r6ws9ws9ws36ws)_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
xtr(:,ii) = temp(:)';
% xtr(:,ii) = abs(1-temp(:)');
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
fname = sprintf('random_30neuron');
save(sprintf('%s.mat',fname),'xtr', '-v7.3');