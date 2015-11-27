function str = flatten_tree(tree, basename, sep)

if nargin==1
    basename = '';
    basenamed = '';
else
    basenamed = [basename '.'];
end

if nargin<3
    sep = '\n';
end

k = fieldnames(tree);

str = '';
for i=1:length(k)
    %disp([basenamed k{i}])
    branch = tree.(k{i});
    if isstruct(branch)
        str = sprintf('%s%s%s%s', str, flatten_tree(branch, [basenamed k{i}]), sep);
    else
        str = sprintf('%s%s%s=%s%s', str, basenamed, k{i}, var2str(branch), sep);
    end
end

%==========================================================================

function str = var2str(v)

str = '';

if isnumeric(v)
    if prod(size(v))>1
        str = '[';
        for i=1:size(v,1)
            for j=1:size(v,2)
                if j~=size(v,2)
                    str = [str num2str(v(i,j)) ', '];
                else
                    str = [str num2str(v(i,j))];
                end
            end
            if i~=size(v,1) 
                str = [str, ' ; '];
            end
        end
        str = [str ']'];
    else
        str = num2str(v);
    end
elseif ischar(v)
    str = ['''' v ''''];
else
    v
    warning('Unhandled type.');
    str = '!! UNHANDLED TYPE !!';
end
    
            
            