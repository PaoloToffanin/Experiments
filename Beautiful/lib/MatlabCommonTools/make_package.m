function make_package(fun_list, package_name, additional_files, exclude_files)

%------------------- Arguments

if ~iscell(fun_list)
    fun_list = {fun_list};
end

if nargin<3
    additional_files = {};
end

if ~iscell(additional_files)
    additional_files = {additional_files};
end

if nargin<4
    exclude_files = {};
end

if ~iscell(exclude_files)
    exclude_files = {exclude_files};
end

for i = 1:length(exclude_files)
    exclude_files{i} = sprintf('^%s$', regexptranslate('wildcard', exclude_files{i}));
end

[pathstr, name, ext, versn] = fileparts(package_name);
package_name = name;
package_path = pathstr;

%-------------------

deps = {};

for i_fun = 1:length(fun_list)
    disp(sprintf('Searching dependencies for "%s"...', fun_list{i_fun}));
    
    list = depfun(fun_list{i_fun}, '-quiet');
    
    % Remove functions from matlabroot
    clean_list = {};
    for i_list = 1:length(list)
        if strncmp(matlabroot, list{i_list}, length(matlabroot))
            continue
        end
        
        skip = 0;
        for j = 1:length(exclude_files)
            start_idx = regexp(list{i_list}, exclude_files{j});
            if length(start_idx)~=0
                skip = 1;
                break
            end
        end
        if skip
            continue
        end               
        
        clean_list{end+1} = list{i_list};
    end
    
    % Merge with other deps
    deps = union(deps, clean_list);
end

disp(sprintf('Found a total of %d dependencies...', length(deps)));

% Merge with additional files 
deps = union(deps, additional_files);

% Makes a directory for the package
if exist(fullfile(package_path, package_name))==7
    a = questdlg(sprintf('The directory "%s" already exists, empty it?', fullfile(package_path, package_name)));
    switch a
        case {'No', 'Cancel'}
            error('Interrupted by user. Change package name or directory name.');
        case {'Yes'}
            rmdir(fullfile(package_path, package_name), 's');
    end
end
mkdir(fullfile(package_path, package_name));

% Copy all required files in the directory
% Warning ! This might not work with classes
for i_dep = 1:length(deps)
    [pathstr, name, ext, versn] = fileparts(deps{i_dep});
    srcfile = deps{i_dep};
    dstfile = fullfile(package_path, package_name, [name, ext]);
    disp(sprintf('Copying "%s" -> "%s"', srcfile, dstfile));
    copyfile(srcfile, dstfile);
end

zip(fullfile(package_path, [package_name, '.zip']), '*', package_name);



