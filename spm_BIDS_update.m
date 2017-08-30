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

for i in 1:numel(BIDS.subjects)
	BIDS.subjects(i)
end

fprintf('Do nothing but can run !!!!');