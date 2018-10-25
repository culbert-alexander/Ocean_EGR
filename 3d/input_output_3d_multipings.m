% l = dir('*.bty');
% output = zeros(42,numel(l));
% input_compressed = zeros(237568,numel(l));
% for i=1:numel(l)
%     name_bty = l(i).name;
%     name = name_bty(1:end-4);
%     name_wav = strcat(name, '_Pos1_rts_Rd_1_Rr_1.wav');
%     input_compressed(:,i) = myDCT(name_wav);
%     output(:,i) = readbty(name_bty,'*',inf,inf,0);
% end
%net1
l = dir('*.bty');
output = zeros(41*41,length(l)/5);
input_full = zeros(240000*5,length(l)/5);
for i=1:length(l)
    name_bty = l(i).name;
    name = name_bty(1:end-6);
    name_wav1 = strcat(name, '_1_rts_Rd_1_Rr_1.wav');
    name_wav2 = strcat(name, '_2_rts_Rd_1_Rr_1.wav');
    name_wav3 = strcat(name, '_3_rts_Rd_1_Rr_1.wav');
    name_wav4 = strcat(name, '_4_rts_Rd_1_Rr_1.wav');
    name_wav5 = strcat(name, '_5_rts_Rd_1_Rr_1.wav');
    input_full(1:240000,i) = audioread(name_wav1);
    input_full(240000+1:240000*2,i) = audioread(name_wav2);
    input_full((240000*2)+1:240000*3,i) = audioread(name_wav3);
    input_full((240000*3)+1:240000*4,i) = audioread(name_wav4);
    input_full((240000*4)+1:240000*5,i) = audioread(name_wav5);
    %input_full(:,length(l)+i) = fliplr(audioread(name_wav));
    output(:,i) = reshape(readbty3d(name_bty),[],1);
    %output(:,length(l)+i) = fliplr(reshape(readbty3d(name_bty),[],1));
end

