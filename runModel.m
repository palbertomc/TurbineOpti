function [meshstatus,cfdstatus] = runModel(blade_type,iga,resource_model,GUIhandles)

% Function run and monitor meshing and CFD runs
%
% Input:
%   blade_type -    string containing (NGV/rotor/S2)
%   iga -           iteration number (scalar)
%
% Output:
%   null
%
% J Bergh, 2014

% Load gui handle data
if (nargin > 3)
    handles = guidata(GUIhandles);
end

% Run and check status of meshing process ...
if (nargin > 3)
	set(handles.txtInfo,'String',sprintf('Running jobs... (%.1f)\n\tMeshing:',iga));
end
fprintf('Running jobs... (%g)\n\tMeshing:',iga)

% Run meshing batch file
[~,~] = system(sprintf('bash mesh_%.1f.sh',iga));

% If the mesher transcript file exists,
if exist('icem_out.txt','file') == 2;

    % Search for "Fixed" or "No problem" keywords in transcript
    [~,output] = system(sprintf('less icem_out.txt | grep "Fixed" | wc -l'));
    [~,output2] = system(sprintf('less icem_out.txt | grep "no problem" | wc -l'));
    [~,output3] = system(sprintf('less icem_out.txt | grep "No  problem" | wc -l'));

    % If not meshed, score 0 in scorecard
    if (str2double(output3) < 9)
	    if (nargin > 3)
    	    set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tMeshing: Failed',iga));
        end
        fprintf('\nRunning jobs... (%g)\n\tMeshing: Failed',iga)
        scorecard = 0;
        meshstatus = 1;
        
    % If successful, score 1 in scorecard
    elseif ((str2double(output) > 0) || (str2double(output2) > 0))
        if (nargin > 3)
	        set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tMeshing: Successful',iga));
    	end
        fprintf('\nRunning jobs... (%g)\n\tMeshing: Successful',iga)
        scorecard = 1;
        meshstatus = 0;
        
    % If neither, there must be another problem and no mesh was
    % generated. Score 0 in scorecared
    else
        if (nargin > 3)
	        set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tMeshing: No mesh',iga));
    	end
        fprintf('\nRunning jobs... (%g)\n\tMeshing: No mesh',iga)
        scorecard = 0;
        meshstatus = 1;
        
    end

% Else if no transcript files exist, the mesher must not have been
% run, score 0 in scorecard vector
else
	if (nargin > 3)
	    set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tMeshing: Not run',iga));
    end
    fprintf('\nRunning jobs... (%g)\n\tMeshing: Not run',iga)
    scorecard = 0;
    meshstatus = 1;
    
end

% Check scorecard and determine if meshing was successful of not. If meshing failed, 
% generate dummy Fluent file
if (scorecard == 0)
    filename = sprintf('%s.cas.gz',blade_type);
    [fid] = fopen(filename, 'w');
    fprintf(fid,'dummy Fluent file');
    fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOTE CFD COMPUTATIONS - to delete?
% Run and check status of CFD process
%set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tCFD:',iga));
%fprintf('\n\nRunning jobs... (%g)\n\tCFD:',iga)

% Copy the local CFD files to the compute server and execute the CFD script
%[~] = ssh2_simple_command(resource_model.cluster_address,resource_model.username,resource_model.cluster_password,...
%        sprintf('mkdir -p /home/%s/temp/',resource_model.username));
    
%[~,~] = system(sprintf('bash copy.sh'));

%[~] = ssh2_simple_command(resource_model.cluster_address,resource_model.username,resource_model.cluster_password,...
%        sprintf('bash /home/jonathan/temp/Generation_1/CFD_%d.sh',iga));

% Monitor the CFD progress and retreive the CFD files once completed
%[~] = monitorJob(resource_model,iga);

%[~,~] = system(sprintf('bash retrieve.sh'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run and check status of CFD job
if (nargin > 3)
	set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tCFD:',iga));
end
fprintf('\n\nRunning jobs... (%g)\n\tCFD:',iga)

% Local CFD run
[~,~] = system(sprintf('bash CFD_%.1f.sh',iga));

% If Fluent transcript file exists ...
if exist('fluent_out.txt','file') == 2;

    % Search for Fluent data file in directory or 'Error' keyword
    % in Fluent transcript file
    [output3] = exist('x4','file');
    [~,output4] = system(sprintf('less fluent_out.txt | grep Error | wc -l'));

    % If CFD data file exists, Fluent must have run
    % successfully
    if (output3 > 0)
	    if (nargin > 3)
    	    set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tCFD: Successful',iga));
		end
        fprintf('\nRunning jobs... (%g)\n\tCFD: Successful',iga)
        cfdstatus = 0;
        
    % If 'Error' is in transcript, something must have failed
    % in CFD run
    elseif (str2double(output4) > 0)
    	if (nargin > 3)
	        set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tCFD: Failed',iga));
    	end
        fprintf('\nRunning jobs... (%g)\n\tCFD: Failed',iga)
        cfdstatus = 1;
    end

% If neither transcript nor data files exist, Fluent must not
% have run
else
	if (nargin > 3)
	    set(handles.txtInfo,'String',sprintf('Running jobs... (%g)\n\tCFD: Not run',iga));
    end
    fprintf('\nRunning jobs... (%g)\n\tCFD: Not run',iga)
    cfdstatus = 1;
end
