%plz parpool asap
function product = generate_bty_env_arr(bathyfile, j)
%parpool
i = 1;
k = 1;
while i <= j
    current_fid = fopen(bathyfile); %inputted .bty file
    name = strcat('copy_of_',num2str(k),'_',bathyfile); %creates a new name for the copy
    edit(name)
    bathyfile_edit = strcat('copy_of_',num2str(k),'_',bathyfile);
    %Finds the matrix size
    textscan(current_fid, '%s', 1, 'Delimiter', '\n');
    n = textscan(current_fid, '%f', 1, 'Delimiter', '\n');
    textscan(current_fid, '%s', 1, 'Delimiter', '\n');
    m = textscan(current_fid, '%f', 1, 'Delimiter', '\n');
    
    %New Env file stuff
    bathyfile_noend = erase(bathyfile,'.bty');
    env_copy_loc = strcat(pwd,'\copy_of_',num2str(k),'_',bathyfile_noend,'.env');
    env = strcat(bathyfile_noend,'.env');
    copyfile(env,env_copy_loc);
    
    %Generates perlin noise and applies it to .bty, creating new .bty
    s = perlin2D(m{1,1},n{1,1});
    noisy_btys = generate_noisy_btys(s,bathyfile,n{1,1},m{1,1}, bathyfile_edit);
    product = noisy_btys;
    
    %Create .arr and .wav from noisy data
    bathyfile_edit_noend = erase(bathyfile_edit,'.bty');
    bellhop3d(bathyfile_edit_noend); %create .arr files
    delayandsum(bathyfile_edit_noend); %creat .wav files
    i = i + 1;
    k = k + 1;
end
end
