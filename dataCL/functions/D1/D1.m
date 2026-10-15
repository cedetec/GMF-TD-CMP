function [D1string,D1table,D1double] = D1(path)
%addpath ./data
D1string = importfileD1string(path, [1, Inf]);
D1table = importfileD1table(path, [1, Inf]);
D1double = importfileD1double(path, [1, Inf]);

end
%