function set_soundlevel_max()

if ispc
    [pathstr, name, ext, versn] = fileparts(which('set_soundlevel_max'));
    cmd = fullfile(pathstr, 'MixerControl-1.0.exe');
    system(cmd);
else
    warndlg('Set the soundcard level up to the maximum.');
end