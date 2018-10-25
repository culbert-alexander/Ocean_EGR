%%
delete *.env;
l = dir('*.bty');
for i=1:numel(l)
    name = l(i).name(1:end-4);
    name_wav = strcat(name, '_Pos1_rts_Rd_1_Rr_1.wav');
    if exist(name_wav, 'file') == 2
        %disp(name_wav);
    else
        delete(l(i).name);
    end
end

l = dir('*.wav');
for i=1:numel(l)
    name = l(1).name(1:end-23);
    name_wav = strcat(name, '.bty');
    if exist(name_wav, 'file') == 2
        %disp(name_wav);
    else
        delete(l(i).name);
    end
end