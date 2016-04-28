One=load('Binary(2f24r)_ws12_alloy_w12_b02_rot_nrot24_pb0.1_pl3_iter_2000.mat');
addpath('./utils/')
addpath('hidstate2nd_24r_2f_12ws/')
fname=sprintf('2nd_BW_f2_24r_ws12_alloy_w12_b96_trans_ntx1_gr1_pb0.1_pl10_iter_2000');
Two=load(sprintf('%s.mat',fname));
% parameter initialize
temp=One.weight;
temp=gpu2cpu_struct(temp);
W_one=temp.vishid;
clear temp;
temp=Two.weight;
temp=gpu2cpu_struct(temp);
W_two=temp.vishid;
clear temp;
vishid_down=W_two;

L2=89;H2=89;L1=78;H1=78;

params_One=One.params;
params_Two=Two.params;
ws_Two=params_Two.ws;
Tlist = get_txmat(params_One.txtype, params_One.rs, params_One.ws, params_One.grid, params_One.numrot, params_One.numch);


numchannels=params_Two.numch;
hidstate = (rand(params_Two.numhid,1,(L2-ws_Two+1)*(H2-ws_Two+1))>0.5)+0.0; % randomize 2nd hidden state
negdata = zeros(L2-ws_Two+1, H2-ws_Two+1, numchannels);
for nf = 1:params_Two.numhid
    for nt = 1:params_Two.numtx
        filter_t = vishid_down(:,nf);
        filter_t = reshape(filter_t,[ws_Two,ws_Two,numchannels]);
        S = reshape(hidstate(nf,nt,:),L2-ws_Two+1,H2-ws_Two+1);
        temp = conv2_mult(S, filter_t, 'same');
        negdata = negdata + temp;
    end
end

hidstate=negdata;
hidstate=permute(hidstate,[3,1,2]);
hidstate=reshape(hidstate,[24,2,78^2]);

L=sqrt(size(hidstate,3));H=L;
numchannels=params_One.numch;
numhid=params_One.numhid;
numtx=params_One.numtx;
ws_One=params_One.ws;

vishid_up = W_one;
vishid_down_one = W_one;
if strcmp(params_One.intype, 'real'),
    vishid_up = 1/weight.sigma*vishid_up;
    vishid_down_one = weight.sigma*vishid_one;
end

vishid_down_one=gather(vishid_down_one);
negdata = zeros(L1, H1, numchannels);
for nf = 1:numhid
    for nt = 1:numtx
        filter_t = full(Tlist{nt})'*vishid_down_one(:,nf);
        filter_t = reshape(filter_t,[ws_One,ws_One,numchannels]);
        S = reshape(hidstate(nt,nf,:),L1,H1);
        S=double(S);
        filter_t=gather(filter_t);
        temp = conv2_mult(S, filter_t, 'same');
        temp=gather(temp);
        negdata = negdata + temp;
    end
end

negdata=gather(negdata);
figure(2);
display_network(reshape(negdata(:,:,1),size(negdata,1)*size(negdata,2),1));