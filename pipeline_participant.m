%==========================================================================
%     C O N F I G U R A T I O N    F I L E  :  P A R T I C I P A N T
%==========================================================================

% Available variables: BIDS and BIDS_App

%==========================================================================
%-fMRI Preprocessing
%==========================================================================
% ask for: slice timing correction (before or after realign)
% ask for: fieldmap
% ask for: realign and unwarp
% ask for: coregister with bias corrected (skull stripped?) anat
% ask for: voxel size for normalise/write
% ask for: smoothing kernel FWHM
% ask for: DARTEL
vox_anat = [1 1 1];
vox_func = [3 3 3];
FWHM = [12 12 12];

f = spm_BIDS(BIDS,'data', 'modality','func', 'type','bold');
if isempty(f), error('Cannot find BOLD time series.'); end
a = spm_BIDS(BIDS,'data', 'modality','anat', 'type','T1w');
if isempty(a), error('Cannot find T1-weighted image.'); end

clear matlabbatch

% % Realign
% %------------------------------------------------------------------
% matlabbatch{1}.spm.spatial.realign.estwrite.data = cellfun(@(x) {{x}},f)';
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];

% % Coregister
% %------------------------------------------------------------------
% matlabbatch{2}.spm.spatial.coreg.estimate.ref    = cellstr(spm_file(f{1},'prefix','mean','number',1));
% matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(a);

% % Segment
% %------------------------------------------------------------------
% matlabbatch{3}.spm.spatial.preproc.channel.vols  = cellstr(a);
% matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
% matlabbatch{3}.spm.spatial.preproc.warp.write    = [0 1];

% % Normalise: Write
% %------------------------------------------------------------------
% matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(f);
% matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = vox_func;

% matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = vox_anat;

% % Smooth
% %------------------------------------------------------------------
% matlabbatch{6}.spm.spatial.smooth.data = cellstr(spm_file(f,'prefix','w'));
% matlabbatch{6}.spm.spatial.smooth.fwhm = FWHM;

% [~,prov] = spm_jobman('run',matlabbatch);
fprintf('Assuming the preprocessing are done - WIP')

%==========================================================================
%-First Level fMRI
%==========================================================================
BIDS_model = spm_jsonread(BIDS_App.model);

if ~strcmp(BIDS_model.blocks{1}.level, 'participant')
	error(['Do not handle ' BIDS_model.blocks{1}.level ' block yet!']);
end

level1_model = BIDS_model.blocks{1};

% BIDS

% BIDS.description
dv = level1_model.inputs.dependent_variable;
meta = spm_BIDS(BIDS,'metadata', 'modality','func', 'type','bold', 'task', dv);
f = spm_BIDS(BIDS,'data', 'modality','func', 'type','bold', 'task', dv);

% fid = find(~cellfun(@isempty,regexp({BIDS.subjects(1).func.task}, level1_model.inputs.dependent_variable)))

% Select the functional file
matlabbatch{1}.spm.stats.fmri_spec.dir = fullfile(spm_file(f, 'path'), 'first');
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = meta.RepetitionTime;

event_file = spm_BIDS(BIDS,'data', 'modality','func', 'type','events', 'task', 'fingerfootlips');

disp(event_file{1})

event = tdfread(event_file{1})
for i = 1:numel(level1_model.transformations)
	TRANSFO = level1_model.transformations(i)
	TRANSFO.events = event
	switch(transfo.name)
		case 'factor'
			spm('Run', fullfile(fileparts(mfilename('fullpath')),'BIDS_transformations.m'));
	end

end

matlabbatch{1}.spm.stats.fmri_spec.sess.scans = spm_file(f, 'prefix','sw');
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = conditions

fprintf('Nothing to do at fMRI first level.\n');


% % From the BIDS-models spec:
% % factor(input, prefix=None, constraint=?none?, ref_level=None)
% % The factor transformation converts a nominal/categorical variable with N
% % unique levels to either N or N-1 binary indicators (i.e., dummy-coding).
% function conditions = BIDS_transformations(transfo, events, varargin)
%     switch(transfo)
%         case {'factor'}
%             input = varargin{1};
%             levels = unique(cellstr(events.(input)));

%             conditions = struct();
%             for i = 1:numel(levels)
%                 conditions(i).name = levels{i};

%                 disp(levels{i});
%                 ids = strmatch(levels{i}, cellstr(events.(input)));
%                 conditions(i).onsets = events.onset(ids);
%                 conditions(i).duration = events.duration(ids);
%             end
%     end
% end
