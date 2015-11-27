function h5s = struct_to_hdf5(s)

h5s = hdf5.h5compound;

fields = fieldnames(s);
for i = 1:length(fields)
    fi = getfield(s, fields{i});
    addMember(h5s, fields{i});
    if isstruct(fi)
        setMember(h5s, fields{i}, struct_to_hdf5(s));
    else
        if ischar(fi)
            setMember(h5s, fields{i}, hdf5.string(fi));
        else
    end
end
        