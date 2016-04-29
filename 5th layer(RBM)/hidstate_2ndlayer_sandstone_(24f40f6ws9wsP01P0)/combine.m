for ii = 1:60
fname = sprintf('hidstate_2ndlayer(1stp2)_sandstone_(2f40f6ws9wsP0)_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
xtr(ii,:) = temp(:)';
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
fname = sprintf('hidstates4th_WB_nowh(p2p2)_imresize_(2f40f288f1000f6ws9ws9ws36ws12rP20P10P10Pb01)_3200iter');
save(sprintf('%s.mat',fname),'xtr', '-v7.3');