for ii = 1:60
fname = sprintf('hidstates4th_alloy2_nowh(p2p2)_imresize_(24f40f288f500f6ws9ws9ws36ws1rP20P10P10Pb05050501)_%d',ii);
f1=load(sprintf('%s.mat', fname));   
temp = double([f1.hidstate;]);
temp = permute(temp,[3,2,1]);
xtr(ii,:) = temp(:)';
% f1=load([CIFAR_DIR '/filter8_ws12.mat']);
end
fname = sprintf('hidstates4th_alloy2_nowh(p2p2)_(24f40f288f500f6ws9ws9ws36ws1rP20P10P10Pb05050501)');
save(sprintf('%s.mat',fname),'xtr', '-v7.3');