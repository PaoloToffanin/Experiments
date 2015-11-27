function md = md5_file(filename)

fid = fopen(filename, 'r');
md = md5(fread(fid));
fclose(fid);