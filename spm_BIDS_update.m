% SPM BIDS App
%   SPM:  http://www.fil.ion.ucl.ac.uk/spm/
%   BIDS: http://bids.neuroimaging.io/
%   App:  https://github.com/BIDS-Apps/SPM/
%
% See also:
%   BIDS Validator: https://github.com/INCF/bids-validator

% Camille Maumet
% $Id$


% BIDS.descr = spm_jsonread(fullfile(BIDS.dir,'dataset_description.json'));

% Copy over the acquisition parameters associated with func (including RepetitionTime)
for i = 1:numel(BIDS.subjects)
	subj = BIDS.subjects(i).name;
	
	for j = 1:numel(BIDS.subjects(i).func)
		if strcmp(BIDS.subjects(i).func(j).type, 'bold')
			task = BIDS.subjects(i).func(j).task;
			ses = BIDS.subjects(i).func(j).ses;
			filename = strrep(BIDS.subjects(i).func(j).filename, '.nii.gz', '.json');
			param_file = fullfile(BIDS_App.dir, subj, ['ses-' ses], 'func', filename);
		
			if ~exist(param_file, 'file')
				param_file = fullfile(BIDS_App.dir, ['task-' task '_bold.json']);
			end
		
			params = spm_jsonread(param_file);
			param_names = fieldnames(params);
		
			for p = 1:numel(param_names)
				BIDS.subjects(i).func(j).(param_names{p}) = params.(param_names{p});
			end
		end
	end
end