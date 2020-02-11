function jFile=jointsFileName(varargin)
    directory=varargin{1};
    c3dFile=varargin{2};
    optLevel=varargin{3};
    
    if nargin==3
        switch optLevel
            case 1
                jFile=alterFileName(directory,c3dFile, '.joints.txt');
            case 2
                jFile=alterFileName(directory,c3dFile, '.jointsTrajOpt.txt');
            case 3
                jFile=alterFileName(directory,c3dFile, '.jointsTrajOpt2.txt');
            otherwise
                error('This optimization level does not exist');
        end
    else
        trajNum=varargin{4};
        jFile=alterFileName(directory,c3dFile,strcat('.Opt',num2str(optLevel),'Joints',num2str(trajNum),'.txt'));
    end
end