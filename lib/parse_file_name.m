function [base, layer, neurite] = parse_file_name(fileName)

    idx = find(fileName == '_');
    i = length(idx);
    idxPeriod = find(fileName == '.');
    j = length(idxPeriod);
    neurite = fileName(idx(i)+1:idxPeriod(j)-1);
    i = i - 2;
    layer = fileName(idx(i)+1:idx(i+1)-1);
    base = fileName(1:idx(i)-1);

end % parse_file_name()

