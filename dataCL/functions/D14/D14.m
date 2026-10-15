function [D14string,D14table,D14double] = D14(path)
%addpath ./data
D14string = importfileD14string(path, [1, Inf]);
D14table = importfileD14table(path, [1, Inf]);
D14double = importfileD14double(path, [1, Inf]);

end
%