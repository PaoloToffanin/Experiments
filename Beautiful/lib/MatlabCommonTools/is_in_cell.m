function b = is_in_cell(cell, str)

%IS_IN_CELL
%    IS_IN_CELL(CELL, STR)
%    Returns true if STR is in CELL, and false otherwise.

b = 0;

for i = 1:length(cell)
    if strcmp(cell{i}, str)
        b = 1;
        return;
    else
        continue;
    end
end
