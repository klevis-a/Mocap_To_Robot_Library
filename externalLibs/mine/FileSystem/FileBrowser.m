classdef FileBrowser < handle
    properties
        %files in the current folder
        files
        %full paths to the files in the current folder
        filesFullPath
        %number of files in the current folder
        numFiles
    end
    
    methods
        function obj = FileBrowser(varargin)
            %directory
            dirPath=varargin{1};
            %empty mask if not specified
            mask='';
            if nargin>1
                mask=varargin{2};
            end
            %get all the files in the specified directory
            allFiles=dir(fullfile(dirPath,mask));
            %remove the folders
            fileFlags=[allFiles.isdir];
            files = allFiles(~fileFlags);
            %populate the object properties
            obj.files = {files.name};
            obj.filesFullPath = fullfile(dirPath,obj.files);
            obj.numFiles=length(obj.files);
        end
        
        %file name of the ith file in the current folder
        function f = file(obj,i)
            f=char(obj.files{i});
        end
        
        %full path to the ith file in the current folder
        function f = fileFullPath(obj,i)
            f=char(obj.filesFullPath{i});
        end
    end
end

