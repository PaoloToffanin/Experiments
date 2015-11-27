function home = getHome
% return the path to the home folder indepently of OS (e.g. works in Linux,
% apple, and windows)
 
    if ispc
        home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
    else
        home = getenv('HOME');
    end
end