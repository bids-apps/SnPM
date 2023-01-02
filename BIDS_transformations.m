transfo = TRANSFO.transfo
events = TRANSFO.events
input = TRANSFO.input

switch(transfo)
    case {'factor'}
        input = varargin{1};
        levels = unique(cellstr(events.(input)));

        conditions = struct();
        for i = 1:numel(levels)
            conditions(i).name = levels{i};

            disp(levels{i});
            ids = strmatch(levels{i}, cellstr(events.(input)));
            conditions(i).onsets = events.onset(ids);
            conditions(i).duration = events.duration(ids);
        end
end
