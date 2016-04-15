for ii = 1:50
fname = sprintf('hidstates5th_random_WB_nowh(p2p2)_imresize_(2f40f288f1000f50f6ws9ws9ws36ws12rP20P10P10Pb01)_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
xtr(:,ii) = temp(:)';
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
fname = sprintf('random_50neuron');
save(sprintf('%s.mat',fname),'xtr', '-v7.3');