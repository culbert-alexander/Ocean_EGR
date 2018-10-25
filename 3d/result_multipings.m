%% net 1 main
close all; 

ret = readbty3dplot('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_multipings/1/munk3d_multipings_m_1_1.bty');

input_result(1:240000) = audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_multipings/1/munk3d_multipings_m_1_1_rts_Rd_1_Rr_1.wav');
input_result(240000+1:240000*2) = audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_multipings/1/munk3d_multipings_m_1_2_rts_Rd_1_Rr_1.wav');
input_result((240000*2)+1:240000*3) = audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_multipings/1/munk3d_multipings_m_1_3_rts_Rd_1_Rr_1.wav');
input_result((240000*3)+1:240000*4) = audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_multipings/1/munk3d_multipings_m_1_4_rts_Rd_1_Rr_1.wav');
input_result((240000*4)+1:240000*5) = audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_multipings/1/munk3d_multipings_m_1_5_rts_Rd_1_Rr_1.wav');
[Y,Xf,Af] = sim(net,input_result')
figure(1); surf(ret{1},ret{2},ret{3},ones(41)); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41), ones(41)+1); alpha(h, 0.75)
legend('Ground Truth', 'Reconstruction');
saveas(1,'2_1.fig');

figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41)); alpha(h, 0.75)
saveas(2,'2_1_sidebyside.fig');
%%
close all; 
ret = readbty3dplot('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_flat/11/munk3d_flat_m_1002_1.bty');
[Y,Xf,Af] = sim(net,audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d_flat/11/munk3d_flat_m_1002_1_rts_Rd_1_Rr_1.wav'))
figure(1); surf(ret{1},ret{2},ret{3},ones(41)); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41), ones(41)+1); alpha(h, 0.75)
legend('Ground Truth', 'Reconstruction');
saveas(1,'11_2.fig');

figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41)); alpha(h, 0.75)
saveas(2,'11_2_sidebyside.fig');

%%
close all; 
ret = readbty3dplot('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d/11/munk3d_m_1003_1.bty');
[Y,Xf,Af] = sim(net,audioread('/Users/dineshpalanisamy/Documents/MATLAB/bathymetry/3d/data3d/11/munk3d_m_1003_1_rts_Rd_1_Rr_1.wav'))
figure(1); surf(ret{1},ret{2},ret{3},ones(41)); hold on; h = surf(ret{1},ret{2},reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41), ones(41)+1); alpha(h, 0.75)
legend('Ground Truth', 'Reconstruction');
saveas(1,'11_3.fig');

figure(2); surf(ret{1},ret{2},ret{3}); hold on; h = surf(ret{1},ret{2}+200,reshape(smoothdata(Y, 'sgolay','SmoothingFactor',.75),41,41)); alpha(h, 0.75)
saveas(2,'11_3_sidebyside.fig');
%%
figure(2);
X = readbty('flat_m_100000_10.bty','*',inf,inf,0);
[Y1,Xf,Af] = sim(net,audioread('flat_m_100000_10_Pos1_rts_Rd_1_Rr_1.wav'))
plot(X); hold on; plot(smoothdata(Y1, 'sgolay','SmoothingFactor',.8));