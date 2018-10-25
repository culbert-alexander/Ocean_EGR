function noisy_btys = generate_noisy_btys(s, BATHYFILE, n, m, bathyfile_edit)
fid = fopen(BATHYFILE);
header = textscan(fid, '%s', 5, 'Delimiter', '\n');
values = textscan(fid, '%f', n*m, 'Delimiter', '\n');
values = reshape(values{1,1}, n, m);
values = values';
i = 1;
j = 1;
bty_data = zeros(n,m);
while i <= m
    while j <= n
        bty_data(i,j) = s(i,j) * values(i,j);
        j = j + 1;
    end
    i = i + 1;
    j = 1;
end

fclose(fid);

fid_write = fopen(bathyfile_edit,'w');

fprintf(fid_write, [header{1,1}{1,1} '\n']);
fprintf(fid_write, [header{1,1}{2,1} '\n']);
fprintf(fid_write, [header{1,1}{3,1} '\n']);
fprintf(fid_write, [header{1,1}{4,1} '\n']);
fprintf(fid_write, [header{1,1}{5,1} '\n']);
i = 1;
while i <= 96
        fprintf(fid_write,'%f ', bty_data(i,:));
        fprintf(fid_write,'\n');
        i = i + 1;
end
fclose(fid_write);
noisy_btys = [header{1,1}; bty_data];
end
