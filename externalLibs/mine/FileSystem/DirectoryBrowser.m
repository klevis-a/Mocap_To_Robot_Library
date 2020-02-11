classdef DirectoryBrowser < DirectoryBrowserAbstract    
    methods
        function obj = DirectoryBrowser(varargin)
            %directory
            dirPath=varargin{1};
            %empty mask if not specified
            mask='';
            if nargin>1
                mask=varargin{2};
            end
            %get the files in the current directory
            files=dir(fullfile(dirPath,mask));
            %keep just the directories
            dirFlags=[files.isdir];
            subFolders = files(dirFlags);
            
            if nargin>1
                obj.subFolders = {subFolders.name};
            else
                %remove the first and second subfolders, these represent the .
                %and ..
                obj.subFolders = {subFolders(3:end).name};
            end
            
            obj.subFoldersFullPath = fullfile(dirPath,obj.subFolders);
            obj.numFolders=length(obj.subFolders);
        end
    end
end

