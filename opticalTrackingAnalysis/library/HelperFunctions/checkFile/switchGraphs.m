function switchGraphs(varargin)
    persistent currentState
    if nargin>0
        currentState=varargin{1};
    else
        currentState=~currentState; 
    end
    
    if currentState
        figure(10)
        figure(11)
        figure(12)
        figure(7)
        figure(8)
        figure(9)
    else
        figure(4)
        figure(5)
        figure(6)
        figure(1)
        figure(2)
        figure(3)
    end
end
