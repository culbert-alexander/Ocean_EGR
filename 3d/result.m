%% net 1 main
close all; 

%we removed the c data color map thing off of surf

%ret = readbty3dplot('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_flat/11/munk3d_flat_m_1001_1.bty');
ret = readbty3dplot('C:\Code\Ocean_Code\map-the-ocean-floor\dp195\3d\munk3d.bty');
%[Y,Xf,Af] = sim(net,audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_flat/11/munk3d_flat_m_1001_1_rts_Rd_1_Rr_1.wav'))
[Y,Xf,Af] = sim(net,audioread('C:\Code\Ocean_Code\map-the-ocean-floor\dp195\3d\munk3d_rts_Rd_1_Rr_1.wav'));
figure(1); 
surf(ret{1},ret{2},ret{3}); 
hold on; 
h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.8),41,41), ones(41)+1);
%h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.8),96,38));
%h = surf(ret{1},ret{2},smoothdata(Y, 'sgolay','SmoothingFactor',.8), ones(41)+1);
alpha(h, 0.75)
legend('Ground Truth', 'Reconstruction');
saveas(1,'11_1.fig');

figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.8),41,41)); alpha(h, 0.75)
%figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.8),96,38)); alpha(h, 0.75)
saveas(2,'11_1_sidebyside.fig');
%%
close all; 
%ret = readbty3dplot('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_flat/11/munk3d_flat_m_1002_1.bty');
%[Y,Xf,Af] = sim(net,audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_flat/11/munk3d_flat_m_1002_1_rts_Rd_1_Rr_1.wav'))
ret = readbty3dplot('C:\\Code\\Ocean_Code\\map-the-ocean-floor\\dp195\\3d\\munk3d.bty');
[Y,Xf,Af] = sim(net,audioread('C:\\Code\\Ocean_Code\\map-the-ocean-floor\\dp195\\3d\\munk3d_rts_Rd_1_Rr_1.wav'));
figure(1); surf(ret{1},ret{2},ret{3},ones(41)); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41), ones(41)+1); alpha(h, 0.75)
%figure(1); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),96,38)); alpha(h, 0.75)
legend('Ground Truth', 'Reconstruction');
saveas(1,'11_2.fig');

figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41)); alpha(h, 0.75)
%figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),96,38)); alpha(h, 0.75)
saveas(2,'11_2_sidebyside.fig');

%%
close all; 
%ret = readbty3dplot('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d/11/munk3d_m_1003_1.bty');
%[Y,Xf,Af] = sim(net,audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d/11/munk3d_m_1003_1_rts_Rd_1_Rr_1.wav'))
ret = readbty3dplot('C:\\Code\\Ocean_Code\\map-the-ocean-floor\\dp195\\3d\\munk3d.bty');
[Y,Xf,Af] = sim(net,audioread('C:\\Code\\Ocean_Code\\map-the-ocean-floor\\dp195\\3d\\munk3d_rts_Rd_1_Rr_1.wav'));
figure(1); surf(ret{1},ret{2},ret{3},ones(41)); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41), ones(41)+1); alpha(h, 0.75)
%figure(1); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),96,38)); alpha(h, 0.75)
legend('Ground Truth', 'Reconstruction');
saveas(1,'11_3.fig');

figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41)); alpha(h, 0.75)
%figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),96,38)); alpha(h, 0.75)
saveas(2,'11_3_sidebyside.fig');
%%
figure(2);
%X = readbty('flat_m_100000_10.bty','*',inf,inf,0);
X = readbty3d('munk3d.bty');
%[Y1,Xf,Af] = sim(net,audioread('flat_m_100000_10_Pos1_rts_Rd_1_Rr_1.wav'))
[Y1,Xf,Af] = sim(net,audioread('munk3d_rts_Rd_1_Rr_1.wav'))
plot(X); hold on; plot(smoothdata(Y1, 'sgolay','SmoothingFactor',.8));