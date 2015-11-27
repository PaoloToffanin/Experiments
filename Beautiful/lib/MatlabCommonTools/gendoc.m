CurDir = pwd;

if exist('doc')==7
    rmdir('doc','s');
end

mkdir('doc');

i = length(CurDir);
while i>0 && CurDir(i)~='/' && CurDir(i)~='\'
    i = i-1;
end
CurDirShort = CurDir(i+1:end);

cd ..

Files = {'bark.m',...
         'unbark.m',...
         'cosgate.m',...
         'dBglobal.m',...
         'dBweighting.m',...
         'fftavg.m',...
         'gensin.m',...
         'plotwav.m',...
         'RMS.m',...
         'RMSdir.m',...
         'wavlength.m',...
         'writestruct.m' };
     
for i=1:length(Files)
    Files{i} = [CurDirShort '/' Files{i}];
end
    
m2html('mfiles',CurDirShort, 'htmldir', [CurDirShort '/doc'], 'source', 'off');

% cd(CurDirShort);
cd ..