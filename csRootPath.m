function rootPath=csRootPath()
% Return the path to the root iset directory
%
% This function must reside in the directory at the base of the ISET
% directory structure.  It is used to determine the location of various
% sub-directories.
% 
% Example:
%   fullfile(csRootPath,'data')

rootPath=which('csRootPath');

rootPath=fileparts(rootPath);

return
