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
