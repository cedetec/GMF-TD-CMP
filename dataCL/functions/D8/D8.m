function [D8string,D8table,D8double] = D8(path)
%addpath ./data
D8string = importfileD8string(path, [1, Inf]);
D8table = importfileD8table(path, [1, Inf]);
D8double = importfileD8double(path, [1, Inf]);

end
%