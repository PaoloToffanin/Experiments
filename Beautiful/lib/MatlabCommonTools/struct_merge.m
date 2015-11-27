function C = struct_merge(A, B)

% C = struct_merge(A, B)
%   Merge struct A and B. If a key is present in both structs, then the
%   value from B is used. Struct arrays are not supported.

% E. Gaudrain <egaudrain@gmail.com> 2010-06-02

C = A;

keys = fieldnames(B);
for k = 1:length(keys)
    key = keys{k};
    C.(key) = B.(key);
end
