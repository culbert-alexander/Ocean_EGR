%% net 1 main
close all; 
X = readbty('flat_m_100000_11.bty','*',inf,inf,0);
[Y1,Xf,Af] = sim(net,audioread('flat_m_100000_11_Pos1_rts_Rd_1_Rr_1.wav'))
plot(X); hold on; plot(smoothdata(Y1, 'sgolay','SmoothingFactor',.75));
%%
figure(2);
X = readbty('flat_m_9901_1.bty','*',inf,inf,0);
[Y1,Xf,Af] = sim(net,audioread('flat_m_9901_1_Pos1_rts_Rd_1_Rr_1.wav'))
plot(X); hold on; plot(smoothdata(Y1, 'sgolay','SmoothingFactor',.8));
%%
figure(2);
X = readbty('flat_m_10100_42.bty','*',inf,inf,0);
[Y1,Xf,Af] = sim(net,audioread('flat_m_9901_1_Pos1_rts_Rd_1_Rr_1.wav'))
plot(X); hold on; plot(smoothdata(Y1, 'sgolay','SmoothingFactor',.75));

%%
figure(2);
X = readbty('flat_m_100000_10.bty','*',inf,inf,0);
[Y1,Xf,Af] = sim(net,audioread('flat_m_100000_10_Pos1_rts_Rd_1_Rr_1.wav'))
plot(X); hold on; plot(smoothdata(Y1, 'sgolay','SmoothingFactor',.8));