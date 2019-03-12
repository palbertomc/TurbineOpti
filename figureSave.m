% TurbineOpti
% Copyright (C) 2019  J. Bergh
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

function figureSave(figurename,filetype)

% Function to save all current figures
%
% Input:
%   figurename -    output file prefix
%   filetype -      format for output file
%
% Ouput:
%   null - 
%
% J Bergh, 2014

% Sets default inputs if function inputs not valid
if (nargin == 0)
    figurename = 'Unknown';
end

if (nargin < 2)
    filetype = 'fig';
end

% Gets figure handles
ChildList = sort(get(0,'Children'));
for i = 1:length(ChildList)                                                                                 % returns no of figures
    if ((strncmp(get(ChildList(i),'Type'),'figure',6)) && (strncmp(get(ChildList(i),'Visible'),'of',2)))    % confirms entity type a figure and is hidden (i.e. not the gui)
        saveas(ChildList(i), [figurename, num2str(ChildList(i)), '.' filetype]);                            % saves figures
        close(ChildList(i));                                                                                % close figure
    end
end
