classdef Activities
    enumeration
        JJ_free,JL,JO_free,IR90
    end
    methods(Static)
        function activity=parse(activityChars)
            switch lower(activityChars)
                case 'jj_free'
                    activity=Activities.JJ_free;
                case 'ir90'
                    activity=Activities.IR90;
                case 'jl'
                    activity=Activities.JL;
                case 'jo_free'
                    activity=Activities.JO_free;
            end     
        end
    end
end

