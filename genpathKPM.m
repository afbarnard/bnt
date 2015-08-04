function p = genpathKPM(d)
% genpathKPM Like built-in genpath, but omits directories whose names
% are 'private', 'Old', 'old', '.git', '.svn', '.hg', 'CVS'.
%
% function p = genpathKPM(d)

if nargin==0,
  p = genpath(fullfile(matlabroot,'toolbox'));
  if length(p) > 1, p(end) = []; end % Remove trailing pathsep
  return
end

% initialise variables
methodChar = '@'; % prefix for method directories
packageChar = '+'; % prefix for package directories
p = ''; % path to be returned

% Generate path based on given root directory
files = dir(d);
if isempty(files)
  return
end

% Add d to the path even if it is empty.
p = [p d pathsep];

% set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
%
% Recursively descend through directories which are neither
% private nor "class" directories.
%
dirs = files(isdir); % select only directory entries from the current listing

for i=1:length(dirs)
  dirname = dirs(i).name;
  if ~strcmp(dirname, '.') && ...
     ~strcmp(dirname, '..') && ...
     ~strncmp(dirname, methodChar, 1) && ...
     ~strncmp(dirname, packageChar, 1) && ...
     ~strcmp(dirname, 'private') && ...
     ...% Exclude version control directories
     ~strcmp(dirname, '.git') && ...
     ~strcmp(dirname, '.svn') && ...
     ~strcmp(dirname, '.hg') && ...
     ~strcmp(dirname, 'CVS') && ...
     ...% Exclude deprecated code
     isempty(strfind(dirname, 'Old')) && ...
     isempty(strfind(dirname, 'old'))
    p = [p genpathKPM(fullfile(d, dirname))]; % recursive calling of this function.
  end
end

%------------------------------------------------------------------------------
