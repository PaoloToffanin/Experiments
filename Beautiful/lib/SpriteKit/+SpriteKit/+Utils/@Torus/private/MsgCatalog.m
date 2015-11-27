function e = MsgCatalog(id)
% Private function to Torus.

%MSGCATALOG Private error message catalog for TORUS.

% Copyright 2014 The MathWorks, Inc.

e.identifier = id;
switch id
    case 'MATLAB:Torus:RepeatedIndexing'
        e.message = 'Repeated indexing is not allowed on Torus.';
    case 'MATLAB:Torus:CommaSeparated'
        e.message = 'Comma-separated outputs are not supported for Torus. {T{I}} can often be replaced by T(I).';
    case 'MATLAB:cellRefFromNonCell'
        e.message = 'Cell contents reference from a non-cell array object.';
    case 'MATLAB:maxlhs'
        e.message = 'Too many output arguments.';
    case 'MATLAB:MultipleResultsFromIndexing'
        e.message = 'Indexing cannot yield multiple results.';
    case 'MATLAB:class:SetProhibited'
        e.message = 'You cannot set the read-only property ''TrueData'' of Torus.';
    case 'MATLAB:indexed_matrix_cannot_be_resized'
        e.message = 'In an assignment A(I) = B, a matrix A cannot be resized.';
end